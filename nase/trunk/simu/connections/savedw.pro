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
;     Revision 2.1  1997/12/10 16:05:41  saam
;           Birth
;
;
;-
FUNCTION SaveDW, _DW

   Handle_Value, _DW, DW
   RETURN, DW

END
