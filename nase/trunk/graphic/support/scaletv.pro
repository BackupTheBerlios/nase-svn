;+
; NAME:
;  ScaleTV()
;
; VERSION:
;  $Id$
;
; AIM:
;  scales and clips data to be displayed by <A>UTV</A>
;
; PURPOSE:
;  This routine is an outsourced part of <A>PTvS</A> that may also be
;  called directly. It scales an image from 0 to <*>TOP</*> and is
;  able to clip data exceeding a given interval.
;  
;
; CATEGORY:
;  Color
;  Graphic
;  Image
;  Internal
;
; CALLING SEQUENCE:
;*sdata = ScaleTV(data [,TOP=...] [,CUTLO=...] [,CUTHI=...] [,ZRANGE=...])
;
; INPUTS:
;  data:: two-dimensional array
;
; INPUT KEYWORDS:
;  TOP       :: uses the colormap entries from 0 up to TOP (default:
;               <*>!TOPCOLOR</*>)
;  ZRANGE    :: Minimum and maximum value to scale the
;               <*>data</*>. The minimum will be scaled to color index
;               0, the maximum to <*>TOP</*>. If
;               the actual data is larger than the provided range,
;               values exeeding these limits will be clipped to the
;               minimum or maximum allowed. These can be retrieved
;               using <*>CUTLO</*> and <*>CUTHI</*>
;               
; OUTPUTS:
;  sdata:: scaled and possibly clipped version of <*>data</*> that may
;          be displayed using <A>UTv</A>.
;
; OPTIONAL OUTPUTS:
;  CUTLO/CUTHI:: indices of array elements that are clipped to the
;                minimum/maximum. Returns <*>-1</*> if nothing was clipped.
;
; EXAMPLE:
;*PTV, ScaleTv(randomu(seed,100,100), ZRANGE=[0.3,0.8])
;scales all values below 0.3 to the minimal color index and all
;indices above 0.8 to the maximal color index
;
; SEE ALSO:
;  <A>PTvS</A>, <A>UTvScl</A>
;-

FUNCTION ScaleTV, data, ZRANGE=_zrange, CUTHI=cuthi, CUTLO=cutlo, TOP=top

On_Error, 2

Default, TOP, !TOPCOLOR
Default, cutlo, -1
Default, cuthi, -1

IF Set(_ZRANGE) THEN BEGIN
    ;;
    ;; clip data if required 
    ;;
                                ; if the zrange is smaller than the actual data,
                                ; we clip the data not fitting into range
    _data = data
    ZRANGE=DOUBLE(_zrange)
                                ; this is needed because if ZRANGE has
                                ; a lower precision than data, the
                                ; comparison  
                                ; MAX(data) GT ZRANGE(1) fails (or at
                                ; least failed for my demo [MS] 
    
    
    ch=0
    cl=0
    IF (LONG(_zrange(1)) NE !NONEl) THEN BEGIN
        cuthi=WHERE(_data GT _zrange(1),ch)
        IF ch GT 0 THEN _data(cuthi)=_zrange(1)
    END ELSE ZRANGE(1) = MAX(data)
    IF (LONG(_zrange(0)) NE !NONEl) THEN BEGIN
        cutlo=WHERE(_data LT _zrange(0),cl)
        IF cl GT 0 THEN _data(cutlo)=_zrange(0)
    END ELSE ZRANGE(0) = MIN(data)

    _data = Scl(_data, [0, top], ZRANGE)
           
END ELSE BEGIN
    _data = Scl(data, [0, top])
END

RETURN, _data
END
