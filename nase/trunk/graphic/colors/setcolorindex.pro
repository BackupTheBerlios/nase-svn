;+
; NAME: SetColorIndex
;
;
;
; PURPOSE: Setzt einen Eintrag des aktuellen Colortables
;
;
;
; CATEGORY: Graphik
;
;
;
; CALLING SEQUENCE: SetColoRindex ( IndexNr, R, G, B )
;
;
; 
; INPUTS: klar!    R,G,B im Bereich 0..255
;
;
;
; OPTIONAL INPUTS: ---
;
;
;	
; KEYWORD PARAMETERS: ---
;
;
;
; OUTPUTS: ---
;
;
;
; OPTIONAL OUTPUTS: ---
;
;
;
; COMMON BLOCKS: Die Routine greift NICHT direkt auf den
;                COLORS-CommonBlock zu, den alle IDL-Grafikroutinen
;                benutzen. (Das geschieht aus Rücksicht auf
;                ev. Kompatibilitätsprobleme zw. IDL-Versionen),
;                sondern benutzt die IDL-TvLCT Routine.
;
;
;
; SIDE EFFECTS: Der entspr. Eintrag in der aktuellen Colormap wird verändert.
;
;
;
; RESTRICTIONS: ---
;
;
;
; PROCEDURE: ---
;
;
;
; EXAMPLE: SetColorIndex, 100, 255,0,0     setzt die Farbe Nr. 100
;                                          auf rot.
;
;
;
; MODIFICATION HISTORY:
;
;       Fri Aug 1 15:18:27 1997, Ruediger Kupper
;       <kupper@sisko.physik.uni-marburg.de>
;
;		Urversion erstellt.
;
;-

Pro SetColorIndex, Nr, R, G, B
   
   if Nr gt !D.Table_Size-1 then message, "Der Farbindex ist nicht verfügbar!"

    My_Color_Map = intarr(256,3) 
    TvLCT, My_Color_Map, /GET  
    My_Color_Map (Nr,*) = [R,G,B]
    TvLCT,  My_Color_Map

End
