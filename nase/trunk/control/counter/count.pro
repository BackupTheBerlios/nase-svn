;+
; NAME:              Count
;
; PURPOSE:           Zaehlt einen mit InitCounter erstellten Zaehler um
;                    eins weiter.
;
; CATEGORY:          MISC
;
; CALLING SEQUENCE:  Count(CS [,overflow])
;
; INPUTS:            CS: eine mit InitCounter initialisiertes Zaehlwerk
;
; OPTIONAL OUTPUTS:  overflow: Trat ein Ueberlauf auf, dh. ist Zaehlwerk
;                              wieder auf 0 ... 0 ??
;
; EXAMPLE:
;                    ThreeBits = InitCounter( [2,2,2] )
;                    FOR i=0,20 DO BEGIN
;                       print, CountValue(ThreeBits)
;                       Count, ThreeBits, overflow
;                       IF Overflow THEN Print,'Ueberlauf'
;                    END
;
; SEE ALSO:          <A HREF=#INITCOUNTER>InitCounter</A>, </A HREF=#COUNTVALUE>CountValue</A>, </A HREF=#COUNTVALUE>ResetCounter</A>
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 2.4  1997/11/25 10:30:24  saam
;           Hyperlinks hatten einen BUG
;
;     Revision 2.3  1997/11/25 10:03:02  saam
;           BUG in Rekursion eliminiert
;
;     Revision 2.2  1997/11/25 09:11:06  saam
;           In eine Procedure verwandelt, aktueller Zaehlerstand
;           wird nun mit CountValue ausgelesen
;
;     Revision 2.1  1997/11/24 16:23:39  saam
;           erstellt fuer Looping
;
;
;-
FUNCTION CountIt, CS, index
   
   IF index GE 0 THEN BEGIN
      CS.counter(index) = CS.counter(index)+1
      
      ; Ueberlauf ??
      IF CS.counter(index) GE CS.maxCount(index) THEN BEGIN
         CS.counter(index) = 0
         RETURN, CountIt(CS, index-1)
      END ELSE RETURN, 0
   END ELSE RETURN, 1
END



PRO Count, CS, overflow
   IF CS.info EQ 'Counter' THEN BEGIN
      overflow = CountIt(CS, CS.n-1)
   END ELSE MESSAGE, 'argument is no valid count structure'
END
