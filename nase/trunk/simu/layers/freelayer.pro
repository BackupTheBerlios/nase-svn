;+
; NAME:               FreeLayer
;
; PURPOSE:            Gibt eine Neuronenschicht frei. 
;
;                     FreeLayer ist lediglich eine Rahmenfunktion, die
;                     selbst�ndig die f�r den jeweiligen Neuronentyp
;                     spezifische <A HREF="#FREELAYER_1">FreeLayer_i</A>-Funktion aufruft.
;
; CATEGORY:           SIMULATION / LAYERS
;
; CALLING SEQUENCE:   FreeLayer, L
;
; INPUTS:             L: eine mit <A HREF="#INITLAYER">InitLayer</A> initialisierte Layer-Struktur
;
; PROCEDURE:          FreeLayer schaut nach dem Typ der �bergebenen Parameter
;                     (aus dem type.type-String) und ruft mit CALL_PRCEDURE die
;                     jeweilige spezielle FreeLayer_i-Prozedur auf.
;
; EXAMPLE:            para1 = InitPara_1(tauf=10.0, vs=1.0)     
;                     Layer = InitLayer (height=5, width=5, type=para1)
;                     FreeLayer, Layer
;
; MODIFICATION HISTORY: 
;
;       $Log$
;       Revision 2.3  1998/11/06 14:27:41  thiel
;              Hyperlinks.
;
;       Revision 2.2  1998/11/06 14:16:46  thiel
;            Kaputte Hyperlinks.
;
;-

PRO FreeLayer, Layer

	Call_Procedure, 'FreeLayer_'+Layer.type, Layer

END 
