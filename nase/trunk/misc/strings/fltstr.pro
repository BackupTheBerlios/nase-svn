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
;* s = FltStr(x [, nDec [, n]] [ SPACE = ...])
;
; INPUTS:
;  x::     Any integer, float or complex scalar or array for which the corresponding string is desired.
;
; OPTIONAL INPUTS:
;  nDec::  The number of decimal places (places after the decimal point) for each string. (Default: The number of decimal
;          places used in the IDL standard output.)
;  n::     The <I>total</I> number of places (including sign and decimal point) reserved for each string.
;          (Default: The number of places used in the IDL standard output.)
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
; RESTRICTIONS:
;  Take care that <*>n</*> is large enough to allow for all the specified decimal places, the decimal point, the sign,
;  and the largest absolute value of <*>x</*>. Otherwise you will get a string of asterisks.
;
; EXAMPLE:
;* Help, FltStr(!pi, 3), FltStr(!pi, 3, 10), FltStr(!pi, 3, 10, SPACE = '0'), FltStr(!pi, 3, 10, SPACE = '')
;
;  IDL prints:
;
;* ><Expression>    STRING    = '3.142'
;* ><Expression>    STRING    = '     3.142'
;* ><Expression>    STRING    = '000003.142'
;* ><Expression>    STRING    = '3.142'
;
; SEE ALSO:
;  <A>IntStr</A>
;
;-



FUNCTION  FltStr,   X_, NDec_, N_,   space = space_


   ;----------------------------------------------------------------------------------------------------------------------
   ; Checking parameters for errors:
   ;----------------------------------------------------------------------------------------------------------------------

   On_Error, 2

   IF  NOT(Set(X_))  THEN  Console, '   Not all arguments defined.', /fatal
   TypeX    = Size(X_   , /type)
   TypeNDec = Size(NDec_, /type)
   TypeN    = Size(N_   , /type)
   IF  (TypeX    GE 7) AND (TypeX    LE 11) AND (TypeX NE 9)  THEN  Console, '  X is of wrong type.'            , /fatal
   IF  (TypeNDec GE 6) AND (TypeNDec LE 11)                   THEN  Console, '  NDec is of wrong type.'         , /fatal
   IF  (TypeN    GE 6) AND (TypeN    LE 11)                   THEN  Console, '  N is of wrong type.'            , /fatal

   IF  Set(space_)  THEN  IF  Size(space_, /type) NE 7        THEN  Console, '  Keyword SPACE is of wrong type' , /fatal

   ;----------------------------------------------------------------------------------------------------------------------
   ; Assigning default values, converting types, initializing variables:
   ;----------------------------------------------------------------------------------------------------------------------

   X = Double(X_)
   IF  TypeNDec NE 0  THEN  NDec = Round(NDec_(0))   ; If NDec is an array, only the first value is taken seriously.
   IF  TypeN    NE 0  THEN  N    = Round(N_(0))      ; dito

   IF  Set(space_)  THEN  Space = StrMid(space_(0),0,1)  ELSE  Space = ' '

   NX = N_Elements(X)

   ;----------------------------------------------------------------------------------------------------------------------
   ; Converting the number(s) to string(s):
   ;----------------------------------------------------------------------------------------------------------------------

   IF  TypeNDec EQ 0  THEN  BEGIN
     XStr = Str(X)
   ENDIF  ELSE  BEGIN
     IF  TypeN EQ 0  THEN  XStr = Str([String( X, format = '(F255.'       +Str(NDec)+')' )])  $
                     ELSE  XStr = Str([String( X, format = '(F'+Str(N)+'.'+Str(NDec)+')' )])
     XStr = Reform(XStr, Size(X, /dim), /overwrite)
     IF  TypeN NE 0  THEN  BEGIN
       NSpace = N - StrLen(XStr)
       FOR  i = 0L, NX-1  DO  IF  NSpace(i) GT 0  THEN  XStr(i) = StrJoin(Replicate(Space, NSpace(i))) + XStr(i)
     ENDIF
   ENDELSE

   IF  (Size(X))(0) EQ 0  THEN  Return, XStr(0)  ELSE  Return, XStr


END
