;+
; NAME:              Count
;
; PURPOSE:           Zaehlt einen mit InitCounter erstellten Zaehler um
;                    eins weiter.
;
; CATEGORY:          MISC
;
; CALLING SEQUENCE:  latestCount = Count(CS [,overflow])
;
; INPUTS:            CS: eine mit InitCounter initialisiertes Zaehlwerk
;
; OUTPUTS:           latestCount: der aktuelle Zaehlerstand
;
; OPTIONAL OUTPUTS:  overflow: Trat ein Ueberlauf auf, dh. ist Zaehlwerk
;                              wieder auf 0 ... 0 ??
;
; EXAMPLE:
;                    ThreeBits = InitCounter( [2,2,2] )
;                    FOR i=0,20 DO BEGIN
;                       print, Count(ThreeBits,overflow)
;                       IF Overflow THEN Print,'Ueberlauf'
;                    END
;
; SEE ALSO:          </A HREF=#INITCOUNTER>InitCounter</A>
;
; MODIFICATION HISTORY:
;
;     $Log$
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
      END
   END ELSE RETURN, 1
END



FUNCTION Count, CS, overflow
   IF CS.info EQ 'Counter' THEN BEGIN
      overflow = CountIt(CS, CS.n-1)
      RETURN, CS.counter
   END ELSE MESSAGE, 'argument is no valid count structure'
END
