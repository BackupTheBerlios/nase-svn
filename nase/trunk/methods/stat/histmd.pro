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
;            to have n entries.
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
;  None, hopefully.
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
;*>      3.00000      1.33333      2.00000      2.66667     -999999.     -999999.
;*>       5.00000      12.0000      16.0000      20.0000      24.0000      28.0000
;
; Large example:
;* a=10.*RandomN(seed,1000)
;* b=2.*RandomN(seed,1000)
;* !P.MULTI=[0,1,2,0,0]
;* h=HistMD([[a],[b]],NBINS=[20,30],GET_BINVALUES=bv)
;* newPTVS, h, bv(1:bv(0,0),0), bv(1:bv(0,1),1)
;* h=HistMD([[a],[b]],NBINS=[20,30],GET_BINVALUES=bv,min=[-10,-1],max=[10,5])
;* newPTVS, h, bv(1:bv(0,0),0), bv(1:bv(0,1),1)
;
; SEE ALSO:
;  <A>Hist()</A>, IDL's <C>Histogram()</C> and IDL's <C>Hist_2D()</C>.
;-


FUNCTION HistMD, s, NBINS=nbins $
                 , BIN_START=bin_start $
                 , MAX=usermax, MIN=usermin $
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

   ;; Find true extents of arrays.
   IF sdim GT 1 THEN BEGIN
      truemin = IMin(s, 1)
      truemax = IMax(s, 1)
   ENDIF ELSE BEGIN
      truemin = Min(s, MAX=truemax)
   ENDELSE 

   Default, usermin, truemin
   Default, usermax, truemax

   usermin = usermin[0:sdim-1]
   usermax = usermax[0:sdim-1]

   ;; Will truncation of values be needed due to user supplied
   ;; restriction? 
   noMinTruncation = Total((truemin-usermin) LT 0) EQ 0 
   noMaxTruncation = Total((usermax-truemax) LT 0) EQ 0 

   ;; rebin max and min for later comparison with data to find out
   ;; which entries are inside max and min ranges
   rebmin = Rebin(Transpose(usermin), sdur, sdim, /SAMPLE)
   rebmax = Rebin(Transpose(usermax), sdur, sdim, /SAMPLE)

   sbinsize = Float(usermax-usermin)/(nbins)

   ;; compute bin indices for the first dimension
   ;; the max values, which would be in the nbins+1 bin are restricted by
   ;; "< (nbins[0]-1)" so they are counted in the last bin, see also
   ;; in the loop below
   combine = Long((s[*,0]-usermin[0])/sbinsize[0]) < (nbins[0]-1)

   ;; for multidimensional stimuli generate onedimensional combined
   ;; array, see IDL's hist_2d routine
   IF sdim GT 1 THEN BEGIN
      FOR sdimidx=1, sdim-1 DO $
       combine = Temporary(combine)+Product(nbins[0:sdimidx-1]) $
       *(Long((s[*,sdimidx]-usermin[sdimidx])/sbinsize[sdimidx]) $
         < (nbins[sdimidx]-1))
   ENDIF

   ;; Construct an array of out-of-range (0) and in-range (1) values.
   in_range = 1
   IF (noMinTruncation EQ 0) THEN BEGIN ;; set lt min to zero
      IF sdim EQ 1 THEN $
       in_range = (s GE rebmin) EQ sdim $
      ELSE $
       in_range = Total((s GE rebmin), 2) EQ sdim
   ENDIF   

   IF (noMaxTruncation EQ 0) THEN BEGIN ;; set gt max to zero
      IF sdim EQ 1 THEN $
       in_range = Temporary(in_range) AND ((s LE rebmax) EQ sdim) $
      ELSE $
       in_range = Temporary(in_range) AND (Total((s LE rebmax), 2) EQ sdim)
   ENDIF

   ;; Set values that are out of range to -1
   combine = (Temporary(combine) + 1L)*Temporary(in_range) - 1L

   shist = Hist(combine, sbinval, 1 $
                 , MINH=0, MAXH=Product(nbins)-1, /EXACT $
                 , MAXBINS=Product(nbins), REVERSE_INDICES=srevidx)

   reverse_indices=srevidx

   get_binvalues = Make_Array(Max(nbins)+1, sdim, /FLOAT, VALUE=!NONE)
   get_binvalues[0, *] = nbins
   FOR idx = 0, sdim-1 DO $
    get_binvalues[1:nbins[idx], idx] = $
    usermin[idx]+FIndGen(nbins[idx])*sbinsize[idx]+0.5*sbinsize[idx]*binmidflag

   Return, Reform(shist, nbins)

END
