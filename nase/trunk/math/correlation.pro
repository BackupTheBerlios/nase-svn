;+
; NAME:
;  Correlation()
;
; VERSION:
;  $Id$
;
; AIM:
;  Computes the correlation or covariance coefficient of two arrays in a specified dimension.
;
; PURPOSE:
;  This routine determines the normalized or not normalized correlation or covariance coefficient(s) of two arrays
;  <*>x</*> and <*>y</*>, either as a whole or along one specified dimension. The covariance coefficient between two
;  vectors here is defined as the correlation coefficient after subtracting the means of the two vectors. The keyword
;  <*>COVARIANCE</*> allows to switch between these two alternatives. The correlation value(s) can be normalized to
;  the length of the respective vectors (such that its (their) expectation value(s) is independent of the length of
;  the vectors) by setting the keyword <*>LENGTHNORM</*>. Normalization to the energies of the <*>x</*> and <*>y</*>
;  vectors can be achieved by setting the keyword <*>ENERGYNORM</*>. In this case, the energy values can be obtained
;  in two named variables to which the keywords <*>XENERGY</*> and <*>YENERGY</*> are set.<BR>
;  The correlation <I>coefficient</I>, in contrast to the correlation <I>function</I>, can be computed very efficiently
;  and therefore deserves its own routine, which of course is much faster than computing the correlation <I>function</I>
;  and taking the centre value.
;
; CATEGORY:
;  Algebra
;  Math
;  Statistics
;  Signals
;
; CALLING SEQUENCE:
;* cxy = Correlation(x, y [, dimension] [, /COVARIANCE] [, /ENERGYNORM  [,XENERGY = ...] [,YENERGY = ...]] [, /LENGTHNORM]
;
; INPUTS:
;  x::  An integer or float array containing the vector(s) which is (are) to be correlated with the vector(s) in <*>y</*>.
;       If, for example, <*>x</*> is a 5-dimensional array and <*>dimension</*> is set to 3, then each vector
;       <*>x[i,j,*,k,l]</*> is correlated with the corresponding vector <*>y[i,j,*,k,l]</*>, for every possible
;       combination of <*>i</*>, <*>j</*>, <*>k</*>, and <*>l</*>.
;  y::  An integer or float array of the same dimensional structure as <*>x</*>.
;
; OPTIONAL INPUTS:
;  dimension::  An integer scalar giving the dimension along which <*>x</*> and <*>y</*> are to be correlated. If omitted
;               or set to zero, <*>x</*> and <*>y</*> are correlated as a whole. Otherwise, <*>dimension</*> must lie
;               somewhere between (including) 1 and the number of dimensions of <*>x</*> and <*>y</*>. Like in the
;               <*>Total</*> syntax, "1" (not "0") denotes the first dimension, and so on.
;
; INPUT KEYWORDS:
;  COVARIANCE::  Set this keyword in order to compute the <I>covariance</I> rather than the <I>correlation</I>
;                coefficient. The former includes subtracting the mean values of the vectors before correlating them.
;                The difference is especially striking when <*>x</*> and <*>y</*> have a marked DC offset; in this case,
;                the <I>correlation</I> will be close to 1, whereas the <I>covariance</I> can still take any value.
;  ENERGYNORM::  Set this keyword in order to normalize the correlation value(s) to the energies of the <*>x</*> and
;                <*>y</*> vectors. "Normalizing to" here means "dividing by the square root of the product of". This
;                kind of normalization is very common in correlation calculations and ensures that the coefficient
;                lies between -1 and 1, the latter indicating perfect (except for a scaling factor) correlation, the
;                former indicating perfect anticorrelation, and 0 indicating perfect (linear) independence of the vectors.
;  LENGTHNORM::  Set this keyword in order to normalize the correlation value(s) to the length of the <*>x</*> and
;                <*>y</*> vectors. "Normalizing to" here means "dividing by". This kind of normalization is <I>not</I>
;                very common in correlation calculations, but may sometimes be useful when comparing correlation values
;                between vector pairs of different lengths. The length normalization, by the way, is implicitly also
;                carried out when normalizing to the energies (with <*>ENERGYNORM</*>), since the energy of a vector is
;                the sum of its squared elements and therefore generally becomes larger with increasing vector length.
;                For this reason, the <*>LENGTHNORM</*> keyword is ignored if the <*>ENERGYNORM</*> keyword is
;                simultaneously set.
;
; OUTPUTS:
;  cxy::  A float variable containing computed correlation coefficient(s). If <*>dimension</*> was not specified, it is
;         just a scalar number. Otherwise, it has the same dimensional structure as <*>x</*> and <*>y</*>, except that
;         the dimension specified by <*>dimension</*> is missing.
;
; OPTIONAL OUTPUTS:
;  XENERGY::  Set this keyword to a named variable which on return will contain the energy (energies) of the <*>x</*>
;             vector(s), i.e., the sum of its (their) squares.
;  YENERGY::  Set this keyword to a named variable which on return will contain the energy (energies) of the <*>y</*>
;             vector(s), i.e., the sum of its (their) squares.
;
; RESTRICTIONS:
;  Remember that the result <*>cxy</*> will always be a float variable, regardless of the type of <*>x</*> or <*>y</*>.
;
; PROCEDURE:
;  Quite straightforward, nothing sophisticated about it. The <*>Total</*> function plays an important part, as well
;  as (in the case of the keyword <*>COVARIANCE</*> being set) the NASE routine <A>RemoveMean</A>.
;
; EXAMPLE:
;  Generate two random arrays and compare typical correlation and covariance coefficients:
;
;* x = RandomN(seed, 50, 100) + 2
;* y = RandomN(seed, 50, 100) + 2
;* Plot , Correlation(x, y, 1, /ENERGYNORM), yrange = [-1,1]
;* OPlot, Correlation(x, y, 1, /COVARIANCE, /ENERGYNORM), color = RGB('red')
;
;-



FUNCTION  Correlation,   X_, Y_, Dimension,  $
                         covariance = covariance,  energynorm = energynorm, lengthnorm = lengthnorm,  $
                         xenergy = xenergy, yenergy = yenergy


   ;----------------------------------------------------------------------------------------------------------------------
   ; Checking parameters and errors, initializing variables:
   ;----------------------------------------------------------------------------------------------------------------------

   On_Error, 2

   IF  NOT(Set(X_) AND Set(Y_))  THEN  Console, '   Not all arguments defined.', /fatal

   SizeX = Size([X_])
   SizeY = Size([Y_])
   DimsX = Size([X_], /dim)
   DimsY = Size([Y_], /dim)
   TypeX = SizeX(SizeX(0)+1)
   TypeY = SizeY(SizeY(0)+1)
   IF  (SizeX(0) NE SizeY(0)) OR (Max(DimsX NE DimsY) EQ 1)  THEN  Console, '  x and y must have the same size', /fatal
   IF  (TypeX GE 6) AND (TypeX LE 11)  THEN  Console, '  x is of wrong type', /fatal
   IF  (TypeY GE 6) AND (TypeY LE 11)  THEN  Console, '  y is of wrong type', /fatal

   ; Checking the argument DIMENSION:
   IF  Set(Dimension)  THEN  BEGIN
     IF  (Size(Dimension, /type) GE 6) AND (Size(dimension, /type) LE 11)  THEN  Console, '  Dimension variable is of wrong type', /fatal
     Dim = Round(Dimension(0))   ; If DIMENSION is an array, only the first value is taken seriously.
   ENDIF  ELSE  $
     Dim = 0L
   IF  (Dim LT 0) OR (Dim GT SizeX(0))  THEN  Console, '  Specified dimension out of allowed range', /fatal

   IF  Dim EQ 0  THEN  N = SizeX(SizeX(0)+2)  $
                 ELSE  N = SizeX(Dim)       ; number of elements in the specified dimension
   ; If the number of elements in the specified dimension is 1, subtracting the mean is equivalent to subtracting X
   ; from itself, since for each epoch the mean value is the (only one) value itself. This will be explicitly computed,
   ; but a warning message is given here:
   IF  N LT 2  THEN  Console, '  x and y must have at least two elements in the specified dimension.', /fatal

   ;----------------------------------------------------------------------------------------------------------------------
   ; Computing the correlation or covariance coefficient:
   ;----------------------------------------------------------------------------------------------------------------------

   ; If the covariance rather than the correlation is to be computed, the means of x and y in the specified dimension
   ; must be subtracted first; otherwise the input variables are just copied:
   IF  Keyword_Set(covariance)  THEN  BEGIN
     X = RemoveMean(X_, Dim)
     Y = RemoveMean(Y_, Dim)
   ENDIF  ELSE  BEGIN
     X = Float(X_)
     Y = Float(Y_)
   ENDELSE

   ; The correlation is determined:
   Cxy = Total(X*Y, Dim)

   ; Is one of the normalization types selected?
   IF  Keyword_Set(energynorm)  THEN  BEGIN
     XEnergy    = Total(X^2, Dim)   ; energy of signal x
     YEnergy    = Total(Y^2, Dim)   ; energy of signal y
     ; Only those epochs are valid whose energy is greater than zero (otherwise the correlation is left zero):
     Valid      = Where(XEnergy NE 0  AND  YEnergy NE 0)
     Cxy(Valid) = Cxy(Valid) / Sqrt(XEnergy(Valid) * YEnergy(Valid))
   ENDIF  ELSE  $
     IF  Keyword_Set(lengthnorm)  THEN  Cxy = Cxy / N

   Return, Cxy


END
