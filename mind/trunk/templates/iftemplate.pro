;+
; NAME:   iftemplate.pro
;
;
; PURPOSE:  iffilter-template
;
;
; CATEGORY: MIND input && templates 
;
;
; CALLING SEQUENCE:    called by input.pro
;	
; KEYWORD PARAMETERS: max_contrast   : contrast of a centered bar
;
;
; OUTPUTS:          bar
;
;
; OPTIONAL OUTPUTS:
;
;
; COMMON BLOCKS:
;
;
; SIDE EFFECTS:
;
;
; RESTRICTIONS:
;
; PROCEDURE:
;
;
; EXAMPLE:
;
;
; MODIFICATION HISTORY:
;
;
;     $Log$
;     Revision 1.1  2000/01/14 10:35:02  alshaikh
;           done
;
;
;-


FUNCTION iftemplate,MODE=mode,PATTERN=pattern,WIDTH=w,HEIGHT=h,temp_vals=_temp_vals,DELTA_T=delta_t,max_Contrast=max_contrast

Default, mode, 1      ; i.e. step

Handle_Value,_temp_vals,temp_vals,/no_copy


   CASE mode OF

;
; INITIALIZE
;
      0: BEGIN                  

         temp_vals =  { $
                       sim_time : 0l $
                      }
         

         print,'INPUT:filter ''iftemplate'' initialized'         
      END


;
; STEP
;
      1: BEGIN                    
               
         FOR x=0,h-1 DO BEGIN                 ; e.g. draw a vertical bar
            FOR y=w/2-3,w/2+3 DO BEGIN 
               pattern(y,x) = max_contrast
            ENDFOR
         endfor 


         temp_vals.sim_time =  temp_vals.sim_time + delta_t
         
      END


;
; FREE
;
      2:BEGIN
         

         print,'INPUT:filter ''iftemplate'' stopped'

      END


     ENDCASE 

 Handle_Value,_temp_vals,temp_vals,/no_copy,/set

return, pattern 
END 
