;+
; NAME:
;   SaveStruc
;
; VERSION:
;   $Id$
;
; AIM:
;   stores a structure in a given LUN
;
; PURPOSE:
;   Arrays and scalar data types can easily be stored via
;   <*>PrintF</*> or <*>WriteU</*>. For structures, this is
;   only possible, if one knows the names and sizes of all
;   tags. SaveStruc and its partner <A>LoadStruc</A> provide
;   an easy to use extension for this.<BR>
;   Why not use IDLs <*>Save</*>, instead? Restored structures
;   always have to have the same name when being restored. This
;   is complicated, if you use different routines to save and
;   restore, because you have to synchronize the naming. It gets
;   even more complicated, if you want to save several structures.
;
; CATEGORY:
;  DataStorage
;  Files
;  IO
;  Structures
;
; CALLING SEQUENCE:
;*  SaveStruc, lun, Struc
;
; INPUTS:
;   lun  :: a valid file pointer
;   struc:: the structure to save
;
; RESTRICTIONS:
;   Struc <B>must not</B> contain any structure or
;   array of structures.
;
; EXAMPLE:
;
;*  a = {tag1:1,$
;*       hallo:[1,2,3,4,5],$
;*       shit:['A N','wkjfh','schluess']}
;*  help, a, /STRUCTURES
;*
;*  >** Structure <4001f608>, 3 tags, length=64, refs=1:
;*  >   TAG1            INT              1
;*  >   HALLO           INT       Array(5)
;*  >   SHIT            STRING    Array(3)
;*
;*  uopenw, 1, 'testfile'
;*  savestruc,1,a
;*  uclose,1
;*  uopenr, 1,'testfile'
;*  b=loadstruc(1)
;*  uclose, 1
;*  help, b, /STRUCTURES
;*
;*  >** Structure <4001f408>, 3 tags, length=64, refs=1:
;*  >   TAG1            INT              1
;*  >   HALLO           INT       Array(5)
;*  >   SHIT            STRING    Array(3)
;
; SEE ALSO:
;   <A>LoadStruc</A>
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
      IF N_Elements(tagSize) GT 3 AND SubSet(tagSize(N_Elements(tagSize)-2),[4,5,6,7,9]) THEN BEGIN
         ; this complicated handling is needed for correct saving of floating-point and string arrays
         ; other types don't care
         FOR i=0l, tagSize(N_Elements(tagSize)-1)-1 DO  BEGIN
            PrintF, lun, (ST.(tag))(i)
         END
      END ELSE PrintF, lun, ST.(tag)
   END

END
