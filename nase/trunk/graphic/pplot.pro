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
