;+
; NAME:               PolarPlot
;
; AIM:                plots polar diagrams
;
; PURPOSE:            Plots a polar diagram.
;
; CATEGORY:           GRAPHICS
;
;
; CALLING SEQUENCE:   PolarPlot, radiusarray, anglearray [,sdevarray]
;                                [,TITLE=title]   [,CHARSIZE=charsize]
;                                [,XRANGE=xrange] [,YRANGE=yrange]
;                                [,XSTYLE=xstyle] [,YSTYLE=ystyle]
;                                [,MINORANGLETICKS=minorangleticks]
;                                [,THICK=thick]   [,/CLOSE],
;                                [,MCOLOR=mcolor] [,SDCOLOR=sdcolor],
;                                [,SMOOTH=smooth]
;                                [,ORIGPT=ORIGPT]
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
;                     title      : Produces a main title centered above the plot window
;                     charsize   : The overall character size for the
;                                  annotation. This keyword does not
;                                  apply when hardware
;                                  (i.e. PostScript) fonts are
;                                  selected. A CHARSIZE of 1.0 is
;                                  normal. The main title is
;                                  written with a character size of
;                                  1.25 times this parameterThe size
;                                  of the characters used to annotate
;                                  the axis and its title 
;                      [xy]range : The desired data range of the axis,
;                                  a 2-element vector. The first
;                                  element is the axis minimum, and
;                                  the second is the maximum. IDL will
;                                  frequently round this range. This
;                                  override can be defeated using the
;                                  [XYZ]STYLE keywords. (Default:
;                                  [-Max(radiusarray),+Max(radiusarray)]) 
;                      [xy]style : This keyword allows specification
;                                  of axis options such as rounding of
;                                  tick values and selection of a box
;                                  axis. (see IDL-Help, default: 4)
;                 minorangleticks: Additional axes for for equidistant
;                                  angles. minorangleticks=n draws n
;                                  subaxes in each quadrant. For n=1 
;                                  axes at 45, 135, 225 and 315 dg are
;                                  plotted.
;                           thick: Indicates the line thickness
;                                  (normal: 1.0, default: 3.0) 
;                           close: the endpoint of the plot is
;                                  connected to the initial data point.
;                          smooth: Interpolated the plot between data
;                                  points (radius,angle) with a
;                                  sin(x)/x function. 
;                                  Smooth specifies the degree of
;                                  interpolation (1 means NO
;                                  interpolation). Sets Keyword CLOSE
;                                  to 1.
;                          mcolor: Color index for the mean data
;                                  points (default: white) 
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
; EXAMPLE: radius = findgen(33)
;          angle = findgen(33)*2.0*!PI/32.0
;          PolarPlot, radius, angle, MINORANGLETICKS=4, TITLE='Spiralplot'
;          OPolarPlot, radius, angle+2, MCOLOR=rgb(200,50,50)
;
;-
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 2.17  2000/07/18 12:59:40  saam
;              killed a vagabondizing title string
;
;        Revision 2.16  2000/07/18 12:56:51  saam
;              + split into plot and oplot part
;              + code cleanup
;              + translated doc header
;              + cut unneccessary plot elements
;
;        Revision 2.15  2000/07/05 16:20:20  gabriel
;             BUGFIX Origpt
;
;        Revision 2.14  2000/07/05 13:36:36  gabriel
;             Keyword ORIGPT new
;
;        Revision 2.13  2000/07/05 10:19:14  saam
;              little bug in doc header
;
;        Revision 2.12  2000/06/23 10:22:12  gabriel
;             !P.MULTI bug fixed
;
;        Revision 2.11  2000/06/08 10:11:34  gabriel
;               BGCOLOR BUG fixed
;
;        Revision 2.10  2000/05/23 08:21:36  gabriel
;             COLOR problem fixed
;
;        Revision 2.9  2000/03/01 16:20:30  gabriel
;                 there was a cut and paste bug
;
;        Revision 2.8  2000/02/24 15:51:49  gabriel
;                ------
;
;        Revision 2.7  2000/02/24 15:49:22  gabriel
;              Bugfix: Axis weren't printed properly
;
;        Revision 2.6  1999/04/29 09:17:26  gabriel
;             Interpolation der Angle war falsch
;
;        Revision 2.5  1999/04/28 17:10:41  gabriel
;             Keyword DELTA neu
;
;        Revision 2.4  1999/02/12 14:48:50  gabriel
;             Keyword CLOSE und Input SDEV neu
;
;        Revision 2.3  1998/02/18 14:07:55  thiel
;               CHARSIZE-Keyword hinzugefuegt.
;
;        Revision 2.2  1998/01/22 14:11:02  thiel
;               Jetzt mit variabler Liniendicke, Keyword THICK.
;
;        Revision 2.1  1998/01/22 13:46:52  thiel
;               Die erste Version ist fertig.
;
;

