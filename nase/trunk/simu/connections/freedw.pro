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
;       $Log$
;       Revision 2.6  1997/12/10 15:53:38  saam
;             Es werden jetzt keine Strukturen mehr uebergeben, sondern
;             nur noch Tags. Das hat den Vorteil, dass man mehrere
;             DelayWeigh-Strukturen in einem Array speichern kann,
;             was sonst nicht moeglich ist, da die Strukturen anonym sind.
;
;       Revision 2.5  1997/12/02 10:04:55  saam
;             Funktionalitaet der SpikeQueue wurde auf dynamische
;             Speicherbelegung umgestellt. Deshalb muss im ver-
;             zoegerten Fall, dieser Speicher freigegeben werden.
;
;       Revision 2.4  1997/10/27 14:28:49  kupper
;             1. Der Learn-Tag wird jetzt nur noch freigegeben, wenn er auch existiert!
;             2. Im Header stand kein Log-Eintrag, daher ist die Mod.Hist. nicht vollständig.
;
;       Fri Sep 12 10:47:40 1997, Mirko Saam
;       <saam@ax1317.Physik.Uni-Marburg.DE>
;	      Schoepfung 
;
;-
PRO FreeDW, _DW

   Handle_Value, _DW, DW, /NO_COPY

   FOR source=0, DW.source_w*DW.source_h-1 DO IF DW.STarget(source) NE -1 THEN BEGIN
      Handle_Free, DW.STarget(source) 
      DW.STarget(source) = -1
   END

   FOR target=0, DW.target_w*DW.target_h-1 DO IF DW.SSource(target) NE -1 THEN BEGIN
      Handle_Free, DW.SSource(target)
      DW.SSource(target) = -1
   END

   IF Contains(DW.info, 'DELAY', /IGNORECASE) THEN FreeSpikeQueue, DW.Queue 

   IF DW.Learn NE -1 THEN Handle_Free, DW.Learn

   Handle_Free, _DW

END
