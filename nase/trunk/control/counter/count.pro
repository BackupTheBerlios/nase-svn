;+
; NAME:              Count
;
; AIM: Increases a counter initialized with <A>initcounter</A> by 1
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
; PROCEDURE:         Diese Procedure benoetigt die Routine _Count
;
; SEE ALSO:          <A HREF="#INITCOUNTER">InitCounter</A>, <A HREF="#COUNTVALUE">CountValue</A>, <A HREF="#COUNTVALUE">ResetCounter</A>
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 2.8  2000/09/28 13:24:19  alshaikh
;           added AIM
;
;     Revision 2.7  1997/11/26 10:54:47  saam
;           Probleme mit Rekursion&automatischer Compilation von CountIt
;           Auslagerung in _Count
;
;     Revision 2.6  1997/11/25 10:39:37  saam
;           yes another HTML-Bug
;
;     Revision 2.5  1997/11/25 10:35:45  saam
;           another HTML-Bug
;
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
PRO Count, CS, overflow
   IF CS.info EQ 'Counter' THEN BEGIN
      overflow = _Count(CS, CS.n-1)
   END ELSE MESSAGE, 'argument is no valid count structure'
END
