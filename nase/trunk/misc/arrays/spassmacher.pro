;+
; NAME: Spassmacher
;
; PURPOSE: Konvertiert ein Float-Array in eine Liste mit folgendem
;          Format:
;             sparse(0,0) : Zahl der Elemente ungleich Null in Sparse
;             sparse(1,0) : Gesamtzahl der Elemente in Vector
;             sparse(0,i) mit Sparse(0,0) => i > 0 :
;                              Index der der aktiven Elemente
;             sparse(1,i) mit Sparse(0,0) => i > 0 :
;                              zu Sparse(0,i) gehoerenden Werte
;                  
;          Vorteile: + geringer Speicherbedarf fuer wenige aktive Elemente
;                   ++ viele Routine behandeln nur aktive Elemente und 
;                      muessen bei Vektorinput diese immer erst heraussuchen, 
;                      dies ist hier nicht mehr notwendig
;          Nachteil: - grosser Speicherbedarf fuer viele aktive Elemente
;
; CATEGORY: MISCELLANEOUS / ARRAY OPERATIONS
;
; CALLING SEQUENCE: sparse = Spassmacher(array [,/DIMENSIONS] [,/SAMETYPE])
;
; INPUTS: array : ein Zahlen-Array
;
; OUTPUTS: sparse : ein zweidimensionales Array.
;                    Der Type des Arrays wird entweder vom Typ des 
;                    Eingabearrays bestimmt, oder er ist immer Float.
;                           
; KEYWORD PARAMETERS: 
;    DIMENSIONS: Dieses Keyword speichert die Information über die 
;                ursprünglichen Dimensionen von vector am Ende des 
;                Sparse-Arrays. Diese können dann zur Rekonstruktion des
;                Originalarrays verwendet werden.
;                   sparse(0,sparse(0,0)+1) : Zahl der Dimensionen
;                   sparse(0,sparse(0,0)+1+i) : ite Dimension
;                   sparse(1,sparse(0,0)+i) : unbenutzt (aber nicht Null, da
;                                              Sparse-Arrays mit /NOZERO
;                                              erzeugt werden.)
;                Außerdem ist der Typ des erzeugten Sparse-Arrays immer
;                gleich dem Typ des Eingabearrays. Siehe auch /SAMETYPE.
;
;    SAMETYPE: Ist SAMETYPE gesetzt, so wird der Type des Sparse-Arrays durch
;              den des Eingabearrays bestimmt. Ansonsten gibt Spassmacher
;              immer ein Float-Array zurück. (Das ist bis jetzt aus 
;              Kompatibilitätsgründen noch die Defaulteinstellung.)
;
; EXAMPLE:  IDL> a=findgen(2,2)
;           IDL> print, spassmacher(a)
;                 3.00000      4.00000
;                 1.00000      1.00000
;                 2.00000      2.00000
;                 3.00000      3.00000
;           IDL> print, spassmacher(a, /DIM)
;                 3.00000      4.00000
;                 1.00000      1.00000
;                 2.00000      2.00000
;                 3.00000      3.00000
;  Dimensionen -> 2.00000      4.12734 <- Fnord
;      1. Dim. -> 2.00000      4.00000
;      2. Dim. -> 2.00000      13.1451
;
;
; SEE ALSO: <A HREF="#SPASSBEISEITE">SpassBeiseite</A>.
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 1.1  1999/12/03 16:21:28  thiel
;            Moved from simu/layers and added dimension support.
;
; 
;       Thu Sep 11 17:16:46 1997, Mirko Saam
;       <saam@ax1317.Physik.Uni-Marburg.DE>
;
;		Schoepfung und ausgiebiger Test, Version 1.1.2.2
;
;-

FUNCTION Spassmacher, a, DIMENSIONS=dimensions, SAMETYPE=sametype

   Default, dimensions, 0
   Default, sametype, 0

   s = Size(a)
   d = s(0) ; the number of dimensions of a

   actindex = WHERE(a NE 0., count)

   IF Keyword_Set(DIMENSIONS) THEN BEGIN
      ; make longer array with space for size information at the end
      sparse = Make_Array(2, count+d+2, TYPE=s(d+1), /NOZERO)
      ; store size info at end of sparse array
      sparse(0,count+1:count+d+1) = s(0:d)
   ENDIF ELSE BEGIN
      ; sparse array that inherits input's type
      IF Keyword_Set(SAMETYPE) THEN $
       sparse = Make_Array(2, count+1, TYPE=s(d+1), /NOZERO) $
      ELSE BEGIN
      ; conventional sparse array
         sparse = Make_Array(2, count+1, /FLOAT, /NOZERO)
         Message, /INFO, 'Why not try the new SAMETYPE option???'
      ENDELSE
   ENDELSE

   sparse(0,0) = count ; active elements
   sparse(1,0) = s(d+2) ; get total number of elements from Size

   IF count NE 0 THEN BEGIN
      sparse(0,1:count) = actindex
      sparse(1,1:count) = a(actindex)
   END
  
   RETURN, sparse


END
