;+
; NAME:               FreeTrainspottingScope
;
; PURPOSE:            Gibt ein TrainspottingScope frei
;                     (siehe <A HREF="#TRAINSPOTTINGSCOPE">TrainspottingScope</A>)
;
; CATEGORY:           GRAPHIC PLOTCILLOSCOPE
;
; CALLING SEQUENCE:   FreePlotcilloscope, TSC
;
; INPUTS:              TSC : eine mit <A HREF="#INITTRAINSPOTTINGSCOPE">InitTrainspottingScope</A> initialisierte
;                            Transpottingscope-Struktur
;
; EXAMPLE:
;                     LP = InitPara1()
;                     L = InitLayer(5,5,TYPE=LP)                   
;                     TSC = InitTrainspottingScope(NEURONS=5*5)
;                     FOR ....
;                          ProceedLayer, L
;                          TrainspottingScope, TSC, LayerOut(L)
;                     END
;                     FreeTrainspottingScope, TSC
;
; SEE ALSO:           <A HREF="#INITTRAINSPOTTINGSCOPE">InitTrainspottingScope</A>, <A HREF="#TRAINSPOTTINGSCOPE">TrainspottingScope</A>
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 2.1  1998/11/08 14:20:09  saam
;           the marriage of trainspotting and plotcilloscope
;
;
;-
PRO FreeTrainspottingScope, _SR
   
   On_Error, 2
   TestInfo, _SR, 'SPIKERASTER'
   Handle_Free, _SR

END
