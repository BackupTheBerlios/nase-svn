;+
; NAME:
;  MinimalIntType()
;
; VERSION:
;  $Id$
;
; AIM:
;  Return the shortest IDL integer datatype that can hold a given value.
;
; PURPOSE:
;  This routine returns the type code of the shortest (unsigned) IDL
;  integer datatype that can hold a given (positive) integer value.
;
; CATEGORY:
;  DataStorage
;
; CALLING SEQUENCE:
;*typecode = MinimalIntType(integer)
;
; INPUTS:
;  integer:: A positive integer value.
;
; OUTPUTS:
;  typecode:: The IDL typecode of the shortest unsigned IDL integer
;             datatype that can hold the given integer value. For an
;             overview of IDL typecodes, see IDL's documentation of the
;             <C>SIZE()</C> function.
;
; RESTRICTIONS:
;  The arguments needs to be a positive integer value.
;
; PROCEDURE:
;  Just a sequence of <C>LT</C> comparisons.
;
; EXAMPLE:
;  Create an array that uses as little memory as possible, while
;  guaranteed to be able to hold values up to MAXVAL:
;
;*MAXVAL=23
;*a=make_array(10, 10, type=MinimalIntType(MAXVAL))
;*help, a 
;*>A               BYTE      = Array[10, 10]
;
;*MAXVAL=2399
;*a=make_array(10, 10, type=MinimalIntType(MAXVAL))
;*help, a 
;*>A               UINT      = Array[10, 10]
;
;*MAXVAL=239923
;*a=make_array(10, 10, type=MinimalIntType(MAXVAL))
;*help, a 
;*>A               ULONG     = Array[10, 10]
;
;*MAXVAL=23992399999999
;*a=make_array(10, 10, type=MinimalIntType(MAXVAL))
;*help, a 
;*>A               ULONG64   = Array[10, 10]
;
; SEE ALSO:
;  IDL's <C>SIZE()</C>.
;-

Function MinimalIntType, arg

   assert, arg gt 0, "Only positive arguments are supported."
   assert, arg eq ULong64(arg), "Only integer arguments are supported."

   if arg lt 2    ^  8 then return, 1 ;byte (8-bit)
   if arg lt 2ul  ^ 16 then return, 12 ;unsigned int (16-bit)
   if arg lt 2ull ^ 32 then return, 13 ;unsigned long int (32-bit)
   return, 15                   ;unsigend long long int (64-bit)
   
End
