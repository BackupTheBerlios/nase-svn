;+
; NAME:                CIndex2RGB
;
; PURPOSE:             Errechnet aus einem Color-Index den
;                      zugehoerigen RGB-Wert. Die Translation-
;                      Tables bei True-Color-Displays werden 
;                      ignoriert                    
;
; CATEGORY:            GRAPHIC
;
; CALLING SEQUENCE:    rgb = CIndex2RGB(cindex)
;
; INPUTS:              cindex: ein Color-Index
;
; OUTPUTS:             rgb:    ein drei-elementiges Array das
;                              die Rot-, Gruen-, und Blau-
;                              Anteile der zug. Farbe enthaelt
;
; RESTRICTIONS:        cindex liefert nur fuer sinnvolle Farb-
;                      indizes einen sinnvollen Wert
;
; EXAMPLE:
;           rgb = CIndex2RGB(2374632)
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 2.2  2000/08/31 10:23:26  kupper
;     Changed to use ScreenDevice() instead of 'X' in Set_Plot for platform independency.
;
;     Revision 2.1  1997/11/05 09:54:02  saam
;           der Klapperstorch hat's gebracht
;
;
;-
FUNCTION CIndex2RGB, cindex

   IF !D.Name EQ ScreenDevice() AND !D.N_COLORS EQ 16777216 THEN BEGIN
      b = cindex / 65536 
      g = (cindex MOD 65536)/256
      r = cindex MOD 256
      RETURN, [r,g,b]
   END ELSE RETURN, GetColorIndex(cindex) 

END
