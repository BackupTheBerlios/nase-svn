;+
; NAME:
;  ReplicateArr()
;
; AIM:
;  Returns an array replicated in multiple dimensions.
;
; PURPOSE:
;  IDL's <C>Replicate</C> returns a single value replicated in multiple dimensions .<BR>
;  IDL's <C>Rebin</C> can do this for all arrays, except string and complex.
;  <C>ReplicatArr</C> can do this for <I>all</I> arrays. <BR>
;  In contrast to <C>Rebin</C> but similar to <C>Replicate</C> only the newly added dimensions
;  have to be specified, the size of the original array does not need to be known.
;
; CATEGORY:
;  Array
;
; CALLING SEQUENCE:
;* ra = ReplicateArr(a, repdim)
;
; INPUTS:
;  a:: the array of any type to be replicated
;  repdim:: an array defining the newly added dimensions
;
; OUTPUTS:
;  ra:: the replicated array of dimension [Dim(a),repdim]
;
; RESTRICTIONS:
;  IDL does not allow more than 8 dimensions.
;
; PROCEDURE:
;  The routine uses <C>Rebin</C> where possible and else works brute force.
;
; EXAMPLE:
;* a = IndGen(10)
;* r = ReplicateArr(a,[5,1,6])
;* help, a, r
;* >  A  INT = Array[10]
;* >  R  INT = Array[10, 5, 1, 6]
;
; SEE ALSO:
;  <C>Replicate</C>, <C>Rebin</C>.
;
;-


FUNCTION ReplicateArr, A, RepDim

  On_Error, 2

  Default, RepDim, 1  ; if not specified, the original array will be returned

  IF N_Params() LT 1  THEN Console, 'invalid arguments', /FATAL
  IF SubSet(0,RepDim) THEN Console, 'invalid new dimensions', /FATAL

  OldDim = Size(A,/DIMENSION)
  NewDim = [OldDim,RepDim]

  IF N_Elements(NewDim) GT 8 THEN Console, 'too many new dimensions', /FATAL


  ; check whether type of array is string/complex or anything else
  Shit = SubSet(Size(A,/TYPE),[6,7])

  IF NOT Shit THEN BEGIN ; use the Rebin function (not possible for string/complex)

    IF N_Elements(NewDim) LT 8 THEN NewDim = [NewDim,Replicate(1,8-N_Elements(NewDim))]
    D0 = NewDim(0) & D1 = NewDim(1) & D2 = NewDim(2) & D3 = NewDim(3)
    D4 = NewDim(4) & D5 = NewDim(5) & D6 = NewDim(6) & D7 = NewDim(7)

    Return, Reform(Rebin(A,D0,D1,D2,D3,D4,D5,D6,D7),[OldDim,RepDim])

  ENDIF ELSE BEGIN  ; do it brute force for string/complex arrays

    Multi   = Product(RepDim) > 1
    OldBin  = N_Elements(A)

    NewA = Reform(A, OldBin)
    FOR i = 1L,Multi-1 DO NewA = [NewA,Reform(A, OldBin)]

    Return, Reform(NewA, NewDim, /OVERWRITE)

  ENDELSE

END

;*************************************************************************************************************************
;*************************************************************************************************************************
