;+
; NAME:                LayerOut
;
; PURPOSE:             Ermittelt einen Handle auf die Spikeliste eines Layer zur Weiterverwendung
;                      mit DelayWeigh.
;
; CATEGORY:            SIMULATION LAYERS
;
; CALLING SEQUENCE:    sl = LayerOut(L)
;
; INPUTS:              L : eine mit <A HREF="#INITLAYER">InitLayer</A> initialisierte Layer
; 
; OUTPUTS:             sl: Handle auf SSpassListe der aktiven Neurone
;
; EXAMPLE:
;                      R = DelayWeigh(CON_L_L, LayerOut(L))
;
; SEE ALSO:            <A HREF="#LAYERSPIKES">LayerSpikes</A>, <A HREF="#SSPASSMACHER">SSpassmacher</A>
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 2.1  1998/11/08 17:43:42  saam
;           the replacement for Out2Vector
;
;
;-
FUNCTION LayerOut, _L

   Handle_Value, _L, L, /NO_COPY
   o = L.O
   Handle_Value, _L, L, /NO_COPY, /SET

   RETURN, O 

END
