;+
; NAME:
;  InputWrapper()
;
; VERSION:
;  $Id$
;
; AIM:
;  makes mind-inputs usable for nase-users 
;
; PURPOSE:
;  makes mind-inputs usable for nase-users 
;
; CATEGORY:
;  Array
;  MIND
;  NASE
;
; CALLING SEQUENCE:
;*  RES=INPUT_WRAPPER(NAME=name,WIDTH=width,HEIGHT=height,DELTA_T=delta_t,TV=tv,MODE=mode,_EXTRA=extra))
;
; INPUTS:
;      NAME    : name of the input filter
;      WIDTH   : grid-width
;      HEIGHT  : grid-height 
;      all filter-specific parameters can be passed
;
; OPTIONAL INPUTS:
;      DELTA_T : time-resolution
;      TV      : input TV-structure (c.f. mind/input)
;      MODE    : processing mode (init/step... c.f. mind/input)
;
;
; OUTPUTS:
;      TV is changed (if passed as keyword)
;      input is returned
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
;
; PROCEDURE:
;
;
; EXAMPLE:
;*
;* > res =inputwrapper(name="ifshiftedsine",stimshift=90.,detectorient=0.,tv=tv,mode=0)
;* > plottvscl, rest
;
; SEE ALSO:
;  all mind input-routines
;
;
;-



function InputWrapper, NAME=name, width=width, height=height, delta_t=delta_t, _EXTRA=e, TV=tv, MODE=mode

default, width, width
default, height, height
default, delta_t, delta_t
default, mode, 0

; fake the TV-handle, needed by all input filters
default, tv, Handle_create(!MH,VALUE={fake: !NONE})

d = CALL_FUNCTION(name, MODE=mode, WIDTH=41, HEIGHT=21, delta_t=0.01, TEMP_VALS=tv, _EXTRA=e)
Handle_Value, tv, tmp, /NO_COPY
mem = tmp.mem
Handle_Value, tv, tmp, /NO_COPY, /SET
return, mem
end
