;+
; NAME:                RemoveDup
;
; AIM:                 removes duplicate, adjacent substrings from a string 
;
; PURPOSE:             Entfernt in einem String bestimmte, aufeinander-
;                      folgende Teilstrings
;
; CATEGORY:            STRINGS
;
; CALLING SEQUENCE:    withoutDups = RemoveDup(string, substring)
;
; INPUTS:              string   : der Original-String
;                      substring: der Substring dessen aufeinanderfolgende,
;                                 Duplikate entfernt werden sollen.
;
; OUTPUTS:             withoutDups: das Resultat halt
;
; EXAMPLE:
;                      filename = '/ich/weiss///nicht//was////soll/es////bedeuten'
;                      print, RemoveDup(filename, '/')
;  
;                      liefert:
;                         '/ich/weiss/nicht/was/soll/es/bedeuten'
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 2.2  2000/09/25 09:13:11  saam
;     * added AIM tag
;     * update header for some files
;     * fixed some hyperlinks
;
;     Revision 2.1  1998/04/06 16:50:21  saam
;           schtrings
;
;
;-
FUNCTION RemoveDup, str, sep

   IF N_Params() NE 2 THEN Message, 'two arguments expected'
   
   s = SIZE(str)
   IF s(0) NE 0 OR s(1) NE 7 THEN Message, 'first argument has to be a string'
   s =  SIZE(sep)
   IF s(0) NE 0 OR s(1) NE 7 THEN Message, 'second argument has to be a string'

   
   cut   = Str_Sep(str, sep)
   count =  N_Elements(cut)

   result = cut(0)
   FOR i=1,count-1 DO BEGIN
      IF cut(i) NE '' THEN result = result+sep+cut(i)
   END
   IF cut(count-1) EQ '' THEN result = result+sep

   RETURN, result
END
