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
; OUTPUTS: Auf einem Echtfarb-Display  : Einfach die Nummer der Farbe (0..16777216)
;          Auf einem ColorTable-Display: Der Farbindex, der mit der neuen Farbe belegt wurde, bzw.
;                                        der Farbindex einer moeglichst aehnlichen Farbe bei
;                                        Keyword NOALLOC
;
; COMMON BLOCKS: common_RGB, My_freier_Farbindex
;                (Wird bisher nur von dieser Funktion verwendet)
;
; SIDE EFFECTS: Die Farbtabelle wird (evtl.) verändert.
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
; PROCEDURE: Echtfarb-Display  : Einfaches Kombinieren der drei 8-bit-Werte zu einem 24-bit-Wert.
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

   IF (!D.Name EQ 'PS') and !PSGREY THEN BEGIN
      ; korrekte Behandlung nur fuer Grauwertpostscripts 
      New_Color_Convert, R, G, B, y, i, c, /RGB_YIC
      IF !REVERTPSCOLORS THEN RETURN, 255-LONG(y) ELSE RETURN, LONG(y)
   END


   if !D.N_Colors LE 256 then begin  ; 256-Farb-Display mit Color-Map   
      IF Keyword_Set(NOALLOC) THEN BEGIN ; keine Farbe umdefienieren, sondern aehnlichste zurueckgeben
         myCM = bytarr(!D.Table_Size,3) 
         TvLCT, myCM, /GET
	 New_Color_Convert, myCM(*,0), myCM(*,1), myCM(*,2), myY, myI, myC, /RGB_YIC
	 New_Color_Convert, R, G, B, Y, I, C, /RGB_YIC
	 differences = (myY - Y)^2 + (myI - I)^2 + (myC - C)^2
         lowestDiff = MIN(differences, bestMatch)
         RETURN, bestMatch
      END

       if Not(Keyword_Set(My_freier_Farbindex))or keyword_set(START) then begin
          Default, start, 1
          My_freier_Farbindex = start
       end
 
       My_Color_Map = bytarr(!D.Table_Size,3) 
       TvLCT, My_Color_Map, /GET  
          
       if set(index) then SetIndex = index else SetIndex = My_freier_Farbindex

       My_Color_Map (SetIndex,*) = [R,G,B]  
       TvLCT, My_Color_Map  
       
       if not set(index) then begin
          My_freier_Farbindex = (My_freier_Farbindex+1) mod !D.Table_Size  
          if My_freier_Farbindex eq 0 then message, /INFORM, "!Farbpalette voll!"  
          return, My_Freier_Farbindex-1
       end
       return,  SetIndex

    endif else Return, RGB_berechnen(R,G,B) ; True-Color-Display   
END      



