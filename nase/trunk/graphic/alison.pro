;+
; NAME:
;  Alison()
;
; VERSION:
;  $Id$
;
; AIM:
;  Return contents of file "alison_greyscale.bmp" as an IDL array.
;
; PURPOSE:
;  This function reads the file "alison_greyscale.bmp" and returns its
;  contents as an array of floating point numbers. No scaling will be
;  performed. Hence, the values returned will be in the range
;  <*>[0.0,255.0]</*>. Note that the actual minimum and maximum of the image
;  values are <*>10.0</*> and <*>249.0</*>.<BR>
;  Regarding the image orientation and indexing order of the array,
;  please see description of the <C>NORDER</C> keyword below.
;
; CATEGORY:
;  Array
;  Graphic
;  Image
;  IO
;
; CALLING SEQUENCE:
;*array = Alison( [,/NORDER] )
;
; INPUT KEYWORDS:
;  NORDER:: Request that array ordering shall conform to the NASE
;           convention: The indexing order will be
;           <*>[row,column]</*>. The origin of the array <*>[0,0]</*>
;           will denote the UPPER LEFT corner of the image.<BR>
;<BR>
;           If this keyword is not set, array ordering will conform to
;           the standard IDL convention: The indexing order will be
;           <*>[column,row]</*>, and the origin of the array
;           <*>[0,0]</*> will denote the LOWER LEFT corner of the
;           image.
;
; OUTPUTS:
;  array:: Array of floats in the range <*>[0.0,255.0]</*>.
;
; EXAMPLE:
;*PlotTvScl, Alison()
;-

Function alison, NORDER = norder
   i = Read_BMP(Getenv('NASEPATH')+'/graphic/alison_greyscale.bmp')
   if keyword_set(NORDER) then i = Rotate(Temporary(i),1)
   return, float(i)
End
