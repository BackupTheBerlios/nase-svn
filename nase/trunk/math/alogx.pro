;+
; NAME:
;  alogx()
;
;
; VERSION:
;  $Id$
;
; AIM:
;  logarithm to any specified base
;
; PURPOSE:
;  Calculate the logarithm to any base.
;
;
; CATEGORY:
;
;  Math
;
; CALLING SEQUENCE:
;
;*    out = alogx(arg, base)
;
;
; INPUTS:
;  arg:: the argument
;  base:: the base for the logarithm
;
;
; OUTPUTS:
;  out0:: log(x) to base
;
; SIDE EFFECTS:
;  no bad feelings up to now
;
; PROCEDURE:
;  The standart formula as you can find in any math book. Unfortunately IDL supports logs to base e and 10 only.
;
; EXAMPLE:
;  Please provide a simple example here. Things
;  you specifiy on IDLs command line should be written
;  as
;*  print, alogx(32,2)
;
;  IDLs output should be shown using
;*  >5.00000
;
;
;-

function alogx, argument, base

	if argument le 0	then message, 'argument must be positiv'
	if base le 0		then message, 'base must be positiv'

	return, alog10(argument)/alog10(base)

end