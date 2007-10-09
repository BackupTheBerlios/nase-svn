;+
; NAME:
;  Scl
;
; VERSION:
;  $Id$
;
; AIM:
;  Linearly rescale array contents.
;
; PURPOSE: 
;  Lineares Skalieren eines Arrayinhaltes, vergleichbar dem, was die
;  TvScl-Routine macht, doch etwas allgemeiner.<BR>
;  <BR>
;  The linear transformation is defined via the transformation
;  of two example points:
;*
;*                             P1'             P2'
;*   output space  ------------o---------------o-------------->    /|\
;*                             |             _/                     |
;*                             \           _/                 transformation
;*                              |         /                         |
;*   input space   -------------o--------o-------------------->     |
;*                              P1       P2
;*
; CATEGORY:
;  Array
;  Image
;  Math
;
; CALLING SEQUENCE:
;  This routine can be a procedure (the argument is changed), as
;  well as a function (the argument stays unchanged, and the result is
;  returned.)<BR>
;  <BR>
;  The <C>Scl()</C> function:
;*new = Scl ( old [,range [,range_in]] )
;  The <C>Scl</C> procedure:
;*Scl, old [,range [,range_in]]
;
; INPUTS:
;  old:: The array to rescale. The array must contain numeric
;        values. If the array is if type FLOAT, computation is performed
;        with FLOAT precision. Otherwise, computation is performed
;        in DOUBLE precision.
;
; OPTIONAL INPUTS:
;  range   :: Ein zweielementiges Array der Form [P1',P2']. Wenn der
;             dritte Positionsparameter "Range_In" nicht angegeben
;             wird, entsprechen diese Werten gerade dem Minimum und
;             dem Maximum des Ergebnisarrays.  Default:
;             [0,!D.Table_Size-1], in Anlehnung an das Verahalten von
;             TvScl.
;  
;  range_in:: Ein zweielementiges Array der Form [P1,P2].  Default:
;             [min(Old),max(Old)]<BR>
;  
;  Man beachte, da� der 1. Positionsparameter die Bilder und der
;  2. Positionsparameter die Urbilder der zwei Beispielpunkte enth�lt
;  (nicht umgekehrt).
;
;
; OUTPUTS: 
;  new:: Ein Array mit gleichen Ausma�en und entsprechend skaliertem
;        Inhalt. Das Ergebnis ist vom Typ Double, wenn das
;        Ausgangsarray vom Typ Double war, sonst vom Typ Float.
;
; RESTRICTIONS: 
;  Falls P1 und P2 identisch sind, ist die Skalierung nicht
;  definiert. Dies ist z.B. der Fall f�r Arrays, welche lauter
;  identische Werte enthalten, sofern "Range_In" nicht explizit
;  angegeben wird.  Als R�ckgabewert wird hier das mehr oder weniger
;  sinnvolle Ergebnis eines Float-Arrays geliefert, das den konstanten
;  Wert P1' enth�lt.
;
; PROCEDURE:
;  Elementary mathematical operations are performed on the array
;  contents. If the input array is of type FLOAT, the Range_In and
;  Range parameters are converted to type FLOAT before computation.
;  Otherwise, the Range_In and
;  Range parameters are converted to type DOUBLE before computation.
;  This is to avoid mixed DOUBLE and FLOAT arithmetics, which caused
;  round-off errors in some situations in the past.
;
; EXAMPLE:
;  1. Diese beiden Aufrufe sind identisch:
;
;*     TvScl,   gauss_2d(100,100)
;*     Tv, Scl( gauss_2d(100,100) )
;
;  2. Dieser Aufruf skaliert den Inhalt des Arrays A auf 
;     Werte im geschlossenen Intervall [0,1]:
;  
;*     Scl, A, [0,1]
;  
;  4. Dieser Aufruf rechnet Temperaturwerte von der
;     Farenheit- in die Celsiusskala um:<BR>
;       0�F = -17.8�C (K�ltemischung)<BR>
;     100�F =  37.8�C (K�rpertemperatur. Naja, hitziges Temperament..)
;  
;*     Celsius = Scl( Fahrenheit, [-17.8,37.8], [0,100] )
;  
;     Man beachte, da� die Werte 0 und 100 im
;     Ausgangsarray nicht enthalten sein m�ssen.
;  
;  5. Diese zwei Aufrufe definieren jeweils die
;     identische Abbildung:
;  
;*     Scl, A, [0,1], [0,1]
;*     Scl, A, [min(A),max(A)]
;              
; SEE ALSO:
;  IDL's <C>TvScl</C>, <A>PlotTvScl</A>, <A>PTvS</A>
;-

Function Scl, A, Range_, Range_In_

   Default, Range_,    [0     , !D.Table_Size-1]  
   Default, Range_In_, [min(A), max(A)       ]

   if size(A, /Type) eq 5 then begin
      ;; A is of type DOUBLE
      Range    = DOUBLE(Range_)
      Range_In = DOUBLE(Range_In_)
   endif else begin
      ;; A is of any other type
      Range    = FLOAT(Range_)
      Range_In = FLOAT(Range_In_)
   endelse
     

   If Range_In(0) eq Range_In(1) then begin
      console, /Warning, "Target interval is a single point! Returning " + $
               "flat array of value "+str(Range(0))+"."
      return, Make_Array(/FLOAT, SIZE=size(A), VALUE=Range(0))
   endif else begin
      Return, (A - Range_In(0)) $ $
              * (Range(1)-Range(0)) $
                / (Range_In(1)-Range_In(0)) $
                + Range(0)
   endelse

End

Pro Scl, A, Range, Range_In

   A = Scl( Temporary(A), Range, Range_In )

End
