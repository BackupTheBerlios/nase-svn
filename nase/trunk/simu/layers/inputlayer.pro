;+
; NAME:               InputLayer
;
; PURPOSE:            Addiert Input vom Typ Sparse (siehe 
;		      <A HREF="../simu/layers/#SPASSMACHER">Spassmacher<\A>) auf die 
;                     Neuronenpotentiale und klingt diese vorher ab. Ein
;                     mehrmaliger Aufruf von InputLayer ist moeglich.
;                     Danach sollte man auf jeden Fall ProceedLayer aufrufen.
;
;                     InputLayer ist lediglich eine Rahmenprozedur, die
;                     selbständig die für den jeweiligen Neuronentyp
;                     spezifische <A HREF="../simu/layers/#INPUTLAYER_1">
;                     InputLayer_i<\A>-Prozdeur aufruft.
;
; CATEGORY:           SIMULATION / LAYERS
;
; CALLING SEQUENCE:   InputLayer, Layer [,_EXTRA=_extra]
;
; INPUTS:             Layer : eine mit InitLayer erzeugte Struktur
;
; OPTIONAL INPUTS &
; KEYWORD PARAMETERS:   _extra: alle übrigen Parameter werden an die jeweilige
;                               ProceedLayer_i-Prozedur weitergereicht.
;                      
; SIDE EFFECTS:       wie so oft wird die Layer-Struktur veraendert
;
; RESTRICTIONS:       keine Überpüfung der Gültigkeit des Inputs (Effizienz!)
;
; PROCEDURE:          InputLayer schaut nach dem Typ des übergebenen Layers (aus dem
;                     Layer.Type-String) und ruft mit CALL_PROCEDURE die
;                     jeweilige spezielle InputLayer_i-Prozedur auf.
;
; EXAMPLE:
;                       para1 = InitPara_1(tauf=10.0, vs=1.0)
;                       mylayer = InitLayer(WIDTH=5, HEIGHT=5, TYPE=para1)
;                       feedingin = Spassmacher( 10.0 + RandomN(seed, mylayer.w*mylayer.h))
;                       InputLayer, mylayer, FEEDING=feedingin
;                       ProceedLayer, mylayer
;                       Print, 'Output: ', Out2Vector(mylayer.O)
;
; MODIFICATION HISTORY:
;
;  $Log$
;  Revision 2.1  1998/11/04 16:32:19  thiel
;         Rahmenprozedur fuer InputLayer_i-Prozeduren.
;
;
;-

PRO InputLayer, Layer, _EXTRA=_extra

	Call_Procedure, 'InputLayer_'+Layer.Type, Layer, _EXTRA=_extra

END








