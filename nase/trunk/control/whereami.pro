;+
; NAME:
;  WhereAmI()
;
; VERSION:
;  $Id$
;
; AIM:
;  determines the name of the calling routine
;
; PURPOSE:
;  This routine determines the name of the routine that called
;  <C>WhereAmI</C>, or the one that called the routine that called
;  <C>WhereAmI</C> ... This is i.e. useful, for plot labels that
;  should indicate, which routine produced the plot. Of course, you
;  can do this by hand, but what if you change the routine name and
;  forget to change your label?
;
; CATEGORY:
;  ExecutionControl
;
; CALLING SEQUENCE:
;*name = WhereAmI([pc] [,SOURCE=...] [,LINE=...])
;
; OPTIONAL INPUTS:
;  pc:: Number (on the callstack) of the routine that shall be
;       displayed as the origin of the message. By default,
;       this is 0, meaning the routine that called
;       <C>WhereAmI</C>. This must not be higher than the actual call
;       stack depth.
;
; OUTPUTS:
;  name:: (uppercase) string containing the routine name that called
;         <C>WhereAmI</C>. This will be $MAIN$, if called from the
;         main execution level.
;
; OPTIONAL OUTPUTS:
;  SOURCE:: the complete filepath to the routine calling <C>WhereAmI</C>
;  LINE  :: line number in the routine calling <C>WhereAmI</C> as long.
;
; EXAMPLE:
;  Assume you are on the main execution (i.e. by typing <C>retall</C>)
;*c = WhereAmI(SOURCE=s,LINE=l) & help, c, s, l
;*>C               STRING    = '$MAIN$'
;*>S               STRING    = ''
;*>L               LONG      =           -1
;
;-

FUNCTION WhereAmI, pickcaller, SOURCE=source, LINE=line

On_Error, 2

Default, pickcaller, 0
IF N_Elements(pickcaller) GT 1 THEN Console, /FATAL, 'argument has to be scalar'

help, calls=m
assert, pickcaller ge 0
assert, (pickcaller+1) lt N_Elements(m), "Too few elements on the callstack."
m = m(pickcaller+1)

; m(i) : 'routine <path( line)>'
m = split(m,' <')
_called_by = m(0)

source = ''
line = -1l
IF N_Elements(m) GT 1 THEN BEGIN ;; main execution level does not provide the following info
    m = split(m(1), '(')
    source = m(0)
    m = split(m(1), ')')
    line=long(m(0))
END


return, _called_by

END
