;+
; NAME: SetColorIndex
;
; AIM: Set one entry in the current color table (or translation table
;      for truecolor).
;
; PURPOSE: Setzt einen Eintrag des aktuellen Colortables - AUCH auf
;          TrueColor Displays. (Dort kann die Verwendung der
;          Farbtabelle allerdings abgeschaltet werden, mit
;          Device, BYPASS_TRANSLATION=0)
;
; CATEGORY: Graphik
;
; CALLING SEQUENCE: SetColorIndex ( IndexNr, {R,G,B | name} )
;
; INPUTS: Entweder R,G,B im Bereich 0..255
;         oder name: ein bekannter Farbnamenstring (s. <A HREF="#../../alien/COLOR">Color</A>.)
;
; COMMON BLOCKS: Die Routine greift NICHT direkt auf den
;                COLORS-CommonBlock zu, den alle IDL-Grafikroutinen
;                benutzen. (Das geschieht aus Rücksicht auf
;                ev. Kompatibilitätsprobleme zw. IDL-Versionen),
;                sondern benutzt die IDL-TvLCT Routine.
;
; SIDE EFFECTS: Der entspr. Eintrag in der aktuellen Colormap wird verändert.
;
; PROCEDURE: Aufruf von <A HREF="#RGB">RGB()</A> mit Schlüsselwort INDEX.
;
; EXAMPLE: SetColorIndex, 100, 255,0,0     setzt die Farbe Nr. 100
;                                          auf rot.
;
;          SetColorIndex, 1, 'dark green'  setzt die Farbe Nr. 1 auf dunkelgrün.
;
;
; SEE ALSO: <A HREF="#RGB">RGB()</A>, <A HREF="#../../alien/COLOR">Color</A>.
;
; MODIFICATION HISTORY:
;
;       $Log$
;       Revision 1.11  2000/10/05 16:01:03  saam
;       * added warning for trying to set wrong color index
;
;       Revision 1.10  2000/10/01 14:50:57  kupper
;       Added AIM: entries in document header. First NASE workshop rules!
;
;       Revision 1.9  1999/11/04 17:31:41  kupper
;       Kicked out all the Device, BYPASS_TRANSLATION commands. They
;       -extremely- slow down performance on True-Color-Displays when
;       connecting over a network!
;       Furthermore, it seems to me, the only thing they do is to work
;       around a bug in IDL 5.0 that wasn't there in IDL 4 and isn't
;       there any more in IDL 5.2.
;       I do now handle this special bug by loading the translation table
;       with a linear ramp. This is much faster.
;       However, slight changes in behaviour on a True-Color-Display may
;       be encountered.
;
;       Revision 1.8  1998/03/20 16:11:52  thiel
;              Inkompatibilitaet IDL 3.6 vs 4.0 beseitigt.
;
;       Revision 1.7  1998/02/27 13:08:18  saam
;             benutzt nun UTvLCT fuer korrekte Farbauswahl
;
;       Revision 1.6  1998/02/26 14:33:36  kupper
;              Setzt jetzt wieder IMMER die Farbtabelle - auch auf 24bit Displays.
;
;       Revision 1.5  1998/02/26 14:12:46  saam
;             Aenderungen der letzten Revision wegen Probleme
;             mit 32-Bit-Diplay zurueckgenommen
;
;       Revision 1.4  1998/02/23 16:20:41  kupper
;              Benutzt jetzt RGB() und kann Farbnamen.
;
;
;       Fri Aug 1 15:18:27 1997, Ruediger Kupper
;       <kupper@sisko.physik.uni-marburg.de>
;
;		Urversion erstellt.
; 
;-

Pro SetColorIndex, Nr, R, G, B
   
   if Nr gt !D.Table_Size-1 THEN BEGIN
       Console, "color index out of range", /WARN
       RETURN
   END
   If (Size(R))(1) eq 7 then Color, R, /EXIT, RED=R, GREEN=G, BLUE=B

   My_Color_Map = intarr(!D.Table_Size,3) ;IDL 3.6
    ;My_Color_Map = [0]                   ;IDL 4
 
   UTvLCT, My_Color_Map, /GET   ;Das /GET-Keyword belegt in IDL 3.6 nur
                                ;die schon bestehende Variable My_Color_Map,
                                ;deshalb muss sie mit der richtigen Groesse
                                ;initialisiert werden

    My_Color_Map (Nr,*) = [R,G,B]
    UTvLCT,  My_Color_Map

End
