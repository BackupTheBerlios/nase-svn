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
;               adjusts so histogram goes to 0 at ends.
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
	  minh=minv, maxh=maxv, exact=exact, bin_start=bin_start, weight=wt ,$
                       REVERSE_INDICES=R_I
 

	;------  If bin size not given pick one  --------
        if n_params(0) lt 3 then BEGIN
           bin = nicenumber((double(max(arr))-double(min(arr)))/30.)
           IF bin EQ 0. THEN bin = 1./30.
        ENDIF
	if keyword_set(nb) then BEGIN
           bin = nicenumber((double(max(arr))-double(min(arr)))/nb)
           IF bin EQ 0. THEN bin = 1./nb
        ENDIF
        ;------  Get max number of bins allowed  --------
	mxbins = 1000				; Def max # of histogram bins.
	if keyword_set(mxb) then mxbins = mxb	; Over-ride max bins.
	;------  Get histogram min and max values  ------
 	mn = min(arr, max = mx)			; Min,max array value.
	if n_elements(minv) ne 0 then mn = minv	; Set min.
	if n_elements(maxv) ne 0 then mx = maxv	; Set max.
	b2 = bin/2.0				; Bin half width.
	xmn = bin*floor(mn/bin)			; First bin start X.
	xmx = bin*(1+floor(mx/bin))		; Last bin end X.
	n = (xmx - xmn)/bin			; Number of histogram bins.
	;------  Test if too many bins  --------
	if n gt mxbins then begin
	  print,' Error in HIST: bin size too small, histogram requires '+$
	    strtrim(n,2)+' bins.'
	  print,' Def.max # of bins = 1000.  May over-ride with NBINS keyword.'
	  return, -1
	endif
 
         
	  ;--------  Make histogram and bin X coordinates  ----------- 
	  h = histogram((arr - xmn)/bin, min=0, max=n,REVERSE_INDICES=R_I)
	  h = h(0:n-1)				; Trim upper end.
 
          x = xmn + bin*findgen(n_elements(h)) ; Bin starting x coordinates.
	;--------  Weighted histogram?  ----------------------------
          if n_elements(wt) ne 0 then begin
             if n_elements(wt) ne n_elements(arr) then begin
                print,' Error in hist: when weights are given there must be one'
                print,'   for each input array element.'
                return,-1
             endif
             h = float(h) ;;
             for  i = 0L ,n_elements(h)-1 DO BEGIN 
                
                IF R_I(i) NE R_I(i+1) THEN BEGIN 
                   h(i) = total(wt(R_I(R_I(i): R_I(i+1)-1))) 
                ENDIF 
                
             ENDFOR 
             
          ENDIF
          ;;-------  Adjust histogram ends  ---------
	if not keyword_set(exact) then begin
	  x = [min(x)-bin,x,max(x)+bin]		; Add a bin to each end so
	  h = [0,h,0]				; histogram drops to 0 on ends.
	endif
 
	;-------  Adjust bin values  ---------
	if keyword_set(bin_start) then x = x + b2  ; default: mid bin x coordinates.
        

	return, h
	end
