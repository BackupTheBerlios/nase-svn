;+
; NAME:
;  ISelect
;
; VERSION:
;  $Id$
;
; AIM:
;  selects a subarray without using the asterisk syntax
;
; PURPOSE:
;  When programming a routine that handles several array dimensions, you
;  need statements like <*>A(*,*,*,*,i,*,*)</*>. This is annoying,
;  when you don't know the postition of <*>i</*> and the array's
;  dimension at compile time. <C>ISelect</C> saves you from
;  constructing complicated <C>CASE</C>-statements by providing an
;  easy to use interface.
;
; CATEGORY:
;  Array
;
; CALLING SEQUENCE:
;*r = ISelect( A, dim, idx)
;
; INPUTS:
;  A  :: input array
;  dim:: dimension of the selection. <*>dim=1</*> specifies the first
;        dimension. Negative values specify the dimension relative to
;        the last dimension of the array (<*>dim=-1<*>: last dimension)
;  idx:: single or list of indices to extract from the specified dimension
;
; OUTPUTS:
;  r :: output array
;  
; EXAMPLE:
;Define a sample array:
;*a=indgen(1,2,3,4,5,6)
;a(*,*,*,2,*,*) is equivalent to:
;*help, iselect(a, 4, 2)
;*;<Expression>    INT       = Array[1, 2, 3, 1, 5, 6]
;
;a(*,*,*,*,*,[1,3,2]) is equivalent to:
;*help, iselect(a, -1, [1,3,2])
;*;<Expression>    INT       = Array[1, 2, 3, 4, 5, 3]
;
;-

FUNCTION ISelect, A, _dim, idx

   ON_Error, 2

   sA = SIZE(A)
   dim = _dim
   
   IF dim eq 0 THEN Console, 'illegal dimension specifier', /FATAL 
   IF (dim LT 0) THEN dim = sA(0)+dim+1
   IF sA(0) LT dim THEN Console, 'dimension too large for array', /FATAL 

   CASE dim OF 
       1: RETURN, A(idx,*,*,*,*,*,*,*)
       2: RETURN, A(*,idx,*,*,*,*,*,*)
       3: RETURN, A(*,*,idx,*,*,*,*,*)
       4: RETURN, A(*,*,*,idx,*,*,*,*)
       5: RETURN, A(*,*,*,*,idx,*,*,*)
       6: RETURN, A(*,*,*,*,*,idx,*,*)
       7: RETURN, A(*,*,*,*,*,*,idx,*)
       8: RETURN, A(*,*,*,*,*,*,*,idx)
       ELSE: Console, "illegal dimension ("+STR(dim)+") this shouldn't happen", /FATAL
   END

END
