;+
; NAME:
;   ExtraSet()
;
; AIM:
;   checks if a structure contains certain tag names
;
; PURPOSE:
;   Checks if a structure contains a certain tag and
;   returns TRUE or FALSE.
;
; CATEGORY:
;  Structures
;
; CALLING SEQUENCE:
;  eset = ExtraSet(Extra, Keyword [,TAGNR=tagnr])
;
; INPUTS:
;  Extra  :: an arbitrary structure
;  Keyword:: the requested tagname as a string
;
; OPTIONAL OUTPUTS:
;  TAGNR  :: contains the position of the tag
;            in the structure if found.
;
; OUTPUTS:
;  eset:: is keyword in EXTRA set?
;
; EXAMPLE:            
;* PRO Slave, test=test, _EXTRA=e                       
;*  IF NOT ExtraSet(e, 'test') THEN Print, 'Keyword TEST NOT set in extra (Slave)'
;*  IF Set(test) THEN Print, '...but its an ordinary Keyword'
;* END
;
;* PRO Meister, _EXTRA=e
;*  IF ExtraSet(e, 'tEsT') THEN Print, 'Keyword TEST set in PRO Meister'
;*  Slave, _EXTRA=e 
;* END
;      
;* Meister, /TEST
;* print, '   '
;* Meister, /SUCK
;
; results in:
;*> Keyword TEST set in PRO Meister
;*> Keyword TEST NOT set in extra (Slave)
;*> ...but its an ordinary Keyword
;*> Keyword TEST NOT set in extra (Slave)
;
;-
FUNCTION ExtraSet, extra, keyword, TAGNR=tagnr

   On_Error, 2

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
