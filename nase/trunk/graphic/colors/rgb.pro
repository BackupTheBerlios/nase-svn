;+
; NAME: RGB()
;
; PURPOSE: Ermöglicht die Angabe von Farbwerten im RGB-Format, und
;           zwar ohne Änderung sowohl auf Echtfarb- als auch auf ColorTable-Systemen.
;
; CATEGORY: Graphic
;
; CALLING SEQUENCE: Der übliche Aufruf von RGB() geschieht in einer
;                    Graphikprozedur im COLOR-Schlüsselwort.
;                   
;                   COLOR= RGB( {Rot,Grün,Blau | Farbname}
;                               [,INDEX=Farbindex] [,START=Startindex] 
;                               [,/NOALLOC] )
;                    
; INPUTS: Entweder Rot, Grün, Blau: Werte im Bereich 0..255, die die
;                                   gewünschte Farbe definieren,
;         oder            Farbname: Ein String mit einem bekannten
;                                   Farbnamen (s. <A HREF="#../../alien/COLOR">Color</A>.) 
;
; KEYWORD PARAMETERS:
;
;         Farbindex      : Dieser Wert hat nur Bedeutung, wenn man sich auf einem
;                          ColorTable-Display befindet. Dann kann hier
;                          nämlich der Farbindex angegeben werden, der
;                          mit der neuen Farbe belegt werden soll.
;                          Default ist der nächste "freie" Farbindex,
;                          wobei beim ersten Aufruf mit dem Index 1
;                          begonnen wird, sofern nicht im
;                          Schlüsselwort START etwas anderes definiert
;                          wird. (S.a. Erläuterung unten)
;         Startindex     : Dieser Wert hat nur Bedeutung, wenn man sich auf einem
;                          ColorTable-Display befindet. Dann kann hier
;                          nämlich der Startwert für den (also der erste zu
;                          belegende) Farbindex angegeben werden, der
;                          dann von Aufruf zu Aufruf hochgezählt
;                          wird. (S.a. Erläuterung unten)
;         NOALLOC         :Falls gesetzt, wird bei 8-bit-Displays keine Farbe allokiert,
;                          sondern eine moeglichst aehnliche zurueckgegeben. Auf allen
;                          anderen Displays wird diese Option ignoriert
;
;                 
; OUTPUTS: 
;          Auf einem Psudoclor-Display (d.h. einem Display mit einer einzigen
;          Farbtabelle für alle Fenster/Outputs, vgl. <A HREF="../../misc#PSEUDOCOLOR_VISUAL()">Pseudocolor_Visual()</A>):
;                 Der Farbindex, der mit der neuen Farbe belegt wurde, bzw.
;                 der Farbindex einer moeglichst aehnlichen Farbe bei
;                 Keyword NOALLOC
;          Auf einem nicht-Pseudocolor-Display:
;                 Seit der standardmäßigen Verwendung von DECOMPOSED=0
;                 wird hier stets der Farbindex !TOPCOLOR, also
;                 der höchste der Farbindices, die NASE-Routinen für
;                 eigene Zwecke verändern dürfen, mit der entsprechenden 
;                 Farbe belegt und zurückgegeben.
;
; COMMON BLOCKS: common_RGB, My_freier_Farbindex
;                (Wird bisher nur von dieser Funktion verwendet)
;
; SIDE EFFECTS: Die Farbtabelle wird verändert.
;
; RESTRICTIONS: Auf einem ColorTable-Display liefert diese Funktion i.d.R. spätestens
;                nach dem 256. Aufruf den Fehler "!Farbpalette voll!".
;                Das kann jedoch durch Angabe eines neuen START-Wertes
;                verhindert werden.
;
;               WICHTIG: Damit RGB() den Displaytyp richtig ermittelt,
;                        muß die Farbinformation in der !D-Varible
;                        etabliert sein. D.h. es muß vorher mindestens
;                        einmal ein Fenster geöffnet worden sein!
;
; PROCEDURE: Echtfarb-Display  : Belegen des Farbindex !TOPCOLOR und Rückgabe desselben.
;
;            Colortable-Display: 1. bestimmen des nächsten freien Farbindex I:
;                                     
;                                  Ist INDEX=Farbindex gesetzt?
;                                   ja  : I=Farbindex.
;                                   nein: Ist START=Startindex gesetzt?
;                                          ja  : I=Startindex.
;                                          nein: Ist dies der erste Aufruf von RGB()?
;                                                 ja  : I=1.
;                                                 nein: I=letzter nicht mit INDEX produzierter Farbindex+1. 
;
;
;                                2. Index I mit der neuen Farbe besetzen und I als Ergebnis zurückgeben. 
;
;                                Das heißt: Wird RGB() ohne
;                                Keyword-Parameter aufgerufen, so
;                                belegt es beim ersten Aufruf den
;                                Index 1 und liefert auch als Ergebnis
;                                1 zurück. Im nächsten Aufruf wird
;                                dann Index 2 belegt und
;                                zurückgeliefert, dann 3 u.s.w.
;                                Zu jeder Zeit kann man einen
;                                bestimmten Index in INDEX wählen, der
;                                dann belegt und zurückgeliefert wird,
;                                was das kontinierliche Belegen der
;                                Indizes nicht beeinflußt (Beim
;                                nächsten normalen Aufruf wird
;                                beispielsweise mit Index 4
;                                fortgefahren).
;                                Wird genau das gewünscht, so kann
;                                jederzeit in START ein neuer
;                                Startwert für die kontinuierliche
;                                Belegung angegeben werden.
;
;                                Bspl: -Neustart von IDL-
;                                      print, RGB(255,0,0)  -> Ausgabe: 1 (und der Farbindex 1 wird mit rot belegt.)
;                                      print, RGB(0,255,0)  -> Ausgabe: 2 (entsprechend)
;                                      print, RGB(0,0,255,INDEX=23) -> Ausgabe: 23 (und der Farbindex 23 wird mit blau belegt)
;                                      print, RGB(0,0,0)    -> Ausgabe: 3
;                                      print, RGB(4,5,6,START=100) -> Ausgabe: 100
;                                      print, RGB(7,8,9)    -> Ausgabe: 101
;
;                               HINWEIS: IN DER REGEL BRAUCHT MAN SICH UM DIESEN GANZEN
;                                        INDEXKRAM NICHT ZU KUEMMERN! (S. EXAMPLE)    
;        
; EXAMPLE: Plot, Array, COLOR=RGB(255,255,255) 
;           liefert auf jedem Display einen weißen Plot! Ein anschließendes
;          OPlot, Array2, COLOR=RGB(255,0,0)
;           liefert dann auf jedem Display einen roten Plot, ohne daß
;           sich die Farbe des ersten Plots ändert!
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 1.20  2000/03/07 14:35:31  kupper
;        Pseudocolor_Visual() was called even on non X/WIN-devices (for example, on PS
;        Color devices). Fixed.
;        Updated Header.
;
;        Revision 1.19  2000/01/17 14:14:14  kupper
;        Changed to reflect new DECOMPOSED=0 standard.
;        Always returnes !TOPCOLOR on True-Color-Displays.
;
;        Revision 1.18  1999/12/02 15:24:25  kupper
;        Removed the Workaround for IDL 5.
;        for it corrupted the work of PlotTvScl, as it always
;        loaded the linear colortable, reuslting in a black and
;        white display of the array!
;
;        Revision 1.17  1999/11/23 13:37:14  kupper
;        exchanged Keyword_Set(START) by Set(START) to allow start-value
;        0.
;
;        Revision 1.16  1999/11/04 18:13:46  kupper
;        Added to Header comment on IDL 5.0 workaround.
;
;        Revision 1.15  1999/11/04 17:40:47  kupper
;        typo.
;
;        Revision 1.14  1999/11/04 17:31:41  kupper
;        Kicked out all the Device, BYPASS_TRANSLATION commands. They
;        -extremely- slow down performance on True-Color-Displays when
;        connecting over a network!
;        Furthermore, it seems to me, the only thing they do is to work
;        around a bug in IDL 5.0 that wasn't there in IDL 4 and isn't
;        there any more in IDL 5.2.
;        I do now handle this special bug by loading the translation table
;        with a linear ramp. This is much faster.
;        However, slight changes in behaviour on a True-Color-Display may
;        be encountered.
;
;        Revision 1.13  1998/03/12 19:45:20  kupper
;               Color-Postscripts werden jetzt richtig behandelt -
;                die Verwendung von Sheets vorrausgesetzt.
;
;        Revision 1.12  1998/02/23 14:59:43  kupper
;               Versteht jetzt Farbnamen.
;
;        Revision 1.11  1998/02/19 17:33:33  thiel
;               Sucht jetzt aehnlichste Farbe mit Hilfe des
;               YIC-Farbmodells.
;
;        Revision 1.10  1998/02/19 14:28:03  saam
;             NOALLOC ermittelt aehnliche Farbe nach HSV-Farbmodell
;
;        Revision 1.9  1998/02/19 14:00:58  saam
;              Bug korrigiert
;
;        Revision 1.8  1998/02/19 13:59:42  saam
;              alternative Farbbestimmung via Maximumsnorm
;
;        Revision 1.7  1997/11/05 10:02:12  saam
;              Keyword NOALLOC hinzugefuegt
;              Schwarz-Weiss PS-Devices werden nun auch unterstuetzt
;
;        Revision 1.6  1997/11/04 12:24:51  kupper
;               Nur Dokumentation in den Header geschrieben!
;
;-

