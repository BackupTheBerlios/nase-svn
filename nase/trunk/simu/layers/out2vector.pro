;+
; NAME:                 Out2Vector
;
; PURPOSE:              Proceed_Layer? gibt ein Handle auf die aktiven Neuronen zurueck.
;                       Mit Hilfe von Out2Vector kann der tatsaechliche Ausgabevektor
;                       ermittelt werden.
;
; CATEGORY:             SIMU
;
; CALLING SEQUENCE:     Vector = Out2Vector(OutHandle)
;
; INPUTS:               OutHandle: ein Handle auf eine sparse Liste, z.B. Layer.O bzw.
;                                  eine Layer-Struktur wenn Keyword DIMENSIONS angegeben
;                                  wurde
;
; KEYWORD PARAMETERS:   DIMENSIONS: als Input verarbeitet die Funktion nun eine Layerstruktur
;                                   und gibt die aktiven Neurone in den Dimensionen des Layers
;                                   zurueck
;
; OUTPUTS:              Vector: das resultierende eindimensionale BytArray aktiver Neurone
;                               bzw. das zweidimensionale von das Keyword DIMENSIONS gesetzt
;                               ist
;
; EXAMPLE:              
;                       LayerProceed, L1
;                       L1Out = Out2Vector(L1.O)
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 2.4  1998/01/29 14:04:35  kupper
;            Dimensionen werden jetzt RICHTIGherum wiederhergestellt...
;
;     Revision 2.3  1997/11/24 10:08:44  saam
;           Keyword DIMENSIONS hinzugefuegt, nicht getestet!!
;
;     Revision 2.2  1997/09/19 16:35:24  thiel
;            Umfangreiche Umbenennung: von spass2vector nach SpassBeiseite
;                                      von vector2spass nach Spassmacher
;
;     Revision 2.1  1997/09/17 10:25:53  saam
;     Listen&Listen in den Trunk gemerged
;
;
;-
FUNCTION Out2Vector, OutHandle, DIMENSIONS=dimensions

   IF NOT Keyword_Set(DIMENSIONS) THEN BEGIN
      RETURN, SSpassBeiseite(Handle_Val(OutHandle))
   END ELSE BEGIN
      RETURN, REFORM(SSpassBeiseite(Handle_Val(OutHandle.O)), OutHandle.h, OutHandle.w)
   END
END
