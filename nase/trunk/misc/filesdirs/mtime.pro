;+
; NAME:                MTime
;
; PURPOSE:             Ermittelt fuer ein File/Directory die Zeit der letzten
;                      Modifikation. 
;
; CATEGORY:            MISC FILES DIRS
;
; CALLING SEQUENCE:    seconds = MTime(File, DATE=Date)
;
; INPUTS:              FILE: ein beliebiger Pfadname (auch auf Verzeichnisse)
;
; OUTPUTS:             seconds: die letzte Aenderung war x Sekunden nach einem
;                               festen Datum (um 1970); bei jeglicher Art von
;                               Fehler wird -1 zurueckgegeben.
;
; OPTIONAL OUTPUTS:    DATE: String, der das Datum im Format 'Tue Feb  2 15:49:49 1999'
;                            enthaelt.
;
; PROCEDURE:
;                      + leider gibts keine Moeglichkeit in IDL direkt an das Datum
;                        heranzukommen ausser ueber einen spawn, 'ls -l' und einen
;                        fiesen grep, der auf jedem System anders aussieht.
;                      + daher benutzt diese Routine ein externes C-Programm, das
;                        mittels des syscalls fstat auf das Datum zugreift.
;                      + die C-Routine heisst mtime.c und befindet sich unter 
;                        $(NASEDIR)/shared
;                      
; EXAMPLE:             
;                      print, mtime('gibtsnet')
;                         -1
;                      $touch gibts
;                      print, mtime('gibts', DATE=date)
;                         919974959
;                      print, date
;                         'Thu Feb 25 22:35:59 1999'
;                     
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 1.2  2000/08/04 14:37:12  kupper
;     Removed absolute reference to /vol/lib/nase.so.
;     Replaced by !NASE_LIB.
;
;     Revision 1.1  1999/07/28 08:42:26  saam
;           hope it works
;
;
;-
FUNCTION MTime, File, DATE=date

   IF TypeOf(FILE) NE 'STRING' THEN Message, 'string as first argument expected'
   
   date = ''
   seconds = CALL_EXTERNAL(!NASE_LIB, 'mtime', File, date)
   date = STRMID(date,0,24)
   
   RETURN, seconds

END
