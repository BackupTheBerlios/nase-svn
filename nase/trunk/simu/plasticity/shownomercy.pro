;+
; NAME:
;  ShowNoMercy
;
; AIM:
;  Eliminate connections with strengths less than certain value (pruning).
;
; PURPOSE: Elimination von Verbindungen mit kleinen Gewichten
;          Klein bedeutet hier: abs(Gewicht) ist klein.
;
; CATEGORY:
;  Simulation / Plasticity
;
; CALLING SEQUENCE: ShowNoMercy, DWMatrix, LESSTHAN=Abschneidewert
;
; INPUTS: DWMatrix : Eine mit InitDW geschaffene Struktur
;
; KEYWORD PARAMETERS: Abschneidewert: Legt fest, wie klein die Gewichte
;                               werden duerfen, bevor sie auf !NONE gesetzt werden.
;
; SIDE EFFECTS: Die Funktion veraendert die uebergebene
;               Delay-Weigh-Struktur.
;
; PROCEDURE: Set
;
; EXAMPLE: ShowNoMercy, W90_90, LessThan=0.01
;          Setzt die Gewichte in der Delay-Weigh-Struktur W90_90, die
;          absolut genommen kleiner als 0.01 sind, auf !NONE
;-
;
; MODIFICATION HISTORY:
;
;       $Log$
;       Revision 1.13  2000/10/12 16:15:17  thiel
;           Had to use old version of SetWeights to correctly delete connections.
;
;       Revision 1.12  2000/09/26 15:13:43  thiel
;           AIMS added.
;
;       Revision 1.11  1998/02/05 13:17:42  saam
;                  + Gewichte und Delays als Listen
;                  + keine direkten Zugriffe auf DW-Strukturen
;                  + verbesserte Handle-Handling :->
;                  + vereinfachte Lernroutinen
;                  + einige Tests bestanden
;
;       Revision 1.10  1997/12/10 15:56:49  saam
;             Es werden jetzt keine Strukturen mehr uebergeben, sondern
;             nur noch Tags. Das hat den Vorteil, dass man mehrere
;             DelayWeigh-Strukturen in einem Array speichern kann,
;             was sonst nicht moeglich ist, da die Strukturen anonym sind.
;
;       Revision 1.9  1997/10/26 18:35:10  saam
;              Schleifenindex zu Long konvertiert, da u.U. groesser als INT
;
;       Revision 1.8  1997/09/17 10:35:31  saam
;            Kontrollausgaben rausgeworfen
;
;       Revision 1.7  1997/09/17 10:25:55  saam
;       Listen&Listen in den Trunk gemerged
;
;       Revision 1.6.2.1  1997/09/15 10:32:50  saam
;            Anpassung an die neue Listenstruktur
;
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

PRO ShowNoMercy, DW, LESSTHAN=LessThan


   IF NOT Set(LESSTHAN) THEN Console, 'LESSTHAN has to be set.', /FATAL

   IF NOT Contains(Info(DW), 'DW_') THEN Console, '[S]DW[_DELAY]_WEIGHT structure expected, but got '+Info(_DW)+' !', /FATAL
   
   W = Weights(DW)
   die = where(W LT LessThan, count)
   
   IF count NE 0 THEN BEGIN
      W(die) = !NONE
      SetWeights, DW, W, NO_INIT=0
   END

END
