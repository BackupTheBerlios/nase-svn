;+
; NAME: SetColorIndex
;
; PURPOSE: Setzt einen Eintrag des aktuellen Colortables - AUCH auf
;          TrueColor Displays. (Dort kann die Verwendung der
;          Farbtabelle allerdings abgeschaltet werden, mit
;          Device, BYPASS_TRANSLATION=0)
;
; CATEGORY: Graphik
;
; CALLING SEQUENCE: SetColoRindex ( IndexNr, {R,G,B | name} )
;
; INPUTS: Entweder R,G,B im Bereich 0..255
;         oder name: ein bekannter Farbnamenstring (s. <A HREF="#../../alien/COLOR">Color</A>.)
;
; COMMON BLOCKS: Die Routine greift NICHT direkt auf den
;                COLORS-CommonBlock zu, den alle IDL-Grafikroutinen
;                benutzen. (Das geschieht aus R�cksicht auf
;                ev. Kompatibilit�tsprobleme zw. IDL-Versionen),
;                sondern benutzt die IDL-TvLCT Routine.
;
; SIDE EFFECTS: Der entspr. Eintrag in der aktuellen Colormap wird ver�ndert.
;
; PROCEDURE: Aufruf von <A HREF="#RGB">RGB()</A> mit Schl�sselwort INDEX.
;
; EXAMPLE: SetColorIndex, 100, 255,0,0     setzt die Farbe Nr. 100
;                                          auf rot.
;
;          SetColorIndex, 1, 'dark green'  setzt die Farbe Nr. 1 auf dunkelgr�n.
;
;
; SEE ALSO: <A HREF="#RGB">RGB()</A>, <A HREF="#../../alien/COLOR">Color</A>.
;
; MODIFICATION HISTORY:
;
;       $Log$
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
   
   if Nr gt !D.Table_Size-1 then message, "Der Farbindex ist nicht verf�gbar!"

   If (Size(R))(1) eq 7 then Color, R, /EXIT, RED=R, GREEN=G, BLUE=B

;    My_Color_Map = intarr(!D.Table_Size,3) 
    My_Color_Map = [0]
 
    UTvLCT, My_Color_Map, /GET  
    My_Color_Map (Nr,*) = [R,G,B]
    UTvLCT,  My_Color_Map

End
