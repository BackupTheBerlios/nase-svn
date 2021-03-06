;+
; NAME:               UWSet
;
; AIM:
;  Set the window active for graphics output. Work around nasty
;  features of IDL's WSet procedure.
;
; PURPOSE:            Ersetzt die WSet-Routine von IDL mit zwei Aenderungen:
;                       + Ist das Fenster nicht verfuegbar, wird kein Fehler erzeugt
;                       + Ist ueberhaupt kein Fenster geoeffnet, oeffnet WSet eines.
;                         Dies tut UWSet nicht!
;
; CATEGORY:           GRAPHIC
;
; CALLING SEQUENCE:   UWSet, WinID, status
;
; INPUTS:             WinID: eine FensterID, die aktiviert werden soll
;
; OPTIONAL OUTPUTS:   status: 0, wenn Fenster nich aktiviert werden konnte
;                             1, alles klar
;
; EXAMPLE:
;                     UWSet, 8, exists
;                     IF NOT exists THEN Window, 8
;                     plot, Indgen(100)
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 2.3  2000/10/01 14:50:42  kupper
;     Added AIM: entries in document header. First NASE workshop rules!
;
;     Revision 2.2  1998/05/14 13:52:22  saam
;           again problems with idl5, hopefully fixed
;
;     Revision 2.1  1997/11/13 14:47:03  saam
;           Creation
;
;
;-
PRO UWset, id, status

   CATCH, Error_Status
   IF Error_Status NE 0 THEN BEGIN
      RETURN      
   END

   status = 0
   
   IF (!D.Window NE -1) OR fix(!VERSION.Release) GT 4 THEN BEGIN
      WSet, id
      status = 1
   END

END
