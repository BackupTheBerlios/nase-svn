;+
; NAME:               EXTRASET
;
; AIM:                checks if a structure contains certain tag names
;
; PURPOSE:            Checks if a structure contains a certain tag and
;                     returns TRUE or FALSE.
;
; CATEGORY:           MISC
;
; CALLING SEQUENCE:   eset = ExtraSet(Extra, Keyword [,TAGNR=tagnr])
;
; INPUTS:             Extra  : an arbitrary structure
;                     Keyword: the requested tagname as a string
;
; OPTIONAL OUTPUTS:   TAGNR  : contains the position of the tag
;                              in the structure if found.
;
; OUTPUTS:            eset: is keyword in EXTRA set?
;
; EXAMPLE:            
;                     PRO Fuck, test=test, _EXTRA=e                       
;                       IF NOT ExtraSet(e, 'test') THEN Print, 'Keyword TEST NOT set in extra (Fuck)'
;                       IF Set(test) THEN Print, '...but its an ordinary Keyword'
;                       
;                     END
;
;                     PRO Meister, _EXTRA=e
;                       IF ExtraSet(e, 'tEsT') THEN Print, 'Keyword TEST set in PRO Meister'
;                       Fuck, _EXTRA=e 
;                     END
;      
;                     Meister, /TEST
;                     print, '   '
;                     Meister, /SUCK
;
;                     Screenshot:
;                       Keyword TEST set in PRO Meister
;                       Keyword TEST NOT set in extra (Fuck)
;                       ...but its an ordinary Keyword
;                       
;                       Keyword TEST NOT set in extra (Fuck)
;
;-
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 2.4  2000/09/25 09:13:08  saam
;     * added AIM tag
;     * update header for some files
;     * fixed some hyperlinks
;
;     Revision 2.3  2000/04/04 14:44:14  saam
;           + added TAGNR optional output
;           + changed doc header to english
;           + better argument checking
;
;     Revision 2.2  1998/02/05 13:26:49  saam
;           Verbesserte Argumentueberpruefung
;
;     Revision 2.1  1998/01/21 23:31:34  saam
;           Creation
;
FUNCTION ExtraSet, extra, keyword, TAGNR=tagnr

   IF N_Params() NE 2 THEN Message, 'wrong syntax'

   ; is extra defined ??
   IF NOT Set(extra) THEN RETURN, 0
   IF TypeOf(extra) NE 'STRUCT' THEN Console, '1st argument is no structure, but need to be', /FATAL
   
   tNames = Tag_Names(extra)

   FOR tagnr=0,N_Tags(extra)-1 DO BEGIN
      IF StrUpCase(keyword) EQ  StrUpCase(tNames(tagnr)) THEN RETURN, 1
   END

   RETURN, 0

END
