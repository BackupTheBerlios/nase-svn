;+
; NAME:               FreeEachHandle
;
; AIM:                frees all children handles of !MH
;
; PURPOSE:            Im Startup-Skript wird ein Handle !MH
;                     erstellt, der als Vater aller neu 
;                     erzeugten Handles verwendet werden kann/soll.
;                     FreeEachHandle gibt alle von !MH abhaengenden
;                     Handles frei. Dies verhindert, dass Speicher
;                     verloren geht.
;
; CATEGORY:           MISC
;
; CALLING SEQUENCE:   FreeEachHandle
;
; SIDE EFFECTS:       Definiert !MH um
;
; EXAMPLE:
;                     A = Create_Handle(!MH, VALUE=Indgen(100,100))   ; hat !MH als Vater
;                     A = 0   ; Handle is weg !!!!!!!!!!!             
;                     B = Create_Handle(VALUE=Indgen(100,100))        ; hat keinen Vater
;                     B = 0   ; Handle is weg !!!!!!!!!!!
;                     FreeEachHandle                
;                   
;                     ; Speicher von Handle A freigegeben, von Handle B nicht!!
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 2.3  2000/09/25 09:13:06  saam
;     * added AIM tag
;     * update header for some files
;     * fixed some hyperlinks
;
;     Revision 2.2  1998/02/05 13:25:34  saam
;           kleiner BugFix
;
;     Revision 2.1  1998/02/03 18:59:29  saam
;           Lange gefordert, endlich erstellt
;
;
;-
PRO FreeEachHandle


   IF Handle_Info(!MH) THEN BEGIN
      Handle_Free, !MH
   END ELSE BEGIN
      print, 'FAH: strange...!MH not defined, declaring it now'
   END
   !MH = Handle_Create()
      
END
