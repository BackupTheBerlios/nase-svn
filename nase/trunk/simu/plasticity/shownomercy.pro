;+
; NAME: ShowNoMercy
;
;
; PURPOSE: Elimination von Verbindungen mit kleinen Gewichten
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
; RESTRICTIONS: Die Funktion geht davon aus, dass nur positive Gewichte
;               verwendet werden.
;
; PROCEDURE: Set
;
; EXAMPLE: W90_90 = ShowNoMercy(W90_90, LessThan=0.01)
;          Setzt die Gewichte in der Delay-Weigh-Struktur W90_90, die
;          kleiner als 0.01 sind, auf !NONE
;
; MODIFICATION HISTORY:
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

die = where((Matrix.weights LT LessThan) AND (Matrix.weights NE !NONE), count)

If count NE 0 Then Matrix.weights(die) = !none


RETURN, Matrix

END
