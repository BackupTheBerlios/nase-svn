;+
; NAME:
;   SetTag
;
; VERSION:
;   $Id$
; 
; AIM:
;   changes or creates tag in a structure
;
; PURPOSE:
;   Sets a certain structure tag to a new value. If the tag doesn't
;   exist, it will create it.
;
; CATEGORY:
;  Structures
;
; CALLING SEQUENCE:
;*   SetTag, S, TN, TV
;
; INPUTS:
;   S :: an arbitrary structure
;  TN :: string specifying the tag name, of the tag to be modified/set
;  TV :: value, that S.TN is set to
;
; SIDE EFFECTS:
;   S will be changed
;
; PROCEDURE:
;   uses <A>DelTag</A> and <*>Create_Struct</*>
;
; EXAMPLE:
;*   a={a:1,c:3}
;*   SetTag, a, 'b', 2
;*   help, a, /str
;*   >** Structure <401bf5c8>, 3 tags, length=6, refs=1:
;*   >   A               INT              1
;*   >   C               INT              3
;*   >   B               INT              2
;* 
;*   SetTag, a, 'b', 'bloedi'
;*   help, a, /str
;*   >** Structure <401bf5c4>, 3 tags, length=6, refs=1:
;*   >A               INT              1
;*   >C               INT              3
;*   >B               STRING    'bloedi'
;
; SEE ALSO:
;   <A>DelTag</A>, <A>ExtraSet</A>
;
;-
PRO SetTag, S, TN, TV

   ON_Error, 2

   IF NOT Set(TN) THEN Message, 'second argument undefined'
   IF NOT Set(TV) THEN Message, 'third argument undefined'
   IF NOT Set(S)  THEN BEGIN
       S = Create_Struct(TN, TV)
       RETURN
   END
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
