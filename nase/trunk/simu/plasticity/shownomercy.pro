;+
; NAME: ShowNoMercy
;
;
; PURPOSE: Elimination von Verbindungen mit kleinen Gewichten
;          Klein bedeutet hier: abs(Gewicht) ist klein.
;
; CATEGORY: SIMULATION
;
; CALLING SEQUENCE: ShowNoMercy, DWMatrix, LESSTHAN=Abschneidewert
;
; INPUTS: DWMatrix : Eine mit InitDW geschaffene Struktur
;
; OPTIONAL INPUTS: ---
;	
; KEYWORD PARAMETERS: Abschneidewert: Legt fest, wie klein die Gewichte
;                               werden duerfen, bevor sie auf !NONE gesetzt werden.
;
; OUTPUTS: ---
;
; OPTIONAL OUTPUTS: ---
;
; COMMON BLOCKS: ---
;
; SIDE EFFECTS: Die Funktion veraendert die uebergebene
;               Delay-Weigh-Struktur.
;
; RESTRICTIONS:---
;
; PROCEDURE: Set
;
; EXAMPLE: ShowNoMercy, W90_90, LessThan=0.01
;          Setzt die Gewichte in der Delay-Weigh-Struktur W90_90, die
;          absolut genommen kleiner als 0.01 sind, auf !NONE
;
; MODIFICATION HISTORY:
;
;       Wed Sep 3 15:57:59 1997, Ruediger Kupper
;       <kupper@sisko.physik.uni-marburg.de>
;
;		Ab Rev. 1.5 ist diese Funktion eine Prozedur.
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


Pro ShowNoMercy, Matrix, LESSTHAN=LessThan


If Not Set(LESSTHAN) Then Return, Matrix

die = where((abs(Matrix.weights) LT LessThan), count)

If count NE 0 Then Matrix.weights(die) = !none


END
