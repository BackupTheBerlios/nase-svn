;+
; NAME:
;  Hist()
;
; VERSION:
;  $Id$
;
; AIM:
;  Computes histogram and corresponding bin values, allowing weighting.
;
; PURPOSE:
;  Compute histogram and corresponding bin values. In contrast to the
;  standard IDL routine <C>Histogram()</C>, <C>Hist()</C> allows
;  weighting of different entries. Furthermore, it adjusts its binsize
;  automatically using <A>NiceNumber</A> if not otherwise specified.<BR>
;  This routine was originally written by R. Sterner,
;  Johns Hopkins University Applied Physics Laboratory.
;   
; CATEGORY:
;  Array
;  Statistics
;
; CALLING SEQUENCE:
;*  h = Hist(a, [,x [,bin]] [,MINH=...] [,MAXH=...]
;*              [,/EXACT] [,/BIN_START] [,MAXBINS=...] [NBINS=...]
;*              [,WEIGHT=...]  [,REVERSE_INDICES...]
;
; INPUTS:
;  a   :: input array
;  bin :: optional bin size. Default is a size to give about 30 bins.
;         <*>NBINS</*> over-rides bin value and returns value used.
;
; INPUT KEYWORDS:
;  MINH      :: sets min histogram value
;  MAXH      :: sets max histogram value
;  EXACT     :: means use <*>MINH</*> and <*>MAXH</*> exactly. Else
;               adjusts x-axis with <A>nicenumber</A> 
;  BIN_START :: means return x as bin start values,
;               else x is returned as bin mid values.
;  MAXBINS   :: set max allowed number of bins to <*>MAXBINS</*>.
;               Over-rides default max of 1000.
;  NBINS     :: Set number of bins used to about <*>NBINS</*>.
;               Actual bin size is a nice number giving about <*>NBINS</*> bins.
;               Over-rides any specified bin size.
;  WEIGHT    :: Array of weights for each input array element.
;               If this is given then the weights are summed for each
;               bin instead of the counts.  Returned histogram is a
;               floating array.  Slower.
;
; OUTPUTS:
;       h :: resulting histogram
;
; OPTIONAL OUTPUTS:
;       x          :: Optionally returned array of data values
;                     corresponding to the histogram bins,
;                     like the data returned in the
;                     <*>LOCATIONS</*> keyword in 
;                     IDL's <C>Histogram()</C>.
;  REVERSE_INDICES :: Set this keyword to a named variable 
;                     in which the list of reverse indices is
;                     returned. See the documentation of IDL's
;                     <C>Histogram()</C> for an example.
;
; EXAMPLE:
;* y=0.5*randomn(s,1000)+3.
;* h=hist(y,axis)
;* plot, axis, h, PSYM=10
;
; SEE ALSO:
;  IDL's <C>Histogram()</C>.
;-
 
 
FUNCTION Hist, arr, x, bin, maxbins=mxbins, nbins=nb $
                , minh=minv, maxh=maxv, exact=exact, bin_start=bin_start $
                , weight=wt, REVERSE_INDICES=r_i
   
   if set(nb) then nb_flag = 1
   if set(nb) and set(bin) then $
    Console,/fatal,"Conflicting keywords: BIN ,NBINS"

   default, exact, 0
   default, nb_flag, 0
   default, nb, 30
   default, bin_start, 0

   ;; histogram results always to length nb+1 (maxh has to be included)
   __nb = nb-1l
   
   default, minv, min(double(arr)) ; Set max.
   default, maxv, max(double(arr)) ; Set min.
  
   if not set(bin) then begin
      if exact eq 1 then bin = ((double(maxv)-double(minv))/float(__nb)) $
      else bin = nicenumber((double(maxv)-double(minv))/float(__nb))
   end
   if bin eq 0 then Console, /fatal $
    , "Only equal values in data, keywords MINH and MAXH needed"
    
   ;;warn if nicenumber changes nbins
   if bin ne ((double(maxv)-double(minv))/float(__nb)) $
    and nb_flag EQ 1 then begin
      Console, /Warn, " BIN changed from "+ $
       str((double(maxv)-double(minv))/float(__nb)) +" to "+str(bin)
      Console, /warn, " resp. NBINS changed from "+str(nb)+" to "+str(round((double(maxv)-double(minv))/float(bin)+1))
      Console, /warn, " Keyword EXACT recommended."
   endif

   ;;------  Get max number of bins allowed  --------
   Default, mxbins, 1000                ;; Def max # of histogram bins.
;   if set(mxb) then mxbins = mxb ; Over-ride max bins.
   n = round((double(maxv)-double(minv))/float(bin)+1)
   
   ;;------  Test if too many bins  --------
   if n gt mxbins then begin
      Console, /Fatal,'Bin size too small, histogram requires '+$
       strtrim(n,2)+' bins.'+$
       ' Def.max # of bins = 1000. May over-ride with NBINS keyword.'
   endif
   ;;make histogram
   if set(wt) then h = fltarr(n) else h = lonarr(n)
   
   ;; array for reverse indices
   r_i = LonArr(n+N_Elements(arr)+1)
   ricount = n+1

   ;; CHANGE from previous version: loop now runs up to the last bin
   ;; (n-1), not (n-2) like before
   FOR i=0l, n-1 DO BEGIN 
      index = Where((arr-minv) GE i*bin AND (arr-minv) LT (i+1)*bin, count)
      IF set(wt) AND count GT 0 THEN h(i) = total(wt(index)) $
      ELSE h(i) = count
      IF count NE 0 THEN BEGIN
         r_i(i) = ricount
         r_i(ricount:ricount+count-1) = index
         ricount = ricount+count
      ENDIF ELSE BEGIN
         r_i(i) = ricount
      ENDELSE ;; count NE 0
   ENDFOR ;; i

   r_i(i) = ricount
   
   ;; compute x-axis for optional output
   x = minv+findgen(n_elements(h))*bin
   IF NOT Keyword_Set(bin_start) THEN x = x + bin/2.

   Return, h

END

