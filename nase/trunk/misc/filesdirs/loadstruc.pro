;+
; NAME:                LoadStruc
;
; AIM:                 restores a structure saved with <A>SaveStruc</A> from a LUN
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
; CALLING SEQUENCE:    Struc = LoadStruc(lun)
;
; INPUTS:              lun  : ein gueltiger FilePointer
;
; OUTPUTS:             Struc: die geladende Struktur
;
; RESTRICTIONS:
;                      Struc darf beim Speichern keine weitere Struktur oder Array von 
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
;                      b=loadstruc(1)
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
; SEE ALSO:         <A HREF="#SAVESTRUC">SaveStruc</A>
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 2.3  2000/09/25 09:13:02  saam
;     * added AIM tag
;     * update header for some files
;     * fixed some hyperlinks
;
;     Revision 2.2  1997/12/17 16:22:23  saam
;           Umwandlung in Funktion
;
;     Revision 2.1  1997/11/26 09:18:04  saam
;           Urversion
;
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
