;+
; NAME:
;  IntStr()
;
; VERSION:
;  $Id$
;
; AIM:
;  Converts integer number(s) to formatted string(s).
;
; PURPOSE:
;  This function converts any integer, float or complex number(s) to formatted integer string(s) with a certain number of
;  places reserved for each number. In addition, a string to fill spaces before the numbers can be specified.
;
; CATEGORY:
;  Strings
;
; CALLING SEQUENCE:
;* s = IntStr(x, n [ SPACE = ...])
;
; INPUTS:
;  x::  Any integer, float or complex scalar or array for which the corresponding integer string is desired.
;       Non-integer values of <*>x</*> are first rounded to the next integer value (internally, no side effect!).
;  n::  The total number of places (including sign) reserved for each string.
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
;* Help, IntStr(3.7, 6), IntStr(4, 6, SPACE = '0'), IntStr(3, 6, SPACE = '')
;
;  IDL prints:
;
;* ><Expression>    STRING    = '     4'
;* ><Expression>    STRING    = '000004'
;* ><Expression>    STRING    = '3'
;
; SEE ALSO:
;  <A>FltStr</A>
;
;-



FUNCTION  IntStr,   X_, N_,   space = space_


   ;----------------------------------------------------------------------------------------------------------------------
   ; Checking parameters for errors:
   ;----------------------------------------------------------------------------------------------------------------------

   On_Error, 2

   IF  NOT(Set(X_) AND Set(N_))  THEN  Console, '   Not all arguments defined.', /fatal
   TypeX    = Size(X_   , /type)
   TypeN    = Size(N_   , /type)
   IF  (TypeX    GE 7) AND (TypeX    LE 11) AND (TypeX NE 9)  THEN  Console, '  X is of wrong type.'            , /fatal
   IF  (TypeN    GE 6) AND (TypeN    LE 11)                   THEN  Console, '  N is of wrong type.'            , /fatal

   IF  Set(space_)  THEN  IF  Size(space_, /type) NE 7        THEN  Console, '  Keyword SPACE is of wrong type' , /fatal

   ;----------------------------------------------------------------------------------------------------------------------
   ; Assigning default values, converting types, initializing variables:
   ;----------------------------------------------------------------------------------------------------------------------

   X    = Round(X_)
   N    = Round(N_(0))      ; If N is an array, only the first value is taken seriously.

   IF  Set(space_)  THEN  Space = StrMid(space_(0),0,1)  ELSE  Space = ' '

   NX = N_Elements(X)

   ;----------------------------------------------------------------------------------------------------------------------
   ; Converting the number(s) to string(s):
   ;----------------------------------------------------------------------------------------------------------------------

   XStr = Str(X)

   NSpace = N - StrLen(XStr)
   FOR  i = 0, NX-1  DO  IF  NSpace(i) GT 0  THEN  XStr(i) = StrJoin(Replicate(Space, NSpace(i))) + XStr(i)

   IF  (Size(X))(0) EQ 0  THEN  Return, XStr(0)  ELSE  Return, XStr


END
