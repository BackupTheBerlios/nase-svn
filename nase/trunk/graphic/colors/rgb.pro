;+
; NAME: RGB()
;
; VERSION:
;  $Id$
;
; AIM:
;  Define color for plotting, works on truecolor and pseudocolor displays.
;
; PURPOSE:
;  Ermöglicht die Angabe von Farbwerten im RGB-Format, und zwar ohne
;  Änderung sowohl auf Echtfarb- als auch auf ColorTable-Systemen. 
;
; CATEGORY:
;  Color
;  Graphic
;
; CALLING SEQUENCE: 
;  Der übliche Aufruf von RGB() geschieht in einer Graphikprozedur im
;  COLOR-Schlüsselwort.
;                   
;* COLOR= RGB( {Rot,Grün,Blau | Farbname}
;*              [,INDEX=Farbindex] [,START=Startindex] 
;*              [,/NOALLOC] )
;                    
; INPUTS: Entweder Rot, Grün, Blau: Werte im Bereich 0..255, die die
;                                   gewünschte Farbe definieren,
;         oder            Farbname: Ein String mit einem bekannten
;                                   Farbnamen (see <A>Color</A>.)
;
; KEYWORD PARAMETERS:
;
;         Farbindex:: Dieser Wert hat nur Bedeutung, wenn man sich auf einem
;                          ColorTable-Display befindet. Dann kann hier
;                          nämlich der Farbindex angegeben werden, der
;                          mit der neuen Farbe belegt werden soll.
;                          Default ist der nächste "freie" Farbindex,
;                          wobei beim ersten Aufruf mit dem Index 1
;                          begonnen wird, sofern nicht im
;                          Schlüsselwort START etwas anderes definiert
;                          wird. (S.a. Erläuterung unten)
;         Startindex:: Dieser Wert hat nur Bedeutung, wenn man sich auf einem
;                          ColorTable-Display befindet. Dann kann hier
;                          nämlich der Startwert für den (also der erste zu
;                          belegende) Farbindex angegeben werden, der
;                          dann von Aufruf zu Aufruf hochgezählt
;                          wird. (S.a. Erläuterung unten)
;         NOALLOC:: Falls gesetzt, wird bei 8-bit-Displays keine Farbe allokiert,
;                          sondern eine moeglichst aehnliche zurueckgegeben. Auf allen
;                          anderen Displays wird diese Option ignoriert
;
;                 
; OUTPUTS: 
;          Auf einem Pseudocolor/Truecolor-Display (vgl. <A>Pseudocolor_Visual()</A>):
;                 Der Farbindex, der mit der neuen Farbe belegt wurde, bzw.
;                 der Farbindex einer moeglichst aehnlichen Farbe bei
;                 Keyword NOALLOC
;
; COMMON BLOCKS: common_RGB, My_freier_Farbindex
;                (Wird bisher nur von dieser Funktion verwendet)
;
; SIDE EFFECTS: Die Farbtabelle wird verändert.
;
; RESTRICTIONS: 
;               WICHTIG: Damit RGB() den Displaytyp richtig ermittelt,
;                        muß die Farbinformation in der !D-Varible
;                        etabliert sein. D.h. es muß vorher mindestens
;                        einmal ein Fenster geöffnet worden sein!
;
; PROCEDURE:
;* 1. bestimmen des nächsten freien Farbindex I:
;*     Ist INDEX=Farbindex gesetzt?
;*     ja  : I=Farbindex.
;*     nein: Ist START=Startindex gesetzt?
;*           ja  : I=Startindex.
;*           nein: Ist dies der erste Aufruf von RGB()?
;*                 ja  : I=1.
;*                 nein: I=letzter nicht mit INDEX produzierter Farbindex+1.
;*
;*
;* 2. Index I mit der neuen Farbe besetzen und I als Ergebnis zurückgeben.
;
; Das heißt: Wird RGB() ohne Keyword-Parameter aufgerufen, so belegt
; es beim ersten Aufruf den Index 1 und liefert auch als Ergebnis 1
; zurück. Im nächsten Aufruf wird dann Index 2 belegt und
; zurückgeliefert, dann 3 u.s.w. Zu jeder Zeit kann man einen
; bestimmten Index in INDEX wählen, der dann belegt und
; zurückgeliefert wird, was das kontinierliche Belegen der Indizes
; nicht beeinflußt (Beim nächsten normalen Aufruf wird beispielsweise
; mit Index 4 fortgefahren). Wird genau das gewünscht, so kann
; jederzeit in START ein neuer Startwert für die kontinuierliche
; Belegung angegeben werden.<BR>
;
; Bspl: -Neustart von IDL-
;* print, RGB(255,0,0)  -> Ausgabe: 1 (und der Farbindex 1 wird mit rot belegt.)
;* print, RGB(0,255,0)  -> Ausgabe: 2 (entsprechend)
;* print, RGB(0,0,255,INDEX=23) -> Ausgabe: 23 (und der Farbindex 23 wird mit blau belegt)
;* print, RGB(0,0,0)    -> Ausgabe: 3
;* print, RGB(4,5,6,START=100) -> Ausgabe: 100
;* print, RGB(7,8,9)    -> Ausgabe: 101
;
; HINWEIS: IN DER REGEL BRAUCHT MAN SICH UM DIESEN GANZEN INDEXKRAM
; NICHT ZU KUEMMERN! (S. EXAMPLE) 
;        
; EXAMPLE:
;* Plot, Array, COLOR=RGB(255,255,255) 
; liefert auf jedem Display einen weißen Plot! Ein anschließendes
;* OPlot, Array2, COLOR=RGB(255,0,0)
; liefert dann auf jedem Display einen roten Plot, ohne daß sich die
; Farbe des ersten Plots ändert!
;
;-
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 1.34  2000/11/29 14:25:27  thiel
;            Header cosmetics.
;
;        Revision 1.33  2000/10/23 14:04:38  kupper
;        Changed a debug message to use new DMsg command.
;
;        Revision 1.32  2000/10/06 12:53:18  saam
;        rgb now always allocates private colors even if there
;        are matching entries in the lower part of the palette
;
;        Revision 1.31  2000/10/05 17:31:10  saam
;        just sets new color index if needed
;
;        Revision 1.30  2000/10/05 16:42:44  saam
;        i hate this nfs stuff
;
;        Revision 1.29  2000/10/05 16:40:59  saam
;        added NOALLOC support for PSEUDOCOLOR visuals, again
;
;        Revision 1.28  2000/10/05 16:23:08  saam
;        last two color indices of palette are not
;        overwritten to protect black & white
;
;        Revision 1.27  2000/10/05 10:26:30  saam
;        *INDEX,NOALLOC removed
;        *allocates only colors GT !TOPCOLOR
;
;        Revision 1.26  2000/10/01 14:50:57  kupper
;        Added AIM: entries in document header. First NASE workshop rules!
;
;        Revision 1.25  2000/08/31 14:59:15  kupper
;        Typo.
;
;        Revision 1.24  2000/08/31 10:23:26  kupper
;        Changed to use ScreenDevice() instead of 'X' in Set_Plot for platform independency.
;
;        Revision 1.23  2000/07/24 13:13:17  saam
;               + true color display are now similarly handled
;                 as color table displays, because using DECOMPOSED=0
;                 always uses the color table (START, INDEX, ...)
;               + allocating more than 256 color (in the whole) session
;                 doesn't any longer produce an error, but overwrites
;                 the oldest colors
;
;        Revision 1.22  2000/04/03 13:23:48  kupper
;        NOALLOC broke on non-Pseudocolor visuals.
;        Fixed.
;
;        Revision 1.21  2000/03/07 14:39:09  kupper
;        corrected hyperlink.
;
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


