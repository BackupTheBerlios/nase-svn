;+
; NAME:              Spassmacher
;
; PURPOSE:           Konvertiert ein eindimensionales Float-Array in eine Liste mit folgendem
;                    Format:
;                             Sparse(0,0) : Zahl der Elemente ungleich Null in Sparse
;                             Sparse(1,0) : Zahl der Elemente in Vector (fuer Sparse2Vector)
;                             Sparse(0,i) mit Sparse(0,0) => i > 0 :
;                                           Index der der aktiven Elemente
;                             Sparse(1,i) mit Sparse(0,0) => i > 0 :
;                                           zu Sparse(0,i) gehoerenden Werte
;                  
;                    Vorteile: + geringer Speicherbedarf fuer wenige aktive Elemente
;                             ++ viele Routine behandeln nur aktive Elemente und muessen bei
;                                Vektorinput diese immer erst heraussuchen, dies ist hier 
;                                nicht mehr notwendig
;                    Nachteil: - grosser Speicherbedarf fuer viele aktive Elemente
;
; CATEGORY:          MISC
;
; CALLING SEQUENCE:  sparse = Spassmacher( vector )
;
; INPUTS:            vector : ein Float-Array
;
; OUTPUTS:           sparse : ein zweidimensionales Float-Array
;
; RESTRICTIONS:      Ist vector mehrdimensional enthaelt sparse die eindimensionalen Indizes
;
; EXAMPLE:
;                    vector = 10*RandomU(seed, 1+20*FIX(RandomU(seed)))
;                    sparse = Spassmacher(vector)
;                    vectorFromSparse = SpassBeiseite(sparse)
; 
;                    IF TOTAL(vector NE vectorFromSparse) EQ 0 THEN Print, 'Success!' $
;                                                              ELSE Print, 'Shit!!!!'
;
; MODIFICATION HISTORY:
;
;       Thu Sep 11 17:16:46 1997, Mirko Saam
;       <saam@ax1317.Physik.Uni-Marburg.DE>
;
;		Schoepfung und ausgiebiger Test, Version 1.1.2.2
;
;-
FUNCTION Spassmacher, vector

   dim = N_Elements(vector)
   sparse = Make_Array(2, dim+1, /FLOAT, /NOZERO)
   
   actNeurons = WHERE(vector NE 0, count)

   sparse(0,0) = count
   sparse(1,0) = dim

   IF count NE 0 THEN BEGIN
      sparse(0,1:count) = actNeurons
      sparse(1,1:count) = vector(actNeurons)
   END
  
   RETURN, sparse(*,0:count)
END
