;+
; NAME:              CountValue
;
; PURPOSE:           Zaehlt einen mit InitCounter erstellten Zaehler um
;                    eins weiter.
;
; CATEGORY:          MISC
;
; CALLING SEQUENCE:  counter = CountValue(CS)
;
; INPUTS:            CS: eine mit InitCounter initialisiertes Zaehlwerk
;
; OUTPUTS:           counter: der aktuelle Zaehlerstand
;
; EXAMPLE:
;                    ThreeBits = InitCounter( [2,2,2] )
;                    FOR i=0,20 DO BEGIN
;                       print, CountValue(ThreeBits)
;                       Count, ThreeBits, overflow
;                       IF Overflow THEN Print,'Ueberlauf'
;                    END
;
; SEE ALSO:          <A HREF="#INITCOUNTER">InitCounter</A>
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 2.3  1997/11/25 10:35:46  saam
;           another HTML-Bug
;
;     Revision 2.2  1997/11/25 10:30:24  saam
;           Hyperlinks hatten einen BUG
;
;     Revision 2.1  1997/11/25 09:10:03  saam
;           Neu und Toll
;
;     Revision 2.1  1997/11/24 16:23:39  saam
;           erstellt fuer Looping
;
;
;-
FUNCTION CountValue, CS
   
   IF CS.info EQ 'Counter' THEN BEGIN
      RETURN, CS.Counter
   END ELSE MESSAGE, 'argument is no valid count structure'
END
