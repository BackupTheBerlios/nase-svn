;+
; NAME:
;  SaveDW()
;
; AIM: Generate version of DW structure that can be saved.
;
; PURPOSE:            Liefert eine speicherbare Variante
;                     einer DelayWeigh-Struktur zurueck
;
; CATEGORY:
;  Simulation / Connections
;
; CALLING SEQUENCE:   SavDW = SaveDW(DW)
;
; INPUTS:             DW:: Eine mit RESTORE eingelesene DelayWeigh-Struktur
;
; OUTPUTS:             SavDW:: eine Struktur, die z.B. mit der IDL-Routine SAVE
;                            gespeichert werden kann
;
; SEE ALSO: RestoreDW
;
;-
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 2.6  2003/08/27 15:39:47  michler
;
;     Modified Files:
;     	savedw.pro
;     some header corrections
;
;     Revision 2.5  2000/09/25 16:49:13  thiel
;         AIMS added.
;
;     Revision 2.4  1998/02/05 13:16:03  saam
;           + Gewichte und Delays als Listen
;           + keine direkten Zugriffe auf DW-Strukturen
;           + verbesserte Handle-Handling :->
;           + vereinfachte Lernroutinen
;           + einige Tests bestanden
;
;     Revision 2.3  1998/01/05 18:04:40  saam
;           very sophisticated...
;           die speicherbare Version enthaelt
;           nun keine Handles mehr. Gab fiese
;           Probleme beim Restaurieren in
;           Kombination mit init_sdw
;
;     Revision 2.2  1998/01/05 17:45:26  saam
;           testversion
;
;     Revision 2.1  1997/12/10 16:05:41  saam
;           Birth
;
;


FUNCTION SaveDW, DW

   IStr = Info(DW) 
   IF (IStr EQ 'SDW_WEIGHT') OR (IStr EQ 'SDW_DELAY_WEIGHT') THEN sdw = 1 ELSE sdw = 0
   IF NOT sdw AND (IStr NE 'DW_WEIGHT') AND (IStr NE 'DW_DELAY_WEIGHT') THEN Message,'DW structure expected, but got '+iStr+' !'

   IF sdw THEN BEGIN
      thDW =  SDW2DW(DW, /KEEP_ARGUMENT)
      Handle_Value, thDW, tDW, /NO_COPY
      Handle_Free, thDW
   END ELSE BEGIN
      Handle_Value, DW, tDW 
   END

   RETURN, tDW

END
