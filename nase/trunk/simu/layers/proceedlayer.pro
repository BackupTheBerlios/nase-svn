;+
; NAME:                 ProceedLayer
;
; PURPOSE:              F�hrt einen Simulationszeitschritt durch (Schwellenvergleich), 
;                       der Input fuer die Layer mu� vorher mit
;                       Prozeduren  <A HREF="../simu/layers/#INPUTLAYER">InputLayer</A> �bergeben werden.
;
;                       ProceddLayer ist lediglich eine Rahmenprozedur, die
;                       selbst�ndig die f�r den jeweiligen Neuronentyp
;                       spezifische <A HREF="../simu/layers/#PROCEEDLAYER_1">
;                       ProceedLayer_i<\A>-Prozdeur aufruft.
;                       
; CATEGORY:             SIMULATION / LAYERS
;
; CALLING SEQUENCE:     ProceedLayer, Layer [,_EXTRA=_extra]  
;
; INPUTS:               Layer: eine durch InitLayer_x initialisierte Layer
;
; OPTIONAL INPUTS &
; KEYWORD PARAMETERS:   _extra: alle �brigen Parameter werden an die jeweilige
;                               ProceedLayer_i-Prozedur weitergereicht.
;
; COMMON BLOCKS:        common_random
;
; PROCEDURE:            ProceedLayer schaut nach dem Typ des �bergebenen Layers (aus dem
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

PRO ProceedLayer, Layer, _EXTRA=_extra

	Call_Procedure, 'ProceedLayer_'+Layer.Type, Layer,_EXTRA=_extra

END