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
;  <C>PolyTV</C> displays two dimensional data as an array of colored
;  rectangles. Colors are chosen according to the array entries
;  interpreted as the indices of the colortable currently active. The
;  size of the rectangles is determined to result in an overall size
;  of the array supplied by the user.<BR>
;  <C>PolyTV</C> offers an alternative to the classic IDL procedure
;  <C>TV</C>. For resizing a <C>TV</C> plot, the underlying array has
;  to be resized which causes memory consumption and large Postscript
;  files. This is not necessary when using <C>PolyTV</C>.<BR>
;  <C>PolyTV</C> is not intended to offer comfortable positioning and
;  color scaling possibilities. Rather, it has been outsourced from
;  <A>UTVScl</A> for the sake of clarity. If comfortable options are
;  needed, <A>UTVScl</A> should be used with the <*>/POLYGON</*>
;  switch active, which invokes <C>PolyTV</C>.
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
;  image:: Two dimensional array whose entries are interpreted as the
;          indices of the currently active colortable. See also
;          <A>ULoadCT</A>.
; 
; INPUT KEYWORDS:
;  xsize, ysize:: Desired horizontal and vertical size of the plot,
;                 given in normal or device coordinates. See switch
;                 <*>DEVICE</*>. Default: 1.0, i.e. the plot covers
;                 the whole area available.
;  xorpos, yorpos:: Horizontal and vertical position of the plot
;                   origin in normal or device coordinates. See switch
;                   <*>DEVICE</*>. Default: 0.0.
;  /DEVICE:: If this switch es set, coordinates <*>xsize</*>,
;            <*>ysize</*>, <*>xorpos</*> and <*>yorpos</*> are
;            interpreted as device coordinates. Default: <*>DEVICE=0</*>.
;  /ORDER:: If set, the image is drawn from the top down instead of
;           the normal bottom up. See also IDL online help for <C>TV</C>.
;
; OUTPUTS:
;  An array of colored rectangles covering the desired area.
;
; PROCEDURE:
;  Compute the size of single rectangles from the number of array
;  entries and overall size, then draw them using the colors specified
;  as the array entries.
;
; EXAMPLE:
;* PolyTV, 245*(1-Gauss_2d(21,21)) $
;*       , XSIZE=0.5, YSIZE=0.5, XORPOS=0.25, YORPOS=0.25
;
; SEE ALSO:
;  <A>UTVScl</A>, <A>ULoadCT</A>, IDL's <C>TV</C>.
;-



PRO PolyTV, image $
            , XSIZE=xsize, YSIZE=ysize $
            , XORPOS=xorpos, YORPOS=yorpos $
            , DEVICE=device $
            , ORDER=order

   ;Debugging, MESSAGES=0

   Default, device, 0
   Default, order, 0

   ;; --- Defaults for origin and size:
   ;; we need a little hack to get right defaults: If /DEVICE was set,
   ;; all values that are (or are NOT) specified are in device
   ;; coordinates. For origin, default is zero in both cases, but for
   ;; normal, default differs:
   devicemax = Convert_Coord([1.0, 1.0], /NORMAL, /TO_DEVICE)
   ;; Overall size in normal coordinates
   IF Keyword_Set(DEVICE) THEN BEGIN
      Default, xsize, devicemax[0]
      Default, ysize, devicemax[1]
   endif else begin
      Default, xsize, 1.
      Default, ysize, 1.
   endelse
   si = [xsize, ysize]
   ;; Position of origin
   Default, xorpos, 0.
   Default, yorpos, 0.
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
   ;DMsg, 'Number of x pixels: '+String(nxp)
   ;DMsg, 'Number of y pixels: '+String(nyp)
   ;DMsg, 'Size of picture: '+String(si)

   ;; Size of a single pixel (eg a rectangle)
   xpsize = si(0)/nxp
   ypsize = si(1)/nyp

   
   ;; Draw polygons, use image array to choose appropriate color
   FOR iy=0, nyp-1 DO BEGIN
      FOR ix=0, nxp-1 DO BEGIN
         xbox = [ix, ix+1, ix+1, ix]
         ybox = [iy, iy, iy+1, iy+1]
         PolyFill, xpsize*xbox+orpos(0), ypsize*ybox+orpos(1) $
          , COLOR=image(ix, order*(nyp-1)+(-2*order+1)*iy), /Normal
      ENDFOR
   ENDFOR

END


   
