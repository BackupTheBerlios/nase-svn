;+
; NAME:
;   StrReplace()
;
; VERSION:
;   $Id$
;
; AIM:
;   replaces a certain substring by another one
;
; PURPOSE:
;   Replaces substring ORG occurring in STRING by a new string
;   NEW. By default, only the first occurence of ORG is replaced.
;   This may be changed by the /G option. You can also replace 
;   ORG case-insensitive with the /I option. Don't ask about the
;   keyword naming; it's stolen from <A HREF="http://www.perl.com>Perl</A>.
;   Be careful with the /G option. It may cause infinite loops!!
;
; CATEGORY:
;  Strings
;
; CALLING SEQUENCE:
;*   rstr = StrReplace(string, org, new [,/G] [,/I])
;
; INPUTS:
;   string :: string, where the replacement should take place 
;   org    :: substring to replace
;   new    :: substring that is inserted for org
;
; INPUT KEYWORDS: 
;   G :: replaces recursively ALL occurences of org. By default, only
;        the FIRST occureence is replaced. Occurences of org, that
;        were created by a previous replacement, are also replaced.
;        This may causes an inifinite recursion. Therefore ORG should
;        never be a real substring of NEW. If ORG is identical to NEW,
;        there are no problem with this. 
;   I :: the replacement is case-insensitive
;
; OUTPUTS:
;   rstr :: the result string
;
; EXAMPLE:
;
;*  print, strreplace('gonzo/gonzo','gonzo','bozo')
;*  >bozo/gonzo
;*  print, strreplace('gonzo/gonzo','gonzo','bozo',/g)
;*  >bozo/bozo
;*  print, strreplace('gonzoggggggggg','Onzog','onzo',/g,/i)
;*  >gonzo
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

   IF org EQ new THEN RETURN, string

   slen = StrLen(string)
   olen = StrLen(org)

   rep = string

   REPEAT BEGIN
      IF Keyword_Set(I) THEN pos = StrPos(StrUpCase(rep),StrUpCase(org)) ELSE pos = StrPos(rep, org)
      IF pos NE -1 THEN rep = StrMid(rep, 0, pos) + new + StrMid(rep, pos+olen, slen)
   END UNTIL ((pos EQ -1) OR NOT Keyword_Set(G))

   RETURN, rep
END
