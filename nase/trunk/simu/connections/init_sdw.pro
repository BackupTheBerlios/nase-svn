;+
; NAME:              Init_SDW
; 
; PURPOSE:           Initialisiert Listen in der DW-Structur
;
; CATEGORY:          INTERAL !!
;
; CALLING SEQUENCE:  Init_SDW, DW
;
; INPUTS:            DW : eine DelayWeigh-Struktur
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 2.1  1997/09/17 10:25:49  saam
;     Listen&Listen in den Trunk gemerged
;
;     Revision 1.1.2.1  1997/09/16 13:26:37  saam
;         Entstanden aus Auslagerung von InitDW
;
;
;-



PRO Init_SDW, DW

   FOR source=0, DW.source_w*DW.source_h-1 DO BEGIN
      wtn = WHERE(DW.Weights(*,source) NE !NONE, count)
      IF count NE 0 THEN DW.STarget(source) = Handle_Create( VALUE=wtn) ELSE DW.STarget(source) = -1
   ENDFOR 
   
   FOR target=0, DW.target_w*DW.target_h-1 DO BEGIN
      wsn = WHERE(DW.Weights(target,*) NE !NONE, count)
      IF count NE 0 THEN DW.SSource(target) = Handle_Create( VALUE=wsn, /NO_COPY) ELSE DW.SSource(target) = -1
   ENDFOR
      
END
