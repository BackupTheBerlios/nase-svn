PRO Analayer, _LS, L

   On_Error,2

   Handle_Value, _LS, LS, /NO_COPY

   ;====> OUTPUT LATEST ACTIVITY
   Sh = LS.Sh
   OpenSheet, Sh, 1

   activity = LayerSpikes(L, /DIMENSIONS)
   nasetv, (activity*200)+55, 0.5, 0.5, STRETCH=LS.stretch, /CENTER

   CloseSheet, Sh, 1
   LS.Sh = Sh

   
   ;====> OUTPUT MEAN ACTIVITY
   IF (LS.t+1) MOD 100 EQ 0 THEN BEGIN
      SB = LS.Sh
      OpenSheet, Sh, 0
      tmp = TRANSPOSE(LS.tot / FLOAT(LS.t) * 1000. * LS.os)
      PlotTvScl, tmp, TITLE="Mean Rate [Hz]", XTITLE='time: '+STRCOMPRESS((LS.t+1)/LS.os, /REMOVE_ALL)+' ms', /LEGEND
      CloseSheet, Sh, 0
      LS.Sh = Sh
   END

   LS.tot = LS.tot + activity
   LS.t = LS.t + 1

   Handle_Value, _LS, LS, /NO_COPY, /SET
END
