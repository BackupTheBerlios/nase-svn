;+
; NAME: ShowNoMercy
;
;
; PURPOSE: Elimination von Verbindungen mit kleinen Gewichten
;          Klein bedeutet hier: abs(Gewicht) ist klein.
;
; CATEGORY: SIMULATION
;
; CALLING SEQUENCE: DWMatrix = ShowNoMercy (DWMatrix, LESSTHAN=Abschneidewert)
;
; INPUTS: DWMatrix : Eine mit InitDW geschaffene Struktur
;
; OPTIONAL INPUTS: ---
;	
; KEYWORD PARAMETERS: Abschneidewert: Legt fest, wie klein die Gewichte
;                               werden duerfen, bevor sie auf !NONE gesetzt werden.
;
; OUTPUTS: Die geaenderte Delay-Weigh-Struktur
;
; OPTIONAL OUTPUTS: ---
;
; COMMON BLOCKS: ---
;
; SIDE EFFECTS: Die Funktion veraendert die uebergebene
;               Delay-Weigh-Struktur, gibt sie aber zusaetzlich als
;               Funktionsergebnis zureuck.
;
; RESTRICTIONS:---
;
; PROCEDURE: Set
;
; EXAMPLE: W90_90 = ShowNoMercy(W90_90, LessThan=0.01)
;          Setzt die Gewichte in der Delay-Weigh-Struktur W90_90, die
;          absolut genommen kleiner als 0.01 sind, auf !NONE
;
; MODIFICATION HISTORY:
;
;       Tue Aug 26 12:25:21 1997, Andreas Thiel
;		abs() eingebaut.
;
;       Thu Aug 21 16:33:56 1997, Andreas Thiel
;		Funktion umbenannt.
;
;       Wed Aug 20 14:38:59 1997, Andreas Thiel
;		Erste Version erstellt.
;
;-


FUNCTION ShowNoMercy, Matrix, LESSTHAN=LessThan


If Not Set(LESSTHAN) Then Return, Matrix

die = where((abs(Matrix.weights) LT LessThan), count)

If count NE 0 Then Matrix.weights(die) = !none


RETURN, Matrix

END
