;+
; NAME:
;  InputLayer
;
; AIM:
;  Transfer input to neuron synapses of a given layer. 
;
; PURPOSE:            Addiert Input vom Typ Sparse (siehe 
;		      <A HREF="#SPASSMACHER">Spassmacher</A>) auf die 
;                     Neuronenpotentiale und klingt diese vorher ab. Ein
;                     mehrmaliger Aufruf von InputLayer ist moeglich.
;                     Danach sollte man auf jeden Fall ProceedLayer aufrufen.
;
;                     InputLayer ist lediglich eine Rahmenprozedur, die
;                     selbständig die für den jeweiligen Neuronentyp
;                     spezifische <A HREF="#INPUTLAYER_1">InputLayer_i</A>-Prozdeur aufruft.
;
; CATEGORY:           SIMULATION / LAYERS
;
; CALLING SEQUENCE:   InputLayer, Layer [,_EXTRA=_extra]
;
; INPUTS:             Layer : eine mit  <A HREF="#INITLAYER">InitLayer</A> erzeugte Struktur
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
;  Revision 2.7  2000/09/28 13:05:26  thiel
;      Added types '9' and 'lif', also added AIMs.
;
;  Revision 2.6  2000/06/19 13:43:12  saam
;       + REV 2.5 insertion of CheckMath was IDL3.6 incompatible
;         ... fixed that
;
;  Revision 2.5  2000/03/17 13:24:38  kupper
;  Now checks and ignores floating underflows.
;  (This means floating underflows will not be reported any more when !EXCEPT=1,
;  which is the default. Set !EXCEPT=2 to report floating underflow errors.)
;
;  Note: In versions of IDL up to and including IDL 4.0.1, the default exception
;  handling was functionally identical to setting !EXCEPT=2.
;
;  Revision 2.4  1998/11/08 17:27:17  saam
;        the layer-structure is now a handle
;
;  Revision 2.3  1998/11/06 14:28:18  thiel
;         Hyperlinks.
;
;  Revision 2.1  1998/11/04 16:32:19  thiel
;         Rahmenprozedur fuer InputLayer_i-Prozeduren.
;
;
;-

PRO InputLayer, _Layer, _EXTRA=_extra

   Handle_Value, _LAYER, LAYER, /NO_COPY
   type = LAYER.TYPE
   Handle_Value, _LAYER, LAYER, /NO_COPY, /SET

   Call_Procedure, 'InputLayer_'+type, _Layer, _EXTRA=_extra

   ;; Ignore any floating underflows:
   IF IdlVersion() GT 3 THEN dummy = Check_Math(Mask=32)

END








