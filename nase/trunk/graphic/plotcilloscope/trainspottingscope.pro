;+
; NAME:              TrainspottingScope
;
; AIM:
;  Gradually plot spiketrain(s) in an oscilloscope-like display.
;
; PURPOSE:           Sukzessive Darstellung der Spikeaktivitaet einer Gruppe
;                    von Neuronen als Spikerasterdiagramm. Diese Routine vereinigt 
;                    die Funktionalitaet von <A HREF=/nase/graphic/#TRAINSPOTTING>Trainspotting</A>
;                    und dem <A HREF=/nase/graphic/plotcilloscope/#PLOTCILLOSCOPE>Plotcilloscope</A>.                     
;
; CATEGORY:          GRAPHICS / PLOTCILLOSCOPE
;
; CALLING SEQUENCE:  TrainspottingScope, TSC, O
;
; INPUTS:            TSC: mit <A HREF=/nase/graphic/plotcilloscope/#INITTRAINSPOTTINGSCOPE>InitTrainspottingScope</A> initialisierte Struktur
;                    O  : der Output einer Neuronengruppe als Handle auf SSpass-Format bzw. ein Arraz mit Nullen und Einsen,
;                         falls NONASE in InitTrainspottingScope gesetzt wurde
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
; RESTRICTIONS:      Im Moment gibt es aus Effizienzgruenden keine Gedaechtnisfunktion
;
; SEE ALSO:          <A HREF="#INITTRAINSPOTTINGSCOPE">InitTrainspottingScope</A>, <A HREF="#FREETRAINSPOTTINGSCOPE">FreeTrainspottingScope</A>
;
; MODIFICATION HISTORY:  
;
;     $Log$
;     Revision 2.10  2000/10/01 14:51:23  kupper
;     Added AIM: entries in document header. First NASE workshop rules!
;
;     Revision 2.9  2000/08/23 13:45:11  kupper
;     Changed point of plotting new time slice by one step, as display was
;     erased one step too early (Display was erased at plotting the last
;     step!)
;
;     Revision 2.8  1999/03/17 10:24:14  saam
;           new keyword NONASE implemented
;
;     Revision 2.7  1999/03/08 13:34:18  thiel
;            Bugs korrigiert, die ich beim Bugfix gemacht hatte.
;
;     Revision 2.6  1999/03/08 12:54:26  thiel
;            Bugfix bei der OVERSAMPLING-BIN-Umrechnung.
;
;     Revision 2.5  1998/11/09 15:14:55  saam
;           passing of extra-arguments was corrupted
;
;     Revision 2.4  1998/11/08 19:36:05  saam
;           some plotting details improved
;
;     Revision 2.3  1998/11/08 17:53:35  saam
;           changed to new layer type
;
;     Revision 2.2  1998/11/08 14:25:07  saam
;           hyperlink malfunction corrected
;
;     Revision 2.1  1998/11/08 14:20:10  saam
;           the marriage of trainspotting and plotcilloscope
;
;
;-
PRO TrainspottingScope, _SR, _y

   Handle_Value, _SR, SR, /NO_COPY

   IF SR.nonase THEN y = SSpassMacher(_y) ELSE y = Handle_Val(_y)

   IF y(0) NE 0 THEN BEGIN
      xsc = SR.xsc
      ysc = SR.ysc
      UserSym, [-xsc, xsc, xsc, -xsc, -xsc], [-ysc,-ysc,ysc,ysc,-ysc], FILL=SR.Fill
      
      neuronC = LIndGen(SR.neurons)
      vertLine = Make_Array(SR.neurons, VALUE=Float(SR.t)/Float(SR.os))

      PlotS, vertLine(0:y(0)-1), y(2:y(0)+1), PSYM=8, SYMSIZE=1.0
   END
   SR.t = SR.t + 1

   IF (SR.T MOD SR.TIME) EQ 1 THEN BEGIN
      plot, FltArr(10), /NODATA, YRANGE=[-1, SR.neurons], XRANGE=[SR.T/SR.os,(SR.T+SR.time)/SR.os], XSTYLE=1, YSTYLE=1, XTICKLEN=0.00001, YTICKLEN=0.00001, YTICKFORMAT='KeineNegativenUndGebrochenenTicks', XTICKFORMAT='KeineNegativenUndGebrochenenTicks', _EXTRA=SR._extra
   END

   Handle_Value, _SR, SR, /NO_COPY, /SET
      
END