FUNCTION RGB_berechnen, R,G,B  ; je 0..255      
   Return, long(R) + long(256)*G + long(65536)*B      
END   
   
FUNCTION RGB, R,G,B, INDEX=index, $; je 0..255
                      START=start,$
                      NOALLOC=noalloc
Common common_RGB, My_freier_Farbindex   
  
   If (Size(R))(1) eq 7 then Color, R, /EXIT, RED=R, GREEN=G, BLUE=B

   ;; ---- X or WIN, and not pseudocolor: ---------------------------------------
   IF ((!D.Name EQ 'X') or (!D.Name EQ 'WIN')) $
    and not Pseudocolor_Visual() then begin
      ;;Changed to reflect new usage of DECOMPOSED=0, R Kupper Jan 17 2000
      ;;       Return, RGB_berechnen(R,G,B)
      SetColorIndex, !TOPCOLOR, R, G, B
      Return, !TOPCOLOR
   endif
   ;; ---------------------------------------------------------------------------


   ;; ---- PS, and !PSGREY set: -------------------------------------------------
   IF (!D.Name EQ 'PS') and !PSGREY THEN BEGIN
      ; korrekte Behandlung nur fuer Grauwertpostscripts 
      New_Color_Convert, R, G, B, y, i, c, /RGB_YIC
      IF !REVERTPSCOLORS THEN RETURN, 255-LONG(y) ELSE RETURN, LONG(y)
   END
   ;; ---------------------------------------------------------------------------


   ;; ---- all other devices: -------------------------------------------------
   IF Keyword_Set(NOALLOC) THEN BEGIN ; keine Farbe umdefinieren, sondern aehnlichste zurueckgeben
      myCM = bytarr(!D.Table_Size,3) 
      TvLCT, myCM, /GET
      New_Color_Convert, myCM(*,0), myCM(*,1), myCM(*,2), myY, myI, myC, /RGB_YIC
      New_Color_Convert, R, G, B, Y, I, C, /RGB_YIC
      differences = (myY - Y)^2 + (myI - I)^2 + (myC - C)^2
      lowestDiff = MIN(differences, bestMatch)
      RETURN, bestMatch
   END

   if Not(Keyword_Set(My_freier_Farbindex))or set(START) then begin
      Default, start, 1
      My_freier_Farbindex = start
   end
   
   My_Color_Map = bytarr(!D.Table_Size,3) 
   TvLCT, My_Color_Map, /GET  
   
   if set(index) then SetIndex = index else SetIndex = My_freier_Farbindex

   My_Color_Map (SetIndex,*) = [R,G,B]  
   TvLCT, Temporary(My_Color_Map)
   
   if not set(index) then begin
      My_freier_Farbindex = (My_freier_Farbindex+1) mod !D.Table_Size  
      if My_freier_Farbindex eq 0 then message, /INFORM, "!Farbpalette voll!"  
      return, My_Freier_Farbindex-1
   end
   return,  SetIndex
   ;; ---------------------------------------------------------------------------

END
