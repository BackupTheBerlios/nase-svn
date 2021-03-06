;+
; NAME:              CountValue
;
; AIM: returns the state of the counter
;
; PURPOSE:           Gibt den aktuellen Zaehlerstand aus 
;                   
; CATEGORY:          MISC
;
; CALLING SEQUENCE:  counter = CountValue(CS [,iter])
;
; INPUTS:            CS: eine mit InitCounter initialisiertes Zaehlwerk
;
; OUTPUTS:           counter: der aktuelle Zaehlerstand
;
; OPTIONAL OUTPUTS:  iter: enthaelt nach dem Aufruf die Gesamtzahl
;                           bereits durchgefuehrter Zaehlungen
;
; EXAMPLE:
;                    ThreeBits = InitCounter( [2,2,2] )
;                    FOR i=0,20 DO BEGIN
;                       print, CountValue(ThreeBits, iter)
;                       print, iter
;                       Count, ThreeBits, overflow
;                       IF Overflow THEN Print,'Ueberlauf'
;                    END
;
; SEE ALSO:          <A HREF="#INITCOUNTER">InitCounter</A>, <A HREF="#COUNT">Count</A>, <A HREF="#RESETCOUNTER">ResetCounter</A>
;-
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 2.7  2000/09/28 13:24:20  alshaikh
;           added AIM
;
;     Revision 2.6  2000/09/27 15:59:08  saam
;     service commit fixing several doc header violations
;
;     Revision 2.5  1998/01/20 12:01:37  saam
;           Erweiterung um optional output: iter
;
;     Revision 2.4  1997/11/25 10:39:38  saam
;           yes another HTML-Bug
;
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
;
FUNCTION CountValue, CS, iter
   IF Contains(CS.info, 'Counter', /IGNORECASE) THEN BEGIN
      iter = 0
      FOR i=0,CS.n-1 DO iter = iter*CS.maxCount(i) + CS.counter(i)
      RETURN, CS.Counter
   END ELSE MESSAGE, 'argument is no valid count structure'
END
