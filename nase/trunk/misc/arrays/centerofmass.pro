;+
; NAME:
;  CenterOfMass()
;
; AIM:
;  Calculate center of mass (gravity).
;
; PURPOSE:
;  Calculate center of gravity for an mass distribution of arbitrary dimensionality <BR>
;  Array indices represent space, array values represent mass.
;
; CATEGORY:
;  Array
;  Math
;  Statistics
;
; CALLING SEQUENCE:
;
;*    cm = CenterOfMass(A [,SIG=...])
;
; INPUTS:
;  A:: an array of arbitrary dimensionality (<=7) of any floating or integer type
;
; INPUT KEYWORDS:
;  SIG:: consider only values of <*>A</*> that deviate at least <*>Sig*StdDev(A)</*> from the mean value of <*>A</*>.<BR>
;        Depending on the sign of <*>Sig</*> lowest or highest values are considered. <BR>
;        (This Keyword is only for compatibility with the earlier <A>Schwerpunkt</A> function.)
;
; OUTPUTS:
;  cm:: Float array with number of elements as number of dimensions of <*>A</*>.
;       Contains <*>!None</*> if no element of <*>A</*> fulfilles the criterion specified via <*>Sig</*> or
;       if all elements are zero.
;
; RESTRICTIONS:
;  Makes only sense (and therefore only allows) floating or integer types.
;  CAUTION: An auxillary array is needed consuming N times the space of argument <*>A</*>,
;  were N is the number of dimensions of <*>A</*>. So watch the size of your argument/space in memory.
;
; PROCEDURE:
;  The mean of the values of <*>A</*> weighted with their index for each dimension is returned.
;  Uses <A>Subscript</A> and <A>ReplicateArr</A>.
;
; EXAMPLE:
;
; SEE ALSO:
;  <A>Schwerpunkt</A> was much slower, wrong for negative <*>Sig</*> and is now obsolete.
;
;-



FUNCTION CenterOfMass, A, SIG=SIG

   On_Error, 2

   IF NOT Set(A) OR (Set(A) AND SubSet(Size(A,/TYPE),[6,7])) THEN  $
     Console, /FATAL, 'Invalid argument'

   SA   = Size(A)
   NDim = SA(0)
   N    = N_Elements(A)

   IF Keyword_Set(SIG) THEN BEGIN
     M   = IMean(A, StdDev)
     Aux = A * (Signum(Sig)*A GE (M+Abs(Sig)*StdDev))
   ENDIF ELSE Aux = A

   IF Total(Abs(Aux)) NE 0 THEN BEGIN

      CM = Total(Temporary(ReplicateArr(Float(Aux(LIndGen(N))),NDim)*SubScript(LIndGen(N),SIZE=SA)),1)
      Return, CM/Total(Abs(Aux))

   END ELSE Return, Replicate(!NONE, NDim)

End
