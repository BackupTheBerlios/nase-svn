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
;       Revision 2.9  1998/02/11 18:03:37  saam
;             neuer Tag brachte keine Effizienz --> wieder weg
;
;       Revision 2.8  1998/02/11 15:43:11  saam
;             Geschwindigkeitsoptimierung durch eine neue Liste
;             die source- auf target-Neuronen abbildet
;
;       Revision 2.7  1998/02/05 13:16:01  saam
;             + Gewichte und Delays als Listen
;             + keine direkten Zugriffe auf DW-Strukturen
;             + verbesserte Handle-Handling :->
;             + vereinfachte Lernroutinen
;             + einige Tests bestanden
;
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

   IF (Info(_DW) EQ 'DW_DELAY_WEIGHT') OR (Info(_DW) EQ 'DW_WEIGHT') THEN RETURN
   IF (Info(_DW) NE 'SDW_DELAY_WEIGHT') AND (Info(_DW) NE 'SDW_WEIGHT') THEN Message,'expected DW structure but got '+STRING(Info(_DW))+' !'

   Handle_Value, _DW, DW, /NO_COPY

   FOR s=0, DW.source_w*DW.source_h-1 DO IF DW.S2C(s) NE -1 THEN BEGIN
      Handle_Free, DW.S2C(s) 
      DW.S2C(s) = -1
   END

   FOR t=0, DW.target_w*DW.target_h-1 DO IF DW.T2C(t) NE -1 THEN BEGIN
      Handle_Free, DW.T2C(t)
      DW.T2C(t) = -1
   END

   IF Contains(DW.info, 'DELAY', /IGNORECASE) THEN FreeSpikeQueue, DW.Queue 

   IF DW.Learn NE -1 THEN Handle_Free, DW.Learn

   Handle_Free, _DW

END
