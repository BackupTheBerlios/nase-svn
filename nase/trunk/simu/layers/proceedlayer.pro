;+
; NAME:                 ProceedLayer
;
; PURPOSE:              Führt einen Simulationszeitschritt durch (Schwellenvergleich), 
;                       der Input fuer die Layer muß vorher mit
;                       Prozeduren  <A HREF="#INPUTLAYER">InputLayer</A> übergeben werden.
;
;                       ProceddLayer ist lediglich eine Rahmenprozedur, die
;                       selbständig die für den jeweiligen Neuronentyp
;                       spezifische <A HREF="#PROCEEDLAYER_1">ProceedLayer_i</A>-Prozdeur aufruft.
;                       
; CATEGORY:             SIMULATION / LAYERS
;
; CALLING SEQUENCE:     ProceedLayer, Layer [,_EXTRA=_extra]  
;
; INPUTS:               Layer : eine mit  <A HREF="#INITLAYER">InitLayer</A> erzeugte Struktur
;
; OPTIONAL INPUTS &
; KEYWORD PARAMETERS:   _extra: alle übrigen Parameter werden an die jeweilige
;                               ProceedLayer_i-Prozedur weitergereicht.
;
; COMMON BLOCKS:        common_random
;
; PROCEDURE:            ProceedLayer schaut nach dem Typ des übergebenen Layers (aus dem
;                       Layer.Type-String und ruft mit CALL_PROCEDURE die
;                       jeweilige spezielle ProceedLayer_x-Prozedur auf.
;
; EXAMPLE:
;                       para1 = InitPara_1(tauf=10.0, vs=1.0)
;                       mylayer = InitLayer(WIDTH=5, HEIGHT=5, TYPE=para1)
;                       feedingin = Spassmacher( 10.0 + RandomN(seed, mylayer.w*mylayer.h))
;                       InputLayer, mylayer, FEEDING=feedingin
;                       ProceedLayer, mylayer
;                       Print, 'Output: ', Out2Vector(mylayer.O)
;
;
; MODIFICATION HISTORY: 
;
;       $Log$
;       Revision 2.6  1998/11/08 17:27:22  saam
;             the layer-structure is now a handle
;
;       Revision 2.5  1998/11/06 14:28:00  thiel
;              Hyperlinks.
;
;       Revision 2.4  1998/11/06 14:16:00  thiel
;              Hyperlink defekt
;
;       Revision 2.3  1998/11/04 16:30:26  thiel
;              Jetzt mit EXTRA-Keyword.
;
;       Revision 2.2  1998/11/04 14:45:28  thiel
;              Variablenzuweisung gespart.
;
;       Revision 2.1  1998/11/04 14:19:07  thiel
;              Neue Rahmenprozedur, die die korrekte
;              ProceedLayer_x-Prozedur selbstaendig
;              aufruft.
;
;- 

PRO ProceedLayer, _Layer, _EXTRA=_extra
   
   Handle_Value, _LAYER, LAYER, /NO_COPY
   type = LAYER.TYPE
   Handle_Value, _LAYER, LAYER, /NO_COPY, /SET
   
   Call_Procedure, 'ProceedLayer_'+Type, _Layer,_EXTRA=_extra

END
