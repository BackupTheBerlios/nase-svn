;+
; NAME:
;  FltStr()
;
; VERSION:
;  $Id$
;
; AIM:
;  Converts floating-point number(s) to formatted string(s).
;
; PURPOSE:
;  This function converts any integer, float or complex number(s) to formatted string(s) with a certain number of places
;  and decimal places reserved for each number. In addition, a string to fill spaces before the numbers can be specified.
;
; CATEGORY:
;  Strings
;
; CALLING SEQUENCE:
;* s = FltStr(x, n, nDec [ SPACE = ...])
;
; INPUTS:
;  x::     Any integer, float or complex scalar or array for which the corresponding string is desired.
;  n::     The <I>total</I> number of places (including sign and decimal point) reserved for each string.
;  nDec::  The number of decimal places (places after the decimal point) for each string.
;
; INPUT KEYWORDS:
;  SPACE::  Set this keyword to a string scalar to be used as a "space-filler" in case the number needs less spaces than
;           specified via <*>n</*>. By default, <*>' '</*> is used. Setting this keyword to <*>''</*> results in an
;           individual length of each string (no spaces before each number). Note that the <*>SPACE</*> string is inserted
;           <I>before</I> the sign of the numbers, which looks quite funny when using a <*>SPACE</*> string other than
;           <*>''</*> or the default.
;
; OUTPUTS:
;  s::  A string (array) of the same dimensional structure as <*>x</*>, containing the string equivalent(s) of <*>x</*>.
;
; EXAMPLE:
;* Help, FltStr(2.2, 10, 3), FltStr(2, 10, 3, SPACE = '0'), FltStr(2, 10, 3, SPACE = '')
;
;  IDL prints:
;
;* ><Expression>    STRING    = '     2.200'
;* ><Expression>    STRING    = '000002.000'
;* ><Expression>    STRING    = '2.000'
;
; SEE ALSO:
;  <A>IntStr</A>
;
;-



FUNCTION  FltStr,   X_, N_, NDec_,   space = space_


   ;----------------------------------------------------------------------------------------------------------------------
   ; Checking parameters for errors:
   ;----------------------------------------------------------------------------------------------------------------------

   On_Error, 2

   IF  NOT(Set(X_) AND Set(N_) AND Set(NDec_))  THEN  Console, '   Not all arguments defined.', /fatal
   TypeX    = Size(X_   , /type)
   TypeN    = Size(N_   , /type)
   TypeNDec = Size(NDec_, /type)
   IF  (TypeX    GE 7) AND (TypeX    LE 11) AND (TypeX NE 9)  THEN  Console, '  X is of wrong type.'            , /fatal
   IF  (TypeN    GE 6) AND (TypeN    LE 11)                   THEN  Console, '  N is of wrong type.'            , /fatal
   IF  (TypeNDec GE 6) AND (TypeNDec LE 11)                   THEN  Console, '  NDec is of wrong type.'         , /fatal

   IF  Set(space_)  THEN  IF  Size(space_, /type) NE 7        THEN  Console, '  Keyword SPACE is of wrong type' , /fatal

   ;----------------------------------------------------------------------------------------------------------------------
   ; Assigning default values, converting types, initializing variables:
   ;----------------------------------------------------------------------------------------------------------------------

   X    = Float(X_)
   N    = Round(N_(0))      ; If N is an array, only the first value is taken seriously.
   NDec = Round(NDec_(0))   ; dito

   IF  Set(space_)  THEN  Space = StrMid(space_(0),0,1)  ELSE  Space = ' '

   NX = N_Elements(X)

   ;----------------------------------------------------------------------------------------------------------------------
   ; Converting the number(s) to string(s):
   ;----------------------------------------------------------------------------------------------------------------------

   XStr = Str([String( X, format = '(F'+Str(N)+'.'+Str(NDec)+')' )])
   XStr = Reform(XStr, Size(X, /dim), /overwrite)

   NSpace = N - StrLen(XStr)
   FOR  i = 0, NX-1  DO  IF  NSpace(i) GT 0  THEN  XStr(i) = StrJoin(Replicate(Space, NSpace(i))) + XStr(i)

   IF  (Size(X))(0) EQ 0  THEN  Return, XStr(0)  ELSE  Return, XStr


END
