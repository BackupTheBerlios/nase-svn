;+
; NAME: KeineGebrochenenTicks
;
;
; PURPOSE: Hilfsfunktion, die zur Unterdrueckung von 
;          gebrochenen Tickmarks bei Achsenbeschriftungen
;          verwendet werden kann. Dies ist zum Beispiel bei 
;          der Beschriftung von Achsen mit Neuronennummern
;          sinnvoll. 
;
; CATEGORY: GRAPHICS / GENERAL
;
; CALLING SEQUENCE: Plot, ... , XTICKFORMAT='KeineGebrochenenTicks', ...
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
;             Plot, (indgen(3)-1), xtickformat='KeineGebrochenenTicks', $
;                                  ytickformat='KeineGebrochenenTicks'
;          mit
;             Plot, (indgen(3)-1)
;
; SEE ALSO: IDL Online Help: Graphics Keywords, continued - [XYZ]TICKFORMAT keyword 
;                            (Dort findet sich auch ein weiteres nettes Beispiel.)
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 2.1  1998/01/29 15:54:21  saam
;              created by modification of keineNegativenundGebrochenenTicks
;
;
;-

FUNCTION KeineGebrochenenTicks, axis, index, value
   IF ((Value - Fix(Value)) NE 0) THEN BEGIN
      Return, '' 
      ENDIF ELSE BEGIN
         Return, String(Value, Format='(I)')
         ENDELSE 
END