FUNCTION RGB_berechnen, R,G,B  ; je 0..255      
   Return, long(R) + long(256)*G + long(65536)*B      
END   
   
FUNCTION RGB, R,G,B, INDEX=index, $; je 0..255
                      START=start,$
                      NOALLOC=noalloc
Common common_RGB, ucc

;;; ucc : user color counter; counter for the reserved color indices
;;;       protected from overwriting by Uloadct, indicated by !TOPCOLOR;
;;;       ucc = 0 points to !TOPCOLOR+1

if set(index)   THEN Console, "keyword INDEX is obsolete, please remove", /WARN

   If (Size(R))(1) eq 7 then Color, R, /EXIT, RED=R, GREEN=G, BLUE=B


   ;; order of following cases matters:

   ;; ---- PS, and !PSGREY set: -------------------------------------------------
   IF (!D.Name EQ 'PS') and !PSGREY THEN BEGIN
      ; korrekte Behandlung nur fuer Grauwertpostscripts 
      New_Color_Convert, R, G, B, y, i, c, /RGB_YIC
      IF !REVERTPSCOLORS THEN RETURN, 255-LONG(y) ELSE RETURN, LONG(y)
   END
   ;; ---------------------------------------------------------------------------


   ;; ---- NOALLOC --------------------------------------------------------------
   IF Keyword_Set(NOALLOC) THEN BEGIN 
       IF NOT Pseudocolor_Visual() THEN BEGIN
           Dmsg, "ignoring keyword NOALLOC in true color mode"
       END ELSE BEGIN
           ;; keine Farbe umdefinieren, sondern aehnlichste zurueckgeben
           myCM = bytarr(!D.Table_Size,3) 
           TvLCT, myCM, /GET
           New_Color_Convert, myCM(*,0), myCM(*,1), myCM(*,2), myY, myI, myC, /RGB_YIC
           New_Color_Convert, R, G, B, Y, I, C, /RGB_YIC
           differences = (myY - Y)^2 + (myI - I)^2 + (myC - C)^2
           lowestDiff = MIN(differences, bestMatch)
           RETURN, bestMatch
       END
   END
   ;; ---------------------------------------------------------------------------



   ;;; search if color is already in palette
   currentColorMap = bytarr(!D.Table_Size,3) 
   TvLCT, currentColorMap, /GET
   matchIdx = MAX(CutSet(CutSet(WHERE(currentColorMap(*,0) EQ R), WHERE(currentColorMap(*,1) EQ G)), WHERE(currentColorMap(*,2) EQ B)))
   IF (matchIdx GT !TOPCOLOR) THEN RETURN, MAX(matchIdx)


   ;;; ok, we have to set a new index
   Default, ucc, -1
   ucc = (ucc + 1) MOD (!D.TABLE_SIZE - !TOPCOLOR - 1 - 2) 
                                ; -2 protects black and white from
                                ; overwrite
   index_to_set = !TOPCOLOR + 1 + ucc


   ; one way to save colors would suggest:
   ; search if the color is already defined by rgb and
   ; return the corresponding index

   ;; ---- Screen (X, MAC or WIN), and not pseudocolor: ---------------------------------------
   IF (!D.Name EQ ScreenDevice()) AND NOT Pseudocolor_Visual() THEN BEGIN
      SetColorIndex, index_to_set, R, G, B  
   ENDIF ELSE BEGIN
   ;; ---- all other devices: -------------------------------------------------   
       My_Color_Map = bytarr(!D.Table_Size,3) 
       TvLCT, My_Color_Map, /GET  
       My_Color_Map (index_to_set,*) = [R,G,B]  
       TvLCT, Temporary(My_Color_Map)
   END

;   if not set(index) then begin
;       ucc = (ucc + 1) MOD (!D.TABLE_SIZE - !TOPCOLOR - 1)
;       My_freier_Farbindex = !TOPCOLOR + 1 + ucc
;      if My_freier_Farbindex eq 0 then message, /INFORM, "!Farbpalette voll!"  
;      return, My_Freier_Farbindex-1
;   end
   return, index_to_set
   ;; ---------------------------------------------------------------------------

END
