;+
; NAME:
;  (Hint: Insert name in THIS line, if you want it to appear in the
;  HTML-help. If you put it elsewhere, the HTML-help item will be 
;  generated from the filename.)
;
; AIM: -please enter a short description of routine (a single line!)-
;  
; PURPOSE:
;  -please specify-
;  
; CATEGORY:
;  -please specify-
;  
; CALLING SEQUENCE:
;  -please specify-
;  
; INPUTS:
;  -please remove any sections that do not apply-
;  
; OPTIONAL INPUTS:
;
;      STIMSHIFT : for values ne 0 the grid is divided up into two equal-sized grids
;                  with the right one (provided 0dg orientation) shifted by a phase
;                  of STIMSHIFT
;
;
;          
;  -please remove any sections that do not apply-
;  
; KEYWORD PARAMETERS:
;  -please remove any sections that do not apply-
;  
; OUTPUTS:
;  -please remove any sections that do not apply-
;  
; OPTIONAL OUTPUTS:
;  -please remove any sections that do not apply-
;  
; COMMON BLOCKS:
;  -please remove any sections that do not apply-
;  
; SIDE EFFECTS:
;  -please remove any sections that do not apply-
;  
; RESTRICTIONS:
;  -please remove any sections that do not apply-
;  
; PROCEDURE:
;  -please specify-
;  
; EXAMPLE:
;  -please specify-
;  
; SEE ALSO:
;  -please remove any sections that do not apply-
;  <A HREF="#MY_ROUTINE">My_Routine()</A>
;  
;-
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 1.3  2000/09/01 14:24:42  alshaikh
;              new keyword STIMSHIFT
;
;        Revision 1.2  2000/09/01 10:12:23  saam
;              still undoumented
;
;

FUNCTION IFod, MODE=mode, PATTERN=pattern, WIDTH=w, HEIGHT=h, TEMP_VALS=_TV, DELTA_T=delta_t, $
                      LOGIC=op, STIMORIENT=stimorient, DETECTORIENT=detectorient, STIMPERIOD=stimperiod, STIMPHASE=stimphase, $
                      STIMSHIFT=stimshift,$
                      STEPANGLE=stepangle,$
                      A=a, _EXTRA=e

;   ON_ERROR, 2

   Default, mode, 1          ; i.e. step
   Default, R   , !NONE
   Default, op  , 'ADD'
   Default, rotperiod, !NONE
   Default, stepangle, 0.

   Handle_Value, _TV, TV, /NO_COPY
   CASE mode OF      
      ; INITIALIZE
      0: BEGIN      

         print,'bla'
          Default, a, 500.
          Default, stimorient, 0
          Default, detectorient, 0
          Default, stimphase, 0
          Default, stimshift, 0
          Default, stimperiod, 1
          md = FIX(MAX([w,h])*1.5)
          md = md + ((md+1) MOD 2) + 50
          y1=sin(2*!DPi*((dindgen(md) - md/2)/stimperiod + stimphase/360.d))          
          y2=sin(2*!DPi*((dindgen(md) - md/2)/stimperiod + (stimphase+stimshift)/360.d))          

          lstim1=(1+rebin(y1,md,md/2,/SAMPLE))*0.5
          lstim2 =(1+rebin(y2,md,md-md/2,/SAMPLE))*0.5
          lstim = fltarr(md,md)
          lstim(*,0:(md/2)-1) = lstim1
          lstim(*,(md/2):md-1) = lstim2

          stim = (rot(lstim,STIMORIENT,1,md/2,md/2,/cubic,/pivot))
          odm=Orient_2d(25, DEGREE=DETECTORIENT-90.)    
          mem = a*((convol(stim, odm))^2)(md/2-h/2:md/2+h/2,md/2-w/2:md/2+w/2)

          TV =  {                             $
                  a            : a           ,$
                  w            : w           ,$
                  h            : h           ,$
                  mem          : mem         ,$
                  stimperiod   : stimperiod  ,$
                  stimphase    : stimphase   ,$
                  stimshift    : stimshift   ,$
                  detectorient : detectorient,$
                  stimorient   : stimorient  ,$
                  stepangle    : stepangle   ,$
                  cangle       : 0d          ,$
                  delta_t      : delta_t     ,$
                  sim_time     : .0d         ,$
                  myop         : opID(op)     $
                }

          outputstring =  'a='+STR(TV.a)+', grating: '+STR(TV.stimorient)+' dg, detector: '+STR(TV.detectorient)+' dg, spat freq: '+STR(TV.stimperiod)+', phase: '+STR(TV.stimphase)+' dg'

          IF stimshift NE 0 THEN outputstring = outputstring + 'right half shifted by : '+STR(TV.stimshift)+' dg'
console, outputstring

      END
      
      ; STEP
      1: BEGIN                             
          IF (TV.stepangle NE 0) THEN BEGIN
              TV.cangle = (TV.cangle + TV.stepangle) MOD 360
              md = FIX(MAX([TV.w,TV.h])*1.5)
              md = md + ((md+1) MOD 2) + 50
              y1=sin(2*!DPi*((dindgen(md) - md/2)/TV.stimperiod + TV.stimphase/360.d))          
              y2=sin(2*!DPi*((dindgen(md) - md/2)/TV.stimperiod + (TV.stimphase+TV.stimshift)/360.d))          

              lstim1=(1+rebin(y1,md,md/2,/SAMPLE))*0.5
              lstim2 =(1+rebin(y2,md,md-md/2,/SAMPLE))*0.5
              lstim = fltarr(md,md)
              lstim(*,0:md/2-1) = lstim1
              lstim(*,(md/2):md-1) = lstim2
              
              stim = (rot(lstim,TV.STIMORIENT+TV.cangle,1,md/2,md/2,/cubic,/pivot))
              odm=Orient_2d(25, DEGREE=TV.DETECTORIENT-90.)    
              TV.mem = TV.a*((convol(stim, odm))^2)(md/2-TV.h/2:md/2+TV.h/2,md/2-TV.w/2:md/2+TV.w/2)
              Console, 'a='+STR(TV.a)+', grating: '+STR(TV.stimorient+TV.cangle)+' dg, detector: '+STR(TV.detectorient)+' dg, spat freq: '+STR(TV.stimperiod)+', phase: '+STR(TV.stimphase)+' dg'
          END
          TV.sim_time =  TV.sim_time + TV.delta_t
          R = Operator(TV.myop, pattern, TV.mem)
      END
      
      ; FREE
      2: BEGIN
         console, 'done'
      END 

      ; PLOT
      3: BEGIN
         console, 'display mode not implemented, yet', /WARN
      END
      ELSE: BEGIN
         console, 'unknown mode', /FATAL
      END
   ENDCASE 
   Handle_Value, _TV, TV, /NO_COPY, /SET

   RETURN, R
END
