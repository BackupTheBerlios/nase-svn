;+
; NAME:                Plot3D
;
; PURPOSE:             Malt mehrere, sich verdeckende Plots in ein drei-
;                      dimensionales Koordinatensystem. Im Prinzip koennte
;                      das gleicher auch die Surface-Routine, wenn sie das
;                      Schluesselwort VERTICAL unterstuetzen wuerde. 
;
; CATEGORY:            NASE GRAPHIC
;
; CALLING SEQUENCE:    Plot3d, data [,x [,y]] [,AX=ax] [,AZ=az] [,/NOAXIS]
;
; INPUTS:              data: a two-dimensional array to be plotted
;
; OPTIONAL INPUTS:     x,y: Vektoren, die die X/Y-Koordinaten des
;                           Grids spezifizieren
;
; KEYWORD PARAMETERS:  AX    : Rotation der Ansicht um die x-Achse (Default: 10)
;                      AZ    : Rotation der Ansicht um die z-Achse (Default:  4)
;                      NOAXIS: Verhindert die Ausgabe der Achsen
;
; PROCEDURE:
;                      + aktiviert z-buffer
;                      + definiert 3d-koordinaten-system
;                      + hinterlegt oplot-Befehle mit schwarzer Flaeche fuer
;                        Verdeckung
;
; RESTRICTIONS:        man sollte AX,AZ nicht zu gross waehlen, sonst geht
;                      das mit der Verdeckung in die Hose
;    
; EXAMPLE:             
;                      a = Gauss_2D(15,15)
;                      Plot3D, a,ax=30 ,az=10
;                      Plot3D, a, [0,2,3,5,7,10,16,17,18,19,19.5,20,21,22,24], Indgen(15)-7, ax=30 ,az=10
;                       
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 2.2  1998/11/10 14:50:02  saam
;           changed plotting details
;
;     Revision 2.1  1998/07/07 13:17:39  saam
;           + first version
;           + may be a bit buggy, especially the hidden lines
;
;
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
   SET_PLOT, 'Z'

   SCALE3, XRANGE=[minx,maxx], YRANGE=[miny,maxy], ZRANGE=[0,1], AX=ax, AZ=az
   T3D, /YZEXCH
   Erase, 0


   polyfill, [minx, x, maxx, minx], [miny, REFORM(data(*,0)), miny, miny], /T3D, Z=z(0)+0.0001, COLOR=0 ; a black surface for hidden lines slightly behind ...
   plot, x, data(*,0), ZVALUE=z(0), /T3D, YRANGE=[MIN(data),MAX(data)], XSTYLE=5, YSTYLE=4, color=0; ... the normal plot  
   FOR i=1,nz-1 DO BEGIN
      polyfill, [minx, x, maxx, minx], [miny, REFORM(data(*,i)), miny, miny], /T3D, Z=z(i)+0.0001, COLOR=RGB(255,255,255,/NOALLOC)
;      polyfill, [minx, x, maxx, minx], [miny, REFORM(data(*,i)), miny, miny], /T3D, Z=z(i)+0.0001, COLOR=30+FIX((i/FLOAT(nz))*180)
      oplot, x, data(*,i), /T3D, ZVALUE=z(i)
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
   b=TVRD()	        ; Read image.
   SET_PLOT, 'X'	; Select X output.
   TV, b	        ; Output the image.
END

