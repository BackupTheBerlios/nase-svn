;+
; NAME:                IDLVERSION
;
; PURPOSE:             Liefert die momentan laufende IDL-Version als LONG
;                      zurueck.
;
; CATEGORY:            MISC
;
; CALLING SEQUENCE:    version = IDLVERSION()
;
; OUTPUTS:             version: die IDL-Version als LONG, (momentan also 3,4 oder 5)
;
; EXAMPLE:
;                      print, IDLVERSION()
;                      5
;                            ; hey, i'm running idl 5 :)
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 1.1  1998/10/28 17:41:38  saam
;           short...
;
;
;-
FUNCTION IDLVERSION
   RETURN, ((LONG(strmid(!VERSION.release,0,1)))(0)-LONG('0'))
END
