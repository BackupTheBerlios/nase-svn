;+
; NAME:
;  Span()
;
; VERSION:
;  $Id$
;
; AIM:
;  returns one-dimensional array of equally spaced doubles
;
; PURPOSE:
;  Returns one-dimensional array of equally spaced doubles ranging
;  from <*>start</*> to <*>stop</*> using a given number of
;  <*>elements</*>. This is a very simple
;  routine, that can save some typing and thinking. Its usage is
;  simpler than the more powerful <A>Ramp</A> function.
;
; CATEGORY:
;  Array
;
; CALLING SEQUENCE:
;*r=span([start [,stop [,elements]]]) 
;<BR>Please look at the examples for usage.
;
; OPTIONAL INPUTS:
;  start    :: specifies the value of the first index of the resulting array
;  stop     :: specifies the value of the first index of the resulting array
;  elements :: number of elements that <*>r</*> will have
;
; OUTPUTS:
;  r :: one-dimensional array of equally spaced doubles
;
; EXAMPLE:
;*span(64)
;returns an array containing 65 elements ranging from 0 to 64
;*span(-18)
;returns an array containing 19 elements ranging from -18 to 0
;*span(-64,64)
;returns an array containing 129 elements ranging from -64 to 64
;*span(-64,64,257)
;returns an array containing 257 elements ranging from -64 to 64
;
; SEE ALSO:
;  <A>Ramp</A>
;-

FUNCTION SPAN, _start, _stop, n

On_Error, 2

CASE N_Params() OF
    0: RETURN, 0
    1: BEGIN
        IF _start GT 0 THEN BEGIN
            start=0
            stop=_start
        END ELSE BEGIN
            start=_start
            stop=0
        END
    END
    2: BEGIN
        start=_start
        stop=_stop
        IF start GT stop THEN swap, start, stop
    END
    3: BEGIN
        start=_start
        stop=_stop
        IF start GT stop THEN swap, start, stop
    END
END

IF Ordinal(stop-start) THEN Default, n, ABS(stop-start)+1 $
                       ELSE Console, 'you must specify n with these parameters', /FATAL
IF N_Elements(start) GT 1 THEN Console, 'start must be a scalar', /FATAL
IF N_Elements(stop) GT 1  THEN Console, 'stop must be a scalar', /FATAL
IF n LT 1                 THEN Console, 'n must be > 0', /FATAL  
IF Not(Ordinal(n))        THEN Console, 'n must be ordinal', /FATAL

IF (n EQ 1) THEN BEGIN
    IF start EQ stop THEN return, start $
                     ELSE Console, "can't succeed with these parameters", /FATAL
END

RETURN, start+DIndgen(n)/(n-1)*(stop-start)

END
