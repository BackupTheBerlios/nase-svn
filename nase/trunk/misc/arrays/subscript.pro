;+
; NAME:               Subscript
;
; AIM:                converts one dimensional arrays into the corresponding multi dimensional ones
;
; PURPOSE:            returns the corresponding multi-dimensional indices
;                     for a list of one-dimensional array indices.
;
; CATEGORY:           MISC ARRAY
;
; CALLING SEQUENCE:   mil = Subscript (A, oil)
;                     mil = Subscript (oil, SIZE=sA)
;
; INPUTS:               A: the array, where the indices point to (D dimensions)
;                     oil: single index or a list of indices (one
;                          dimensional) 
; KEYWORD PARAMETERS:  sA: the size (as returned by IDLs SIZE function)
;                          of the underlying array. This options saves
;                          memory in contrast to passing the whole array A.
;
; OUTPUTS:            mil: array containing the resulting multidimensional
;                          array indices. If OIL is scalar, the array
;                          contains D elements (equal to the number of
;                          dimensions of A). If OIL is in array, MIL has
;                          D+1 dimensions, where the leading one adresses
;                          the index count.
;
; PROCEDURE:         DIVs and MODs
;
; EXAMPLE:           Arr = IndGen(23,17,5)
;                    print, Subscript(Arr, 999)
;                                      => output: 10    9    2
;                    print, Arr(10,9,2)
;                                      => output: 999
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 1.3  2000/09/25 09:12:55  saam
;        * added AIM tag
;        * update header for some files
;        * fixed some hyperlinks
;
;        Revision 1.2  2000/05/22 09:43:18  saam
;              + expanded to process multiple indices at once
;              + enhanced error processing
;              + new keyword SIZE to save memory
;
;        Revision 1.1  1997/10/29 15:59:57  kupper
;        Schöpfung!
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
