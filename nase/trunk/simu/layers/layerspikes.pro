;+
; NAME:
;  LayerSpikes()
;
; AIM:
;  Return current state of spiking activity in given layer.
;
; PURPOSE:            Ermittelt den Spike-Zustand einer Layer.
;
; CATEGORY:           SIMULATION LAYERS
;
; CALLING SEQUENCE:   S = LayerSpikes(L [,/DIMENSIONS])
;
; INPUTS:             L : eine mit <A HREF="#INITLAYER">InitLayer</A> initialisierte Layer
;
; KEYWORD PARAMETERS: DIMENSION: falls gesetzt wird das Array in den Dimensionen des Layers
;                                zurueckgegeben 
;
; OUTPUTS:            S : ein ein- oder zweidimensionales Array (siehe Keyword DIMENSIONS), dessen
;                         Elemente 1 fuer Spike und 0 fuer keinen Spike enthalten.
;                       
; EXAMPLE:
;                     LP = InitPara_1()
;                     L = InitLayer(WIDTH=5,HEIGHT=10,TYPE=LP)
;                     S = LayerSpikes(L)
;                     help, S
;                     ;S               FLOAT     = Array(50)                                              
;                     S = LayerSpikes(L, /DIMENSIONS)
;                     help, S
;                     ;S               FLOAT     = Array(10,5)
;                                              
; SEE ALSO:           <A HREF="#LAYEROUT">LayerOut</A>
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 2.2  2000/09/28 13:05:26  thiel
;         Added types '9' and 'lif', also added AIMs.
;
;     Revision 2.1  1998/11/08 17:43:43  saam
;           the replacement for Out2Vector
;
;
;-
FUNCTION LayerSpikes, _L, DIMENSIONS=DIMENSIONS

   Handle_Value, _L, L, /NO_COPY
   O = SSpassBeiseite(Handle_Val(L.O))
   IF Keyword_Set(DIMENSIONS) THEN o = REFORM(O, L.h, L.w, /OVERWRITE)
   Handle_Value, _L, L, /NO_COPY, /SET

   RETURN, O

END
