;+
; NAME: SpassBeiseite
;
; PURPOSE: Konvertiert die mit Spassmacher erzeugte Liste wieder zurueck in 
;          ein Array.
;          Format des Sparse-Arrays:
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
; CALLING SEQUENCE: vector = SpassBeiseite( sparse )
;
; INPUTS: sparse : ein zweidimensionales Sparse-Array
;
; OUTPUT: vector : ein Float-Array
;
; EXAMPLE: --- Ohne Speichern der Dimension:
;  IDL> a=indgen(3,2)
;  IDL> print, a
;         0       1       2
;         3       4       5
;  IDL> b=spassmacher(a, /SAME)
;  IDL> print, b
;         5       6
;         1       1
;         2       2
;         3       3
;         4       4
;         5       5
;  IDL> c=spassbeiseite(b, /SAME)
;  IDL> print, c
;         0       1       2       3       4       5 
;
; ----- Mit Dimension:
;  IDL> b=spassmacher(a, /SAME, /DIM)
;  IDL> c=spassbeiseite(b, /SAME, /DIM)
;  IDL> print, c
;         0       1       2
;         3       4       5  
;
;
; SEE ALSO: <A HREF="#SPASSMACHER">Spassmacher</A>.
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
;		Schoepfung und ausgiebiger Test, Version 1.1.2.1
;
;-

FUNCTION SpassBeiseite, sparse, DIMENSIONS=dimensions, SAMETYPE=sametype

   Default, dimensions, 0
   Default, sametype, 0

   s = Size(sparse)
   diminfoi = sparse(0,0)+1 ; index of array where dimension info starts
  
   IF Keyword_Set(DIMENSIONS) THEN BEGIN
      ; if there's only one dimension (empty sparse array) or there are
      ; as many entries in sparse(0,0) than in the whole array, then there
      ; can't be any dimension-information:
      IF (s(0) EQ 1) OR (s(s(0)) EQ diminfoi) THEN $
       Message, 'No dimension information present.' $
      ELSE BEGIN
         ; generate array by specifying Size-information:
         ; first part of Size-array is stored at the end of sparse,
         ; type is inherited from sparse, overall elements are in sparse(1,0)
         a = Make_Array(SIZE= $
          [Reform(sparse(0,diminfoi:diminfoi+sparse(0,diminfoi)),/OVERWRITE), $
           s(s(0)+1), sparse(1,0)])
      ENDELSE
   ENDIF ELSE BEGIN
      ; array that inherits sparse's type but has no dimensions
      IF Keyword_Set(SAMETYPE) THEN $
       a = Make_Array(sparse(1,0), TYPE=s(3)) $
      ELSE BEGIN
      ; conventional:
         a = Make_Array(sparse(1,0), /FLOAT)
         Message, /INFO, 'Why not try the new SAMETYPE option???'
      ENDELSE
   ENDELSE

   ; put values in array:
   IF sparse(0,0) NE 0 THEN $
    a(sparse(0,1:diminfoi-1)) = sparse(1,1:diminfoi-1)
   
   RETURN, a

END
