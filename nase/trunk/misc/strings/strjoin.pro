;+
; NAME:                StrJoin
;
; PURPOSE:             Konkatentiert ein Array von Strings zu einem einzigen
;                      String und fuegt Separatoren zwischen den Strings ein.
;                      Standard-Separator ist ein Leerzeichen.
;
; CATEGORY:            STRINGS
;
; CALLING SEQUENCE:    res = StrJoin(strs [, sep])
;
; INPUTS:              strs: ein Stringarray
;
; OPTIONAL INPUTS:     sep : ein Separatorstring (default: ' ')
;
; OUTPUTS:             res: der konkatenierte String
;
; EXAMPLE:             print, StrJoin(['/usr/bin','/bin','/vol/bin'], ':')
;                      '/usr/bin:/bin:/vol/bin'
;
;                      print, StrJoin(['/usr/bin'], ':')
;                      '/usr/bin'
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 1.1  1999/02/22 11:14:39  saam
;           new & cool
;
;
;-
FUNCTION StrJoin, strs, sep

   Default, sep, ' '
   
   IF TypeOf(strs) NE 'STRING' THEN Message, 'only works for strings in 1st arg'
   IF TypeOf(sep)  NE 'STRING' THEN Message, 'only works for strings in 2nd arg'

   rstr = strs(0)
   nstrs = N_Elements(strs)
   FOR i=1,nstrs-1 DO rstr = rstr + sep + strs(i) 

   RETURN, rstr
END
