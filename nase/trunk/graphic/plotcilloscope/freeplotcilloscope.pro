;+
; NAME:                FreePlotcilloscope
; 
; AIM:
;  Free the dynamic memory allocated by a plotcilloscope structure.
;
; PURPOSE:             Gibt ein Plotcilloscope frei.
;                      (Siehe auch <A HREF="#PLOTCILLOSCOPE">Plotcilloscope</A>)
;
; CATEGORY:            GRAPHIC PLOTCILLOSCOPE
;
; CALLING SEQUENCE:    FreePlotcilloscope, PS
;
; INPUTS:              PS: eine mit InitPlotcilloscope initialisierte
;                          Struktur
;
; EXAMPLE:
;            PS = InitPlotcilloscope(TIME=100)
;            FOR i=0,199 DO BEGIN
;               y = 100-i+15.*RandomU(seed,1)
;               Plotcilloscope, PS, y
;               wait, 0.06
;            END
;            FOR i=0,199 DO BEGIN
;               y = -100+i+15.*RandomU(seed,1)
;               Plotcilloscope, PS, y
;               wait, 0.06
;            END
;            FreePlotcilloscope, PS
;
; SEE ALSO:  <A HREF="#INITPLOTCILLOSCOPE">InitPlotcilloscope</A>, <A HREF="#PLOTCILLOSCOPE">Plotcilloscope</A>
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 2.2  2000/10/01 14:51:23  kupper
;     Added AIM: entries in document header. First NASE workshop rules!
;
;     Revision 2.1  1998/11/08 14:29:15  saam
;          is needed to free the handles
;
;
;-
PRO FreePlotcilloscope, _PS

   On_Error, 2

   TestInfo, _PS, 'T_PLOT'
   Handle_Free, _PS
END
