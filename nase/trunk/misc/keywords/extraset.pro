;+
; NAME:               EXTRASET
;
; PURPOSE:            Ueberprueft, ob die _EXTRA-Struktur ein bestimmtes
;                     Keyword enthaelt und gibt je nachdem 1 (TRUE) oder 
;                     0 (FALSE) zurueck. 
;                     Der Test ist dann erforderlich, wenn eine Routine
;                     _EXTRA weitergeben & selbst auswerten muss. 
;                     Eigentlich spricht nichts dagegen, die Routine fuer
;                     beliebige Strukturen zu verwenden.
;
; CATEGORY:           MISC
;
; CALLING SEQUENCE:   eset = ExtraSet(Extra, Keyword)
;
; INPUTS:             Extra  : die _EXTRA-Struktur
;                     Keyword: ein String, der den Keyword-IDENTIFIER enthaelt
;
; OUTPUTS:            eset: ist das Keyword in Extra gesetzt ??
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
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 2.1  1998/01/21 23:31:34  saam
;           Creation
;
;
;-
FUNCTION ExtraSet, extra, keyword

   ; is extra defined ??
   IF NOT Set(extra) THEN RETURN, 0
   
   tNames = Tag_Names(extra)

   FOR i=0,N_Tags(extra)-1 DO BEGIN
      IF StrUpCase(keyword) EQ  StrUpCase(tNames(i)) THEN RETURN, 1
   END

   RETURN, 0

END
