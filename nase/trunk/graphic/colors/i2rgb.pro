;+
; NAME:
;  I2RGB()
;
; VERSION:
;  $Id$
;
; AIM:
;  transforms an indexed into a true-color image using the current or
;  a standard color palette
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
;  iimage :: a two-dimensional array containing color indices in the
;            range <*>[0..!TOPCOLOR]</*> 
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
;*ptv, i2rgb(!TOPCOLOR*gauss_2d(200,100), PALETTE=5), /TRUE
;
; SEE ALSO:
;  <A>I2RGBS</A>, <A>CIndex2RGB</A>, <A>UTv</A>
;
;-
FUNCTION I2RGB, a, PALETTE=p

IF Set(p) THEN BEGIN
    UTVLCT, sp, /GET
    ULoadCT, p
END

b = CIndex2RGB(a)

IF Set(p) THEN UTVLCT, sp, /OVER
RETURN, b
END
