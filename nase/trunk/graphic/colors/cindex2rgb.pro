;+
; NAME:                CIndex2RGB
;
; VERSION:             $Id$
;
; AIM: Compute 8 bit RGB values from a 24 bit Truecolor value.
;
; PURPOSE:             Errechnet aus einem Color-Index den
;                      zugehoerigen RGB-Wert. Die Translation-
;                      Tables bei True-Color-Displays werden 
;                      ignoriert. 
;                      DEVICE, DECOMPOSED=xx  will be considered.                    
;
; CATEGORY:            GRAPHIC
;
; CALLING SEQUENCE:    
;*                     rgb = CIndex2RGB(cindex)
;
; INPUTS:              cindex:: ein Color-Index
;
; OUTPUTS:             rgb::    ein drei-elementiges Array das
;                              die Rot-, Gruen-, und Blau-
;                              Anteile der zug. Farbe enthaelt
;
; RESTRICTIONS:        cindex liefert nur fuer sinnvolle Farb-
;                      indizes einen sinnvollen Wert
;
; EXAMPLE:
;*           rgb = CIndex2RGB(2374632)
;-
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 2.7  2000/10/31 19:02:18  gabriel
;         decompose gibts bei PS nicht
;
;     Revision 2.6  2000/10/30 18:31:26  gabriel
;          header bug
;
;     Revision 2.5  2000/10/30 10:40:34  gabriel
;           DEVICE DECOMPOSED is now considered
;
;     Revision 2.4  2000/10/27 18:57:22  gabriel
;          TrueColorMode only with colortables (nase restriction)
;
;     Revision 2.3  2000/10/01 14:50:57  kupper
;     Added AIM: entries in document header. First NASE workshop rules!
;
;     Revision 2.2  2000/08/31 10:23:26  kupper
;     Changed to use ScreenDevice() instead of 'X' in Set_Plot for platform independency.
;
;     Revision 2.1  1997/11/05 09:54:02  saam
;           der Klapperstorch hat's gebracht
;
;
;
FUNCTION CIndex2RGB, cindex
   default, DECOMPOSED, 0
   IF !D.Name EQ ScreenDevice() then DEVICE, GET_DECOMPOSED=DECOMPOSED
   IF !D.Name EQ ScreenDevice() AND $ 
    !D.N_COLORS EQ 16777216 AND $
    DECOMPOSED EQ 1 THEN BEGIN
      stop
      b = cindex / 65536 
      g = (cindex MOD 65536)/256
      r = cindex MOD 256
      RETURN, [r,g,b]
   END ELSE RETURN, GetColorIndex(cindex) 

END
