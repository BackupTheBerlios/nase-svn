;+
; NAME:               Schwerpunkt()
;
; AIM:                center of gravtity (violates naming convention)
;
; PURPOSE:            Liefert die Koordinaten des (Masse-)Schwerpunktes in einem
;                     Array beliebiger Dimension. 
;
; CATEGORY:           MISC ARRAYS
;
; CALLING SEQUENCE:   Ortsvektor = Schwerpunkt (Array [,SIG=sig])
;
; INPUTS:             Array:      Ein beliebiges Array (natürlich kein Stringarray...)
;
; KEYWORD PARAMETERS: SIG: falls, gesetzt gehen nur die Werte in die Schwerpunkts-
;                           berechnung ein, die groesser gleich SIG mal der Standard-
;                           abweichung der Verteilung sind. SIG kann auch negativ sein,
;                           sodass man damit eine >kleiner-gleich<-Bedingung realisieren
;                           kann.
;
; OUTPUTS:            Ortsvektor: Ortsvektor zum Schwerpunkt in Arraykoordinaten
;                                (Ursprung bei Array(0,0)). Wurde kein signifikanter
;                                Wert gefunden, wird !NONE fuer jede Koordinate zurueckgegeben.
;
; RESTRICTIONS:       Funktioniert auf allen Arrays, hat aber nicht mehr die
;                     Aussage eines Masseschwerpunktes, wenn das Array
;                     negative Wrte enthält... (Stichwort: Ladungsschwerpunkt) 
;
; PROCEDURE:          Definitionsgemäß. Benutzt Subscript()
;
; EXAMPLE:            myArr = Gauss_2D(21,21)
;                     print, Schwerpunkt(myArr)
;                          => Ausgabe: 10.000   10.000
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 1.3  2000/09/25 09:12:55  saam
;        * added AIM tag
;        * update header for some files
;        * fixed some hyperlinks
;
;        Revision 1.2  1999/07/28 08:35:35  saam
;              allow computation of COM only for significant values,
;              by the new SIG-Keyword
;
;        Revision 1.1  1997/10/29 17:29:45  kupper
;               Schöpfung!
;
;-

Function Schwerpunkt, A, SIG=sig

   s = size(A)
   dims = s(0)
   erg = fltarr(dims)
   
   
   IF Keyword_Set(SIG) THEN BEGIN
      m = UMoment(A, SDEV=sd)
      significant = WHERE(A GE m(0)+FLOAT(sig)*sd, c) 
   END ELSE BEGIN
      c = N_Elements(A)
      significant = LIndGen(c)
   END
   IF c NE 0 THEN BEGIN
      
      FOR i=0, c-1 DO BEGIN 
         erg = erg + FLOAT(A(significant(i)))*SubScript(A, significant(i))
      end

      return, erg/Total(ABS(A(significant)))
   END ELSE RETURN, REPLICATE(!NONE, dims)

End
