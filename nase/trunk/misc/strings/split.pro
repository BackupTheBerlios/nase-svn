;+
; NAME:               Split
;
; AIM:                divides a string into pieces as designated by a separator string (superceded by IDL>=5 STR_SEP!?)
;
; PURPOSE:            Splits a string into substrings. The separator
;                     string can be chosen.
;
; CATEGORY:           MISC STRINGS
;
; CALLING SEQUENCE:   subs = Split(string, sep [,/I])
;
; INPUTS:             string: the string to be split
;                     sep   : a separator string (e.g., " " or ",")
;
; KEYWORD PARAMETERS: I     : the separator is matched case INsensitive
;
; OUTPUTS:            subs  : resulting array of substrings
;
; EXAMPLE:
;                     IDL> subs = split('a b c d e f', ' ')
;                     IDL> help, subs
;                     SUBS            STRING    = Array[6]
;                     
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 1.3  2000/10/10 16:28:59  kupper
;     Broke on seperators longer than one character. Fixed.
;
;     Revision 1.2  2000/09/25 09:13:11  saam
;     * added AIM tag
;     * update header for some files
;     * fixed some hyperlinks
;
;     Revision 1.1  2000/06/19 13:38:47  saam
;           + unbelievable it does not already exist
;
;
;-
FUNCTION Split, string, sep, I=I

   On_Error, 2

   IF N_Params() NE 2 THEN Message, 'wrong number of arguments'
   IF NOT Set(string) THEN Message, '1st argument is undefined'
   IF NOT Set(sep)    THEN Message, '2nd argument is undefined'
   
   IF TypeOf(string) NE 'STRING' THEN Message, 'String as 1st argument expected'
   IF TypeOf(sep)    NE 'STRING' THEN Message, 'String as 2nd argument expected'
   
   pos = 0
   REPEAT BEGIN
      IF Keyword_Set(I) THEN npos = StrPos(StrUpCase(string),StrUpCase(sep), pos) ELSE npos = StrPos(string, sep, pos)
       IF npos NE -1 THEN seg = StrMid(string, pos, npos-pos) ELSE seg = StrMid(string,pos, StrLen(string)-pos)
       IF Set(res) THEN res = [res, seg] ELSE res = [seg]
       pos = npos+strlen(sep)
   END UNTIL (npos EQ -1)
   RETURN, res
   
END
