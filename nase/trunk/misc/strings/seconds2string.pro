;+
; NAME:               Seconds2String
;
; PURPOSE:            Konvertiert Sekunden in einen String aus Stunden/Minuten und Sekunden
;
; CATEGORY:           MISC
;
; CALLING SEQUENCE:   ResultStr = Seconds2String(Time)
;
; INPUTS:             Time : eine Zeit in Sekunden
;
; OUTPUTS:            ResultStr : der Stunden/Minuten/Sekunden-String
;
; EXAMPLE:
;                     print, Seconds2String(24865)
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 1.1  1997/10/26 18:41:57  saam
;           vom Himmel gefallen
;
;
;-
FUNCTION Seconds2String, sec

   sec     = LONG(sec)
   timestr = ""

   h = sec/3600 
   m = (sec - h*3600)/60
   s = sec MOD 60

   IF h NE 0 THEN timestr = timestr + STRING(h) + 'h' 
   IF m NE 0 OR h NE 0 THEN timestr = timestr + STRING(m) + 'm'
   timestr = timestr + STRING(s) + 's'

   RETURN, StrCompress(timestr)
END 
