;+
; NAME:
;  NoNone_Proc
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
;                      W_neu = <A HREF="#NONONE_FUNC">NoNone_Func</A>(W_alt
;                                          [,VALUE=wert]
;                                          [,NONES=Indices]
;                                          [,COUNT=occurrences])
;                   oder als Prozedur:
;                      NoNone_Proc, W_alt 
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
; OPTIONAL OUPUTS: NONES: Die Indices der ersetzten Elemente.
;                         Enthielt die Matrix keine !NONEs, so wird -1 
;                         zurückgegeben.
;                  COUNT: Anzahl der ersetzten Werte.
;                         (Ergebnis wird von WHERE
;                         durchgeschleift.)
;
; SIDE EFFECTS: Die uebergebene Matrix wird verandert, soll ja auch, also
;               nicht wirklich ein Side Effect, ich wollts ja nur gesagt haben.
;
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
; SEE ALSO: <A HREF="#NONONE_FUNC">NoNone_Func</A>, <A HREF="#WEIGHTS">Weights</A>
;
;-
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 2.4  2000/09/25 16:49:13  thiel
;            AIMS added.
;
;        Revision 2.3  1999/09/22 14:44:02  kupper
;        Updated Hyperling...
;
;        Revision 2.2  1999/09/22 10:16:41  kupper
;        Added COUNT Keyword.
;
;        Revision 2.1  1998/06/08 10:12:24  thiel
;               Die andere Haelfte der NoNone-Routine.
;
;        Revision 2.3  1998/05/27 12:09:53  kupper
;               NONES-Keyword hinzugefügt.
;
;        Revision 2.2  1998/05/02 22:27:45  thiel
;               Keyword-Implemetation vergessen!
;
;        Revision 2.1  1998/05/02 21:48:08  thiel
;               Endlich ausgelagert!
;


PRO NoNone_Proc, w, VALUE=value, NONES=nones, COUNT=count

   Default, value, 0.0

   nones = where(w EQ !NONE, count)
   
   IF count NE 0 THEN w(nones) = value
   
END
