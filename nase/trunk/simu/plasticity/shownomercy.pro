;+
; NAME: ShowNoMercy
;
;
; PURPOSE: Elimination von Verbindungen mit kleinen Gewichten
;          Klein bedeutet hier: abs(Gewicht) ist klein.
;
; CATEGORY: SIMULATION PLASTICITY
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
;
; MODIFICATION HISTORY:
;
;       $Log$
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
;-
PRO ShowNoMercy, _DW, LESSTHAN=LessThan


   IF NOT Set(LESSTHAN) THEN message, 'Also, LESSTHAN müßte schon angegeben werden...'
   
   Handle_Value, _DW, DW, /NO_COPY
   
   die = where((abs(DW.Weights) LT LessThan), count)
   
   IF count NE 0 THEN BEGIN
      DW.Weights(die) = !NONE
      
   ; soc : source neuron of connection 
   ; toc : target neuron of connection
      soc =  die / (DW.target_w*DW.target_h)
      toc =  die MOD (DW.target_w*DW.target_h)
      
      FOR i=0l, LONG(count)-1 DO BEGIN
         wtn = WHERE(DW.Weights(*,soc(i)) NE !NONE, tcount)
         IF tcount NE 0 THEN Handle_Value, DW.STarget(soc(i)), wtn, /SET ELSE BEGIN
            IF DW.STarget(soc(i)) NE -1 THEN BEGIN
               Handle_Free, DW.STarget(soc(i))
               DW.STarget(soc(i)) = -1
            END
         END
         
         stn = WHERE(DW.Weights(toc(i),*) NE !NONE, tcount)
         IF tcount NE 0 THEN Handle_Value, DW.SSource(toc(i)), stn, /SET ELSE BEGIN
            IF DW.SSource(toc(i)) NE -1  THEN BEGIN
               Handle_Free, DW.SSource(toc(i))
               DW.SSource(toc(i)) = -1
            END
         END
      END
   END

   Handle_Value, _DW, DW, /NO_COPY, /SET

END
