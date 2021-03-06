;+
; NAME:               OPPlot
;
; AIM:
;  Add dataset to an existing plot, and fill area below the line with
;  a color.
;
; PURPOSE:            Plottet einen Datensatz wie OPlot und fuellt die aufgespannte Flaeche aus.
;
; CATEGORY:           GRAPHIC
;
; CALLING SEQUENCE:   OPPlott [,x] ,y [,BASELINE=baseline] [,COLOR=color] [,/INVERSE]
;
; INPUTS:             y : die zu plottenden Ordinaten-Werte
;
; OPTIONAL INPUTS:    x : die y gehoerenden Abszissen-Werte
;
; KEYWORD PARAMETERS: BASELINE: gibt die Grundlinie fuer den Fullvorgang an. Default ist 0
;                     COLOR   : die Fuellfarbe
;                     INVERSE : spart die aufgespannte Flaeche beim Fuellen aus
;               
;                     SOWIE ALLE [O]PLOT - OPTIONEN 
;
; EXAMPLE:             
;                     pplot, 1-2*randomu(seed,50)
;                     opplot, 0.5-randomu(seed,50), color=rgb(250,0,0), baseline=-0.5
;
; SEE ALSO:           <A HREF=#PPLOT>PPlot</A>
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 2.4  2000/10/01 14:50:42  kupper
;     Added AIM: entries in document header. First NASE workshop rules!
;
;     Revision 2.3  1999/12/02 14:18:30  saam
;           + there was some senseless playing with !P.multi
;           + plotting of axes eliminated
;
;     Revision 2.2  1998/10/05 12:16:03  saam
;           + docheader added
;           + still problem with axis labelling
;
;
;-
PRO OPPlot, z, zz, BASELINE=baseline, COLOR=color, INVERSE=inverse, _EXTRA=e

   On_Error, 2
   Default, COLOR, !P.COLOR
   Default, BASELINE, 0.0


   IF N_Params() LT 1 THEN Message, 'wrong number of arguments'
   n = N_Elements(z)
   IF N_Params() EQ 2 THEN BEGIN
      x = z
      y = zz
   END ELSE BEGIN
      x = LindGen(n)
      y = z
   END
   
   x = [x, x(n-1),   x(n-1),     x(0), x(0)]

   IF Keyword_Set(INVERSE) THEN BEGIN
      ybase = (convert_coord(!Y.window, /NORMAL, /TO_DATA))(1)
   END ELSE BEGIN
      ybase = baseline
   END

   y = [y, y(n-1), ybase, ybase, y(0)]


   PolyFill, x, y, COLOR=color, NOCLIP=0

   IF NOT Keyword_Set(INVERSE) THEN PlotS, [x(0), x(n-1)], [baseline, baseline], COLOR=color, NOCLIP=0

   ; plot the axes without confusing !P.Multi

END
