;+
; NAME:              LayerMUA
;
; PURPOSE:           Ermittelt das MUA (multiple unit activity) einer Layer. Bei diesem 
;                    Signal handelt es sich HIER einfach um die Summe aller Spikes. Das
;                    kann man natuerlich anders ermitteln z.B. ueber TOTAL(LayerSpikes(L)),
;                    doch ist diese Routine hier wesentlich fixer!!
;                    
; CATEGORY:          SIMULATION LAYERS
;
; CALLING SEQUENCE:  MUA = LayerMUA(L)
;
; INPUTS:            L  : eine mit <A HREF="#INITLAYER">InitLayer</A> initialisierte Layer
;
; OUTPUTS:           MUA: das MUA-Signal als LONG       
;
; EXAMPLE:
;                    LP=InitPara_1()
;                    L=InitLayer(WIDTH=5, HEIGHT=10, TYPE=LP)
;                    print, LAYERMUA(L)
;
; PROCEDURE:         uses LayerOut to get SSpass-List from layer and dereferences first element
; 
; SEE ALSO:          <A HREF="#LAYERSPIKES">LayerSpikes</A>, <A HREF="#LAYERDATA">LayerData</A>
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 2.1  1998/11/08 17:44:20  saam
;           new & quick
;
;
;-
FUNCTION LayerMUA, _L

   RETURN, LONG((Handle_Val(LayerOut(_L)))(0))

END
