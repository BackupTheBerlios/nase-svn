;+
; NAME:
;  WeightCount()
;
; AIM: Count existing connections (NE !None) contained in DW structure. 
;
; PURPOSE:            Zaehlt die vorhandenen (nicht !NONE) Verbindungen in
;                     einer DW-Struktur.
;
; CATEGORY:
;  Simulation / Connections
;
; CALLING SEQUENCE:   c = WeightCount(DW)
;
; INPUTS:             DW: eine mit InitDW initialisierte DW-Struktur
;
; OUTPUTS:            c: die Zahl der Gewichte
;
;-
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 2.2  2000/09/25 16:49:14  thiel
;         AIMS added.
;
;     Revision 2.1  1998/02/05 13:10:16  saam
;           Cool
;

FUNCTION WeightCount, DW

   IStr = Info(DW) 
   IF (IStr EQ 'SDW_WEIGHT') OR (IStr EQ 'SDW_DELAY_WEIGHT') THEN sdw = 1 ELSE sdw = 0
   IF NOT sdw AND (IStr NE 'DW_WEIGHT') AND (IStr NE 'DW_DELAY_WEIGHT') THEN Message,'[S]DW[_DELAY]_WEIGHT structure expected, but got '+iStr+' !'
   
   IF sdw THEN BEGIN
      Handle_Value, DW, tDW, /NO_COPY
      nr = N_Elements(tDW.W)
      IF nr EQ 1 AND tDW.W(0) EQ -1 THEN nr = 0
      Handle_Value, DW, tDW, /NO_COPY, /SET
      RETURN, nr
   END ELSE BEGIN
      Handle_Value, DW, tDW, /NO_COPY
      dummy = WHERE(tDW.Weights NE !NONE, c)
      Handle_Value, DW, tDW, /NO_COPY, /SET
      RETURN, c
   END      

END
