;+
; NAME:               InitTrainspottingscope
;
; PURPOSE:            Initialisiert ein TrainspottingScope
;                     (siehe <A HREF="#TRAINSPOTTINGSCOPE">TrainspottingScope</A>)
;
; CATEGORY:           GRAPHIC PLOTCILLOSCOPE
;
; CALLING SEQUENCE:   TSC = InitTrainspottingScope(NEURONS=neurons [,TIME=time] 
;                            [,OVERSAMPLING=oversampling]
;                            [-other-Plot-Keywords-] 
;
; KEYWORD PARAMETERS: NEURONS      : Anzahl der darzustellenden Neurone
;                     TIME         : die Laenge der dargestellten Zeitachse (Def.:500)
;                     OVERSAMPLING : korrekte Umrechnung von BIN in ms bei
;                                    ueberabtastenden Neuronen
;
;                     Au�erdem sind alle Schl�sselworte erlaubt, die
;                     auch PLOT nimmt. Default f�r XTITLE ist "t / ms", fuer
;                     YTITLE "Neuron #"
;
; OUTPUTS:            TSC : ein Struktur zum Benutzen mit TrainspottingScope (HANDLE!)
;
; EXAMPLE:
;                    LP = InitPara1()
;                    L = InitLayer(5,5,TYPE=LP)                   
;                    TSC = InitTrainspottingScope(NEURONS=5*5)
;                    FOR ....
;                         ProceedLayer, L
;                         TrainspottingScope, TSC, LayerOut(L)
;                    END
;                    FreeTrainspottingScope, TSC
;
; SEE ALSO:          <A HREF="#TRAINSPOTTINGSCOPE">TrainspottingScope</A>, <A HREF="#FREETRAINSPOTTINGSCOPE">FreeTrainspottingScope</A>
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 2.1  1998/11/08 14:20:09  saam
;           the marriage of trainspotting and plotcilloscope
;
;
;-
FUNCTION InitTrainspottingScope, TIME=time, NEURONS=neurons, $
                                 OVERSAMPLING=oversampling, $
                                 XTITLE=xtitle, YTITLE=ytitle, _EXTRA=_extra

   On_Error, 2

   IF NOT Keyword_Set(NEURONS) THEN Message, 'keyword NEURONS is needed'

   Default, OVERSAMPLING, 1
   Default, TIME, 500l

   Default, XTITLE, 't / ms'
   If not keyword_set(_EXTRA) then _extra = {XTITLE: xtitle} else begin
      If not extraset(_extra, "xtitle") then _extra = create_struct(_extra, "xtitle", xtitle)
   EndElse

   Default, YTITLE, 'Neuron #'
   If not keyword_set(_EXTRA) then _extra = {YTITLE: ytitle} else begin
      If not extraset(_extra, "ytitle") then _extra = create_struct(_extra, "ytitle", ytitle)
   EndElse


   ;----------------> define UserSymbol: filled square
   PlotWidthNormal = (!X.Window)(1)-(!X.Window)(0)
   PlotHeightNormal = (!Y.Window)(1)-(!Y.Window)(0)
   
   PlotAreaDevice = Convert_Coord([PlotWidthNormal,PlotHeightNormal], /Normal, /To_Device)
   
   Default, XSymbolSize, 0.0
   Default, YSymbolSize, 2.0/(Neurons+1)
   
   ;----- Usersymbols, die nur ein Pixel breit sind (Stretch=0.0), duerfen
   ;      nicht FILLed dargestellt werden, da sie dann nicht zu sehen sind:
   IF XSymbolSize EQ 0.0 THEN Fill = 0 ELSE Fill = 1
   
   xsizedevice = xsymbolsize*PlotAreaDevice(0)
   ysizedevice = ysymbolsize*PlotAreaDevice(1)
   
   xsizechar = xsizedevice/!D.X_CH_SIZE
   ysizechar = ysizedevice/!D.Y_CH_SIZE


   PS = { info   : 'SPIKERASTER'  ,$
          neurons: neurons        ,$
          t      : 0l             ,$
          time   : LONG(time)     ,$
          os     : oversampling   ,$
          xsc    : xsizechar/2.   ,$
          ysc    : ysizechar/2.   ,$
          fill   : fill           ,$
          _extra : _extra}


   plot, FltArr(10), /NODATA, YRANGE=[-2, PS.neurons+2], XRANGE=[-2,PS.time/PS.os+2], XSTYLE=1, YSTYLE=1, XTICKLEN=0.00001, YTICKLEN=0.00001, YTICKFORMAT='KeineNegativenUndGebrochenenTicks', XTICKFORMAT='KeineNegativenUndGebrochenenTicks', _EXTRA=_extra

   RETURN, HANDLE_CREATE(!MH, VALUE=ps, /NO_COPY)
END