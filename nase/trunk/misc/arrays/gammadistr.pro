;+
; NAME:
;  GammaDistr()
;
; VERSION:
;  $Id$
;
; AIM:
;  Fill an array with values according to the gamma distribution function. 
;
; PURPOSE:
;  <C>GammaDistr()</C> fills an array with values according to the
;  gamma distribution function
;*  g(x)=Exp(-a*x)*a^m*x^(m-1)/Gamma(m)
;
; CATEGORY:
;  Array
;  Math
;  Statistics
;
; CALLING SEQUENCE:
;* result = GammaDistr(x, M=..., A=..., E=..., V=...
;*                     [,TAUMIN=...][,/NORMALIZED])
;
; INPUTS:
;  x:: A onedimensional array of values for which the gamma
;      distribution function is to be computed.
;
; INPUT KEYWORDS:
;  M:: First parameter. (<*>M=E^2/V</*>.)
;  A:: Second parameter. (<*>A=E/V<*>.)
;  E:: Mean of the resulting distribution.
;  V:: Variance of the resulting distribution.
;  TAUMIN:: Shifts the function along the x-axis. Default: 0.
;  /NORMALIZED :: Returns a function whose intergral is normailzed to
;                 1.
;
; OUTPUTS:
;  result:: A onedimensional array containing the function values.
;
; RESTRICTIONS:
;  m must not be too large, otherwise overflows may occur.
;
; PROCEDURE:
;  First compute logarithm of the final result, and the use exponential
;  function.
;
; EXAMPLE:
;* x=FIndGen(1000)/100.
;* y=GammaDistr(x,M=6.,A=6.,TAUMIN=2.)
;* Plot, x,y
;
; SEE ALSO:
;  IDL's <C>Gamma()</C> and  <C>LNGamma()</C>.
;-



FUNCTION GammaDistr, x, M=m, A=a $
                      , E=e, V=v $
                      , TAUMIN=taumin, NORMALIZED=normalized

   Default, taumin, 0.

   IF Set(E) AND Set(V) THEN BEGIN
      a = e/v
      m = e^2/v
   ENDIF

   xshift = (x-taumin) > 0.
   g = Make_Array(SIZE=Size(xshift))

   lga = LNGamma(m) ;; use LN of Gamma to avoid overflows
   IF NOT Finite(lga) THEN Console, /FATAL $
    , 'Gamma(m) is too large. Try passing DOUBLE values.'

   ;; initial version:
   ;;   g = a^m*xshift^(m-1.)*Exp(-a*xshift)/ga
   ;; changed order to avoid overflows
   ;;   g = Exp(-a*xshift)*a^m*xshift^(m-1.)/ga 

   ;; compute ln of result to avoid overflows, but keep out indizes
   ;; where xshift is zero
   nonzeroidx = Where(xshift NE 0., count)
   IF count EQ 0 THEN Console, /WARN, 'Complete array EQ 0.' ELSE BEGIN
      g[nonzeroidx] = Exp(-a*xshift[nonzeroidx] $
                          + m*ALog(a) $
                          + (m-1.)*ALog(xshift[nonzeroidx]) $
                          - lga)
   ENDELSE

   gnotfinite = Where(Finite(g) NE 1, count)
   IF count NE 0 THEN Console, /FATAL $
    , 'Some array entries too large. Try passing DOUBLE values.'

   IF Keyword_Set(NORMALIZED) THEN g = g/Total(g)

   Return, g

END

