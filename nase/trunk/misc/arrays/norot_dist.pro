;+
; NAME: NoRot_Dist
;
; PURPOSE: Belegen eines Arrays mit dem euklidischen Abstand des jeweiligen
;          Eintrags von einem zentralen Punkt des Arrays ohne zyklische 
;          Randbedingungen. 
;
; CATEGORY: MISCELLANEOUS / ARRAY OPERATIONS
;
; CALLING SEQUENCE: array = NoRot_Dist(n [,m] [,CENTERCOL=spalte] [,CENTERROW=zeile]
;
; INPUTS: n: Zahl der Spalten des resultierenden Arrays
;
; OPTIONAL INPUTS: m: Zahl der Zeilen des resultierenden Arrays.
;                     Wird m nicht angegeben, so ist das Ergebnis
;                     Ein Array der Groesse n x n.
;                  spalte: Die Spalte des Ortes, von dem aus die Entfernung
;                          gemessen wird. Default: 0
;                  zeile: Die Zeile des Ortes, von dem aus die Entfernung
;                         gemessen wird. Default: 0
;                  Uebrigens: zeile und spalte koennen auch ausserhalb
;                             der Arraygrenzen liegen.
;
; OUTPUTS: array: Das entsprechende Array, uebrigens vom Typ float.
;
; PROCEDURE: Entstanden aus IDL-Routine 'Dist', erweitert um die Moeglich-
;            keit, den Mittelpunkt anzugeben, die zyklischen Randbedingungen
;            wurden entfernt.
;
; EXAMPLE: print, norot_dist(5, centerrow=1, centercol=1)
;          
;          ergibt:
;
;          1.41421      1.00000      1.41421      2.23607      3.16228
;          1.00000      0.00000      1.00000      2.00000      3.00000
;          1.41421      1.00000      1.41421      2.23607      3.16228
;          2.23607      2.00000      2.23607      2.82843      3.60555
;          3.16228      3.00000      3.16228      3.60555      4.24264
;
; SEE ALSO: Original-IDL-Routine DIST, <A HREF="#NOROT_SHIFT">NoRot_Shift</A>
;           
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 1.1  1998/05/12 09:29:44  thiel
;               Neue Routine als Ergaenzung zu DIST.
;
;-


FUNCTION NoRot_Dist, n, m, CENTERCOL=centercol, CENTERROW=centerrow

   Default, centercol, 0
   Default, centerrow, 0

   x=findgen(n)-centercol       ;Make a row
   x = x ^ 2                    ;column squares

   IF n_elements(m) LE 0 THEN m = n
   
   a = FLTARR(n,m,/NOZERO)      ;Make array

   FOR i=0L, m-1 DO BEGIN       ;Row loop
      y = sqrt(x + (i-centerrow)^2) ;Euclidian distance
      a(0,i) = y                ;Insert the row
   ENDFOR

   Return, a

END

