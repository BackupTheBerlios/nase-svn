;+
; NAME: PlotTVScl
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



PRO PlotTvscl, w, XPos, YPos, FULLSHEET=FullSheet, CHARSIZE=Charsize, $
                 _EXTRA=_extra

Default, Charsize, 1.0

ArrayHeight = (size(w))(2)
ArrayWidth  = (size(w))(1)

!Y.TickLen = 1.0/(ArrayWidth+1)/2.0
!X.TickLen = 1.0/(ArrayHeight+1)/2.0

IF ArrayHeight GE 15 THEN !Y.Minor = 0 ELSE $
 IF ArrayHeight GE 7 THEN !Y.Minor = 2 ELSE !Y.Minor=-1

IF ArrayWidth GE 15 THEN !X.Minor = 0 ELSE $
 IF ArrayWidth GE 7 THEN !X.Minor = 2 ELSE !X.Minor=-1

Default, XPos, 0.0
Default, YPos, 0.0

PosDevice = Convert_Coord([XPos,YPos], /Normal, /To_Device)

OriginDevice = [!X.Margin(0)*!D.X_CH_Size*Charsize,!Y.Margin(0)*!D.Y_CH_Size*Charsize]+PosDevice
UpRightDevice = [!X.Margin(1)*!D.X_CH_Size*Charsize,!Y.Margin(1)*!D.Y_CH_Size*Charsize]

OriginNormal = Convert_Coord(OriginDevice, /Device, /To_Normal)
UpRightNormal = Convert_Coord(UpRightDevice, /Device, /To_Normal)


RandNormal = OriginNormal + UpRightNormal


PlotPositionDevice = FltArr(4)
PlotPositionDevice(0) = OriginDevice(0)
PlotPositionDevice(1) = OriginDevice(1)

VisualWidth = !D.X_VSIZE*(1-XPos)
VisualHeight = !D.Y_VSIZE*(1-YPos)

PixelSizeDevice = convert_coord([(1.0-RandNormal(0))/float(ArrayWidth+1),(1.0-RandNormal(1))/float(ArrayHeight+1)], /normal, /to_device)

IF NOT Set(FullSheet) THEN BEGIN 
 IF PixelSizeDevice(1)*(ArrayWidth+1)+OriginDevice(0)+UpRightDevice(0) LT VisualWidth THEN BEGIN
       PlotPositionDevice(2) = PixelSizeDevice(1)*(ArrayWidth+1)+OriginDevice(0)
       PlotPositionDevice(3) = VisualHeight - UpRightDevice(1)
   ENDIF ELSE BEGIN
       PlotPositionDevice(3) = PixelSizeDevice(0)*(ArrayHeight+1)+OriginDevice(1)
       PlotPositionDevice(2) = VisualWidth - UpRightDevice(0)
     ENDELSE 
     Plot, indgen(2), /NODATA, Position=PlotPositionDevice, /Device, $
      xrange=[-1, ArrayWidth], /xstyle, xtickformat='KeineNegativenUndGebrochenenTicks', $
      yrange=[-1, ArrayHeight], /ystyle, ytickformat='KeineNegativenUndGebrochenenTicks', charsize=charsize,_EXTRA=_extra
ENDIF ELSE BEGIN
   !P.Region = [0.0,0.0,1.0,1.0]
   Plot, indgen(2), /NODATA, $
      xrange=[-1, ArrayWidth], /xstyle, xtickformat='KeineNegativenUndGebrochenenTicks', $
      yrange=[-1, ArrayHeight], /ystyle, ytickformat='KeineNegativenUndGebrochenenTicks', charsize=charsize,_EXTRA=_extra
ENDELSE







TotalPlotWidthNormal = (!X.Window)(1)-(!X.Window)(0) ;Normalkoordinaten
TotalPlotHeightNormal = (!Y.Window)(1)-(!Y.Window)(0)

PlotWidthNormal = TotalPlotWidthNormal - TotalPlotWidthNormal*2*!Y.Ticklen
PlotHeightNormal = TotalPlotHeightNormal - TotalPlotHeightNormal*2*!X.Ticklen

PlotAreaDevice = Convert_Coord([PlotWidthNormal,PlotHeightNormal], /Normal, /To_Device)



UTVScl, W, OriginNormal(0)+TotalPlotWidthNormal*!Y.Ticklen, OriginNormal(1)+TotalPlotHeightNormal*!X.Ticklen, X_SIZE=PlotAreaDevice(0)/!D.X_PX_CM, Y_SIZE=PlotAreaDevice(1)/!D.Y_PX_CM 


END
