;+
; NAME: 
;   IFShiftedSine
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


FUNCTION IFShiftedSine, MODE=mode, PATTERN=pattern, WIDTH=w, HEIGHT=h, TEMP_VALS=_TV, DELTA_T=delta_t, $
                      LOGIC=op, STIMORIENT=stimorient, DETECTORIENT=detectorient, STIMPERIOD=stimperiod, STIMPHASE=stimphase, $
                STIMSHIFT=stimshift,$ $
                STEPANGLE=stepangle,detectsize=detectsize, pick=pick,iwidth=iwidth,iheight=iheight, $
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
         Default,iwidth, w*10   
         Default,iheight,h*10
         Default, a, 500.
         Default, stimorient, 0
         Default, detectorient, 0
         Default, stimphase, 0
         Default, stimshift, 0
         Default, stimperiod, 1
         mdx = fix(iwidth+2*detectsize)
         mdy = fix(iheight+2*detectsize)
         mdy= ((mdy+1)/2)*2
         mdx= ((mdx+1)/2)*2
         y1=sin(2*!DPi*((dindgen(mdy) - mdy/2)/stimperiod + stimphase/360.d))          
         y2=sin(2*!DPi*((dindgen(mdy) - mdy/2)/stimperiod + (stimphase+stimshift)/360.d))          
         
         lstim1=(1+rebin(y1,mdy,mdx/2,/SAMPLE))*0.5
         lstim2 =(1+rebin(y2,mdy,mdx-mdx/2,/SAMPLE))*0.5
          lstim = fltarr(mdy,mdx)
          lstim(*,0:(mdx/2)-1) = lstim1
          lstim(*,(mdx/2):mdx-1) = lstim2
          
          stim = (rot(lstim,STIMORIENT,1,mdy/2,mdx/2,/cubic,/pivot))
          odm=Orient_2d(detectsize, DEGREE=DETECTORIENT-90.)    
          temp = (a*((convol(stim, odm))^2))(detectsize:iheight+detectsize-1,detectsize:iwidth+detectsize-1)
          
          
          Default, pick, grid(size=size(temp),count=[h,w], /UNIFORM)	

          mem=temp(pick)
          mem=reform(mem,h,w)
          
        	 
          
          
          TV =  {                             $
                  a            : a           ,$
                  w            : w           ,$
                  h            : h           ,$
                  mem          : mem         ,$
                  stim         : stim, $
                  stimperiod   : stimperiod  ,$
                  stimphase    : stimphase   ,$
                  stimshift    : stimshift   ,$
                  detectorient : detectorient,$
                  detectsize   : detectsize, $
                  iwidth         : iwidth,  $
		  iheight      : iheight, $
                  pick         : pick, $ 
                  stimorient   : stimorient  ,$
                  stepangle    : stepangle   ,$
                  cangle       : 0d          ,$
                  delta_t      : delta_t     ,$
                  sim_time     : .0d         ,$
                  myop         : opID(op)     $
                }

          outputstring =  'a='+STR(TV.a)+', grating: '+STR(TV.stimorient)+' dg, detector: '+STR(TV.detectorient)+' dg, spat freq: '+STR(TV.stimperiod)+', phase: '+STR(TV.stimphase)+' dg'

	outputstring=outputstring+' input image: size: '+STR(TV.iheight)+'x'+STR(TV.iwidth)+' detectorsize : '+str(detectsize)+'... returned convoluted img with min='+STR(min(TV.mem))+' and max='+STR(max(TV.mem))+'. '

          IF stimshift NE 0 THEN outputstring = outputstring + 'right half shifted by : '+STR(TV.stimshift)+' dg'
console, outputstring

      END
      
      ; STEP
      1: BEGIN                             
          IF (TV.stepangle NE 0) THEN BEGIN
             TV.cangle = (TV.cangle + TV.stepangle) MOD 360
             mdx = fix(TV.iwidth+2*TV.detectsize)
             mdy = fix(TV.iheight+2*TV.detectsize)
	     mdy= ((mdy+1)/2)*2
             mdx= ((mdx+1)/2)*2
             y1=sin(2*!DPi*((dindgen(mdy) - mdy/2)/TV.stimperiod + TV.stimphase/360.d))          
             y2=sin(2*!DPi*((dindgen(mdy) - mdy/2)/TV.stimperiod + (TV.stimphase+TV.stimshift)/360.d))          
             
              lstim1=(1+rebin(y1,mdy,mdx/2,/SAMPLE))*0.5
              lstim2 =(1+rebin(y2,mdy,mdx-mdx/2,/SAMPLE))*0.5
              lstim = fltarr(mdy,mdx)
              lstim(*,0:mdx/2-1) = lstim1
              lstim(*,(mdx/2):mdx-1) = lstim2
              
              stim = (rot(lstim,TV.STIMORIENT+TV.cangle,1,mdy/2,mdx/2,/cubic,/pivot))
              odm=Orient_2d(TV.detectsize, DEGREE=TV.DETECTORIENT-90.)    
              temp = a*((convol(stim, odm))^2)(detectsize:iheight+detectsize-1,detectsize:iwidth+detectsize-1)

                                ; points to pick
              
              
            
              TV.mem=temp(TV.pick)
	      TV.mem=reform(TV.mem,h,w)

              out= 'a='+STR(TV.a)+', grating: '+STR(TV.stimorient+TV.cangle)+' dg, detector: '+STR(TV.detectorient)+' dg, spat freq: '+STR(TV.stimperiod)+', phase: '+STR(TV.stimphase)+' dg'
	out=out+' input image: size: '+STR(TV.iheight)+'x'+STR(TV.iwidth)+' detectorsize : '+str(detectsize)+'... returned convoluted img with min='+STR(min(TV.mem))+' and max='+STR(max(TV.mem))+'. '
	console,out
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
         
         cuttedstim = TV.stim(TV.detectsize:TV.iheight+TV.detectsize-1,TV.detectsize:TV.iwidth+TV.detectsize-1)
         pick = reform(TV.pick, TV.h, TV.w)
         d=subscript(cuttedstim,TV.pick)    
         balancect, cuttedstim-.5
         plottvscl, cuttedstim-.5, /LEGEND, get_position=pos
         oplot, d(*, 0), d(*, 1), psym=4, color=rgb("white")
         odm=Orient_2d(TV.detectsize, DEGREE=TV.DETECTORIENT-90.)    
         utvscl, odm, pos(2)+0.1, pos(1)
         xyouts, pos(2)+0.1, pos(1), "OD",/normal
      END
      ELSE: BEGIN
         console, 'unknown mode', /FATAL
      END


   ENDCASE 
    Handle_Value, _TV, TV, /NO_COPY, /SET
   
   RETURN, R
END
