;+
; NAME:    ifcsur.pro
;
;
; PURPOSE:  simulates center-surround-RFs 
;
;
; CATEGORY:  input 
;
;
; CALLING SEQUENCE:   internal
;
; 
; INPUTS:       s1,s2,k1,k2,off_rate
;               determines mex-hat-parameters
;    ON-CENTER 
;         pattern = (convol(pattern,k1*gauss_2d(range_h,range_w,s1) $
;                          -k2*gauss_2d(range_h,range_w,s2),1, $
;                          center=1,/edge_truncate) + temp_vals.off_rate) > 0 
;    OFF-CENTER      
;          pattern =  (temp_vals.off_rate - convol(pattern,k1*gauss_2d(range_h,range_w,s1) $
;                          +k2*gauss_2d(range_h,range_w,s2),1, $
;                          center=1,/edge_truncate))  > 0  
;
;
;
; OPTIONAL INPUTS:
;
;	
; KEYWORD PARAMETERS:  ONCENTER   : if set => ON-CENTER-RF 
;                                   otherwise OFF-CENTER-RF
;
;
; OUTPUTS:  Input, filtered by CENTER-SURROUND-RFs
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
;     Revision 1.2  2000/01/19 14:50:59  alshaikh
;           now EVERY parameter is stored in temp_vals
;
;     Revision 1.1  2000/01/17 15:05:04  alshaikh
;           initial version
;
;
;-


FUNCTION ifcsur, MODE=mode, PATTERN=pattern, WIDTH=w, HEIGHT=h, TEMP_VALS=_temp_vals, DELTA_T=delta_t, $
                 S1=s1,S2=s2,K2=k2,K1=k1,OFF_RATE=off_rate,ONCENTER=oncenter


   Default, mode   , 1          ; i.e. step
   Default, pattern, !NONE
   Default, s1, 1.5
   Default, s2, 2*1.5
   Default, k2, 0.9
   Default, k1, 3.94*k2
   Default, ONCENTER,0.0
   Default, OFF_RATE,10.0
   
   Handle_Value,_temp_vals,temp_vals,/no_copy
   
   
   CASE mode OF
      
;
; INITIALIZE
;
      0: BEGIN                  

convol_range_w = w-1
convol_range_h = h-1
         
         temp_vals =  { $
                       sim_time : 0l, $
                       s1       : s1, $
                       s2       : s2, $
                       k1       : k1, $
                       k2       : k2, $
                       range_w  : convol_range_w, $
                       range_h  : convol_range_h, $
                       on_mode  : oncenter, $
                       OFF_RATE : OFF_RATE, $
                       delta_t  : delta_t $ 
                      }
         
         print,'INPUT:filter ''ifcsur'' initialized'         
      END
      

;
; STEP
;
      1: BEGIN            
         range_h = temp_vals.range_h
         range_w = temp_vals.range_w
         k1 = temp_vals.k1
         k2 = temp_vals.k2
         s1 = temp_vals.s1
         s2 = temp_vals.s2
         

         IF temp_vals.on_mode NE 0 THEN $ 
         pattern = (convol(pattern,k1*gauss_2d(range_h,range_w,s1) $
                          -k2*gauss_2d(range_h,range_w,s2),1, $
                          center=1,/edge_wrap) + temp_vals.off_rate) > 0 $
          ELSE $
          pattern =  (temp_vals.off_rate - convol(pattern,k1*gauss_2d(range_h,range_w,s1) $
                          +k2*gauss_2d(range_h,range_w,s2),1, $
                          center=1,/edge_wrap))  > 0 
         
         
         temp_vals.sim_time =  temp_vals.sim_time + temp_vals.delta_t
         
      END
      
      
;
; FREE
;
      2:BEGIN
         
         print,'INPUT:filter ''ifcsur'' stopped'
         
      END 
      ELSE: BEGIN
         Message, 'unknown mode'
      END
      
   ENDCASE 
   
   Handle_Value,_temp_vals,temp_vals,/no_copy,/set
   
   RETURN, pattern 
END 
