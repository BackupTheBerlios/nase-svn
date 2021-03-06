;+
; NAME:
;  NoNone_Func()
;
; AIM: Change !NONE to another value for evaluation or display purposes.
;
; PURPOSE: Veraendern des Wertes der !NONE-Verbindungen zum Zweck der
;          Auswertung oder Darstellung.
;
; CATEGORY:
;  Simulation / Connections
;
; CALLING SEQUENCE: Entweder als Funktion:
;                      W_neu = NoNone_Func(W_alt
;                                          [,VALUE=wert]
;                                          [,NONES=Indices]
;                                          [,COUNT=occurrences])
;                   oder als Prozedur:
;                      <A HREF="#NONONE_PROC">NoNone_Proc</A>, W_alt 
;                                   [,VALUE=wert]
;                                   [,NONES=Indices]
;                                   [,COUNT=occurrences]
;
; INPUTS: W_alt: Eine Gewichtsmatrix mit !NONE-Eintraegen,
;                in der Regel wohl das Ergebnis eines <A HREF="#WEIGHTS">Weights</A>-
;                Aufrufs.
;
; OPTIONAL INPUTS: wert: Der Wert, der anstelle von !NONE in die
;                        Gewichtsmatrix eingetragen bzw zurueckgeliefert wird.
;                        Default = 0.0
;
; OUTPUTS: W_neu: Die Gewichtsmatrix, deren !NONE-Eintraege ersetzt
;                 wurden.
;
; OPTIONAL OUPUTS: NONES: Die Indices der ersetzten Elemente.
;                         Enthielt die Matrix keine !NONEs, so wird -1 
;                         zur�ckgegeben.
;                         (Ergebnis wird von WHERE
;                         durchgeschleift.)
;                  COUNT: Anzahl der ersetzten Werte.
;                         (Ergebnis wird von WHERE
;                         durchgeschleift.)
;
; PROCEDURE: Eigentlich nur eine IDL-Where-Anweisung nett verpackt.
;
; EXAMPLE: w_alt=[1.0,1.0,!none]
;          print, w_alt
;          w_neu= NoNone_Func(w_alt)
;          print, w_alt 
;          print, w_neu
;          NoNone_Proc, w_alt
;          print, w_alt
;
; SEE ALSO: <A HREF="#NONONE_PROC">NoNone_Proc</A>, <A HREF="#WEIGHTS">Weights</A>
;
;-
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 2.3  2000/09/25 16:49:13  thiel
;            AIMS added.
;
;        Revision 2.2  1999/09/22 10:16:57  kupper
;        Added COUNT Keyword.
;
;        Revision 2.1  1998/06/08 10:09:44  thiel
;               Die eine Haelfte der NoNone-Routine.
;
;        Revision 2.3  1998/05/27 12:09:53  kupper
;               NONES-Keyword hinzugef�gt.
;
;        Revision 2.2  1998/05/02 22:27:45  thiel
;               Keyword-Implemetation vergessen!
;
;        Revision 2.1  1998/05/02 21:48:08  thiel
;               Endlich ausgelagert!
;



FUNCTION NoNone_Func, w, VALUE=value, NONES=nones, COUNT=count

   Default, value, 0.0

   nones = where(w EQ !NONE, count)
   
   result = w
   
   IF count NE 0 THEN result(nones) = value

   Return, result

END
