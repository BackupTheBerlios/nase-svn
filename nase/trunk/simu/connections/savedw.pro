;+
; NAME:               SaveDW
;
; PURPOSE:            Liefert eine speicherbare Variante
;                     einer DelayWeigh-Struktur zurueck
;
; CATEGORY:           SIMULATON CONNECTIONS
;
; CALLING SEQUENCE:   SavDW = SaveDW(DW)
;
; INPUTS:             DW: Eine mit RESTORE eingelesene DelayWeigh-Struktur
;
; OUPUTS:             SavDW: eine Struktur, die z.B. mit der IDL-Routine SAVE
;                            gespeichert werden kann
;
; MODIFICATION HISTORY:
;
;     $Log$
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
;-

FUNCTION SaveDW, _DW

   Handle_Value, _DW, DW
   DW.SSource = -1
   DW.STarget = -1
   DW.Learn = -1
   RETURN, DW

END
