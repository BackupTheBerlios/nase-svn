;+
; NAME: AbsoluteTicks
;
; AIM:
;  Suppress signs of plot labels (show absolute values).
;
; PURPOSE: Hilfsfunktion, die zur Unterdrueckung des Vorzeichens
;          bei Achsenbeschriftungen verwendet werden kann. Dies 
;          ist zum Beispiel bei der Achsenbeschriftung von Polar-
;          diagrammen sinnvoll. 
;
; CATEGORY: GRAPHICS / GENERAL
;
; CALLING SEQUENCE: Plot, ... , XTICKFORMAT='AbsolueTicks', ...
;                   (Funktioniert natuerlich auch mit AXIS, CONTOUR, SHADE_SURF, SURFACE)  
;
; INPUTS: Axis :  Die Nummer der Achse (0 = X-, 1 = Y- und 2 = Z-Achse)
;         Index : Der Tickmark-Index, beginnend bei 0
;         Value : Der Wert, der normalerweise als Tickmark dienen wuerde.
;
; OUTPUTS: Der Absolutwert von Value.
;
; PROCEDURE: Gucken, welchen Wert das Plot eigentlich an die Achse schreiben will
;            und den Absolutwert davon in einen String umwandeln und zurueckgeben.
;
; EXAMPLE: Vergleiche:
;             Plot, (indgen(3)-1), ytickformat='AbsoluteTicks'
;          mit
;             Plot, (indgen(3)-1)
;
; SEE ALSO: IDL Online Help: Graphics Keywords, continued - [XYZ]TICKFORMAT keyword 
;                            (Dort findet sich auch ein weiteres nettes Beispiel.)
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 2.3  2000/10/01 14:51:44  kupper
;        Added AIM: entries in document header. First NASE workshop rules!
;
;        Revision 2.2  1998/01/22 14:24:22  thiel
;               Der Header war kaputt.
;
;        Revision 2.1  1998/01/22 14:21:56  thiel
;               Eine weitere neue Tickformat-Funktion.
;
;
;-


FUNCTION AbsoluteTicks, axis, index, value
   Return, String(Abs(Value), Format='(G0.0)')

END
