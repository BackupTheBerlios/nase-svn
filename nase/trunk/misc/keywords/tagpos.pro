;+
; NAME:               TagPos
;
; PURPOSE:            Ermittelt an welcher Stelle in einer Struktur sich ein oder mehrere
;                     Tags befinden. Damit wird ein Zugriff via STRUCT.(i) moeglich.
;
; CATEGORY:           MISC STRUCTURES 
;
; CALLING SEQUENCE:   p = TagPos(S, T)
;
; INPUTS:             S : eine beliebige Struktur
;                     T : ein [Array von ] TagNamen, der Position bestimmt werden soll 
;
; OUTPUTS:            p : [LongArray der] Positionen, an denen der entsprechende Tag gefunden wurde,
;                         nicht gefundene Tags werden mit -1 belegt.
;
; EXAMPLE:            S = {shit : 0, fuck : 'ing', mist : 0l}
;                     print, TagPos(S,'fuck')
;                     ;      1
;                     print, S.(TagPos(S,'fuck'))
;                     ;      'ing'
;                     T = ['fuck', 'shit', 'merde', 'bullshit']print, TagPos(S,'fuck')   
;                     print, TagPos(S,T)
;                     ;      1           0          -1          -1
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 2.1  1998/11/16 14:13:51  saam
;           damn, another function for structures, other are to come ...soon
;
;
;-
FUNCTION TagPos, S, T

   ON_ERROR, 2
   
   IF N_Params() NE 2 THEN Message, 'Structure AND TagName expected'

   IF NOT Set(S) THEN Message, 'Structure not defined'
   IF NOT Set(T) THEN Message, 'TagName not defined'

   tn = Tag_Names(S)
   tnc = N_Elements(tn)
   tc = N_Elements(T)

   FOR j=0l, tc-1 DO BEGIN ; all tags to be found in the structure
      FOUND = 0
      FOR i=0l,tnc-1 DO BEGIN ; all tags in the structure
         IF STRUPCASE(tn(i)) EQ STRUPCASE(T(j)) THEN BEGIN 
            IF SET(TP) THEN TP = [TP, i] ELSE TP = i
            FOUND = 1
         END
      END
      IF NOT FOUND THEN BEGIN  ; no corresponding tag found, return !NONE for this tag
         IF SET(TP) THEN TP = [TP, -1] ELSE TP = -1
      END
   END
   RETURN, TP
END
