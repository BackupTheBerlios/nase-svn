;+
; NAME:
;
; PURPOSE:
;
; CATEGORY:
;
; CALLING SEQUENCE:
; 
; INPUTS:
;
; OPTIONAL INPUTS:
;	
; KEYWORD PARAMETERS:
;
; OUTPUTS:
;
; OPTIONAL OUTPUTS:
;
; COMMON BLOCKS:
;
; SIDE EFFECTS:
;
; RESTRICTIONS:
;
; PROCEDURE:
;
; EXAMPLE:
;
; MODIFICATION HISTORY:
;
;-

FUNCTION KeineNegativenUndGebrochenenTicks, axis, index, value
   IF (Value LT 0) OR ((Value - Fix(Value)) NE 0) THEN BEGIN
      Return, '' 
      ENDIF ELSE BEGIN
         Return, String(Value, Format='(I)')
         ENDELSE 
END



PRO PlotTvscl, w, XPos, YPos, FULLSHEET=FullSheet, GET_POSITION=get_position, GET_MINOR=get_minor, $
                 _EXTRA=_extra

ArrayHeight = (size(w))(2)
ArrayWidth  = (size(w))(1)

Default, XPos, 0.0
Default, YPos, 0.0
!P.Region(0) = XPos
!P.Region(1) = YPos

ArrayRatio = float(Min([ArrayHeight,ArrayWidth]))/float(Max([ArrayHeight,ArrayWidth]))
print, ArrayRatio

VisualWidth = !D.X_VSIZE*(1-XPos)
VisualHeight = !D.Y_VSIZE*(1-YPos)

print, visualwidth
print, visualheight


VisualRatio = float(Min([VisualWidth, VisualHeight]))/float(Max([VisualWidth, VisualHeight]))
print, !x.margin

RandNormal = Convert_Coord([(!X.Margin(0)+!X.Margin(1))*!D.Y_CH_Size,(!Y.Margin(0)+!Y.Margin(1))*!D.X_CH_Size],/device,/to_normal)
    
XRegionNormal = float(ArrayWidth)/float(ArrayHeight)+RandNormal(0)
YRegionNormal = float(ArrayHeight)/float(ArrayWidth)+RandNormal(1)

print, xregionnormal
print, yregionnormal

;IF NOT Set(FullSheet) THEN BEGIN 
; IF VisualHeight/float(ArrayHeight) LT VisualWidth/float(ArrayWidth) THEN BEGIN
;   IF XRegionNormal LE 1.0 THEN BEGIN  
;       !P.Region(2) = XRegionNormal
;       !P.Region(3) = 1.0
;       ENDIF ELSE BEGIN
;          !P.Region(2) = 1.0
;          !P.Region(3) = YRegionNormal
;       ENDELSE
;   ENDIF ELSE BEGIN
;      IF YRegionNormal LE 1.0 THEN BEGIN
;         !P.Region(2) = 1.0
;         !P.Region(3) = YRegionNormal
;         ENDIF ELSE BEGIN
;            !P.Region(2) = XRegionNormal
;            !P.Region(2) = 1.0
;         ENDELSE
;  ENDELSE 
;ENDIF ELSE !P.Region(2) = !P.Region(0)


print, 'Rand:',randnormal(0)

IF NOT Set(FullSheet) THEN BEGIN 
 IF VisualHeight/float(ArrayHeight)+RandNormal(0) LT VisualWidth/float(ArrayWidth)+RandNormal(1) THEN BEGIN
       !P.Region(2) = XRegionNormal
       !P.Region(3) = 1.0
   ENDIF ELSE BEGIN
         !P.Region(2) = 1.0
         !P.Region(3) = YRegionNormal
  ENDELSE 
ENDIF ELSE !P.Region(2) = !P.Region(0)



print, !P.region

!Y.TickLen = 1.0/(ArrayWidth+1)/2.0
!X.TickLen = 1.0/(ArrayHeight+1)/2.0

IF ArrayHeight GE 15 THEN !Y.Minor = 0 ELSE $
 IF ArrayHeight GE 7 THEN !Y.Minor = 2 ELSE !Y.Minor=-1

IF ArrayWidth GE 15 THEN !X.Minor = 0 ELSE $
 IF ArrayWidth GE 7 THEN !X.Minor = 2 ELSE !X.Minor=-1


Plot, indgen(2), /NODATA, $
    xrange=[-1, ArrayWidth], /xstyle, xtickformat='KeineNegativenUndGebrochenenTicks', $
    yrange=[-1, ArrayHeight], /ystyle, ytickformat='KeineNegativenUndGebrochenenTicks',_EXTRA=_extra



;Plot, indgen(2), /NODATA, $;position=[plotpx, plotpy, plotpx1, plotpy1], $
;    xrange=[-1, ArrayWidth], /xstyle, xminor=xt(1), $
;    yrange=[-1, ArrayHeight], /ystyle, yminor=yt(1), $
;;    ;xticklen=ticklen(0), yticklen=ticklen(1),
;    _EXTRA=_extra



XOriginNormal = (!X.Window)(0);Normalkoordinaten
YOriginNormal = (!Y.Window)(0)

print, xoriginnormal

TotalPlotWidthNormal = (!X.Window)(1)-(!X.Window)(0) ;Normalkoordinaten
TotalPlotHeightNormal = (!Y.Window)(1)-(!Y.Window)(0)

PlotWidthNormal = TotalPlotWidthNormal - TotalPlotWidthNormal*2*!Y.Ticklen
PlotHeightNormal = TotalPlotHeightNormal - TotalPlotHeightNormal*2*!X.Ticklen

PlotAreaDevice = Convert_Coord([PlotWidthNormal,PlotHeightNormal], /Normal, /To_Device)


UTVScl, w, XOriginNormal+TotalPlotWidthNormal*!Y.Ticklen, YOriginNormal+TotalPlotHeightNormal*!X.Ticklen, X_SIZE=PlotAreaDevice(0)/!D.X_PX_CM, Y_SIZE=PlotAreaDevice(1)/!D.Y_PX_CM 


END
