;+
; NAME: cornsweet_simulate
;
; AIM : Module of cornsweet.pro (see also: FaceIt)
;
; PURPOSE:
;
;
; CATEGORY:
;
;
; CALLING SEQUENCE:
;
; 
; INPUTS:
;
;
; OPTIONAL INPUTS:
;
;	
; KEYWORD PARAMETERS:
;
;
; OUTPUTS:
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
;-
; MODIFICATION HISTORY:
;
;
;     $Log$
;     Revision 1.2  2000/09/27 15:08:05  alshaikh
;           AIM-tag added
;
;     Revision 1.1  2000/02/16 10:20:37  alshaikh
;           initial version
;
;
;

FUNCTION gen_pattern,LENGTH=length,AMPLITUDE=amplitude,TAU=tau,POS1=pos1
middle =  length/2
pos2 =  length-pos1

pattern_array =  fltarr(length)
FOR i=0,pos1-1 DO BEGIN
   pattern_array(pos1-i) = amplitude*exp(-i/tau)
   pattern_array(pos2+i) = amplitude*exp(-i/tau)
ENDFOR 

FOR i=0,middle-pos1 DO BEGIN
   pattern_array(pos1+i) = -amplitude*exp(-i/tau)
   pattern_array(pos2-i) = -amplitude*exp(-i/tau)
ENDFOR 
return, pattern_array
END 



FUNCTION cornsweet_SIMULATE, dataptr


   inparr =  fltarr((*dataptr).length,1)
   inparr(*,0) = gen_pattern(LENGTH=(*dataptr).length, AMPLITUDE=(*dataptr).extinpampl, TAU=(*dataptr).extinptau, POS1=(*dataptr).extinpleft)
   

   (*dataptr).inpattern = ((*dataptr).extinpoffset+inparr(*,0)) > 0
  
   inpspass = Spassmacher((inparr+(*dataptr).extinpoffset) > 0)
   feed_pre = inpspass

 
   link_pre_pre = DelayWeigh( (*dataptr).CON_pre_pre, LayerOut((*dataptr).pre))

      
   InputLayer, (*dataptr).pre, FEEDING=feed_pre
   InputLayer, (*dataptr).pre, LINKING=link_pre_pre

   
   ProceedLayer, (*dataptr).pre

   ; Increment counter and reset if period is over:
   (*dataptr).counter = ((*dataptr).counter+1) mod (*dataptr).extinpperiod
   (*dataptr).passedtime = (*dataptr).passedtime+1 

   ; Allow continuation of simulation:
   Return, 1 ; TRUE

;--- NO CHANGES NECESSARY BELOW THIS LINE.


END ; cornsweet_SIMULATE
