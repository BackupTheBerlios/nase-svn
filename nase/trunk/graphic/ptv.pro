;+
; NAME:
;  PTv
;
; VERSION:
;  $Id$
;
; AIM:
;  Color coded display of a two-dimensional array in a coordinate
;  system (no NASE support, less bugs).
;
; PURPOSE:
;  Color coded display of a two-dimensional array in a coordinate
;  system. This version is similar to <A>PlotTVScl</A> but fixes 
;  several serious design bugs, has a cleaner code, but does not support
;  any NASE options.
;
; CATEGORY: 
;  Graphic
;
; CALLING SEQUENCE: 
;*Ptv, data 
;*     [,XNorm] [,YNorm]
;*     [,/QUADRATIC]
;*     [,/FITPLOT]
;*     [,/LEGEND] [,LEGMARGIN=...] [,LEG_MIN=...] [, LEG_MAX=...]
;*     [,XRANGE=...] [,YRANGE=...]
;*     [,CHARSIZE=...]
;*     [,/ORDER]
;*     [,/POLYGON]
;*     [,TRUE=...]
;*     [,CUBIC=...] [, /INTERP] [, /MINUS_ONE]
;*     [,GET_POSITION=...] [,GET_PIXELSIZE=...]
;*
;* all other Keywords are passed to <C>PLOT</C>
;
; INPUTS: 
;  data:: two-dimensional array
;
; OPTIONAL INPUTS: 
;  XNorm, YNorm:: Specify the lower left corner of the plotregion used
;                 by <C>PTvS</C> in normal coordinates. The user
;                 himself has to care for sufficient space for labels.  
;
; INPUT KEYWORDS: 
;  CHARSIZE:: The overall character size for the annotation (default: <*>!P.CHARSIZE</*>)
;  FITPLOT :: The standard behavior of this routine is to plot the
;             coordinate system outside the bitmap, with the tickmarks
;             touching the border of the bitmap. Turning on this
;             option, the bitmap will touch the axes, instead, with
;             the tickmarks plotted above the bitmap.
;  LEGEND   :: displays a legend on the very right of the plot (using <A>TvSclLegend</A>) 
;  LEGMARGIN:: set the space that is used for the legend in normal
;              coordinates of the plot region (<*>/LEGEND</*>
;              has to be set, default: 0.15) 
;  LEGMIN,LEGMAX:: alternative labels for the legend (<*>/LEGEND</*>
;                  has to be set)
;  NOSCALE :: Turns off scaling. Please use <A>PTv</A> instead. 
;  ORDER     :: If specified, ORDER overrides the current setting of
;               the !ORDER system variable for the current image only.
;               If set, the image is drawn from the top down instead
;               of the normal bottom up.
;  POLYGON   :: If producing postscript as output device, <A>UTV</A> and its partners
;               produce bitmap output. With this option, the bitmap is
;               composed of polygon (each pixel a filled
;               polygon). This is advantageous, if you want to edit
;               the pixels with a vector drawing program like
;               COREL. Note, that setting this option disables the
;               function of <*>/CUBIC</*>, <*>/INTERP</*> and <*>/MINUS_ONE</*>.
;  QUADRATIC :: the pixels of the bitmap will be quadratic  
;  [XY]RANGE :: array containing two elements (minimum, maximum value)
;               for an alternative [XY]-axis labeling. 
;  TRUE      :: Set this keyword to a nonzero value to indicate that a
;               TrueColor (16-, 24-, or 32-bit) image is to be
;               displayed. The value assigned to TRUE specifies the
;               index of the dimension over which color is
;               interleaved. The image parameter must have three
;               dimensions, one of which must be equal to three. For
;               example, set <*>TRUE</*> to 1 to display an image that
;               is pixel interleaved and has dimensions of (3, m, n).
;               Specify 2 for row-interleaved images, of size (m, 3,
;               n), and 3 for band-interleaved images of the form (m, n, 3).
;  CUBIC, INTERP, MINUS_ONE:: will be passed to IDL routine
;                            <C>ConGrid</C>, to smooth the
;                            bitmap. This only works, if
;                            <*>/POLYGON</*> is not set.   
;
; OPTIONAL OUTPUTS:
;  GET_POSITION:: a four-element array [x0,y0,x1,y1], specifying the
;                 lower left and upper right corner of the plot in
;                 normal coordinates.
;  GET_PIXELSIZE:: an array [XSize, YSize], specifying the size of one
;                  bitmap pixel in normal coordinates
;
; PROCEDURE: 
;  1. compute the plot region<BR>
;  2. set up the coordinate system and plot axes <BR>
;  3. paste bitmap via <A>UTVScl</A><BR>
;  4. add a legend 
;
; EXAMPLE: 
;*x=randomn(seed,300,20)       
;*balancect, x
;*ptvs, x, /legend
;*plots, [0,299], [0,19], COLOR=RGB("white")
;
;
; SEE ALSO: <A>PTVS</A>, <A>PlotTV</A>, <A>UTVScl</A>, <A>TVSclLegend</A>,
;           <A>Plottvscl_update</A>            
;-


PRO PTv, Image, XNorm, YNorm, $
         GET_Position=Get_Position, $
         GET_PIXELSIZE=Get_PixelSize, $
         _EXTRA=e

   On_Error, 2
   CASE N_Params() OF
       0: Console, 'incorrect number of arguments', /FATAL
       1: PTvS, /NOSCALE, Image, GET_Position=Get_Position, GET_PIXELSIZE=Get_PixelSize, _EXTRA=e
       2: PTvS, /NOSCALE, Image, XNORM, GET_Position=Get_Position, GET_PIXELSIZE=Get_PixelSize, _EXTRA=e
       3: PTvS, /NOSCALE, Image, XNorm, YNorm, GET_Position=Get_Position, GET_PIXELSIZE=Get_PixelSize, _EXTRA=e
       ELSE: Console, 'too many arguments', /FATAL
   END
END


