;+
; NAME: NoNone
;
; PURPOSE: Veraendern des Wertes der !NONE-Verbindungen zum Zweck der
;          Auswertung oder Darstellung.
;
; CATEGORY: SIMUALTION / CONNECTIONS
;
; CALLING SEQUENCE: Entweder als Funktion:
;                      W_neu = NoNone (W_alt
;                                      [,VALUE=wert]
;                                      [,NONES=Indices]
;                                      [,COUNT=occurrences])
;                   oder als Prozedur:
;                              NoNone, W_alt 
;                                      [,VALUE=wert]
;                                      [,NONES=Indices]
;                                      [,COUNT=occurrences]
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
;                         zurückgegeben.
;                         (Ergebnis wird von WHERE
;                         durchgeschleift.)
;                  COUNT: Anzahl der ersetzten Werte.
;                         (Ergebnis wird von WHERE
;                         durchgeschleift.)
;
; PROCEDURE: Dies ist nur ein Wrapper für die Funktionen <A HREF="#NONONE_PROC">NoNone_Proc</A> und <A HREF="#NONONE_FUNC">NoNone_Func</A>.
;
; EXAMPLE: w_alt=[1.0,1.0,!none]
;          print, w_alt
;          w_neu= NoNone_Func(w_alt)
;          print, w_alt 
;          print, w_neu
;          NoNone_Proc, w_alt
;          print, w_alt
;
; SEE ALSO: <A HREF="#NONONE_PROC">NoNone_Proc</A>,
;           <A HREF="#NONONE_FUNC">NoNone_Func</A>,
;           <A HREF="#WEIGHTS">Weights</A>
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 2.5  1999/09/22 14:39:50  kupper
;        Added new procompiling-feature to NASE-startup script.
;        Allowing identically named Procs/Funcs (currently NoNone and Scl).
;
;-


Function NoNone, w, VALUE=value, NONES=nones, COUNT=count
   
   Return, NoNone_Func( w, VALUE=value, NONES=nones, COUNT=count )

End

Pro NoNone, w, VALUE=value, NONES=nones, COUNT=count

   NoNone_Proc, w, VALUE=value, NONES=nones, COUNT=count

End
