;+
; NAME:
;  Split()
;
; VERSION:
;  $Id$
;
; AIM:
;  Divides a string into pieces as designated by a separator string, superceeded by <C>Str_Sep()</C>.
;
; PURPOSE:
;  Splits a string into substrings. The separator string can be
;  chosen. This routine seems to be superceeded by <C>Str_Sep()</C> in
;  IDL versions GE 5.
;
; CATEGORY:
;  Strings
;
; CALLING SEQUENCE:
;* subs = Split(string, sep [,/I])
;
; INPUTS:
;  string:: The string to be split.
;  sep:: A separator string (e.g., " " or ",").
;
; INPUT KEYWORDS:
;  I:: The separator is matched case INsensitive.
;
; OUTPUTS:
;  subs:: resulting array of substrings
;
; PROCEDURE:
;  Invented long ago.
;
; EXAMPLE:
;* subs = Split('a b c d e f', ' ')
;* help, subs
;*> SUBS            STRING    = Array[6]
;
; SEE ALSO:
;  IDL's own <C>Str_Sep()</C>
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
