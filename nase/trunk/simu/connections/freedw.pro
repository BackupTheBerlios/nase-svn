;+
; NAME:                FreeDW
;
; PURPOSE:             Gibt den von InitDW belegten dynamischen Speicher wieder frei
;
; CATEGORY:            SIMULATION
;
; CALLING SEQUENCE:    FreeDW, Layer
;
; INPUTS:              Layer: eine mit InitDW initialisierte Struktut
;
; SIDE EFFECTS:        Layer ist nach den Aufruf nicht mehr verwendbar
;
; EXAMPLE:             
;                      Layer = InitDW(....)
;                      FreeDW, Layer
;
; MODIFICATION HISTORY:
;
;       Fri Sep 12 10:47:40 1997, Mirko Saam
;       <saam@ax1317.Physik.Uni-Marburg.DE>
;       $Revision$
;
;		Schoepfung 
;
;-
PRO FreeDW, DW

   FOR source=0, DW.source_w*DW.source_h-1 DO IF DW.STarget(source) NE -1 THEN BEGIN
      Handle_Free, DW.STarget(source) 
      DW.STarget(source) = -1
   END

   FOR target=0, DW.target_w*DW.target_h-1 DO IF DW.SSource(target) NE -1 THEN BEGIN
      Handle_Free, DW.SSource(target)
      DW.SSource(target) = -1
   END

   IF DW.Learn NE -1 THEN Handle_Free, DW.Learn

END
