;+
; NAME:    IFcsur
;
; AIM:     convolutes input with a mexican hat
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
;               k1 and k2 are omitted if keyword /NORMALIZE is set
;
;  for the non-normalized case :
;
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
;  and with the keyword /normalize set :
;
;    ON-CENTER 
;         pattern = (convol(pattern,gauss_2d(range_h,range_w,s1,/norm) $
;                          -gauss_2d(range_h,range_w,s2,/norm),1, $
;                          center=1,/edge_truncate) + temp_vals.off_rate) > 0 
;    OFF-CENTER      
;          pattern =  (temp_vals.off_rate - convol(pattern,gauss_2d(range_h,range_w,s1,/norm) $
;                          +gauss_2d(range_h,range_w,s2,/norm),1, $
;                          center=1,/edge_truncate))  > 0  
;
; 
;
; OPTIONAL INPUTS:
;
;	
; KEYWORD PARAMETERS:  ONCENTER   : if set => ON-CENTER-RF 
;                                   otherwise OFF-CENTER-RF
;                      NORMALIZE  : Integral DOG == 0
;
;
; OUTPUTS:  Input, filtered by CENTER-SURROUND-RFs
;
;-
;
; MODIFICATION HISTORY:
;
;
;     $Log$
;     Revision 1.7  2000/09/29 08:10:34  saam
;     added the AIM tag
;
;     Revision 1.6  2000/02/25 15:06:10  alshaikh
;           new keyword /NORMALIZE
;
;     Revision 1.5  2000/01/28 15:24:09  saam
;           console changes updates
;
;     Revision 1.4  2000/01/27 17:44:24  alshaikh
;           new console-syntax
;
;     Revision 1.3  2000/01/26 16:20:38  alshaikh
;           print,message -> console
;
;     Revision 1.2  2000/01/19 14:50:59  alshaikh
;           now EVERY parameter is stored in temp_vals
;
;     Revision 1.1  2000/01/17 15:05:04  alshaikh
;           initial version
;
;



FUNCTION ifcsur, MODE=mode, PATTERN=pattern, WIDTH=w, HEIGHT=h, TEMP_VALS=_temp_vals, DELTA_T=delta_t, $
                 S1=s1,S2=s2,K2=k2,K1=k1,OFF_RATE=off_rate,ONCENTER=oncenter, NORMALIZE=normalize

 COMMON ATTENTION

   Default, mode   , 1          ; i.e. step
   Default, pattern, !NONE
   Default, s1, 1.5
   Default, s2, 2*1.5
   Default, k2, 0.9
   Default, k1, 3.94*k2
   Default, ONCENTER,0.0
   Default, OFF_RATE,10.0
   Default, NORMALIZE,0	
   
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
		       NORMALIZE: NORMALIZE, $	
                       delta_t  : delta_t $ 
                      }
         
          console,P.CON,'initialized',/msg         
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
         
	IF temp_vals.normalize eq 0 then begin
         IF temp_vals.on_mode NE 0 THEN $ 
         pattern = (convol(pattern,k1*gauss_2d(range_h,range_w,s1) $
                          -k2*gauss_2d(range_h,range_w,s2),1, $
                          center=1,/edge_wrap) + temp_vals.off_rate) > 0 $
          ELSE $
          pattern =  (temp_vals.off_rate - convol(pattern,k1*gauss_2d(range_h,range_w,s1) $
                          +k2*gauss_2d(range_h,range_w,s2),1, $
                          center=1,/edge_wrap))  > 0 
	
	END ELSE BEGIN
	IF temp_vals.on_mode NE 0 THEN $ 
         pattern = (convol(pattern,gauss_2d(range_h,range_w,s1,/norm) $
                          -gauss_2d(range_h,range_w,s2,/norm),1, $
                          center=1,/edge_wrap) + temp_vals.off_rate)> 0 $
          ELSE $
          pattern =  (temp_vals.off_rate - convol(pattern,gauss_2d(range_h,range_w,s1,/norm) $
                          +gauss_2d(range_h,range_w,s2,/norm),1, $
                          center=1,/edge_wrap))  > 0 
        END 
          

         
         temp_vals.sim_time =  temp_vals.sim_time + temp_vals.delta_t
         
      END
      
      
;
; FREE
;
      2:BEGIN
         
          console,P.CON,'stopped',/msg
         
      END 
      ELSE: BEGIN
          console,P.CON, 'unknown mode',/fatal
      END
      
   ENDCASE 
   
   Handle_Value,_temp_vals,temp_vals,/no_copy,/set
   
   RETURN, pattern 
END 
