;+
; NAME:               IFBOX
;
; PURPOSE:           generates a filled box or an inverted filled box (that is a frame) defined
;                    by the points (x1,y1) and (x2,y2)
;
;
; CATEGORY:           MIND INPUT  
;
; CALLING SEQUENCE:   
;                     ignore_me  = IFbox( MODE=0, 
;                                              TEMP_VALS=temp_vals
;                                              [,WIDTH=width] [,HEIGHT=height] [,DELTA_T=delta_t] 
;                                              ,X1=x1,Y1=y1,X2=x2,Y2=y2, [INVERT=invert] )
;
;                     newPattern = IFTemplate( [MODE=1], PATTERN=pattern )
;                     ignore_me  = IFTemplate( MODE=[2|3] )
;	
; KEYWORD PARAMETERS: DELTA_T   : passing time in ms between two sucessive calls of this filter function
;                     HEIGHT    : height of the input to be created
;                     MODE      : determines the performed action of the filter. 
;                                  0: INIT, 1: STEP (Default), 2: FREE, 3: PLOT (filter characteristics (if useful))
;                     PATTERN   : filter input
;                     TEMP_VALS : internal structure that reflects the filter function/status. This
;                                 is initialized when MODE=0, read/modified for MODE=1 and freed for
;                                 MODE=2
;                     WIDTH     : width of the input to be created
;                    X1(2),Y1(2): box is defined by two points
;                     INVERT    : inverted result 
;                     LOGIC     : logical mode (see iftemplate2) 'AND','OR','ADD', 'SUB'
;                     value     : the box is of constant values 'value', default 1.0 
;
;
; OUTPUTS:            newPattern: the filtered version of PATTERN
;                     ignore_me : just ignore it
;
; SIDE EFFECTS:       TEMP_VALS is changed by the function call!
;
;-
;
; MODIFICATION HISTORY:
;
;
;     $Log$
;     Revision 1.4  2000/01/28 15:24:09  saam
;           console changes updates
;
;     Revision 1.3  2000/01/27 17:44:24  alshaikh
;           new console-syntax
;
;     Revision 1.2  2000/01/26 16:20:38  alshaikh
;           print,message -> console
;
;     Revision 1.1  2000/01/20 11:01:33  alshaikh
;           initial version
;
;







FUNCTION IFbox, MODE=mode, PATTERN=pattern, WIDTH=w, HEIGHT=h, TEMP_VALS=_TV, DELTA_T=delta_t, $
                LOGIC=logic, $
                X1=x1,Y1=y1,X2=x2,Y2=y2,INVERT=invert, VALUE=value

   COMMON ATTENTION

   ON_ERROR, 2

   Default, mode, 1          ; i.e. step
   Default, R   , !NONE
   Default, invert,0.0
   Default, logic, 'ADD'
   Default, value, 1.0

   Handle_Value, _TV, TV, /NO_COPY
   CASE mode OF      
      ; INITIALIZE
      0: BEGIN                  
         logiclist = ['AND','OR','ADD','SUB']
         mylogic = WHERE(STRUPCASE(logic) EQ logiclist,c)
         
         IF x1 GT x2 THEN BEGIN
            temp = x1
            x1 = x2
            x2 =  temp
         END 
            
         IF y1 GT y2 THEN BEGIN
            temp = y1
            y1 = y2
            y2 =  temp
         END 

         TV =  {                    $
                delta_t  : delta_t ,$
                sim_time : .0d     ,$
                x1 : x1            ,$
                x2 : x2            ,$
                y1 : y1            ,$
                y2 : y2            ,$
                mylogic  : mylogic(0),$
                h  : h             ,$
                w  : w             ,$
                value : value      ,$
                invert : invert    $
         }
         
         console,P.CON,'initialized',/msg         
      END
      
      ; STEP
      1: BEGIN                             
         R = fltarr(TV.h,TV.w)
         FOR x=TV.x1,TV.x2 DO BEGIN
            FOR y=TV.y1,TV.y2 DO BEGIN 
               R(y,x) = TV.value
            ENDFOR
         endfor 
         IF TV.invert NE 0 THEN R = TV.value - R
         TV.sim_time =  TV.sim_time + TV.delta_t

         CASE TV.mylogic OF
            
            0 : BEGIN           ; AND
               R = pattern AND R
            END
            
            1 : BEGIN           ; OR
               R = pattern OR R
            END
            
            2 : BEGIN           ; ADD
               R = pattern + R
            END
            3 : BEGIN           ; SUB
               R = (pattern - R) > 0
            END


         ENDCASE
         
      END
      
      ; FREE
      2: BEGIN
         console, P.CON,'done',/msg
      END 

      ; PLOT
      3: BEGIN
         console, P.CON, 'display mode not implemented, yet',/warning
      END
      ELSE: BEGIN
         console, P.CON, 'unknown mode',/warning
      END
   ENDCASE 
   Handle_Value, _TV, TV, /NO_COPY, /SET

   RETURN, R
END
