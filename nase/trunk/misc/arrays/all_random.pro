;+
; NAME:             All_Random
;
; PURPOSE:          Erzeugt ein Array mit paarweis verschiedenen Zufallszahlen. 
;
; CATEGORY:         MISC ARRAYS
;
; CALLING SEQUENCE: Array = All_Random (n)
;
; INPUTS:           n: Integer, n>0.
;
; OUTPUTS:          Array: Long-Array der Länge n, das jede ganze Zahl im
;                          Intervall [0,n) genau einmal enthält. 
;
; COMMON BLOCKS:    common_random
;
; RESTRICTIONS:     n>0
; 
; SEE ALSO:         <A HREF="http://neuro.physik.uni-marburg.de/nase/misc/arrays/#FRACRANDOM">FracRandom</A>
;
; EXAMPLE:          Zufaellige_Reihenfolge = All_Random (100)
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 1.2  1999/02/17 19:28:02  saam
;              just calls fracrandom
;
;        Revision 1.1  1997/10/06 16:25:00  kupper
;              Aus der Traufe gehoben. Aeh.. Taufe. (Wiege?) Oder wie sagt man...?
;
;-

Function All_Random, n
   RETURN, FracRandom(n)
End
