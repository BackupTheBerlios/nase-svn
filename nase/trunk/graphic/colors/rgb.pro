;+
; NAME: RGB()
;
; PURPOSE: Ermˆglicht die Angabe von Farbwerten im RGB-Format, und
;           zwar ohne ƒnderung sowohl auf Echtfarb- als auch auf ColorTable-Systemen.
;
; CATEGORY: Graphic
;
; CALLING SEQUENCE: Der ¸bliche Aufruf von RGB() geschieht in einer
;                    Graphikprozedur im COLOR-Schl¸sselwort.
;                   
;                   COLOR= RGB( Rot, Gr¸n, Blau [,INDEX=Farbindex] [,START=Startindex] 
;                               [,/NOALLOC] )
;                    
; INPUTS: Rot, Gr¸n, Blau: Werte im Bereich 0..255, die die gew¸nschte Farbe definieren.
;
; KEYWORD PARAMETERS:
;
;         Farbindex      : Dieser Wert hat nur Bedeutung, wenn man sich auf einem
;                          ColorTable-Display befindet. Dann kann hier
;                          n‰mlich der Farbindex angegeben werden, der
;                          mit der neuen Farbe belegt werden soll.
;                          Default ist der n‰chste "freie" Farbindex,
;                          wobei beim ersten Aufruf mit dem Index 1
;                          begonnen wird, sofern nicht im
;                          Schl¸sselwort START etwas anderes definiert
;                          wird. (S.a. Erl‰uterung unten)
;         Startindex     : Dieser Wert hat nur Bedeutung, wenn man sich auf einem
;                          ColorTable-Display befindet. Dann kann hier
;                          n‰mlich der Startwert f¸r den (also der erste zu
;                          belegende) Farbindex angegeben werden, der
;                          dann von Aufruf zu Aufruf hochgez‰hlt
;                          wird. (S.a. Erl‰uterung unten)
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
; SIDE EFFECTS: Die Farbtabelle wird (evtl.) ver‰ndert.
;
; RESTRICTIONS: Auf einem ColorTable-Display liefert diese Funktion i.d.R. sp‰testens
;                nach dem 256. Aufruf den Fehler "!Farbpalette voll!".
;                Das kann jedoch durch Angabe eines neuen START-Wertes
;                verhindert werden.
;
;               WICHTIG: Damit RGB() den Displaytyp richtig ermittelt,
;                        muﬂ die Farbinformation in der !D-Varible
;                        etabliert sein. D.h. es muﬂ vorher mindestens
;                        einmal ein Fenster geˆffnet worden sein!
;
; PROCEDURE: Echtfarb-Display  : Einfaches Kombinieren der drei 8-bit-Werte zu einem 24-bit-Wert.
;            Colortable-Display: 1. bestimmen des n‰chsten freien Farbindex I:
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
;                                2. Index I mit der neuen Farbe besetzen und I als Ergebnis zur¸ckgeben. 
;
;                                Das heiﬂt: Wird RGB() ohne
;                                Keyword-Parameter aufgerufen, so
;                                belegt es beim ersten Aufruf den
;                                Index 1 und liefert auch als Ergebnis
;                                1 zur¸ck. Im n‰chsten Aufruf wird
;                                dann Index 2 belegt und
;                                zur¸ckgeliefert, dann 3 u.s.w.
;                                Zu jeder Zeit kann man einen
;                                bestimmten Index in INDEX w‰hlen, der
;                                dann belegt und zur¸ckgeliefert wird,
;                                was das kontinierliche Belegen der
;                                Indizes nicht beeinfluﬂt (Beim
;                                n‰chsten normalen Aufruf wird
;                                beispielsweise mit Index 4
;                                fortgefahren).
;                                Wird genau das gew¸nscht, so kann
;                                jederzeit in START ein neuer
;                                Startwert f¸r die kontinuierliche
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
;           liefert auf jedem Display einen weiﬂen Plot! Ein anschlieﬂendes
;          OPlot, Array2, COLOR=RGB(255,0,0)
;           liefert dann auf jedem Display einen roten Plot, ohne daﬂ
;           sich die Farbe des ersten Plots ‰ndert!
;
; MODIFICATION HISTORY:
;
;        $Log$
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
  

   IF !D.Name EQ 'PS' THEN BEGIN
      ; korrekte Behandlung nur fuer Grauwertpostscripts 
      Color_Convert, R, G, B, h, s, v, /RGB_HSV
      IF !REVERTPSCOLORS THEN RETURN, 255-LONG(v*255) ELSE RETURN, LONG(v*255)
   END


   if !D.N_Colors LE 256 then begin  ; 256-Farb-Display mit Color-Map   
      IF Keyword_Set(NOALLOC) THEN BEGIN ; keine Farbe umdefienieren, sondern aehnlichste zurueckgeben
         myCM = bytarr(!D.Table_Size,3) 
         TvLCT, myCM, /GET
	 Color_Convert, myCM(*,0), myCM(*,1), myCM(*,2), myH, myS, myV, /RGB_HSV
	 Color_Convert, R, G, B, H, S, V, /RGB_HSV
	 differences = (myH - H)^2 + (myS - S)^2 + (myV - V)^2
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



