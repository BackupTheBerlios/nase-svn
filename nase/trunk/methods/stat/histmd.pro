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
;  in other words, it counts the occurrences of vectors
;  i.e. certain combinations of numbers in a
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
;* result = HistMD(vectors [,NBINS=...] [MIN=...] [MAX=...] 
;*                         [/BIN_START]
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
;  MIN/MAX:: Use these keywords to manually set the ranges inside which
;            you want to compute the histogram. Both <*>min</*> and
;            <*>max</*> have 
;            to have n entries. See restrictions as well.  
;  BIN_START:: Return bin values as those where bins start, otherwise
;              return bin values as those in the middle of
;              bins. Default: <*>BIN_START=0</*>.
;
; OUTPUTS:
;  result:: A longword array of dimensions specified by
;           <*>NBINS</*>. <*>result[<B>x</B>]</*> with <B>x</B> being
;           an n-dimensional subscript vector is equal to the number
;           of simultaneous occurrences of the components of <B>x</B>.
;
; OPTIONAL OUTPUTS:
;  GET_BINVALUES:: Use this keyword to retreive the values
;                  corresponding to the histogram bins. See switch
;                  <*>BIN_START</*> as well. The format of
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
;  The <*>MIN</*> and <*>MAX</*> keywords have been added recently but
;  not been tested extensively. For ranges that are larger than the
;  data ranges, they seem to work ok, but it has not yet been tried to
;  clip the data. 
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
;* newPTVS, h, bv(1:bv(0,0),0), bv(1:bv(0,1),1)
;
; SEE ALSO:
;  <A>Hist()</A>, IDL's <C>Histogram()</C> and IDL's <C>Hist_2D()</C>.
;-


FUNCTION HistMD, s, NBINS=nbins $
                 , BIN_START=bin_start $
                 , MAX=max, MIN=min $
                 , GET_BINVALUES=get_binvalues $
                 , REVERSE_INDICES=reverse_indices

   Default, bin_start, 0

   binmidflag = bin_start EQ 0

   ssize = Size(s)
   sdur = ssize[1]
   IF ssize[0] EQ 1 $
    THEN sdim = 1 $
   ELSE sdim = ssize[2]
      
   Default, nbins, Make_Array(sdim, VALUE=10, /INT)

   IF sdim NE N_Elements(nbins) THEN $
    Console, /FATAL, 'Need number of bins for each stimulus dimension.'

   IF sdim GT 1 THEN BEGIN
      IF NOT Set(MIN) THEN smin = IMin(s, 1) ELSE smin = min
      IF NOT Set(MAX) THEN smax = IMax(s, 1) ELSE smax = max
   ENDIF ELSE BEGIN
      IF NOT Set(MIN) THEN smin = Min(s) ELSE smin = min
      IF NOT Set(MAX) THEN smax = Max(s) ELSE smax = max
   ENDELSE 

   ;;   sbinsize = (smax-smin)/(nbins-1) ;; old version
   sbinsize = Float(smax-smin)/(nbins)

   ;; compute bin indices for the first dimension
   ;; the max values, which would be in the nbins+1 bin are restricted by
   ;; "< (nbins[0]-1)" so they are counted in the last bin, see also
   ;; in the loop below
   combine = Long((s[*,0]-smin[0])/sbinsize[0]) < (nbins[0]-1)

   ;; for multidimensional stimuli generate onedimensional combined
   ;; array, see IDL's hist_2d routine
   IF sdim GT 1 THEN BEGIN
      FOR sdimidx=1, sdim-1 DO $
       combine = Temporary(combine)+Product(nbins[0:sdimidx-1]) $
       *(Long((s[*,sdimidx]-smin[sdimidx])/sbinsize[sdimidx]) $
         < (nbins[sdimidx]-1))
   ENDIF

   shist = Hist(combine, sbinval, 1 $
                 , MINH=0, MAXH=Product(nbins)-1, /EXACT $
                 , MAXBINS=Product(nbins), REVERSE_INDICES=srevidx)

   reverse_indices=srevidx

   get_binvalues = Make_Array(Max(nbins)+1, sdim, /FLOAT, VALUE=!NONE)
   get_binvalues[0, *] = nbins
   FOR idx = 0, sdim-1 DO $
    get_binvalues[1:nbins[idx], idx] = $
    smin[idx]+FIndGen(nbins[idx])*sbinsize[idx]+0.5*sbinsize[idx]*binmidflag

   Return, Reform(shist, nbins)

END
