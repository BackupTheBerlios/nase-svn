;+
; NAME:
;  RemoveMean()
;
; VERSION:
;  $Id$
;
; AIM:
;  Removes the mean value(s) from an array in the specified dimension.
;
; PURPOSE:
;  This routine determines the mean value(s) of an array <*>x</*> as a whole or in a certain dimension and subtracts it
;  (them) from the array as a whole or from the sub-arrays in that dimension, respectively. The obtained result <*>y</*>
;  is returned as an array of the same dimensional structure as the input array, but possibly of a more general type
;  (e.g., float instead of integer).
;
; CATEGORY:
;  Algebra
;  Array
;  Math
;  Statistics
;  Signals
;
; CALLING SEQUENCE:
;* y = RemoveMean(x [,dimension]
;
; INPUTS:
;  x::  An integer or float array from which to subtract the mean value(s).
;
; OPTIONAL INPUTS:
;  dimension::  An integer scalar giving the dimension in which to subtract the mean value(s). If omitted or set to zero,
;               the mean value of <*>x</*> is subtracted from <*>x</*> as a whole. Otherwise, <*>dimension</*> must have
;               a value between 1 and the number of dimensions of <*>x</*>. Like in the <*>Total</*> syntax, "1" (not "0")
;               denotes the first dimension, and so on.
;
; OUTPUTS:
;  y::  A float array of the same dimensional structure as <*>x</*>, being the same as x, except that the mean value(s)
;       has (have) been subtracted.
;
; RESTRICTIONS:
;  Note that if <*>x</*> is of any integer type, the result <*>y</*> will be of float type.
;
; PROCEDURE:
;  After testing for some special cases, the procedure generally is as follows:<BR>
;  The mean values of the array <*>x</*> in the specified dimension are computed. The resulting array <*>M</*> has one
;  less dimension than <*>x</*> and is therefore "blown up" to the size of <*>x</*>. Afterwards it is subtracted from
;  <*>x</*>.
;
; EXAMPLE:
;  Generate an array and see how the mean values are removed in different dimensions (display the results if you like):
;
;* x  = FIndGen(10,1,3,1,5)
;* y  = RemoveMean(x)
;* y0 = RemoveMean(x, 0)
;* y1 = RemoveMean(x, 1)
;* y2 = RemoveMean(x, 2)
;* y3 = RemoveMean(x, 3)
;* y4 = RemoveMean(x, 4)
;* y5 = RemoveMean(x, 5)
;
;-



FUNCTION  RemoveMean,   X, Dimension


   ;----------------------------------------------------------------------------------------------------------------------
   ; Checking parameters and errors, initializing variables:
   ;----------------------------------------------------------------------------------------------------------------------

   On_Error, 2

   IF  NOT(Set(X))  THEN  Console, '  Argument not defined.', /fatal

   SizeX = Size([X])
   DimsX = Size(X, /dim)
   TypeX = Size(X, /type)
   NDims = SizeX(0)
   IF  (TypeX GE 6) AND (TypeX LE 11)  THEN  Console, '  x is of wrong type', /fatal

   ; Checking the argument DIMENSION:
   IF  Set(Dimension)  THEN  BEGIN
     IF  (Size(Dimension, /type) GE 6) AND (Size(Dimension, /type) LE 11)  THEN  Console, '  Dimension variable is of wrong type', /fatal
     Dim = Round(Dimension(0))   ; If DIMENSION is an array, only the first value is taken seriously.
   ENDIF  ELSE  $
     Dim = 0L
   IF  (Dim LT 0) OR (Dim GT NDims)  THEN  Console, '  Specified dimension out of allowed range', /fatal

   IF  Dim EQ 0  THEN  N = N_Elements(X)  $
                 ELSE  N = DimsX(Dim-1)       ; number of elements in the specified dimension
   ; If the number of elements in the specified dimension is 1, subtracting the mean is equivalent to subtracting X
   ; from itself, since for each epoch the mean value is the (only one) value itself. This will be explicitly computed,
   ; but a warning message is given here:
   IF  N LT 2  THEN  Console, '  Specified dimension contains only one element. Result is identically zero.', /warning

   ;----------------------------------------------------------------------------------------------------------------------
   ; Special and easy case (treating X as a whole, or X is one-dimensional):
   ;----------------------------------------------------------------------------------------------------------------------

   ; If DIM is zero (this includes the case that DIMENSION is not set) or if X is one-dimensional, the mean is subtracted
   ; from X as a whole:
   IF  (Dim EQ 0) OR (NDims EQ 1)  THEN  Return,  X - Total(X) / N
   ; => In the following it can be assumed that  1.) NDims >= 2,
   ;                                        and  2.) 1 <= Dim <= NDims.
   Assert, (NDims GE 2) AND (Dim GE 1) AND (Dim LE NDims)

   ;----------------------------------------------------------------------------------------------------------------------
   ; Computing the mean values array M and "blowing it up" to the size of X:
   ;----------------------------------------------------------------------------------------------------------------------

   ; The mean value(s) is (are) computed:
   M = Total(X,Dim) / N

   ; The following array contains the indices of the dimensions which have "survived" the TOTAL procedure, followed by the
   ; index of that dimension which has been eliminated (assuming the maximal number of dimensions being 8):
   DM = [Where(IndGen(8) NE (Dim-1)) , (Dim-1)]
   ; The array with the dimensions of X is extended by "ones" such that it has 8 elements altogether (the roundabout
   ; way of first generating a 9-element array and then truncating it is just a one-command-line version of handling
   ; the situation that DIMSX has already 8 elements, which would yield the second argument for REPLICATE zero and thus
   ; lead to an error):
   DX = ([DimsX , Replicate(1,9-NDims)])(0:7)
   ; Now M can be "blown up" with the REBIN routine to the same overall size as X; however, the dimension specified by
   ; DIM is now at the last position. (Unfortunately, by the way, the REBIN routine does not accept an array as the
   ; second argument, which makes the command line look somewhat confusing):
   M = Rebin(M,  DX(DM(0)),DX(DM(1)),DX(DM(2)),DX(DM(3)),DX(DM(4)),DX(DM(5)),DX(DM(6)),DX(DM(7)), /sample)

   ; The dimension at the last position has to be shifted to the position originally specified by DIM. In principle,
   ; the corresponding permutation vector for the TRANSPOSE routine is not difficult to create; it is just obtained by
   ; sorting the indices contained in DM.
   ; However, the very unpleasant situation may arise that the DIM-th dimension (currently at the last position) contains
   ; only one element and has therefore been eliminated by IDL. In such a case, the transposing procedure would lead to
   ; an error because the permutation vector has more elements than M has dimensions. The permutation vector therefore
   ; has to be truncated correspondingly. Afterwards, the eliminated dimensions are inserted again, using the REFORM
   ; function, in order to restore X's original dimensional structure.
   IF  (Size(M))(0) NE 8  $
     ; If dimensions were lost because the last dimension has only one element:
     THEN  M = Reform(Transpose(M, Sort(DM(0:(Size(M))(0)-1))), DimsX, /overwrite)  $
     ; If nothing scary has happened during the rebinning => everything all right:
     ELSE  M = Transpose(M, Sort(DM))

   Return, X - Temporary(M)


END
