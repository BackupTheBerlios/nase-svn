;+
; NAME:                FileExists
;
; PURPOSE:             Testet, ob der uebergebene Filename existiert und
;                      gibt auf Wunsch die FStat(IDL-Struktur)- und die file
;                      -Information(Shell Kommando) zurueck.
;
; CATEGORY:            MISC
;
; CALLING SEQUENCE:    trueFalse = FileExists(file [, INFO=info] [, STAT=stat])
;
; INPUTS:              file     : der zu testende Filename
;
; OUTPUTS:             trueFalse: existiert file oder nicht?
;
; OPTIONAL OUTPUTS:    INFO: enthaelt das Ergebnis das file Kommandos, falls file
;                            existiert
;                      STAT: enthaelt die FSTAT-Info, falls file existiert
;
; EXAMPLE:
;                      print, fileExists('shit')
;                      spawn, 'touch shit', r
;                      print, fileExists('shit', INFO=info, STAT=stat)
;                      print, info
;                      help, stat, /STRUCTURES
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 2.1  1998/02/24 08:40:52  saam
;           zip-zip-zippi-die-dip
;
;
;-
FUNCTION FileExists, file, STAT=stat, INFO=info

   OpenR, lun, file, /GET_LUN, ERROR=err
   IF NOT err THEN BEGIN
      stat = FStat(lun)      
      Close, lun
      Free_Lun, lun

      spawn, 'file '+file, r
      info = r(0)
      
      RETURN, 1
   ENDIF ELSE RETURN, 0
   
END
