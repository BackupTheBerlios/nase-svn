
FUNCTION IFod, MODE=mode, PATTERN=pattern, WIDTH=w, HEIGHT=h, TEMP_VALS=_TV, DELTA_T=delta_t, $
                      LOGIC=op, STIMORIENT=stimorient, DETECTORIENT=detectorient, STIMPERIOD=stimperiod, STIMPHASE=stimphase, $
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
          Default, a, 500.
          Default, stimorient, 0
          Default, detectorient, 0
          Default, stimphase, 0
          Default, stimperiod, 1
          md = FIX(MAX([w,h])*1.5)
          md = md + ((md+1) MOD 2) + 50
          y=sin(2*!DPi*((dindgen(md) - md/2)/stimperiod + stimphase/360.d))          
          lstim=(1+rebin(y,md,md,/SAMPLE))*0.5
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
                  detectorient : detectorient,$
                  stimorient   : stimorient  ,$
                  stepangle    : stepangle   ,$
                  cangle       : 0d          ,$
                  delta_t      : delta_t     ,$
                  sim_time     : .0d         ,$
                  myop         : opID(op)     $
                }
         Console, 'a='+STR(TV.a)+', grating: '+STR(TV.stimorient)+' dg, detector: '+STR(TV.detectorient)+' dg, spat freq: '+STR(TV.stimperiod)+', phase: '+STR(TV.stimphase)+' dg'
      END
      
      ; STEP
      1: BEGIN                             
          IF (TV.stepangle NE 0) THEN BEGIN
              TV.cangle = (TV.cangle + TV.stepangle) MOD 360
              md = FIX(MAX([TV.w,TV.h])*1.5)
              md = md + ((md+1) MOD 2) + 50
              y=sin(2*!DPi*((dindgen(md) - md/2)/TV.stimperiod + TV.stimphase/360.d))          
              lstim=(1+rebin(y,md,md,/SAMPLE))*0.5
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
