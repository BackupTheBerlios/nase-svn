;+
; NAME:                SaveStruc
;
; PURPOSE:             Arrays und skalare Datentypen lassen sich einfach
;                      per PrintF oder WriteU speichern. Dies geht fuer
;                      Structures nur, wenn man beim Laden die Tags und
;                      Dimensionen kennt. Leider weiss man das halt nicht
;                      immer. Die Funktionen SaveStruc und das Komplement 
;                      LoadStruc heben diese Einschraekung auf.
;
; CATEGORY:            MISC
;
; CALLING SEQUENCE:    SaveStruc, lun, Struc
;
; INPUTS:              lun  : ein gueltiger FilePointer
;                      Struc: die zu speichernde Struktur
;
; RESTRICTIONS:
;                      Struc darf keine weitere Struktur oder Array von 
;                      Structuren enthalten.
;
; EXAMPLE:
;                      a = {tag1:1,$
;                           hallo:[1,2,3,4,5],$
;                           shit:['A N','wkjfh','schluess']}
;                      help, a, /STRUCTURES
;                      openw, 1, 'testfile'
;                      savestruc,1,a
;                      close,1
;                      openr, 1,'testfile'
;                      loadstruc,1,b
;                      close, 1
;                      help, b, /STRUCTURES
;                      
;                   Screenshot:
;                      ** Structure <4001f608>, 3 tags, length=64, refs=1:
;                         TAG1            INT              1
;                         HALLO           INT       Array(5)
;                         SHIT            STRING    Array(3)
;                      ** Structure <4001f408>, 3 tags, length=64, refs=1:
;                         TAG1            INT              1
;                         HALLO           INT       Array(5)
;                         SHIT            STRING    Array(3)
;
; SEE ALSO:         <A HREF="#LOADSTRUC">LoadStruc</A>
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 2.1  1997/11/26 09:18:04  saam
;           Urversion
;
;
;-
PRO SaveStruc, lun, ST

   s = SIZE(st)

   IF (s(0) NE 1) OR (s(N_Elements(s)-2) NE 8) THEN Message, 'sorry, only for scalar structures'
   
   nTags = N_Tags(ST)
   tagName = Tag_Names(ST)

   PrintF, lun, nTags
   FOR tag=0, nTags-1 DO BEGIN
      PrintF, lun, tagName(tag)
      tagSize = SIZE(ST.(tag))
      IF tagSize(N_Elements(tagSize)-2) EQ 8 THEN Message, 'sorry, tags are not allowed to be structures'
      PrintF, lun, N_Elements(tagSize)
      PrintF, lun, tagSize 
      IF N_Elements(tagSize) GT 3 THEN BEGIN
         ; this complicated handling is needed for correct saving of string arrays
         ; other types don't care 
         FOR i=0l, tagSize(N_Elements(tagSize)-1)-1 DO  BEGIN
            PrintF, lun, (ST.(tag))(i)
         END
      END ELSE PrintF, lun, ST.(tag)
   END

END
