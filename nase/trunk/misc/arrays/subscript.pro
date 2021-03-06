;+
; NAME:
;   Subscript()
;
; VERSION:
;   $Id$
;
; AIM:
;   converts one dimensional arrays into the corresponding multi dimensional ones
;
; PURPOSE:
;   returns the corresponding multi-dimensional indices
;   for a list of one-dimensional array indices.
;
; CATEGORY:
;   Array
;
; CALLING SEQUENCE:
;   mil = Subscript (A, oil)
;   mil = Subscript (oil, SIZE=sA)
;
; INPUTS:
;   A  :: the array, where the indices point to (D dimensions)
;   oil:: single index or a list of indices (one dimensional) 
;
; INPUT KEYWORDS:
;   sA :: the size (as returned by IDLs SIZE function)
;         of the underlying array. This options saves
;         memory in contrast to passing the whole array A.
;
; OUTPUTS:
;   mil :: array containing the resulting multidimensional
;          array indices. If OIL is scalar, the array
;          contains D elements (equal to the number of
;          dimensions of A). If OIL is in array, MIL has
;          2 dimensions, where the leading one adresses
;          the index count.
;
; PROCEDURE:
;   DIVs and MODs
;
; EXAMPLE:
;
;*  Arr = IndGen(23,17,5)
;*  print, Subscript(Arr, 999)
;*  > 10    9    2
;*  print, Arr(10,9,2)
;*  > 999
;
;-
Function Subscript, _A1, _A2, SIZE=_size
 
  ; check dimensions & syntax
  CASE N_Params() OF
      1: BEGIN
          indices = _A1
          IF NOT Set(_size) THEN Console, 'either dims or size must be set', /FATAL
          dims=_size(1:_size(0))
         END
      2: BEGIN
          indices=_A2
          dims=(SIZE(_A1))(1:(SIZE(_A1))(0))
         END
      ELSE: Console, 'wrong number of argument', /FATAL
  END
  ndim=N_Elements(dims)


   ni = N_Elements(indices)
   IF ni GT 1 THEN i = REFORM(indices, ni) ELSE i = indices
   
   res = lonarr(ni, ndim)
   divby = product(dims)

   for dim=ndim-1, 1, -1 do begin
       divby = divby/dims(dim)
       res(*,dim) = i/divby
       i = i mod divby
   endfor
   res(*,0) = i
   
   return, reform(res)
   
End
