;+
; NAME:
;  PolyTV
;
; VERSION:
;  $Id$
;
; AIM:
;  Display two dimensional array using colored rectangles. 
;
; PURPOSE:
;  (When referencing this very routine in the text as well as all IDL
;  routines, please use <C>RoutineName</C>.)
;
; CATEGORY:
;  Array
;  Graphic
;  Image
;
; CALLING SEQUENCE:
;* PolyTV, image
;*       [, XSIZE=...][, YSIZE=...] 
;*       [, XORPOS=...][, YORPOS=...]
;*       [, /DEVICE] 
;*       [, /ORDER]
;
; INPUTS:
;  image:: array
;
; INPUT KEYWORDS:
;  xsize, ysize:: Desired overall size of plot.
;  xorpos, yorpos:: Origin.
;  /DEVICE:: Convert coordinates to device.
;  /ORDER:: Start in uper left.
;
; OUTPUTS:
;  TV  
;
; PROCEDURE:
;  
;
; EXAMPLE:
;* PolyTV, 245*(1-Gauss_2d(21,21)) $
;*       , XSIZE=0.5, YSIZE=0.5, XORPOS=0.25, YORPOS=0.25
;
; SEE ALSO:
;  <A>UTVScl</A>.
;-



PRO PolyTV, image $
            , XSIZE=xsize, YSIZE=ysize $
            , XORPOS=xorpos, YORPOS=yorpos $
            , DEVICE=device $
            , ORDER=order

   Debugging, MESSAGES=0

   Default, device, 0
   Default, order, 0

   ;; Overall size in normal coordinates
   Default, xsize, 1.
   Default, ysize, 1.
   si = [xsize, ysize]

   ;; Position of origin
   Default, xorpos, 0.
   Default, yorpos, 0
   orpos = [xorpos, yorpos]

   ;; Coordinate conversion
   IF Keyword_Set(DEVICE) THEN BEGIN
      si = Convert_Coord(si, /DEVICE, /TO_NORMAL)
      orpos = Convert_Coord(orpos, /DEVICE, /TO_NORMAL)
   ENDIF

   ;; Number of pixels
   nxp = (Size(image))(1)
   nyp = (Size(image))(2)

   ;; Info messages
   DMsg, 'Number of x pixels: '+String(nxp)
   DMsg, 'Number of y pixels: '+String(nyp)
   DMsg, 'Size of picture: '+String(si)

   ;; Size of a single pixel (eg a rectangle)
   xpsize = si(0)/nxp
   ypsize = si(1)/nyp

   
   ;; Draw polygons, use image array to choose appropriate color
   FOR iy=0, nyp-1 DO BEGIN
      FOR ix=0, nxp-1 DO BEGIN
         xbox = [ix, ix+1, ix+1, ix]
         ybox = [iy, iy, iy+1, iy+1]
         PolyFill, xpsize*xbox+orpos(0), ypsize*ybox+orpos(1) $
          , COLOR=image(ix, order*(nyp-1)+(-2*order+1)*iy), /NORM
      ENDFOR
   ENDFOR

END


   
