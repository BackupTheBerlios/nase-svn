;+
; NAME:
;  newPTVS
;
; VERSION:
;  $Id$
;
; AIM:
;  Color coded display of a two-dimensional array in a coordinate system.
;
; PURPOSE:
;  Color coded display of a two-dimensional array in a coordinate
;  system. This version is similar to <A>PTVS</A>, but supports
;  optional x- and y-axis annotation, displaying subarrays via the
;  usual <*>XYRANGE</*>-keywords and does not draw tick marks where there are
;  no array entries. It is intended to inherit all of PTV's
;  functionality in the future, but this has not yet been accomplished.
;
; CATEGORY:
;  Array
;  Graphic
;  Image
;
; CALLING SEQUENCE:
;* newPTVS, image [,x [,y]] [,/FITPLOT] [,/ORDER] [,/POLYGON] [,/CORNERS] 
;*                   [,CUBIC=...] [,/INTERP] [,/MINUS_ONE] [,/SMOOTH] 
;*                   [,/LEGEND] [,LEGMARGIN=...]
;
; INPUTS:
;  image:: One- or two dimensional array of numerical data.
;
; OPTIONAL INPUTS:
;  x, y:: One-dimensional arrays of x and y values corresponding to
;         the array indices. This can be used to adjust the axis tick
;         values. 
;
; INPUT KEYWORDS:
;  /FITPLOT:: The standard behavior of this routine is to plot the
;             coordinate system outside the bitmap, with the tickmarks
;             touching the border of the bitmap. Turning on the
;             <*>/FITPLOT</*> option, the bitmap will touch the axes
;             instead, with the tickmarks overlaying the bitmap.
;  /ORDER:: If specified, the image's first line (i.e. <*>image[*,0]</*>
;           is drawn at the top of the window, instead of drawing
;           <*>image[*,0]</*> at the window's bottom. <*>/ORDER</*> reverses
;           the y-axis annotation, but only after <*>YRANGE</*> has
;           been applied.
;  /POLYGON:: When producing postscript output, <A>UTV</A> and its
;             partners produce bitmap output. With this option, the
;             bitmap is composed of polygons (each pixel a filled
;             polygon). This is advantageous if you want to edit the
;             pixels with a vector drawing program like
;             COREL. Furthermore, for
;             small arrays (up to 1000 entries), the output files
;             composed of polygons are 
;             smaller than their bitmap counterparts. But
;             <B>beware</B>, for arrays with many entries composing output
;             out of polygons results in huge PS files. Note that
;             setting the <*>/POLYGON</*> option disables the function of
;             <*>/CUBIC</*>, <*>/INTERP</*> and <*>/MINUS_ONE</*>.
; /CORNERS:: In addition to the axes that start and end in the middle
;            of the array pixels, setting this option draws additional
;            corners that result in a normal IDL axes box surrounding
;            the image. Default: 1.
; CUBIC, /INTERP, /MINUS_ONE:: These will be passed to the underlying
;                              IDL routine <C>ConGrid</C> to smooth
;                              the bitmap. See <C>Congrid</C>'s documentation
;                              for more info. This only works if
;                              <*>/POLYGON</*> is not set.   
; /SMOOTH:: Smoothes the plot, shortcut for setting <*>CUBIC=-0.5</*>
;           and <*>/MINUS_ONE</*>. 
; /LEGEND:: Displays a legend of the color code on the very right of
;            the plot using <A>TvSclLegend</A>. 
; LEGMARGIN:: Modifies the amount of space on the right side of the
;             plot that is used to plot the legend, in percent of the
;             total plot width. Default: 0.15. 
; LEG???:: All other keywords beginning with a <*>LEG</*> will be
;          passed to <A>TvSclLegend</A> without the leading
;          <*>LEG</*>. This can be used to adjust the legend to your
;          personal needs. 
;  
; OPTIONAL OUTPUTS:
;  
;
; SIDE EFFECTS:
;  
;
; RESTRICTIONS:
;  - The legend title is always on ths same side as the annotation to save
;  space. Usage of <*>LEGMID</*> is therefore not recommended, since
;  the middle annotation would occur in the same place as the title.<BR>
;  <BR>
;  Not yet implemented: <BR>
;  - optional positioning <BR>
;  - ranges that extend beyond the array values <BR>
;  - ranges with first value larger than second <BR>
;  - quadratic pixels <BR>
;  - where should extra go? <BR>
;  - true color support <BR>
;  - ZRANGE, without clipping but stretching instead , makes only
;  sense in PTVScale?<BR>
;  
; PROCEDURE:
;  Scale the array and pass it to <A>newPTV</A>.
;
; EXAMPLE:
;* NewPTVS, IndGen(20,5), FIndGen(20)/50., /LEGEND, XRANGE=[0.1,0.3]
;
; SEE ALSO:
;  <A>PTVS</A>, <A>Scl</A>, <A>newPTV</A>.
;-

PRO newPTVS, first, second, third, _EXTRA=_extra

   mif = Min(first, MAX=maf)
   Default, legmin, Str(mif, FORMAT='(G0.0)')
   Default, legmax, Str(maf, FORMAT='(G0.0)')

   a = Scl(first, [0, !TOPCOLOR])

   CASE N_Params() OF
      1: newPTV, a, LEGMIN=legmin, LEGMAX=legmax, _EXTRA=_extra
      2: newPTV, a, second, LEGMIN=legmin, LEGMAX=legmax, _EXTRA=_extra
      3: newPTV, a, second, third, LEGMIN=legmin, LEGMAX=legmax, _EXTRA=_extra
      ELSE: Console, /FATAL, 'Wrong number of arguments.'
   ENDCASE

END

