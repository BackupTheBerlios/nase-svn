;+
; NAME:
;   LoadStruc()
;
; AIM:
;   restores a structure saved with <A>SaveStruc</A> from a LUN
;
; PURPOSE:
;   Arrays and scalar data types can easily be stored via
;   <*>PrintF</*> or <*>WriteU</*>. For structures, this is 
;   only possible, if one knows the names and sizes of all
;   tags. <*>LoadStruc</*> and its partner <A>SaveStruc</A> provide
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
;*   struc = LoadStruc(lun)
;
; INPUTS:             
;   lun  :: a valid file pointer
;
; OUTPUTS:
;   struc:: the structure loaded from lun
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
;   <A>SaveStruc</A>
;
;-
FUNCTION LoadStruc, lun

   nTags = 0
   ReadF, lun, nTags

   FOR tag=0, nTags-1 DO BEGIN
      tagName = ''
      ReadF, lun, tagName

      tagSizeElements = 0
      ReadF, lun, tagSizeElements
      
      tagSize = IntArr(tagSizeElements)
      ReadF, lun, tagSize
      
      IF tagSizeElements LT 4 THEN BEGIN
         ; we have found a scalar
         tmpval = Make_Array(SIZE=[1,1,tagSize(1), tagSize(2)])
         tagVal = tmpval(0)
      END ELSE BEGIN
         ; hurra, it's an array
         tagVal = Make_Array(SIZE=tagSize)
      END
      ReadF, lun, tagVal

      IF tag EQ 0 THEN BEGIN
         ST = Create_Struct(tagName, tagVal)
      END ELSE BEGIN
         ST = Create_Struct(ST, tagName, tagVal)
      END
   END

   RETURN, ST
END
