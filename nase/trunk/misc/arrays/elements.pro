;+
; NAME:
;  Elements()
;
; AIM:
;  returns all distinct elements of an array
;
; PURPOSE:
;  This function returns all distinct elements of an array, i.e. multiple entries of the argument
;  occur only once in the result. The result is sorted in ascending order.<BR>
;  Analogous to IDL's <*>N_Elements</*> an undefined argument is allowed. Here it will result in <*>!None</*>
;  as return value. This result may be intepreted as 'empty set' and can be passed to several function dealing
;  with sets (e.g. <A>CutSet</A>, <A>UniSet</A>).
;
; CATEGORY:
;  Array
;
; CALLING SEQUENCE:
;*    el = Elements(arr [,cnt])
;
; INPUTS:
;  arr:: an array of any type and any dimensions
;
; OPTIONAL OUTPUTS:
;  cnt:: contains the number of elements of <*>el</*>
;
;
; PROCEDURE:
;  <*>Elements</*> uses IDL's <*>Uniq</*>. Therefore the result is
;  necessarily sorted.
;
; EXAMPLE:
;
; SEE ALSO:
;  <*>N_Elements</*>
;
;
;-

FUNCTION Elements, arr, cnt

  IF Set(arr) THEN BEGIN
    ; ok, do it!
    el  = arr(Uniq(arr,Sort(arr)))
    cnt = N_ELEMENTS(el)
    RETURN, [el]

  ENDIF ELSE BEGIN
    ; an undefined argument is interpreted as an empty set (!None)
    Console, 'argument undefined; returning !NONE',/MSG
    RETURN, !NONE

  ENDELSE

END