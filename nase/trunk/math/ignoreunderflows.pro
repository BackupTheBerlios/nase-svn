;+
; NAME:
;  IgnoreUnderflows
;
; VERSION:
;  $Id$
;
; AIM:
;  Suppress display of <I>Floating Underflow</I> math errors.
;
; PURPOSE: 
;  <I>Floating Underflow</I> errors can appear very frequently in numeric
;  computations. In most cases, these are non-critical errors,
;  indicating that an expression evaluated to a result too small to be
;  represented by a floating point number, and that the result was
;  therefore substituted by zero.<BR>
;  When executing IDL main programs, math errors accumulate and will
;  be displayed after termination of the main level program. (See also
;  meaning of the <*>!EXCEPT</*> system variable in the IDL help.)
;  This will be tolerable in most cases. However, output of the error
;  messages may be a problem when executing standalone
;  widget-applications, allowing for an active commandline. Here, math
;  errors will instantly be printed each time the event cycle is
;  terminated. I.e., <I>Floating Underflow</I> error messages are likely to
;  be printed very numerously, which may considerably slow down
;  program execution.<BR>
;  One possible solution to this problem is setting <*>!EXCEPT=0</*>,
;  which will totally suppress output of math errors. This will lead to
;  suppression of error messages even for critical math errors. For
;  platforms supporting selective resetting of math error flags,
;  another method can be used: To selectively suppress <I>Floating
;  Underflow</I> error messages, call <C>IgnoreUnderflows</C> whenever a
;  floating underflow is likely to have appeared in your
;  computations. This will reset the specific flag and prevent IDL from
;  printing an error message. Printing of other math errors is not
;  changed by a call to this routine.<BR>
;  <B>See section RESTRICTIONS for a note on IDL versions and platforms.</B>
;
; CATEGORY:
;  IO
;  Math
;  Widgets
;
; CALLING SEQUENCE:
;*IgnoreUnderflows
;
; SIDE EFFECTS:
;  On platforms (and IDL versions) supporting selective clearing of
;  math error flags, the flag indicating floating underlow will be
;  cleared.
;
; RESTRICTIONS:
;  Selective reset of math error flags is, apparently, not supported
;  on the Windows platform (keyword <C>MASK</C> to
;  <C>CHECK_MATH</C>). Also, the <C>MASK</C> keyword to
;  <C>CHECK_MATH</C> is unknown in IDL version 3.<BR>
;  In these cases, calls to <C>IgnoreUnderflows</C> are silently
;  skipped. <B>If future versions of IDL support selective flag
;  handling for math errors on the windows platform, please adjust
;  this procedure!</B>
;
; PROCEDURE:
;  Check for supported platform/version, then execute
;  <*>dummy = Check_Math(Mask=32)</*>. 
;
; EXAMPLE:
;*> a = exp(-300)
;*% Program caused arithmetic error: Floating underflow
;*> a = exp(-300) & IgnoreUnderflows
;*>
;
; SEE ALSO:
;  <C>CHECK_MATH</C>
;-

Pro IgnoreUnderflows
   If IdlVersion() gt 3 then $
    If !Version.OS_FAMILY ne "WIndows" then dummy = Check_Math(Mask=32)
End
