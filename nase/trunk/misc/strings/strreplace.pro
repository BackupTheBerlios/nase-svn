;+
; NAME:               StrReplace
;
; AIM:                replaces a certain substring by another one
;
; PURPOSE:            Ersetzt einen Teilstring ORG in einem String STRING durch einen
;                     anderen Teilstring NEW
;
; CATEGORY:           MISC STRINGS
;
; CALLING SEQUENCE:   rstr = StrReplace(string, org, new [,/G] [,/I])
;
; INPUTS:             string: der OriginalString, in dem die Ersetzung stattfinden soll
;                     org   : der in string zu ersetzende Teilstring
;                     new   : der String, der fuer org eingesetzt wird
;
; KEYWORD PARAMETERS: G     : ersetzt rekursiv ALLE org Teilstrings, ansonsten
;                             wird nur das ERSTE Auftreten ersetzt. ACHTUNG:
;                             es werden auch die org's ersetzt, die erst durch
;                             die Ersetzung entstanden sind (moegliche unendliche
;                             Rekursion!!!) Daher sollte ORG nie ein Teilstring
;                             von NEW sein.
;                     I     : die Ersetzung erfolgt Case-Insensitive
;
; OUTPUTS:            rstr: der Ergebnisstring
;
; EXAMPLE:
;                     IDL> print, strreplace('gonzo/gonzo','gonzo','bozo')
;                     bozo/gonzo
;                     IDL> print, strreplace('gonzo/gonzo','gonzo','bozo',/g)
;                     bozo/bozo
;                     IDL> print, strreplace('gonzoggggggggg','Onzog','onzo',/g,/i)
;                     gonzo
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 1.2  2000/09/25 09:13:11  saam
;     * added AIM tag
;     * update header for some files
;     * fixed some hyperlinks
;
;     Revision 1.1  1999/03/02 14:01:31  saam
;           unbelievable it doesn't already exist
;
;
;-
FUNCTION StrReplace, string, org, new, G=G, I=I

   On_Error, 2

   IF N_Params() NE 3 THEN Message, 'wrong number of arguments'
   IF NOT Set(string) THEN Message, '1st argument is undefined'
   IF NOT Set(org)    THEN Message, '2nd argument is undefined'
   IF NOT Set(new)    THEN Message, '3rd argument is undefined'

   IF TypeOf(string) NE 'STRING' THEN Message, 'String as 1st argument expected'
   IF TypeOf(org)    NE 'STRING' THEN Message, 'String as 2nd argument expected'
   IF TypeOf(new)    NE 'STRING' THEN Message, 'String as 3rd argument expected'

   slen = StrLen(string)
   olen = StrLen(org)

   rep = string

   REPEAT BEGIN
      IF Keyword_Set(I) THEN pos = StrPos(StrUpCase(rep),StrUpCase(org)) ELSE pos = StrPos(rep, org)
      IF pos NE -1 THEN rep = StrMid(rep, 0, pos) + new + StrMid(rep, pos+olen, slen)
   END UNTIL ((pos EQ -1) OR NOT Keyword_Set(G))

   RETURN, rep

END
