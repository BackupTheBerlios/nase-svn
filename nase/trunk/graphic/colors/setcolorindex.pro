;+
; NAME: SetColorIndex
;
; PURPOSE: Setzt einen Eintrag des aktuellen Colortables
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
   
   if Nr gt !D.Table_Size-1 then message, "Der Farbindex ist nicht verfügbar!"

;    My_Color_Map = intarr(256,3) 
;    TvLCT, My_Color_Map, /GET  
;    My_Color_Map (Nr,*) = [R,G,B]
;    TvLCT,  My_Color_Map

   dummy = RGB(INDEX=Nr, R, G, B)

End
