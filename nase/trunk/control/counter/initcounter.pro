;+
; NAME:              InitCounter
;
; AIM: initializes a single/multiple counter
;
; PURPOSE:           Initialisiert ein Zaehlwerk aus beliebigen Zaehlern.
;                    Jeder Zaehler hat einen individuellen Ueberlauf.
;                    
; CATEGORY:          MISC
;
; CALLING SEQUENCE:  CS = InitCounter( MaxCount )
;
; INPUTS:            MaxCount: eine Liste (oder ein Skalar), die den Ueberlauf
;                           fuer den entsprechenden Zaehler angibt. Der entspr.
;                           Zaehler laeuft dann von 0 bis Ueberlauf-1
;
; OUTPUTS:           CS: die Zaehlerstruktur
;
; EXAMPLE:
;                    DigitalUhrMitSekunden = InitCounter( [24,60,60] )
;                    FOR eineMinute=0,59 DO BEGIN
;                       print, CountValue(DigitalUhrMitSekunden)  ; gibt den aktuellen zaehlerstand aus
;                       Count, DigitalUhrMitSekunden              ; erhoeht den zaehlen um 1
;                    END
;
; SEE ALSO:          <A HREF="#COUNT">Count</A>, <A HREF="#RESETCOUNTER">ResetCounter</A>, <A HREF="#COUNTVALUE">CountValue</A>
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 2.7  2000/09/28 13:24:20  alshaikh
;           added AIM
;
;     Revision 2.6  1999/03/16 12:55:21  saam
;           corrected disfunctional example
;
;     Revision 2.5  1997/11/25 10:39:39  saam
;           yes another HTML-Bug
;
;     Revision 2.4  1997/11/25 10:35:46  saam
;           another HTML-Bug
;
;     Revision 2.3  1997/11/25 10:30:25  saam
;           Hyperlinks hatten einen BUG
;
;     Revision 2.2  1997/11/25 09:11:33  saam
;           Hyperlinks aktualisiert
;
;     Revision 2.1  1997/11/24 16:23:24  saam
;           Erstellt fuer Looping
;
;-
FUNCTION InitCounter, MaxCount

   n = N_Elements(MaxCount)
   
   CountStruc = { info    : 'Counter'   ,$
                  n       : n           ,$
                  counter : LonArr(n)   ,$
                  maxCount: MaxCount    }
   RETURN, CountStruc

END
