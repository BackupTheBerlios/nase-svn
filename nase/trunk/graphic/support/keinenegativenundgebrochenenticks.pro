;+
; NAME: KeineNegativenUndGebrochenenTicks
;
;
; PURPOSE: Hilfsfunktion, die zur Unterdrueckung von negativen
;          und gebrochenen Tickmarks bei Achsenbeschriftungen
;          verwendet werden kann. Dies ist zum Beispiel bei 
;          der Beschriftung von Achsen mit Neuronennummern
;          sinnvoll. 
;
; CATEGORY: GRAPHICS / GENERAL
;
; CALLING SEQUENCE: Plot, ... , XTICKFORMAT='KeineNegativenUndGebrochenenTicks', ...
;                   (Funktioniert natuerlich auch mit AXIS, CONTOUR, SHADE_SURF, SURFACE)  
;
; INPUTS: Axis :  Die Nummer der Achse (0 = X-, 1 = Y- und 2 = Z-Achse)
;         Index : Der Tickmark-Index, beginnend bei 0
;         Value : Der Wert, der normalerweise als Tickmark dienen wuerde.
;
; OUTPUTS: Ein leerer String, falls Value negativ ist oder zwischen 0 und 1 liegt
;          Ansonsten die Integerdarstellung von 'Value'
;
; PROCEDURE: Gucken, welchen Wert das Plot eigentlich an die Achse schreiben will
;            und einen Leerstring zurueckgeben, falls der geplante Wert nicht
;            ganzzahlig und positiv ist.
;
; EXAMPLE: Vergleiche:
;             Plot, (indgen(3)-1), xtickformat='KeineNegativenUndGebrochenenTicks', $
;                                  ytickformat='KeineNegativenUndGebrochenenTicks'
;          mit
;             Plot, (indgen(3)-1)
;
; SEE ALSO: IDL Online Help: Graphics Keywords, continued - [XYZ]TICKFORMAT keyword 
;                            (Dort findet sich auch ein weiteres nettes Beispiel.)
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 2.2  1997/12/10 17:45:24  thiel
;               Dokumentation verfasst.
;
;        Revision 2.1  1997/12/10 16:37:03  thiel
;               Ausgelagert aus 'PlotTVScl'.
;
;-


FUNCTION KeineNegativenUndGebrochenenTicks, axis, index, value
   IF (Value LT 0) OR ((Value - Fix(Value)) NE 0) THEN BEGIN
      Return, '' 
      ENDIF ELSE BEGIN
         Return, String(Value, Format='(I)')
         ENDELSE 
END
