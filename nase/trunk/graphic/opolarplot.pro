;+
; NAME:               OPolarPlot
;
; AIM:                Overplot a polar diagram.
;
; PURPOSE:            Overplots the current plot with a polar diagram.
;
; CATEGORY:           GRAPHICS
;
; CALLING SEQUENCE:   PolarPlot, radiusarray, anglearray [,sdevarray]
;                                [,THICK=thick]   [,/CLOSE],
;                                [,MCOLOR=mcolor] [,SDCOLOR=sdcolor]
;                                [,SMOOTH=smooth]
;                                [,ORIGPT=ORIGPT [,DCOLOR=dcolor] ]
;
; INPUTS:             radiusarray: array containing the values, that
;                                  are plotted as distances from the
;                                  orgin of the coordinate system 
;                     anglearray : the angles corresponding to
;                                  radiusarray in rad (0..2*!Pi)
;
; OPTIONAL INPUTS:    sdevarray  : array containing the standard
;                                  deviation for each value of
;                                  radiusarray 
;
; KEYWORD PARAMETERS:
;                           thick: Indicates the line thickness
;                                  (normal: 1.0, default: 3.0) 
;                           close: the endpoint of the plot is
;                                  connected to the initial data point.
;                          smooth: Interpolated the plot between data
;                                  points (radius,angle) with a
;                                  sin(x)/x function. 
;                                  Smooth specifies the degree of
;                                  interpolation (1 means NO
;                                  interpolation). Only works if angle
;                                  array ranges over 360 degree.
;                          mcolor: Color index for the mean data
;                                  points (default: white) 
;                          dcolor: Color index for the original data
;                                  points. This option only works, if
;                                  you plot the original data points
;                                  using keyword origpt (Default: mcolor).
;                         sdcolor: Color index for the standard
;                                  deviation (if set, default: dark blue) 
;                          origpt: original data points are emphasized
;                                  by bold dots with a radius of
;                                  origpt (default: 0)
;
; PROCEDURE: 0. determines useful plot area
;            1. scale the plot area appropriate
;            2. plot mean and standard deviation using opolarplot
;            3. plot axes
;            4. plot circle at any tickmarks position (uses ARCS in alien)
;            5. plot intermediate axes (uses RADII in alien)  
;
; EXAMPLE: radius = findgen(8)
;          angle = findgen(8)*2.0*!PI/7.0
;          PolarPlot, radius, angle, MINORANGLETICKS=4, TITLE='Spiralplot'
;          OPolarPlot, radius, angle+2, MCOLOR=rgb(200,50,50), SMOOTH=5
;
;-
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 2.5  2000/10/01 14:50:42  kupper
;        Added AIM: entries in document header. First NASE workshop rules!
;
;        Revision 2.4  2000/09/01 19:51:45  saam
;              fixed several confusions with SMOOTH,
;              CLOSE und arrays larger 30 elements
;
;        Revision 2.3  2000/07/24 13:18:40  saam
;              + added keyword DPLOT
;
;        Revision 2.2  2000/07/24 10:28:11  saam
;              + added _EXTRA tag for oplot
;
;        Revision 2.1  2000/07/18 12:56:51  saam
;              + split into plot and oplot part
;              + code cleanup
;              + translated doc header
;              + cut unneccessary plot elements
;
;
;


PRO OPolarPlot, radiusarray, anglearray, sdevarray,           $
                MCOLOR=mcolor, DCOLOR=dcolor, SDCOLOR=sdcolor,$
                DELTA=DELTA, SMOOTH=smooth,                   $
                THICK=thick, CLOSE=CLOSE,                     $
                ORIGPT=ORIGPT,                                $
                radiusinterpol=radiusinterpol,                $
                winkelinterpol=winkelinterpol,                $
                _EXTRA=e

;'On_Error, 2

IF (N_Params() LT 2) OR (N_Params() GT 3) THEN Console, 'wrong parameter count', /FATAL
IF Set(radiusinterpol) THEN Console, 'keyword RADIUSINTERPOL is undocumented, please document if you need it', /WARN
IF Set(winkelinterpol) THEN Console, 'keyword WINKELINTERPOL is undocumented, please document if you need it', /WARN

