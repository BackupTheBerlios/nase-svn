;+
; NAME:              TrainspottingScope
;
; PURPOSE:           Sukzessive Darstellung der Spikeaktivitaet einer Gruppe
;                    von Neuronen als Spikerasterdiagramm. Diese Routine vereinigt 
;                    die Funktionalitaet von <A HREF=/nase/graphic/#TRAINSPOTTING>Trainspotting</A>
;                    und dem <A HREF=/nase/graphic/plotcilloscope/#PLOTCILLOSCOPE>Plotcilloscope</A>.                     
;
; CATEGORY:          GRAPHICS PLOTCILLOSCOPE
;
; CALLING SEQUENCE:  TrainspottingScope, TSC, O
;
; INPUTS:            TSC: mit <A HREF=/nase/graphic/plotcilloscope/#INITTRAINSPOTTINGSCOPE>InitTrainspottingScope</A> initialisierte Struktur
;                    O  : der Output einer Neuronengruppe im SSpass-Format
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
; RESTRICTIONS:      Im Moment gibt es aus Effizienzgruenden keine Gedaechtnisfunktion,
;                    daher kann die Abszissen-Beschirftung nicht aktualisiert werden.
;
; SEE ALSO:          <A HREF="#INITTRAINSPOTTINGSCOPE">InitTrainspottingScope</A>, <A HREF="#FREETRAINSPOTTINGSCOPE">FreeTrainspottingScope</A>
;
; MODIFICATION HISTORY:  
;
;     $Log$
;     Revision 2.2  1998/11/08 14:25:07  saam
;           hyperlink malfunction corrected
;
;     Revision 2.1  1998/11/08 14:20:10  saam
;           the marriage of trainspotting and plotcilloscope
;
;
;-
PRO TrainspottingScope, _SR, y, $
                        XSYMBOLSIZE=XSymbolSize, YSYMBOLSIZE=YSymbolSize, $
                        XTITLE=xtitle

   Handle_Value, _SR, SR, /NO_COPY
   IF y(0) NE 0 THEN BEGIN
      xsc = SR.xsc
      ysc = SR.ysc
      UserSym, [-xsc, xsc, xsc, -xsc, -xsc], [-ysc,-ysc,ysc,ysc,-ysc], FILL=SR.Fill
      
      neuronC = LIndGen(SR.neurons)
      vertLine = Make_Array(SR.neurons, VALUE=SR.t MOD SR.time)

      PlotS, vertLine, neuronC, PSYM=8, SYMSIZE=1, COLOR=!P.BACKGROUND
      PlotS, vertLine(0:y(0)), y(2:y(0)+1), PSYM=8, SYMSIZE=1.0
   END
   SR.t = SR.t + 1
   Handle_Value, _SR, SR, /NO_COPY, /SET
      
END

