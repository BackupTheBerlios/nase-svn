;+
; NAME:
;  Hist()
;
; VERSION:
;  $Id$
;
; AIM:
;   computes histogram and corresponding x values, allowing weighting
;
; PURPOSE:
;  Compute histogram and corresponding x values. Allows weights.
;  This routine was originally written by R. Sterner,
;  Johns Hopkins University Applied Physics Laboratory.
;   
; CATEGORY:
;  Array
;  Statistics
;
; CALLING SEQUENCE:
;*  h = hist(a, [,x [,bin]] [,MINH=...] [,MAXH=...]
;*              [,/EXACT] [,/BIN_START] [,MAXBINS=...] [NBINS=...]
;*              [,WEIGHT=...]  [,/REVERSE_INDICES]
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
;       x          :: optionally returned array of <*>x</*> values
;  REVERSE_INDICES :: Set this keyword to a named variable 
;                     in which the list of reverse indices is returned
;
;-
 
 
function hist, arr, x, bin, maxbins=mxb, nbins=nb, $
               minh=minv, maxh=maxv,exact=exact, bin_start=bin_start, weight=wt ,$
               REVERSE_INDICES=R_I
   
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
   if bin eq 0 then Console, /fatal, " Only equal values in data, keywords MINH and MAXH needed"
    
   ;;warn if nicenumber changes nbins
   if bin ne  ((double(maxv)-double(minv))/float(__nb)) and nb_flag EQ 1 then begin
      Console, /Warn, " BIN changed from "+ $
       str((double(maxv)-double(minv))/float(__nb)) +" to "+str(bin)
      Console, /warn, " resp. NBINS changed from "+str(nb)+" to "+str(round((double(maxv)-double(minv))/float(bin)+1))
      Console, /warn, " Keyword EXACT recommended."
   endif

   ;;------  Get max number of bins allowed  --------
   mxbins = 1000                ;; Def max # of histogram bins.
   if set(mxb) then mxbins = mxb ; Over-ride max bins.
   n = round((double(maxv)-double(minv))/float(bin)+1)
   
   ;;------  Test if too many bins  --------
   if n gt mxbins then begin
      Console, /Fatal,' Error in HIST: bin size too small, histogram requires '+$
       strtrim(n,2)+' bins.'
      Console, /Fatal,' Def.max # of bins = 1000.  May over-ride with NBINS keyword.'
   endif
   ;;make histogram
   if set(wt) then h = fltarr(n) else h = lonarr(n)
   
   for i=0l, n-2 do begin
      index = where( (arr-minv)  GE i*bin and (arr-minv) LT (i+1) * bin, count)
      if set(wt) and count GT 0 then h(i) = total(wt(index)) $
      else h(i) = count
   endfor
   ;;compute x-axis
   x = minv+findgen(n_elements(h))*bin
   if bin_start NE 1 then x = x + bin/2.

   return, h
end