PRO PolarPlot, radiusarray, anglearray, sdevarray,                               $
               TITLE=title,                                                 $
               CHARSIZE=charsize,                                           $
               XRANGE=xrange, YRANGE=yrange,                                $
               XSTYLE=xstyle, YSTYLE=ystyle,                                $
               MINORANGLETICKS=minorangleticks,                             $
               radiusinterpol=radiusinterpol, winkelinterpol=winkelinterpol,$
               _EXTRA=e


On_Error, 2

IF (N_Params() LT 2) OR (N_Params() GT 3) THEN Console, 'wrong parameter count', /FATAL
IF Set(radiusinterpol) THEN Console, 'keyword RADIUSINTERPOL is undocumented, please document if you need it', /WARN
IF Set(winkelinterpol) THEN Console, 'keyword WINKELINTERPOL is undocumented, please document if you need it', /WARN

Default, xstyle  , 4
Default, ystyle  , 4
Default, xrange  , [-Max(radiusarray),Max(radiusarray)]
Default, yrange  , [-Max(radiusarray),Max(radiusarray)]
Default, title   , ''
Default, charsize, 1.0



; this longish region is to get a proper scaling
; for the plot ..... and to care for MULTI plots
plot,radiusarray , anglearray,/POLAR, /NODATA, $
 XSTYLE=xstyle, YSTYLE=ystyle, $
 XRANGE=xrange, YRANGE=yrange, $
 TITLE='',_EXTRA=e

PTMP = !P.MULTI
!P.MULTI(0) = 1

plotregion_norm = [[!X.WINDOW(0),!Y.WINDOW(0)],[!X.WINDOW(1),!Y.WINDOW(1)]] 
plotregion_norm_center = [0.5,0.5]
plotregion_device = convert_coord(plotregion_norm,/NORM,/TO_DEVICE)
plotregion_device_center = convert_coord(plotregion_norm_center,/NORM,/TO_DEVICE)

plotregion_device = plotregion_device(0:1,*)
plotregion_device_center(0) = plotregion_device_center(0)
xsize_device = plotregion_device(0,1)-plotregion_device(0,0)
ysize_device = plotregion_device(1,1)-plotregion_device(1,0)
org_plotregion_device = [ plotregion_device(0,0) + xsize_device/2.,$
                          plotregion_device(1,0) + ysize_device/2. ]
shift_plotregion_device = org_plotregion_device-plotregion_device_center

if !P.MULTI(1) eq 0 OR !P.MULTI(2) eq 0 then begin 
   shift_plotregion_device(1) = 0.0
end else begin
   shift_plotregion_device(*) = 0.0
endelse

xy_dim = [xsize_device,ysize_device]
corr_fac = min(xy_dim,min_size_ind)/ FLOAT( max(xy_dim,max_size_ind))
corr_fac = [corr_fac,corr_fac]
corr_fac(min_size_ind) = 1.0
plotregion_device_new = [[plotregion_device(*,0)]-shift_plotregion_device,$
                         [plotregion_device(*,0)+xy_dim*corr_fac]-shift_plotregion_device]

plot, radiusarray, anglearray,/POLAR, $
  XSTYLE=xstyle, YSTYLE=ystyle, $
  XRANGE=xrange, YRANGE=yrange, $
  TITLE=title,POSITION=plotregion_device_new,/DEVICE,/NODATA,_EXTRA=e



; now, we can do the data plot
IF Set(sdevarray) THEN opolarplot, radiusarray, anglearray, sdevarray, RADIUSINTERPOL=radiusinterpol, WINKELINTERPOL=winkelinterpol, _EXTRA=e $
                  ELSE opolarplot, radiusarray, anglearray, RADIUSINTERPOL=radiusinterpol, WINKELINTERPOL=winkelinterpol, _EXTRA=e
                                ; i cant pass RADIUSINTERPOL and
                                ; WINKELINTERPOL via _EXTRA because
                                ; _EXTRA doesn't return data!


; plot the axes
Axis, 0,0, xax=0, /DATA, XTICKFORMAT=('AbsoluteTicks'), XRANGE=xrange, CHARSIZE=charsize, XTICK_GET=TA
Axis, 0,0, yax=0, /DATA, YTICKFORMAT=('AbsoluteTicks'), YRANGE=yrange, CHARSIZE=charsize

; plot a solid circle (constant radius) at each tick position
; avoids problems with double plotting of -x, x and circles near zero
; radius (this often produced incriptions like 0.343434E-17 which was
; of course very annoying)
TA = ABS(TA)
myArcs = TA(uniq(TA, sort(TA))) 
nozero = WHERE(myArcs GT MAX(myArcs/100.), c)
IF c NE 0 THEN myArcs = myArcs(nozero)

Arcs, myArcs, LINESTYLE=1


; plot a solid line (constant angle) for each minor tick
IF (Set(minorangleticks)) THEN BEGIN
 IF minorangleticks NE 0 THEN BEGIN
    rayarray = 90.0/(minorangleticks+1)*(1.0+findgen(4*(minorangleticks+1)))
    Radii, 0.0, max(TA), rayarray, LINESTYLE=1, /DATA
 ENDIF
ENDIF 


!P.MULTI = PTMP

END 
