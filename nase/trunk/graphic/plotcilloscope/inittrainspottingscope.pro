;+
; NAME:               InitTrainspottingscope
;
; PURPOSE:            Initialisiert ein TrainspottingScope
;                     (siehe <A HREF="#TRAINSPOTTINGSCOPE">TrainspottingScope</A>)
;
; CATEGORY:           GRAPHICS / PLOTCILLOSCOPE
;
; CALLING SEQUENCE:   TSC = InitTrainspottingScope(NEURONS=neurons [,TIME=time] 
;                            [,OVERSAMPLING=oversampling]
;                            [-other-Plot-Keywords-] 
;
; KEYWORD PARAMETERS: NEURONS      : Anzahl der darzustellenden Neurone
;                     TIME         : die Laenge der dargestellten Zeitachse in ms (Def.:500)
;                     OVERSAMPLING : korrekte Umrechnung von BIN in ms bei
;                                    ueberabtastenden Neuronen
;
;                     Außerdem sind alle Schlüsselworte erlaubt, die
;                     auch PLOT nimmt. Default für XTITLE ist "t / ms", fuer
;                     YTITLE "Neuron #"
;
; OUTPUTS:            TSC : ein Struktur zum Benutzen mit TrainspottingScope (HANDLE!)
;
; EXAMPLE:
;                    LP = InitPara1(SPIKENOISE=100)
;                    L = InitLayer(WIDTH=5,HEIGHT=5,TYPE=LP)                   
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
;     Revision 2.4  1999/03/08 12:54:26  thiel
;            Bugfix bei der OVERSAMPLING-BIN-Umrechnung.
;
;     Revision 2.3  1998/11/09 15:14:54  saam
;           passing of extra-arguments was corrupted
;
;     Revision 2.2  1998/11/08 19:36:06  saam
;           some plotting details improved
;
;     Revision 2.1  1998/11/08 14:20:09  saam
;           the marriage of trainspotting and plotcilloscope
;
;
;-
FUNCTION InitTrainspottingScope, TIME=time, NEURONS=neurons, $
                                 OVERSAMPLING=oversampling, $
                                 XSYMBOLSIZE=XSymbolSize, YSYMBOLSIZE=YSymbolSize, $
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


   plot, FltArr(10), /NODATA, YRANGE=[-1, neurons], XRANGE=[-1,time/oversampling+1], XSTYLE=1, YSTYLE=1, XTICKLEN=0.00001, YTICKLEN=0.00001, YTICKFORMAT='KeineNegativenUndGebrochenenTicks', XTICKFORMAT='KeineNegativenUndGebrochenenTicks', _EXTRA=_extra


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
          time   : LONG(time*oversampling)     ,$
          os     : oversampling   ,$
          xsc    : xsizechar/2.   ,$
          ysc    : ysizechar/2.   ,$
          fill   : fill           ,$
          _extra : _extra}


   RETURN, HANDLE_CREATE(!MH, VALUE=ps, /NO_COPY)
END
