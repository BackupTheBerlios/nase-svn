;+
; NAME: NoNone
;
; PURPOSE: Veraendern des Wertes der !NONE-Verbindungen zum Zweck der
;          Auswertung oder Darstellung.
;
; CATEGORY: SIMUALTION / CONNECTIONS
;
; CALLING SEQUENCE: Entweder als Funktion:
;                      W_neu = NoNone(W_alt, [VALUE=wert])
;                   oder als Prozedur:
;                      NoNone, W_alt, [VALUE=wert]
;
; INPUTS: W_alt: Eine Gewichtsmatrix mit !NONE-Eintraegen,
;                in der Regel wohl das Ergebnis eines <A HREF="#WEIGHTS">Weights</A>-
;                Aufrufs.
;
; OPTIONAL INPUTS: wert: Der Wert, der anstelle von !NONE in die
;                        Gewichtsmatrix eingetragen bzw zurueckgeliefert wird.
;                        Default = 0.0
;
; OUTPUTS: W_neu: Die Gewichtsmatrix, deren !NONE-Eintraege ersetzt wurden.
;
; SIDE EFFECTS: Die Prozedur-Variante veraendert natuerlich die uebergebene
;               Matrix.
;
; PROCEDURE: Eigentlich nur eine IDL-Where-Anweisung nett verpackt.
;
; EXAMPLE: w_alt=[1.0,1.0,!none]
;          print, w_alt
;          w_neu= nonone(w_alt)
;          print, w_alt 
;          print, w_neu
;          nonone, w_alt
;          print, w_alt
;
; SEE ALSO: <A HREF="#WEIGHTS">Weights</A>
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 2.1  1998/05/02 21:48:08  thiel
;               Endlich ausgelagert!
;
;-


FUNCTION NoNone, w

   noneindex = where(w EQ !NONE, count)

   result = w
   
   IF count NE 0 THEN result(noneindex) = 0.0

   Return, result

END


PRO NoNone, w

   noneindex = where(w EQ !NONE, count)
   
   IF count NE 0 THEN w(noneindex) = 0.0
   
END
