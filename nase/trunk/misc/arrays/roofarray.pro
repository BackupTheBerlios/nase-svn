;+
; NAME: RoofArray
;
; AIM: two dimensional version of hill?
;
; PURPOSE: Belegen eines Arrays mit stufenfoermig abfallenden
;          Werten, bei quadratischen Arrays sieht das aus wie
;          eine Pyramide.
;
; CATEGORY: MISCELLANEOUS / ARRAY OPERATIONS
;
; CALLING SEQUENCE: array = RoofArray(n [,m] [/INVERSE]
;
; INPUTS: n: Zahl der Spalten des resultierenden Arrays
;
; OPTIONAL INPUTS: m: Zahl der Zeilen des resultierenden Arrays.
;                     Wird m nicht angegeben, so ist das Ergebnis
;                     Ein Array der Groesse n x n.
;
; KEYWORD PARAMETERS: INVERSE: Wird INVERSE gesetzt, so hat der Rand
;                              des Arrays den groessten Wert, ansonsten
;                              die Mitte.
;
; OUTPUTS: array: Das entsprechende Array, uebrigens vom Typ float.
;
; PROCEDURE: 1. Syntaxkontrolle
;            2. quadratisches Array erzeugen, das pyramidenfoermig
;               belegt ist (Man beachte, dass dies in einer einzigen
;               Zeile moeglich ist, Danke auch an Ruediger!)
;            3. Kopien der mittleren Zeile oder Spalte in der Mitte 
;               einflicken, um rechteckiges Array zu erzeugen.
;
; EXAMPLE: print, RoofArray(5,7)
;          
;          ergibt:
;
;      0.00000      0.00000      0.00000      0.00000      0.00000
;      0.00000      1.00000      1.00000      1.00000      0.00000
;      0.00000      1.00000      2.00000      1.00000      0.00000
;      0.00000      1.00000      2.00000      1.00000      0.00000
;      0.00000      1.00000      2.00000      1.00000      0.00000
;      0.00000      1.00000      1.00000      1.00000      0.00000
;      0.00000      0.00000      0.00000      0.00000      0.00000
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 1.2  2000/09/25 09:12:55  saam
;        * added AIM tag
;        * update header for some files
;        * fixed some hyperlinks
;
;        Revision 1.1  1998/05/28 16:01:46  thiel
;               Neu!
;
;-


FUNCTION RoofArray, n, m, INVERSE=inverse

 
   IF n_elements(m) LE 0 THEN m = n

   IF (n LE 1) OR (m LE 1) THEN Message, 'Dimensions less than 2 are senseless!'
   
   quadrat = Min([n,m])
   
   centerfloat = (quadrat-1)/2.0 > 0.5

   center = Round(centerfloat)

   i = indgen(quadrat,quadrat)

   a = Float(Fix(Abs(layercol(index=i,height=quadrat,widt=quadrat)-centerfloat) > abs(layerrow(ind=i,hei=quadrat,widt=quadrat)-centerfloat)))

   IF (n EQ m) THEN IF Keyword_Set(INVERSE) THEN Return, a $
    ELSE Return, Abs(a-Max(a))

   b = FLTARR(n,m,/NOZERO)

   IF n GT m THEN BEGIN
      b(0:center-1,*) = a(0:center-1,*)
      b(center:n-center-1,*) = rebin(a(center,*),n-2*center,m, /SAMPLE)
      b(n-center:n-1,*) = a(quadrat-center:quadrat-1,*)
   ENDIF ELSE BEGIN
      b(*,0:center-1) = a(*,0:center-1)
      b(*,center:m-center-1) = rebin(a(*,center),n,m-2*center, /SAMPLE)
      b(*,m-center:m-1) = a(*,quadrat-center:quadrat-1)
   ENDELSE

   IF Keyword_Set(INVERSE) THEN Return, b ELSE Return, Abs(b-Max(b))
 
END

