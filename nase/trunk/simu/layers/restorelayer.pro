;+
; NAME:                 RESTORELAYER
;
;
; PURPOSE:              Stellt mit save abgespeicherte Layer Strukturen wieder her
;
;
; CATEGORY:             CONNECTIONS
;
;
; CALLING SEQUENCE:     RESTORELAYER,Layer
;
; 
; INPUTS: 
;                       Layer : Struktur namens Layer
;
;
; EXAMPLE:              para4 = InitPara_4(tauf=10.0, vs=1.0)     
;                       Layer = InitLayer_4(height=5, width=5, type=para4)
;                       save,Layer                             
;                       restore
;                       restore,Layer
;
;
; MODIFICATION HISTORY:
;
;
;     $Log$
;     Revision 2.1  1997/12/16 09:09:10  gabriel
;          Erzeugt handles fue eine zuvor abgespeicherte Layerstruktur
;
;
;-


PRO RESTORELAYER,Layer

    Layer.O = Handle_Create(VALUE=[0, Layer.w*Layer.h])

END
