;+
; NAME: 
;   IFoD
;
; VERSION:
;   $Id$
;
; AIM:
; convolutes sinusoidal grating with Canny-Edge detectors
;   
; PURPOSE:
;   
; CATEGORY:
;  Array
;  DataStructures
;  Input
;  Internal
;
; CALLING SEQUENCE:
;  
; INPUTS:
;
;      STIMSHIFT : for values ne 0 the grid is divided up into two equal-sized grids
;                  with the right one (provided 0dg orientation) shifted by a phase
;                  of STIMSHIFT
;
;      STEP      : adjacent rf's are separated by STEP points
;
;      DETECTSIZE: size of the convolution-kernel. is directly passed
;                  to <a>orient_2d<\a>
;  
; OPTIONAL INPUTS:
;  
; INPUT KEYWORDS:
;
; OUTPUTS:
;  
; OPTIONAL OUTPUTS:
;  
; COMMON BLOCKS:
;  
; SIDE EFFECTS:
;  
; RESTRICTIONS:
;  
; PROCEDURE:
;  
; EXAMPLE:
;  
; SEE ALSO:
;-


FUNCTION IFod, MODE=mode, PATTERN=pattern, WIDTH=w, HEIGHT=h, TEMP_VALS=_TV, DELTA_T=delta_t, $
                      LOGIC=op, STIMORIENT=stimorient, DETECTORIENT=detectorient, STIMPERIOD=stimperiod, STIMPHASE=stimphase, $
                STIMSHIFT=stimshift,$ $
                STEPANGLE=stepangle,detectsize=detectsize, step=step, $
                      A=a, _EXTRA=e

;   ON_ERROR, 2

   Default, mode, 1          ; i.e. step
   Default, R   , !NONE
   Default, op  , 'ADD'
   Default, rotperiod, !NONE
   Default, stepangle, 0.
   Default, step, 1.
   Default, detectsize, 25.

   Handle_Value, _TV, TV, /NO_COPY
   CASE mode OF      
      ; INITIALIZE
      0: BEGIN      

          Default, a, 500.
          Default, stimorient, 0
          Default, detectorient, 0
          Default, stimphase, 0
          Default, stimshift, 0
          Default, stimperiod, 1
          mdx = w*step+2*detectsize
          mdy = h*step+2*detectsize
          md = fix((max([mdx, mdy])+1)*2)/2
          y1=sin(2*!DPi*((dindgen(md)/step - md/2)/stimperiod + stimphase/360.d))          
          y2=sin(2*!DPi*((dindgen(md)/step - md/2)/stimperiod + (stimphase+stimshift)/360.d))          

          lstim1=(1+rebin(y1,md,md/2,/SAMPLE))*0.5
          lstim2 =(1+rebin(y2,md,md-md/2,/SAMPLE))*0.5
          lstim = fltarr(md,md)
          lstim(*,0:(md/2)-1) = lstim1
          lstim(*,(md/2):md-1) = lstim2

          stim = (rot(lstim,STIMORIENT,1,md/2,md/2,/cubic,/pivot))
          odm=Orient_2d(detectsize, DEGREE=DETECTORIENT-90.)    
          temp = a*((convol(stim, odm))^2)

          ; points to pick
          lowx = indgen(w)*step+md/2-(step*w/2)+1
          lowy = indgen(h)*step+md/2-step*h/2+1

          mem = fltarr(h, w)
          for y=0, n_elements(lowy)-1 do begin
             mem(y, * ) = temp(lowy(y), lowx)
          endfor 
          temp = !NONE


          TV =  {                             $
                  a            : a           ,$
                  w            : w           ,$
                  h            : h           ,$
                  mem          : mem         ,$
                  stimperiod   : stimperiod  ,$
                  stimphase    : stimphase   ,$
                  stimshift    : stimshift   ,$
                  detectorient : detectorient,$
                  detectsize   : detectsize, $
                  step         : step,  $
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
             mdx = w*TV.step+2*TV.detectsize
             mdy = h*TV.step+2*TV.detectsize
             md = FIX(MAX([mdx,mdy]))
             y1=sin(2*!DPi*((dindgen(md) - md/2)/TV.stimperiod + TV.stimphase/360.d))          
             y2=sin(2*!DPi*((dindgen(md) - md/2)/TV.stimperiod + (TV.stimphase+TV.stimshift)/360.d))          
             
              lstim1=(1+rebin(y1,md,md/2,/SAMPLE))*0.5
              lstim2 =(1+rebin(y2,md,md-md/2,/SAMPLE))*0.5
              lstim = fltarr(md,md)
              lstim(*,0:md/2-1) = lstim1
              lstim(*,(md/2):md-1) = lstim2
              
              stim = (rot(lstim,TV.STIMORIENT+TV.cangle,1,md/2,md/2,/cubic,/pivot))
              odm=Orient_2d(TV.detectsize, DEGREE=TV.DETECTORIENT-90.)    
              temp = a*((convol(stim, odm))^2)

                                ; points to pick
              lowx = indgen(w)*TV.step+md/2-(TV.step*w/2)+1
              lowy = indgen(h)*TV.step+md/2-TV.step*h/2+1
              
              TV.mem = fltarr(h, w)
              for y=0, n_elements(lowy)-1 do begin
                 TV.mem(y, * ) = temp(lowy(y), *)
              endfor 
              temp = !NONE

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
