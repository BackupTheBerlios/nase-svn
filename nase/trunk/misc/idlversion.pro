;+
; NAME:                IDLVERSION
;
; AIM:                 returns the used version of IDL
;
; PURPOSE:             Liefert die momentan laufende IDL-Version als LONG
;                      zurueck.
;
; CATEGORY:            MISC
;
; CALLING SEQUENCE:    version = IDLVERSION([/FULL])
;
; KEYWORDS: FULL:      Liefert die Haupt- und alle
;                      Minor-Versionen als LONG-Array zurück.
;
; OUTPUTS:             version: die IDL-Version als LONG, (momentan also 3,4 oder 5)
;
; EXAMPLE:
;                      print, IDLVERSION()
;                      5
;                            ; hey, i'm running idl 5 :)
;
;                      print, IDLVERSION(/FULL)
;                      5 0 2
;                            ; I'm running IDL 5.0.2
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 1.3  2000/09/25 09:10:32  saam
;     * appended AIM tag
;     * some routines got a documentation update
;     * fixed some hyperlinks
;
;     Revision 1.2  1999/11/04 16:24:03  kupper
;     Added FULL keyword.
;
;     Revision 1.1  1998/10/28 17:41:38  saam
;           short...
;
;
;-
FUNCTION IDLVERSION, FULL=full
   if Keyword_set(FULL) then return, long(str_sep(!version.release, "."))
   RETURN, long(!version.release)
END
