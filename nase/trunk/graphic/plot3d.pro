;+
; NAME:
;  Plot3D
;
; VERSION:
;  $Id$
;
; AIM:
;  Imitate surface plot by overlaying several simple plots.
;
; PURPOSE:
;  Draw several plots behind one another into a three dimensional
;  coordinate system. Each plot hides those lying behind it. The
;  result is similar to the output of IDL's <C>Surface</C> with the
;  <C>/HORIZONTAL</C>-keyword set and the <C>AZ</C>-parameter less
;  than 45 degrees.  
;
; CATEGORY:
;  Graphic
;
; CALLING SEQUENCE:
;* Plot3d, data [,x [,y]] [,AX=...] [,AZ=...] [,/NOAXIS]
;
; INPUTS:
;  data:: A two-dimensional array to be plotted.
;
; OPTIONAL INPUTS:
;  x, y:: Vectors specifying the x/y-coordinates of the grid. This
;        influences the coordinates themselves, not only the
;        annotation of the axis (see second example).
;
; INPUT KEYWORDS:
;  AX:: Rotation of the viewpoint around the x-axis (Default: 10).
;  AZ:: Rotation of the viewpoint around the z-axis (Default:  4)
;  /NOAXIS:: Suppress axis output.
;
; RESTRICTIONS:
;  <*>AX</*>/<*>AZ</*> should not be chosen too large, since the hiding of the plots
;  may fail then.
;
; PROCEDURE:
; + activate z-buffer<BR>
; + define 3d coordinate system<BR>
; + hide plots behing others by adding polyfills in background color.
;
; EXAMPLE:
;* a = Gauss_2D(15,15)
;* Plot3D, a,ax=30 ,az=10
;* Plot3D, a, [0,2,3,5,7,10,16,17,18,19,19.5,20,21,22,24] $
;*  , Indgen(15)-7, ax=30 ,az=10
;
; SEE ALSO:
;  IDL's <C>Surface</C>.
;-


PRO Plot3d, data, x, _z, AX=ax, AZ=az, NOAXIS=noaxis

   ;-----> 
   ;-----> CHECK SYNTAX AND COMPLETE COMMAND LINE
   ;-----> 
   IF N_Params() LT 1 THEN Messsage, 'incorrect number of arguments'

   S = SIZE(data) &  nx=S(1) &  nz=S(2) 

   IF N_Params() LT 3 THEN BEGIN
      z = LIndgen(nz)/FLOAT(nz)
      minz = 0
      maxz = nz-1
   END ELSE BEGIN 
      z = (_z-MIN(_z))/FLOAT(MAX(_z)-MIN(_z))
      minz = MIN(_z)
      maxz = MAX(_z)  
   END
   IF N_Params() LT 2 THEN x = LIndgen(nx)
   
   minx = MIN(x)    & maxx = MAX(x)    
   miny = MIN(data) & maxy = MAX(data)

   Default, AX    , 10
   Default, AZ    , 4



   ;-----> 
   ;-----> PLOT IN Z-BUFFER
   ;-----> 
   current_device = !D.Name
   uSET_PLOT, 'Z'

   SCALE3, XRANGE=[minx,maxx], YRANGE=[miny,maxy], ZRANGE=[0,1], AX=ax, AZ=az
   T3D, /YZEXCH
   Erase, 0

   ;; color indices
   back = GetBackground()
   fore = GetForeground()

   polyfill, [minx, x, maxx, minx], [miny, REFORM(data(*,0)), miny, miny], /T3D, Z=z(0)+0.0001, COLOR=back ; a black surface for hidden lines slightly behind ...
   plot, x, data(*,0), ZVALUE=z(0), /T3D, YRANGE=[MIN(data),MAX(data)], XSTYLE=5, YSTYLE=4, COLOR=fore ;; ... the normal plot  
   FOR i=1,nz-1 DO BEGIN
      polyfill, [minx, x, maxx, minx], [miny, REFORM(data(*,i)), miny, miny], /T3D, Z=z(i)+0.0001, COLOR=back ;; old version: RGB(255,255,255,/NOALLOC)
;      polyfill, [minx, x, maxx, minx], [miny, REFORM(data(*,i)), miny, miny], /T3D, Z=z(i)+0.0001, COLOR=30+FIX((i/FLOAT(nz))*180)
      oplot, x, data(*,i), /T3D, ZVALUE=z(i), COLOR=fore
   END

;   polyfill,[[n/2,MIN(data)-ABS(MIN(data)/10.),0],[n/2,MAX(data)+MAX(data)/10.,0],[n/2,MAX(data)+MAX(data)/10.,1],[n/2,MIN(data)-ABS(MIN(data)/10.),1],[n/2,MIN(data)-ABS(MIN(data)/10.),0]], /T3D, COLOR=150


   ;-----> 
   ;-----> PLOT AXIS
   ;-----> 
   IF NOT Keyword_Set(NOAXIS) THEN BEGIN
      AXIS, !X.CRANGE(0),!Y.CRANGE(0), 0, XAXIS=0, /T3D, CHARSIZE=1.5, XSTYLE=1
      AXIS, !X.CRANGE(0),!Y.CRANGE(0), 1, YAXIS=0, /T3D, CHARSIZE=1.5, YSTYLE=1
      AXIS, !X.CRANGE(0),!Y.CRANGE(0), 0, ZAXIS=1, /T3D, CHARSIZE=1.5, ZSTYLE=1, ZRANGE=[minz,maxz]
   END

   ;-----> 
   ;-----> OUTPUT RESULT
   ;----->    
   b = TVRD()	        ; Read image.
   USet_Plot, current_device	; Select previous output device.
   UTV, b, /ALLOWCOLORS             ; Output the image.

END

