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

   winnr = (MAX([1,!P.Multi(1)])*MAX([1,!P.Multi(2)]))
   
   !P.multi(0) = (!P.multi(0)+1) MOD winnr
   plot,x,y,/NODATA,/NOERASE,_EXTRA=e
   !P.multi(0) = (!P.multi(0)+winnr-1) MOD winnr

END
