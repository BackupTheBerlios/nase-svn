;+
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 2.5  1998/11/08 17:34:46  saam
;           obsolete and replaced by layerspikes and layerout respectively
;
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
;-
FUNCTION Out2Vector, OutHandle, _EXTRA=e

   Message, /INFORMATIONAL, "OUT2VECTOR wurde durch LayerSpikes ersetzt. Bitte Aufruf korrigieren!"
   LayerSpikes, OutHandle, _EXTRA=e

END