IF Set(DELTA) THEN BEGIN
    Console, 'keyword DELTA is renamed to SMOOTH, please change call respectively', /WARN
    Default, SMOOTH, DELTA
END ELSE Default, SMOOTH, 1

_radiusarray = radiusarray
_anglearray = anglearray

IF set(SDEVARRAY) THEN _sdevarray = sdevarray
BGCOLOR = GetBgColor()
BGCOLOR = RGB(BGCOLOR(0), BGCOLOR(1), BGCOLOR(2),/NOALLOC)
Default, MCOLOR , !P.COLOR
Default, DCOLOR , MCOLOR
Default, SDCOLOR, RGB(150,150,200,/NOALLOC)
IF SMOOTH GT 1.0 THEN DEFAULT,CLOSE ,1

DEFAULT,CLOSE ,0
Default, thick, 3.0
default, origpt, 0


IF SMOOTH GT 1 THEN BEGIN
    index = 0
    REPEAT BEGIN
        index = N_ELEMENTS(_radiusarray) + index
        _radiusarray = [_radiusarray,_radiusarray,_radiusarray]
        IF set(_SDEVARRAY) THEN  _sdevarray=[_sdevarray,_sdevarray,_sdevarray]
    ENDREP UNTIL N_ELEMENTS(_radiusarray) GE 30 
    
    
    _radiusarray = Sincerpolate(_radiusarray,smooth)
    _radiusarray = _radiusarray(index*smooth : (index+ N_ELEMENTS(radiusarray))*smooth-1+close)
    
    IF set(_SDEVARRAY) THEN BEGIN
        _sdevarray =   Sincerpolate(_sdevarray ,smooth)
        _sdevarray = _sdevarray(index*smooth : (index+ N_ELEMENTS(radiusarray))*smooth-1+close)
    END

    _anglearray = [_anglearray,last(_anglearray)+_anglearray(1)-_anglearray(0)]
    _anglearray = _anglearray(0)+findgen(N_ELEMENTS(_radiusarray))/FLOAT(N_ELEMENTS(_radiusarray)-1)*(last(_anglearray)-_anglearray(0))
    
END ELSE BEGIN
    
    IF CLOSE EQ 1 THEN BEGIN
        _radiusarray = [_radiusarray,_radiusarray(0)]
        _anglearray = [_anglearray,last(_anglearray)+_anglearray(1)-_anglearray(0)]
        IF set(SDEVARRAY) THEN _sdevarray = [_sdevarray,_sdevarray(0)]
    ENDIF
    
ENDELSE



; plots the standard deviation
IF set(_SDEVARRAY) THEN BEGIN
   x1 = (_radiusarray(*)-_sdevarray(*))*cos(_anglearray(*))
   m1 = (_radiusarray(*)-_sdevarray(*))*sin(_anglearray(*))
   x2 = (_radiusarray(*)+_sdevarray(*))*cos(_anglearray(*))
   m2 = (_radiusarray(*)+_sdevarray(*))*sin(_anglearray(*))
   polyfill, [x1,last(x1),REVERSE(x2),x2(0)], [m1,last(m1), REVERSE(m2),m2(0)], COLOR=sdcolor
ENDIF

; overplot (optional) standard deviation with the mean data
oplot, _radiusarray, _anglearray, /POLAR, THICK=thick, COLOR=mcolor, _EXTRA=e

; plot the original data points as dots (optional)
IF ORIGPT GT 0 THEN BEGIN
    r = ORIGPT
    PHI=findgen(40+1)*2*!PI/40. 
    y=r*sin(PHI) & x=r*cos(PHI) 
    usersym, x, y, /FILL
    
    oplot, radiusarray, anglearray, /POLAR, PSYM=8, COLOR=dcolor
ENDIF

radiusinterpol = _radiusarray
winkelinterpol = _anglearray
END 
