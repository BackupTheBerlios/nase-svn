;+
; NAME:               FracRandom
;
; AIM:                draws k (k<=n) random pairwise different numbers for a set of n numbers
;
; PURPOSE:            Erzeugt ein Array aus m paarweise verschiedenen Zufallszahlen,
;                     die aus dem Intervall [0,n) gezogen werden. Dies kann z.B. als
;                     fuer ein anderes Array benutzt werden.
;
; CATEGORY:           MISC ARRAY
;
; CALLING SEQUENCE:   x = FracRandom(n [,m][,OLDMETHOD=OLDMETHOD][,VERBOSE=VERBOSE])
;
; INPUTS:             n: Zahlen werden aus [0,1,...,n-1] gezogen, n>0
;                     m: es werden m paarweise verschiedene Zahlen gezogen, m>0, m<=n
;
; KEYWORDS            OLDMETHOD: Benutzt die alte Methode (langsam)
;                     VERBOSE:   verbosly 
;
; OUTPUTS:            x: Long-Array mit m Elementen
;
; COMMON BLOCKS:      COMMON_RANDOM
;
; RESTRICTIONS:       n>0, m>0, m<=n
;
; PROCEDURE:          Zieht n gleichverteilte Elemente zwischen 0..1. Diese Elemente
;                     werden mit der Fkt. sort sortiert  und als Ergebnis wird der
;                     Index von sort zurueckgegeben. Zuvor wird mit Uniq ueberprueft
;                     ob alle Elemnte disjunkt sind. Falls nicht, wird nach 10 mal probieren
;                     nach obigen Verfahren die alte Methode benutzt (kommt sowieso nicht vor: Lotto!!)
;                     Ist das Verhaeltnis m/n kleiner als 0.005 wird auch die alte Methode benutzt.
;                     Beschleunigung bei n=10^5 Faktor 1000 , bei n=10^4 Faktor 20 
;                     OLDMETHOD: 
;                     Index-Array wird um die bereits gezogenen Zahlen
;                     verkleinert (viel scheller als Brute-Force der 
;                     noch aelteren Version von All_Random(), Faktor 15 bei n=10^4)
;
; EXAMPLE:            
;                     ;ziehe 10 Zahlen aus dem Intervall 0..99
;                     print, FracRandom(100,10)
;
;                     ;ziehe 10000 paarweise verschiedene Zufallszahlen
;                     print, FracRandom(10000)
;
; AUTHOR:             Mirko Saam
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 1.4  2000/09/25 09:12:54  saam
;        * added AIM tag
;        * update header for some files
;        * fixed some hyperlinks
;
;        Revision 1.3  1999/07/14 16:53:58  gabriel
;            NEW Method implemented:
;            +uses sort and randomu for indexing
;            +speeds up for big dimensions
;            +Keyword new: OLDMETHOD and VERBOSE
;
;        Revision 1.2  1999/02/24 15:52:20  saam
;              there was a certain, very low probability that
;              an access beyond array dimensions occured; this
;              is fixed
;
;        Revision 1.1  1999/02/17 19:24:16  saam
;              improvement & completely rewritten of all_random:
;                + take variable elements from given set
;                + no brute force any more!!
;
;
;-
FUNCTION FracRandom, n, m, OLDMETHOD=OLDMETHOD , VERBOSE=VERBOSE
   COMMON common_random, seed

   ; check for argument count
   np = N_Params()
   IF np EQ 1 THEN m = n
   IF (np GT 2) OR (np LT 1) THEN Message, 'wrong number of arguments'

   ;check for argument semantics
   IF n LE 0 THEN Message, "n has to be greater than 0" 
   IF m LE 0 THEN Message, "i can't pull no element, m>0"

   default,OLDMETHOD,0
   default,VERBOSE,0
   IF OLDMETHOD EQ 1 THEN BEGIN
      ind = LIndGen(n)          ; the array where numbers are taken from
      res = [-1]                ; the resulting array
      FOR i=0l, m-1 DO BEGIN
         xind = long((n-i)*Randomu(seed)) < (n-i-1 > 0)
         
         res = [res, ind(xind)]
                                ;remove the value from ind
         IF xind EQ 0 THEN BEGIN
            IF i LT n-1 THEN ind = ind(1:n-i-1) ;this case is needed because if only 1 element is remaining n-i-1 is less than 1
         END ELSE IF xind EQ n-i-1 THEN BEGIN
            ind = ind(0:n-i-2)
         END ELSE BEGIN
            ind = [ind(0:xind-1), ind(xind+1:n-i-1)]
         END 
      END
      RETURN, res(1:m)
   END ELSE BEGIN ;; new method
      
      IF FLOAT(m)/FLOAT(n) LT 0.005 THEN BEGIN
         IF VERBOSE THEN  print,"--> m/n LT 0.005, change to old method of FracRandom, much faster!!"
         return,FracRandom(n,m,/OLDMETHOD)
      ENDIF
      WHILE 1 DO BEGIN
         a = randomu(seed,n) 
         res = sort(a)
         IF N_ELEMENTS(uniq(res(sort(res)))) EQ n THEN RETURN, res(0:m-1) $
         ELSE BEGIN 
            IF VERBOSE THEN print,"some uniq values, what's wrong? --> Try it again"
            max_retrials = max_retrials-1
            IF max_retrials EQ 0 THEN BEGIN
            IF VERBOSE THEN print,"change to old method of FracRandom"
               return, FracRandom(n,m,/OLDMETHOD)
            ENDIF
         ENDELSE
      ENDWHILE
      
   END

END
