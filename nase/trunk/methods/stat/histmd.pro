;+
; NAME:
;  HistMD()
;
; VERSION:
;  $Id$
;
; AIM:
;  Compute multidimensional histograms.
;
; PURPOSE:
;  <C>HistMD()</C> computes a histogram of multidimensional data,
;  i.e. it counts the occurrences of vectors or combinations of numbers in a
;  stream of data. It is an extension of IDL's own <C>Hist_2D()</C>
;  routine.
;
; CATEGORY:
;  Array
;  Math
;  Statistics
;  Signals
;
; CALLING SEQUENCE:
;* result = HistMD(vectors [,NBINS=...] 
;*                         [,GET_BINVALUES=...] [,REVERSE_INDICES=...])
;
; INPUTS:
;  vectors:: A sequence of n-dimensional vectors arranged in an array
;            of the form vectors[time,component]. 
;
; INPUT KEYWORDS:
;  NBINS:: A multidimensional array specifying the number of bins
;          desired for each of the n dimensions. <*>NBINS(i)</*>
;          therefore specifies the number of bins to be used for the
;          <*>i</*>th dimension. The default is 10 for all dimensions.
;
; OUTPUTS:
;  result:: A longword array of dimensions specified by
;           <*>NBINS</*>. <*>result[<B>x</B>]</*> with <B>x</B> being
;           an n-dimensional subscript vector is equal to the number
;           of simultaneous occurrences of the components of <B>x</B>.
;
; OPTIONAL OUTPUTS:
;  GET_BINVALUES:: Use this keyword to retreive the values
;                  corresponding to the histogram bins. The format of
;                  the array returned is:<BR>
;                  array(0,j): Number of bins in the <*>j</*>th
;                              dimension.<BR>
;                  array(i+1,j): Data value corresponding to
;                                <*>i</*>th bin in the <*>j</*>th
;                              dimension.<BR>
;                  Array entries not used are set to <*>!NONE</*>.
;  REVERSE_INDICES:: Set this keyword to a named variable in which the
;                    list of reverse indices is returned. reverse
;                    indices relate each bin entry to the index in
;                    the data sequence at which it originally occured.
;                    Note that reverse indices returned are
;                    onedimensional. See the documentation of IDL's
;                    <C>Histogram()</C> for an example.
;
; RESTRICTIONS:
;  At present, <C>HistMD()</C> computes its values using excatly the
;  complete range of data in each dimension. The option of setting
;  ranges by the user has been omitted for the sake of simplicity for
;  the time being, but may be added later. 
;
; PROCEDURE:
;  Generate onedimensional array form multidimensional one and apply
;  <A>Hist()</A>-procedure. See also source code for IDL's
;  <C>Hist_2D()</C> which uses the same technique for two dimensions.
;
; EXAMPLE:
;  Small example:
;* v=[[1,2,3,1,2,3,1,2,3],[10,20,30,10,20,30,20,30,10]]
;* print, v
;*>       1       2       3       1       2       3       1       2       3
;*>      10      20      30      10      20      30      20      30      10
;* print, histmd(v,nbins=[3,5],get_bin=b)
;*>           2           0           1
;*>           0           0           0
;*>           1           2           0
;*>           0           0           0
;*>           0           1           2
;* print, b
;*>      3.00000      1.00000      2.00000      3.00000     -999999.     -999999.
;*>      5.00000      10.0000      15.0000      20.0000      25.0000      30.0000
;
; Large example:
;* a=10.*RandomN(seed,1000)
;* b=2.*RandomN(seed,1000)
;* h=HistMD([[a],[b]],NBINS=[20,30],GET_BINVALUES=bv)
;* ptvs, h, xrange=bv(1:bv(0,0),0), yrange=bv(1:bv(0,1),1)
;
; SEE ALSO:
;  <A>Hist()</A>, IDL's <C>Histogram()</C> and IDL's <C>Hist_2D()</C>.
;-


FUNCTION HistMD, s, NBINS=nbins $
                 , GET_BINVALUES=get_binvalues $
                 , REVERSE_INDICES=reverse_indices

   ssize = Size(s)
   sdur = ssize(1)
   IF ssize(0) EQ 1 $
    THEN sdim = 1 $
   ELSE sdim = ssize(2)
      
   Default, nbins, Make_Array(sdim, VALUE=10, /INT)

   IF sdim NE N_Elements(nbins) THEN $
    Console, /FATAL, 'Need number of bins for each stimulus dimension.'

   IF sdim GT 1 THEN BEGIN
      smin = IMin(s, 1)
      smax = IMax(s, 1)
   ENDIF ELSE BEGIN
      smin = Min(s, MAX=smax)
   ENDELSE 

   sbinsize = (smax-smin)/(nbins-1)

   combine = Long((s(*,0)-smin(0))/sbinsize(0))
   ;; for multidimensional stimuli generate onedimensional combined
   ;; array, see IDL's hist_2d routine
   IF sdim GT 1 THEN BEGIN
      FOR sdimidx=1, sdim-1 DO $
       combine = Temporary(combine)+(Product(nbins(0:sdimidx-1))) $
       *Long((s(*,sdimidx)-smin(sdimidx))/sbinsize(sdimidx))
   ENDIF

   shist = Hist(combine, sbinval, 1 $
                 , MINH=0, MAXH=Product(nbins)-1, /EXACT $
                 , MAXBINS=Product(nbins), REVERSE_INDICES=srevidx)

   reverse_indices=srevidx

   get_binvalues = Make_Array(Max(nbins)+1, sdim, /FLOAT, VALUE=!NONE)
   get_binvalues(0, *) = nbins
   FOR idx = 0, sdim-1 DO $
    get_binvalues(1:nbins(idx), idx) = $
    smin(idx)+FIndGen(nbins(idx))*sbinsize(idx)

   Return, Reform(shist, nbins)

END
