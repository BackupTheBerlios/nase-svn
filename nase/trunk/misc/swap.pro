;+
; NAME:
;  Swap
;
; VERSION:
;  $Id$
;
; AIM:
;  exchanges the values of two arbitrary variables
;
; PURPOSE:
;  Exchanges the values of two variables. No temporary memory is
;  used.
;
; CATEGORY:
;  DataStructures
;
; CALLING SEQUENCE:
;*swap, a, b
;
; INPUTS:
;  a,b:: the two variables to be exchanged 
;
; EXAMPLE:
;*a=5 & b=10 & print, a, b
;*;       5      10
;*swap, a, b & print, a, b
;*;      10       5
;
;-

PRO SWAP, a, b

;this works, and doesn't need a temporary variable, but only
;works for variables/array of the same type
;a=a+b
;b=a-b
;a=a-a

;;this uses a temporary variable, but no temporary memory!
tmp=Temporary(a)
a=Temporary(b)
b=Temporary(tmp)

END
