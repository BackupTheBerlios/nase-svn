;+
; NAME:               DelTag 
;
; AIM:                deletes a tag from a structure
;
; PURPOSE:            Loescht einen Tag aus einer Struktur. War der Tag ein Handle,
;                     so wird dieser freigegeben.
;
; CATEGORY:           MISC STRUCTURES
;
; CALLING SEQUENCE:   DelTag, S, T
;
; INPUTS:             S : eine beliebige Struktur aus der ein Tag geloescht werden soll
;                     T : ein String, der den zu loeschenden Tag bezeichnet
;
; SIDE EFFECTS:       Aus S wird T ggf. geloescht.
;
; PROCEDURE:          benutzt im wesentlich ExtraDiff
;
; EXAMPLE:
;                     a={a:1,b:2,c:3}
;                     DelTag, a, 'b'
;                     help, a, /str
;                     ;  ** Structure <40214e08>, 2 tags, length=4, refs=1:
;                     ;    A               INT              1
;                     ;    C               INT              3
;                     DelTag, a, 'dummy'
;                     help, a, /str
;                     ;  ** Structure <40214e08>, 2 tags, length=4, refs=1:
;                     ;    A               INT              1
;                     ;    C               INT              3
;
; SEE ALSO:           <A>SetTag</A>, <A>ExtraDiff</A> 
;
;-
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 1.3  2000/09/25 09:13:08  saam
;     * added AIM tag
;     * update header for some files
;     * fixed some hyperlinks
;
;     Revision 1.2  2000/01/17 14:29:52  kupper
;     Typo!
;     Must have been AGES ODL!
;
;     Revision 1.1  1999/03/19 14:10:35  saam
;           a little, cute routine
;
PRO DelTag, S, TN

   On_Error, 2

   IF NOT Set(S)  THEN Message, 'first argument undefined'
   IF NOT Set(TN) THEN Message, 'second argument undefined'

   IF TypeOf(S)  NE 'STRUCT' THEN Message, 'first argument has to be a structure'
   IF TypeOf(TN) NE 'STRING' THEN message, 'second argument has to be a string'

   deleted = ExtraDiff(S, TN)

   IF TypeOf(deleted) EQ 'LONG' THEN BEGIN
      IF Handle_Info(deleted) THEN BEGIN
         print, 'DELTAG DEBUG: Handle freed!'
         Handle_Free, deleted
      END
   END
END

   
