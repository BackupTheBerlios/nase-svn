;+
; NAME:              GetColorIndex
;
; PURPOSE:           Ermittelt einen Eintrag des aktuellen Colortables
;
; CATEGORY:          GRAPHIC
;
; CALLING SEQUENCE:  Color = GetColorIndex(IndexNr)
;
; INPUTS:            IndexNr : der Index des gewuenschten Farbtabelleneintrags
;
; OUTPUTS:           Color   : ein 3-elementiges Array, das RGB-Werte enthaelt
;
; COMMON BLOCKS: Die Routine greift NICHT direkt auf den
;                COLORS-CommonBlock zu, den alle IDL-Grafikroutinen
;                benutzen. (Das geschieht aus Rücksicht auf
;                ev. Kompatibilitätsprobleme zw. IDL-Versionen),
;                sondern benutzt die IDL-TvLCT Routine.
;
; EXAMPLE: 
;                Color = GetColorIndex(25)
;
; MODIFICATION HISTORY:
;
;       $Log$
;       Revision 2.1  1997/11/05 09:46:30  saam
;             das Pendant zu SetColorIndex
;
;
;-
FUNCTION GetColorIndex, Nr
   
   IF Nr GT !D.Table_Size-1 THEN MESSAGE, "colour index not availible"

    My_Color_Map = intarr(256,3) 
    TvLCT, My_Color_Map, /GET  

    RETURN, My_Color_Map(Nr,*)
END
