;+
; NAME:
;  ShiftDim()
;
; VERSION:
;  $Id$
;
; AIM:
;  Cyclically shifts the dimensions of an array.
;
; PURPOSE:
;  Special case of IDLs' <*>Transpose</*>.<BR>
;  Returns an array given with arbitrary size with cyclically shifted dimension order.
;
; CATEGORY:
;  Array
;
; CALLING SEQUENCE:
;  narr = ShiftDim(arr, step)
;
; INPUTS:
;  arr :: The array to be shifted.<BR>
;         Arrays with less than two dimensions will be
;         returned unchanged and cause a warning.
;  step:: The scalar shift parameter.
;         This argument is passed to IDLs' <*>Shift<*>. Therefore the same
;         rules for the direction of the shift hold.<BR>
;         Also, shift specification as 0 results in no shift.
;
; OUTPUTS:
;  narr:: The resulting array with the dimension order shifted.
;
; PROCEDURE:
;  Uses IDLs' <*>Transpose</*> in combination with <*>Shift</*> applied to
;  an index array for the dimensions.
;
; EXAMPLE:
;*  a = intarr(2,3,4)
;*  print, size(shiftdim(a,-1),/dimensions)
;*  > 3 4 2
;
; SEE ALSO:
;  <*>Transpose</*>
;
;-


FUNCTION ShiftDim, arr, step

  On_Error, 2

  ndsarr = Size(arr,/n_dimensions)
  IF ndsarr LT 2 THEN BEGIN
    Console, 'array dimensions < 2; returning',/WARNING
    Return, arr
  ENDIF ELSE Return, Transpose(arr,Shift(IndGen(ndsarr),step))

END


;*************************************************************************************************************************
;*************************************************************************************************************************
