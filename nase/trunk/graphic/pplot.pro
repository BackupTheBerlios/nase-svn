;+
; NAME:               PPlot
;
; PURPOSE:            Plottet einen Datensatz wie Plot und fuellt die aufgespannte Flaeche aus.
;
; CATEGORY:           GRAPHIC
;
; CALLING SEQUENCE:   PPlott [,x] ,y [,BASELINE=baseline] [,COLOR=color] [,/INVERSE]
;
; INPUTS:             y : die zu plottenden Ordinaten-Werte
;
; OPTIONAL INPUTS:    x : die y gehoerenden Abszissen-Werte
;
; KEYWORD PARAMETERS: BASELINE: gibt die Grundlinie fuer den Fullvorgang an. Default ist 0
;                     COLOR   : die Fuellfarbe
;                     INVERSE : spart die aufgespannte Flaeche beim Fuellen aus
;               
;                     SOWIE ALLE PLOT - OPTIONEN 
;
; EXAMPLE:             
;                     pplot, 1-2*randomu(seed,50)
;                     opplot, 0.5-randomu(seed,50), color=rgb(250,0,0), baseline=-0.5
;
; SEE ALSO:           <A HREF=#OPPLOT>OPPlot</A>
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 2.2  1998/10/05 12:16:03  saam
;           + docheader added
;           + still problem with axis labelling
;
;
;-
PRO PPlot, z, zz, COLOR=color, BASELINE=baseline, INVERSE=inverse, _EXTRA=e

   On_Error, 2
   Default, COLOR   , !P.COLOR
   Default, BASELINE, 0.0
   Default, INVERSE, 0

   IF N_Params() LT 1 THEN Message, 'wrong number of arguments'
   n = N_Elements(z)
   IF N_Params() EQ 2 THEN BEGIN
      x = REFORM(z)
      y = REFORM(zz)
   END ELSE BEGIN
      x = LindGen(n)
      y = REFORM(z)
   END
   IF N_Elements(x) NE N_Elements(y) THEN Message, 'abszissa and ordinate values are of different count'
   


   Plot, x, y, COLOR=color, /NODATA, _EXTRA=e
 
   OPPlot, x, y, COLOR=color, BASELINE=baseline, INVERSE=inverse, _EXTRA=e
   

END
