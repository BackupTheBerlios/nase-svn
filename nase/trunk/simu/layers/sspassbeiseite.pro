;+
; NAME:              SSpassBeiseite
;
; PURPOSE:           Konvertiert ein mit SSpassmacher erzeugte Liste, wieder in einen Vector.
;                    Das Format der Liste:
;                             SSparse(0) : Zahl der Elemente ungleich Null in Sparse
;                             SSparse(1) : Zahl der Elemente in Vector (fuer Sparse2Vector)
;                             SSparse(i) mit Sparse(0,0)+1 => i > 1 :
;                                           Index der der aktiven Elemente
;                  
;                    Vorteile: + geringer Speicherbedarf fuer wenige aktive Elemente
;                             ++ viele Routine behandeln nur aktive Elemente und muessen bei
;                                Vektorinput diese immer erst heraussuchen, dies ist hier 
;                                nicht mehr notwendig
;                    Nachteil: - grosser Speicherbedarf fuer viele aktive Elemente
;
; CATEGORY:          MISC
;
; CALLING SEQUENCE:  vector = SSpassBeiseite( ssparse )
;
; INPUTS:            ssparse : ein eindimensionales Long-Array
;
; OUTPUTS:           vector : ein Array mit Nullen und Einsen belegt
;
; RESTRICTIONS:      Ist vector mehrdimensional enthaelt ssparse die eindimensionalen Indizes
;
; EXAMPLE:
;                    vector = BytArr( 1+20*RandomU(seed) )
;                    vector( FIX( 20*RandomU(seed, 5) ) ) = 1
;                    ssparse = SSpassmacher(vector)
;                    vectorFromSSparse = SSpassBeiseite(ssparse)
; 
;                    IF TOTAL(vector NE vectorFromSparse) EQ 0 THEN Print, 'Success!' $
;                                                              ELSE Print, 'Shit!!!!'
;
; MODIFICATION HISTORY:
;
;       $Log$
;       Revision 2.1  1997/09/19 16:35:32  thiel
;              Umfangreiche Umbenennung: von spass2vector nach SpassBeiseite
;                                        von vector2spass nach Spassmacher
;
;       Revision 2.1  1997/09/17 10:25:57  saam
;       Listen&Listen in den Trunk gemerged
;
;       Revision 1.1.2.4  1997/09/15 10:31:23  saam
;            Bugs korrigiert
;
;
;       Thu Sep 11 17:16:46 1997, Mirko Saam
;       <saam@ax1317.Physik.Uni-Marburg.DE>
;
;		Schoepfung und ausgiebiger Test, Version 1.1.2.1
;
;-
FUNCTION SSpassBeiseite, ssparse

   vector = FltArr(ssparse(1))
   
   IF ssparse(0) GT 0 THEN vector( ssparse(2:ssparse(0,0)+1) ) = 1.0
   
   RETURN, vector

END
