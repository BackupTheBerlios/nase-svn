;+
; NAME:
;  I2RGBS()
;
; VERSION:
;  $Id$
;
; AIM:
;  version of <A>I2RGB</A> that scales data to minimal and maximal
;  color palette values
;
; PURPOSE:
;  Transforms an indexed into a true-color image using the current or
;  a standard color palette. 
;  
; CATEGORY:
;  Color
;  Graphic
;  Image
;
; CALLING SEQUENCE:
;*tcimage=I2RGB(iimage [,PALETTE=...])
;
; INPUTS:
;  iimage :: a two-dimensional array containing color indices in an
;            arbitrary range 
;
; INPUT KEYWORDS:
;  PALETTE :: The number of the standard color palette to used for the
;             transformation. If not passed, the current palette is used.
;
; OUTPUTS:
;  tcimage:: array (3,width,height) representing the true-color
;            version of <*>iimage</*>
;
; EXAMPLE:
;*ptv, i2rgbs(gauss_2d(200,100), PALETTE=5), /TRUE
; In this context the call produces identical results like
;*ptvs, i2rgb(gauss_2d(200,100), PALETTE=5), /TRUE
; but there are cases, where you really need <C>I2RGBS</C>.
; 
; SEE ALSO:
;  <A>I2RGB</A>, <A>CIndex2RGB</A>, <A>UTv</A>
;
;-
FUNCTION i2rgbs, _a, _EXTRA=e

a=_a-min(_a)
a=a/max(a)*!TOPCOLOR

RETURN, i2rgb(a,_EXTRA=e)
END
