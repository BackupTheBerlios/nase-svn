;+
; NAME: PlotTV
;
; PURPOSE: TV-Darstellung eines Arrays zusammen mit einem
;          Koordinatensystem, Achsenbeschriftung und Legende
;          Bis auf die Skalierung der Grauwert-Intensitaeten
;          gleiche Funktionalitaet wie <A HREF="#PLOTTVSCL#">PlotTVScl</A>.
;
; CATEGORY: GRAPHICS / GENERAL
;
; PROCEDURE: Aufruf von PlotTVScl mit Schluesselwort /NOSCALE
;
; SEE ALSO: <A HREF="#PLOTTVSCL">PlotTVScl</A>
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 2.1  1997/12/17 15:19:27  thiel
;            PlotTV entsteht als Gegenstueck zu PlotTVScl.
;
;
;-


PRO PlotTV, Image, XNorm, YNorm, _EXTRA=e

   CASE N_Params() OF
      0: Message, 'incorrect number of arguments'
      1: PlotTvScl, /NOSCALE, Image, _EXTRA=e
      2: PlotTvScl, /NOSCALE, Image, XNorm, _EXTRA=e
      3: PlotTvScl, /NOSCALE, Image, XNorm, YNorm, _EXTRA=e
      ELSE: Message, 'too many arguments'
   END
END


