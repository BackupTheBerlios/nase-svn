;+
; NAME:              ResetCounter
;
; PURPOSE:           Setzt das mit InitCounter initialisierte Zaehlwerk auf Null.
;                    
; CATEGORY:          MISC
;
; CALLING SEQUENCE:  ResetCounter, CS
;
; INPUTS:            CS: eine mit InitCounter initialisierte Zaehlerstruktur
;
; EXAMPLE:
;                    DigitalUhrMitSekunden = InitCounter( [24,60,60] )
;                    FOR eineMinute=0,59 DO BEGIN
;                       print, CountValue(DigitalUhrMitSekunden)
;                       Count, DigitalUhrMitSekunden
;                    END
;                    ResetCounter, DigitalUhrMitSekunden ; ein neuer Tag beginnt
;
; SEE ALSO:          <A HREF="#COUNT">Count</A>, <A HREF="#INITCOUNTER">InitCounter</A>, <A HREF="#COUNTVALUE">CountValue</A>
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 2.4  1997/11/25 10:39:41  saam
;           yes another HTML-Bug
;
;     Revision 2.3  1997/11/25 10:35:46  saam
;           another HTML-Bug
;
;     Revision 2.2  1997/11/25 10:30:25  saam
;           Hyperlinks hatten einen BUG
;
;     Revision 2.1  1997/11/25 09:10:27  saam
;           Neu und Toll
;
;
;-
PRO ResetCounter, CS

   IF CS.info EQ 'Counter' THEN BEGIN
      CS.counter(*) = 0
   END ELSE Message, 'no valid Count-Structure'

END
