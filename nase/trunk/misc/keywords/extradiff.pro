;+
; NAME:
;  ExtraDiff
;
; VERSION:
;  $Id$
; 
; AIM:
;  extracts tags from a structur eand puts them into another
;
; PURPOSE:
;  Extrahiert bestimmte Tags aus einer Struktur A und fuegt diese zu einer 
;  neuen Struktur B zusammen. Die passenden Tags werden defaultmaessig aus A
;  geloescht. 
;  Nuetzlich ist das z.B. wenn aus dem  _EXTRA-Keyword nur bestimmte 
;  Keywords an FUNCTIONS/PRO weitergegeben werden sollen.
;
; CATEGORY:
;  DataStructures
;  ExecutionControl
;  Structures
;
; CALLING SEQUENCE:
;*B = ExtraDiff(A, diff [,/LEAVE] [,/SUBSTRING])
;
; INPUTS:
;  A    :: die Extra- oder eine andere Struktur
;  diff :: ein Array von Strings, die aus A extrahiert werden sollen
;
; INPUT KEYWORDS:
;  LEAVE     :: bewirkt, dass A unveraendert bleibt
;  SUBSTRING :: Abschwaechung der Gleichheit der TagNames zwischen A und diff. 
;               Alle Tags aus A deren Teilstrings in diff enthalten sind werden
;               extrahiert.
;
; OUTPUTS:
;  B :: eine anonyme Struktur mit den Tags aus diff, die in A enthalten
;       sind. Hat keines uebereingestimmt wird !NONE zurueckgegeben.
;  A :: enthaelt die uebriggebliebenen Tags (falls /LEAVE nicht gesetzt),
;       bzw. ist undefiniert, wenn es keine mehr gibt
;
; SIDE EFFECTS:
;  aus A werden ggf. Tags geloescht
;
; RESTRICTIONS:
;  named-Structures werden zu anonymous-Structures
;
; EXAMPLE:
;*A = {a:1, b:2, z:'Haha'}
;*B = ExtraDiff(A,['a','z'])
;*
;*help, A, /STR
;*; Structure <4000a7c8>, 1 tags, length=2, refs=1:
;*;  B               INT              2
;*help, B, /STR
;*; ** Structure <4002ec08>, 2 tags, length=24, refs=1:
;*;  A               INT              1
;*;  Z               STRING    'Haha'     
;
; SEE ALSO:
;  <A>DiffSet</A>, <A>UNDEF</A>
;
;-
FUNCTION ExtraDiff, extra, keywords, LEAVE=leave, SUBSTRING=substring

   IF N_Params() NE 2 THEN Message, 'wrong syntax'

   ; is extra defined ??
   IF Set(extra) THEN BEGIN   
      tNames = Tag_Names(extra)
      
      keyc   = N_Elements(keywords)
      extrac = N_Tags(extra)
      
  

      ; make a list of keywords found in the structure
      FOR i=0,extrac-1 DO BEGIN
         FOR j=0,keyc-1 DO BEGIN
            IF Keyword_Set(SUBSTRING) THEN BEGIN
               IF Contains(StrUpCase(tNames(i)), StrUpCase(keywords(j)))  THEN BEGIN
                                ; ok, we've got one keyword that is in the structure
                  IF Set(keysfound) THEN keysfound = [keysfound, tNames(i)] ELSE keysfound = tNames(i)
                  IF Set(tagnumbers) THEN tagnumbers = [tagnumbers, i] ELSE tagnumbers = i
               END
            END ELSE BEGIN
               IF StrUpCase(keywords(j)) EQ  StrUpCase(tNames(i)) THEN BEGIN
                                ; ok, we've got one keyword that is in the structure
                  IF Set(keysfound) THEN keysfound = [keysfound, keywords(j)] ELSE keysfound = keywords(j)
                  IF Set(tagnumbers) THEN tagnumbers = [tagnumbers, i] ELSE tagnumbers = i
               END
            END
         END
      END
      

      IF Set(keysfound) THEN BEGIN
         ; create the result containing the tags found
         diff = Create_Struct(keysfound(0), extra.(tagnumbers(0)))
         FOR i=1, N_Elements(keysfound)-1 DO BEGIN
            diff = Create_Struct(diff, keysfound(i), extra.(tagnumbers(i)))
         END
   
         ; delete tags from extra if wanted
         IF (NOT Keyword_Set(LEAVE)) AND Set(tagnumbers) THEN BEGIN
            staytags = DiffSet(Indgen(extrac), tagnumbers)
            IF staytags(0) NE !NONE THEN BEGIN
               newextra = Create_Struct(tNames(staytags(0)),extra.(staytags(0)))
               FOR i=1, N_Elements(staytags)-1 DO newextra =  Create_Struct(newextra, tNames(staytags(i)),extra.(staytags(i)))
            END      
            IF Set(newextra) THEN extra = newextra ELSE undef, extra
         END

      END 
   END
   IF Set(diff) THEN RETURN, diff ELSE RETURN, !NONE


END
