;+
; NAME:   ifrotgrid.pro
;
;
; PURPOSE:  sine-grid with various orientation
;
;
; CATEGORY: MIND input  
;
;
; CALLING SEQUENCE:    called by input.pro
;	
; INPUTS:              ROTATE      : mode=rotating grid
;                      FIXED       : mode=fixed grid
;                      RANDOM      : mode=random orientation 
;                      LAMBDA      : sine-WAVELENGTH
;                      DELTA_ALPHA : ALPHA-difference between 2 steps 
;                      ALPHA       : rotating : start-alpha
;                                    fixed    :    "
;                                    random   : offset 
;                      DIV         : mode random : 2PI is divided up into div pieces  
;                      LOGIC       : logical operation ->
;                                    NEW_INPUT = OLDINPUT #LOGIC# GENERATED_INPUT
;                      MYSEED      : Initial value for SEED  (Default is taken from common-block) 
;
;
;
; OUTPUTS:          sine-grid
;
;-
;
; MODIFICATION HISTORY:
;
;
;     $Log$
;     Revision 1.7  2000/01/28 15:24:09  saam
;           console changes updates
;
;     Revision 1.6  2000/01/28 14:30:35  alshaikh
;           seems to be ok, now
;
;     Revision 1.5  2000/01/27 17:44:25  alshaikh
;           new console-syntax
;
;     Revision 1.4  2000/01/27 13:20:41  alshaikh
;           KEYWORD : myseed
;
;     Revision 1.3  2000/01/19 14:51:00  alshaikh
;           now EVERY parameter is stored in temp_vals
;
;     Revision 1.2  2000/01/14 14:10:10  alshaikh
;           bugfix
;
;     Revision 1.1  2000/01/14 13:45:37  alshaikh
;           done
;



FUNCTION ifrotgrid,MODE=mode,PATTERN=pattern,WIDTH=w,HEIGHT=h,temp_vals=_temp_vals,DELTA_T=delta_t, $
                   ROTATE = rotate, $
                   RANDOM = random, $
                   FIXED  = fixed ,$
                   LAMBDA= lambda,$
                   DELTA_ALPHA=delta_alpha,$
                   ALPHA =  alpha, $
                   DIV = div, $
                   LOGIC= logic,$
                   MYSEED=myseed
                    
 COMMON COMMON_random, seed
 COMMON ATTENTION

 Default, mode, 1               ; i.e. step
 Default, div , 0.0
 Default, fixed,0.0
 Default, random,0.0
 Default, alpha,0.0
 Default, duration,1.0
 Default, logic, 'ADD'
 Default, myseed, seed
 Handle_Value,_temp_vals,temp_vals,/no_copy
 

   CASE mode OF

;
; INITIALIZE
;
      0: BEGIN 

if set(myseed) THEN myseed = lonarr(36)+myseed ELSE myseed= seed

         logiclist = ['AND','OR','ADD']
         mylogic = WHERE(STRUPCASE(logic) EQ logiclist,c)


         temp_pattern =  pattern
         background = fltarr(2*h+1,2*w+1)

         offset =  lambda/(2*3.14159)*(4*1)+1-h


         FOR x=0,2*h DO BEGIN
            FOR y=0,2*w DO BEGIN 
               background(x,y) = 0.5*(1+(sin(2*3.14159/lambda*(x+offset))))
            ENDFOR 
         ENDFOR 

         xoff = h
         yoff = w

         temp_vals =  { $
                       sim_time      : 0l        ,$
                       xoff          : xoff      ,$  
                       yoff          : yoff      ,$
                       alpha         : alpha         ,$
                       div           : div,$ 
                       dur_counter   : 0.0, $
                       background    :background  ,$
                       pattern       : fltarr(h,w), $
                       h             : h ,$
                       w             : w,  $
                       delta_t       : delta_t, $
                       random        : random  ,$
                       delta_alpha   : delta_alpha, $
                       myseed        : myseed, $
                       mylogic       : mylogic(0) $ 
                      }
         

         console,P.CON,'filter ''ifrotgrid'' initialized, mode :'+logic 
         
      END


;
; STEP
;
      1: BEGIN 

   
            temp_pattern =  pattern
            temp_vals.dur_counter = 0
            xoff =  temp_vals.xoff
            yoff =  temp_vals.yoff
            background = temp_vals.background
            _seed = temp_vals.myseed
                        
            
            IF temp_vals.random NE 0 THEN $
             angle = (round( (randomu(_seed)*temp_vals.div)+0.5)-1)*2*3.14159/temp_vals.div $ 
                           +temp_vals.delta_alpha $
                           ELSE angle =  temp_vals.alpha

            temp_vals.myseed =  _seed

            FOR x=-(temp_vals.h/2),temp_vals.h/2 DO BEGIN
               FOR y=-(temp_vals.w/2),(temp_vals.w/2) DO BEGIN
                  temp_pattern(temp_vals.h/2+x,temp_vals.w/2+y) = background(xoff+x*cos(angle)-y*sin(angle),yoff+x*sin(angle)+y*cos(angle))
               ENDFOR
            ENDFOR       
            
            IF fixed EQ 0 THEN angle =  angle + temp_vals.delta_alpha
            temp_vals.alpha =  angle
         
         temp_vals.sim_time =  temp_vals.sim_time + temp_vals.delta_t
         temp_vals.pattern = temp_pattern

         CASE temp_vals.mylogic OF

            0 : BEGIN   ; AND
               temp_pattern = pattern AND temp_pattern
            END

            1 : BEGIN   ; OR
               temp_pattern = pattern OR temp_pattern
            END

            2 : BEGIN   ; ADD
               temp_pattern = pattern + temp_pattern
            END
         ENDCASE
      END                       ; STEP


;
; FREE
;
      2:BEGIN
         
         temp_pattern = 0.0
         console,P.CON,'filter ''ifrotgrid'' stopped'

      END


     ENDCASE 

 Handle_Value,_temp_vals,temp_vals,/no_copy,/set

return, temp_pattern 
END 
