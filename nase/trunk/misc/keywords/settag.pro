;+
; NAME:               SetTag
;
; PURPOSE:            Setzt einen Tag in einer Struktur auf einen Wert. Existiert
;                     der Tag noch nicht, so wird er angelegt. Ein bestehender Tag
;                     wird ueberschrieben.
;
; CATEGORY:           MISC STRUCTURES
;
; CALLING SEQUENCE:   SetTag, S, TN, TV
;
; INPUTS:             S  : eine beliebige Struktur aus der ein Tag geloescht werden soll
;                     TN : ein String, der den zu setzenden/definierenden Tag bezeichnet
;                     TV : der Wert, den S.TN annehmen soll
;
; SIDE EFFECTS:       S wird veraendert!
;
; PROCEDURE:          benutzt DelTag und Create_Struct
;
; EXAMPLE:            a={a:1,c:3}
;                     SetTag, a, 'b', 2
;                     help, a, /str
;                       ** Structure <401bf5c8>, 3 tags, length=6, refs=1:
;                       A               INT              1
;                       C               INT              3
;                       B               INT              2
;                     SetTag, a, 'b', 'bloedi'
;                     help, a, /str
;                       ** Structure <401bf5c4>, 3 tags, length=6, refs=1:
;                       A               INT              1
;                       C               INT              3
;                       B               STRING    'bloedi'
;
; SEE ALSO:           <A HREF="#DELTAG">DelTag</A>
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 1.5  2000/04/04 14:25:40  saam
;           one implemented condition could never be fulfilled
;           -> erased
;
;     Revision 1.4  2000/04/04 14:22:34  saam
;           changed implementation to not change the
;           order of existing tags
;
;     Revision 1.3  2000/04/04 13:59:24  saam
;           bug if structure contained only one tag corrected
;
;     Revision 1.2  2000/01/17 14:29:52  kupper
;     Typo!
;     Must have been AGES ODL!
;
;     Revision 1.1  1999/07/28 08:46:41  saam
;           there has to be a settag if there is a deltag!
;
;
;-
PRO SetTag, S, TN, TV

   ON_Error, 2

   IF NOT Set(S)  THEN Message, 'first argument undefined'
   IF NOT Set(TN) THEN Message, 'second argument undefined'
   IF NOT Set(TV) THEN Message, 'third argument undefined'

   IF TypeOf(S)  NE 'STRUCT' THEN Message, 'first argument has to be a structure'
   IF TypeOf(TN) NE 'STRING' THEN message, 'second argument has to be a string'

   IF ExtraSet(S, TN, TAGNR=tagnr) THEN BEGIN
       ; tag already exists, replace it
       tn = Tag_Names(S)
       FOR i=0,tagnr-1 DO IF Set(_S) THEN _S = Create_Struct(_S, tn(i), S.(i)) ELSE _S = Create_Struct(tn(i), S.(i))  
       IF Set(_S) THEN _S = Create_Struct(_S, tn(tagnr), TV) ELSE _S = Create_Struct(tn(tagnr), TV)
       FOR i=tagnr+1, N_Tags(S)-1 DO IF Set(_S) THEN _S = Create_Struct(_S, tn(i), S.(i)) ELSE _S = Create_Struct(tn(i), S.(i))
       S = _S
   END ELSE BEGIN
       ; tag doesn't exist, append to the end
       S = Create_Struct(S, TN, TV)
   END

       ; the following was the old implementation:
       ; works even for the THEN case above
       ; but it w/could change the order of the tags, and i didn't want this
       ; for several reasons, therfore the above more complicated implementation 
       ;DelTag, S, TN
       ;IF TypeOf(S) EQ "STRUCT" THEN S = Create_Struct(S, TN, TV) ELSE S = Create_Struct(TN, TV)

END
