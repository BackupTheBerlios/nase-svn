;+
; NAME: All_Random()
;
; PURPOSE: Erzeugt ein Array mit paarweis verschiedenen Zufallszahlen. 
;
; CATEGORY: Miscellaneous
;
; CALLING SEQUENCE: Array = All_Random (n)
;
; INPUTS: n: Integer, n>0.
;
; OUTPUTS: Array: Int-Array der Länge n, das jede ganze Zahl im
;                  Intervall [0,n) genau einmal enthält. 
;
; COMMON BLOCKS: common_random  (Standard)
;
; RESTRICTIONS: n>0
;               Achtung, für n>1000 kann die Ausführungszeit schnell
;               recht lange werden! (Dummer Brute Force-Algorithmus...)
;
; PROCEDURE: Brute Force: Für jedes Element solange Randoms erzeugen,
;             bis eine "neue" Zahl gefunden ist
;
; EXAMPLE: Zufaellige_Reihenfolge = All_Random (100)
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 1.1  1997/10/06 16:25:00  kupper
;        Aus der Traufe gehoben. Aeh.. Taufe. (Wiege?) Oder wie sagt man...?
;
;-

Function All_Random, n
   common common_random, seed

   erg = intarr(n)-1
   for i=0, n-1 do begin
      repeat begin
         x = fix(n*Randomu(seed)) < n
         dumm = where (erg eq x, count)
      endrep until count eq 0
      erg(i) = x
   end
   return, erg
End
