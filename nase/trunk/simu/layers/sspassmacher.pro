;+
; NAME:              SSpassmacher
;
; PURPOSE:           Konvertiert ein eindimensionales Array, das nur 1'en und 0'en enthaelt 
;                    in eine Liste mit folgendem Format:
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
; CALLING SEQUENCE:  ssparse = SSpassmacher( vector )
;
; INPUTS:            vector : ein Array mit Nullen und Einsen belegt
;
; OUTPUTS:           ssparse : ein eindimensionales Long-Array
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
;       Thu Sep 11 17:16:46 1997, Mirko Saam
;       <saam@ax1317.Physik.Uni-Marburg.DE>
;
;		Schoepfung und ausgiebiger Test, Version 1.1.2.1
;
;-
FUNCTION SSpassmacher, vector

   dim = N_Elements(vector)
   ssparse = LonArr(dim+2)
   
   ssparse(1,0) = dim
   actNeurons = WHERE(vector NE 0, count)

   IF count NE 0 THEN BEGIN
      ssparse(0,0) = count
      ssparse(2:count+1) = actNeurons
   END
  
   RETURN, ssparse(0:count+1)
END
