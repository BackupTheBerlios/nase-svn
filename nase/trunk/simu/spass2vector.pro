;+
; NAME:              Spass2Vector
;
; PURPOSE:           Konvertiert die mit Vector2Spass erzeugte Liste wieder zurueck in einen
;                    Vector (Float-Array)
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
; CALLING SEQUENCE:  vector = Spass2Vector( sparse )
;
; INPUTS:            sparse : ein zweidimensionales Float-Array
;
; OUTPUT:            vector : ein Float-Array
;
; RESTRICTIONS:      Ist vector mehrdimensional enthaelt sparse die eindimensionalen Indizes
;                    Vector muss definiert sein, keine Ueberpruefung (Effizienz!)
;
; EXAMPLE:
;                    vector = 10*RandomU(seed, 1+20*FIX(RandomU(seed)))
;                    sparse = Vector2Spass(vector)
;                    vectorFromSparse = Spass2Vector(sparse)
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
FUNCTION Spass2Vector, sparse

   vector = FltArr(sparse(1,0))
   
   IF sparse(0,0) GT 0 THEN vector( sparse(0,1:sparse(0,0)) ) = sparse(1,1:sparse(0,0))
   
   RETURN, vector

END
