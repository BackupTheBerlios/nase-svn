;+
; NAME: Scl
;
; PURPOSE: Lineares Skalieren eines Arrayinhaltes, vergleichbar
;          dem, was die TvScl-Routine macht, doch etwas allgemeiner.
;
; CATEGORY: ARRAY, MISCELLANEOUS
;
; CALLING SEQUENCE: Entweder Funktionsform:
;                      New = Scl ( Old [,Range [,Range_In]] )
;
;                   oder Prozedurform:
;                            Scl, Old [,Range [,Range_In]]
;
; INPUTS: Old: Das zu skalierende Array.
;
; PROCEDURE:  Die lineare Abbildung wird über die Abbildung 
;             zweier Beispielpunkte definiert:
;
;                              P1'             P2'
;    Outputraum    ------------o---------------o-------------->    /|\
;                              |             _/                     |
;                              \           _/                   Abbildung
;                               |         /                         |
;    Inputraum     -------------o--------o-------------------->     |
;                               P1       P2
;
;
; OPTIONAL INPUTS: Range   : Ein zweielementiges Array der Form
;                            [P1',P2']. Wenn der dritte
;                            Positionsparameter "Range_In" nicht 
;                            angegeben wird, entsprechen diese
;                            Werten gerade dem Minimum und dem
;                            Maximum des Ergebnisarrays.
;                            Default: [0,!D.Table_Size-1], in
;                            Anlehnung an das Verahalten von
;                            TvScl.
;
;                  Range_In: Ein zweielementiges Array der Form
;                            [P1,P2].
;                            Default: [min(Old),max(Old)]
;
;                  Man beachte, daß der 1. Positionsparameter
;                  die Bilder und der 2. Positionsparameter die
;                  Urbilder der zwei Beispielpunkte enthält
;                  (nicht umgekehrt).
;
; OUTPUTS: New: Ein Array mit gleichen Ausmaßen und entsprechend 
;               skaliertem Inhalt. Das Ergebnis ist vom Typ
;               Double, wenn das Ausgangsarray vom Typ Double
;               war, sonst vom Typ Float.
;
; RESTRICTIONS: Falls P1 und P2 identisch sind, ist die
;               Skalierung nicht definiert. Dies ist z.B. der
;               Fall für Arrays, welche lauter identische Werte
;               enthalten, sofern "Range_In" nicht explizit
;               angegeben wird.
;               Als Rückgabewert wird hier das mehr oder weniger 
;               sinnvolle Ergebnis eines Float-Arrays geliefert, das
;               den konstanten Wert P1' enthält.               
;
; PROCEDURE: Elementare mathematische Operationen auf dem Arrayinhalt.
;
; EXAMPLE: 1. Diese beiden Aufrufe sind identisch:
;
;              TvScl,   gauss_2d(100,100)
;              Tv, Scl( gauss_2d(100,100) )
;
;          2. Dieser Aufruf skaliert den Inhalt des Arrays A auf 
;             Werte im geschlossenen Intervall [0,1]:
;
;              Scl, A, [0,1]
;
;          4. Dieser Aufruf rechnet Temperaturwerte von der
;             Farenheit- in die Celsiusskala um:
;               0°F = -17.8°C (Kältemischung)
;             100°F =  37.8°C (Körpertemperatur. Naja, hitziges Temperament..)
;
;              Celsius = Scl( Fahrenheit, [-17.8,37.8], [0,100] )
;
;             Man beachte, daß die Werte 0 und 100 im
;             Ausgangsarray nicht enthalten sein müssen.
;
;          5. Diese zwei Aufrufe definieren jeweils die
;             identische Abbildung:
;
;              Scl, A, [0,1], [0,1]
;              Scl, A, [min(A),max(A)]
;              
;
; SEE ALSO: <A HREF="../../alien/#SCALEARRAY">ScaleArray()</A>
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 1.6  1999/10/11 12:10:30  kupper
;        Changed return value for homogeneous Arrays to P1', to be
;        compatible to the behaviour of PlotTvScl known until now.
;
;        Added a Temporary().
;
;        Revision 1.5  1999/10/08 12:52:20  kupper
;        Now catches the case (Range_In(0) eq Range_In(1)).
;
;        Revision 1.4  1999/09/22 14:42:24  kupper
;        Grrr. Hyperling again.
;
;        Revision 1.3  1999/09/22 14:36:27  kupper
;        Corrected Hyperling.
;
;        Revision 1.2  1999/09/22 14:33:05  kupper
;        Added Docu.
;
;        Revision 1.1  1999/09/22 13:33:50  kupper
;        Added new procompiling-feature to NASE-startup script.
;        Allowing identically named Procs/Funcs (currently NoNone and Scl).
;
;-

Function Scl, A, Range, Range_In

   Default, Range,    [0     , !D.Table_Size-1]  
   Default, Range_In, [min(A), max(A)       ]

   If Range_In(0) eq Range_In(1) then begin
      return, Make_Array(/FLOAT, SIZE=size(Temporary(A)), VALUE=Range(0))
   endif else begin
      Return, (A - Range_In(0)) $
                * FLOAT(Range(1)-Range(0)) $
                / (Range_In(1)-Range_In(0)) $
                + Range(0)
   endelse

End

Pro Scl, A, Range, Range_In

   A = Scl( Temporary(A), Range, Range_In )

End
