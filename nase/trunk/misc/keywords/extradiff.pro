;+
; NAME:                ExtraDiff
;
; PURPOSE:             Extrahiert bestimmte Tags aus einer Struktur A und fuegt diese zu einer 
;                      neuen Struktur B zusammen. Die passenden Tags werden defaultmaessig aus A
;                      geloescht. 
;                      Nuetzlich ist das z.B. wenn aus dem  _EXTRA-Keyword nur bestimmte 
;                      Keywords an FUNCTIONS/PRO weitergegeben werden sollen.
;
; CATEGORY:            MISC KEYWORDS STRUCTURES
;
; CALLING SEQUENCE:    B = ExtraDiff(A, diff [,/LEAVE])
;
; INPUTS:              A    : die Extra- oder eine andere Struktur
;                      diff : ein Array von Strings, die aus A extrahiert werden sollen
;
; KEYWORD PARAMETERS:  LEAVE: bewirkt, dass A unveraendert bleibt
;
; OUTPUTS:             B : eine anonyme Struktur mit den Tags aus diff, die in A enthalten
;                          sind. Hat keines uebereingestimmt wird !NONE zurueckgegeben.
;                      A : enthaelt die uebriggebliebenen Tags (falls /LEAVE nicht gesetzt),
;                          bzw. !NONE, wenn es keine gibt
;
; SIDE EFFECTS:        aus A werden ggf. Tags geloescht
;
; RESTRICTIONS:        named-Structures werden zu anonymous-Structures
;
; EXAMPLE:             A = {a:1, b:2, z:'Haha'}
;                      B = ExtraDiff(A,['a','z'])
;
;                      IDL> help, A, /STR
;                      ** Structure <4000a7c8>, 1 tags, length=2, refs=1:
;                      B               INT              2
;                      IDL> help, B, /STR
;                      ** Structure <4002ec08>, 2 tags, length=24, refs=1:
;                      A               INT              1
;                      Z               STRING    'Haha'     
;
;                      A = {a:1, b:2, z:'Haha'}
;                      
; SEE ALSO:            <A HREF="http://neuro.physik.uni-marburg.de/nase/misc/arrays/#DIFFSET">DiffSet</A>
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 2.2  1998/08/14 10:10:13  saam
;           doc header errors corrected
;
;     Revision 2.1  1998/07/21 13:06:19  saam
;           long needed, never time to write...
;
;
;-
FUNCTION ExtraDiff, extra, keywords, LEAVE=leave

   IF N_Params() NE 2 THEN Message, 'wrong syntax'

   ; is extra defined ??
   IF NOT Set(extra) THEN RETURN, !NONE
   
   tNames = Tag_Names(extra)

   keyc   = N_Elements(keywords)
   extrac = N_Tags(extra)
   
  

   ; make a list of keywords found in the structure
   FOR i=0,extrac-1 DO BEGIN
      FOR j=0,keyc-1 DO BEGIN
         IF StrUpCase(keywords(j)) EQ  StrUpCase(tNames(i)) THEN BEGIN
            ; ok, we've got one keyword that is in the structure
            IF Set(keysfound) THEN keysfound = [keysfound, keywords(j)] ELSE keysfound = keywords(j)
            IF Set(tagnumbers) THEN tagnumbers = [tagnumbers, i] ELSE tagnumbers = i
         END
      END
   END

   ; create the result containing the tags found
   IF Set(keysfound) THEN BEGIN
      diff = Create_Struct(keysfound(0), extra.(tagnumbers(0)))
      FOR i=1, N_Elements(keysfound)-1 DO BEGIN
         diff = Create_Struct(diff, keysfound(i), extra.(tagnumbers(i)))
      END
   END
   
   ; delete tags from extra if wanted
   IF (NOT Keyword_Set(LEAVE)) AND Set(tagnumbers) THEN BEGIN
      staytags = DiffSet(Indgen(extrac), tagnumbers)
      IF staytags(0) NE !NONE THEN BEGIN
         newextra = Create_Struct(tNames(staytags(0)),extra.(staytags(0)))
         FOR i=1, N_Elements(staytags)-1 DO newextra =  Create_Struct(newextra, tNames(staytags(i)),extra.(staytags(i)))
      END      
      IF Set(newextra) THEN extra = newextra ELSE extra = !NONE
   END

   
   IF NOT Set(diff) THEN RETURN, !NONE ELSE RETURN, diff

END
