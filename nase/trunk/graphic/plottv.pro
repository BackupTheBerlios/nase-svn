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
;     Revision 2.2  1997/12/19 16:04:13  thiel
;            Auch PlotTV liefert jetzt Informationen zurueck.
;
;     Revision 2.1  1997/12/17 15:19:27  thiel
;            PlotTV entsteht als Gegenstueck zu PlotTVScl.
;
;
;-


PRO PlotTV, Image, XNorm, YNorm, $
               GET_Position=Get_Position, $
               GET_COLOR=Get_Color, $
               GET_XTICKS=Get_XTicks, $
               GET_YTICKS=Get_YTicks, $
               GET_PIXELSIZE=Get_PixelSize, $
               _EXTRA=e

   CASE N_Params() OF
      0: Message, 'incorrect number of arguments'
      1: PlotTvScl, /NOSCALE, Image, GET_Position=Get_Position, GET_COLOR=Get_Color, GET_XTICKS=Get_XTicks, GET_YTICKS=Get_YTicks, GET_PIXELSIZE=Get_PixelSize, _EXTRA=e
      2: PlotTvScl, /NOSCALE, Image, XNorm, GET_Position=Get_Position, GET_COLOR=Get_Color, GET_XTICKS=Get_XTicks, GET_YTICKS=Get_YTicks, GET_PIXELSIZE=Get_PixelSize, _EXTRA=e
      3: PlotTvScl, /NOSCALE, Image, XNorm, YNorm, GET_Position=Get_Position, GET_COLOR=Get_Color, GET_XTICKS=Get_XTicks, GET_YTICKS=Get_YTicks, GET_PIXELSIZE=Get_PixelSize, _EXTRA=e
      ELSE: Message, 'too many arguments'
   END
END


