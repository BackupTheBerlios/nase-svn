;+
; NAME:
;
; PURPOSE:
;
; CATEGORY:
;
; CALLING SEQUENCE:
;
; INPUTS:
;
; OPTIONAL INPUTS:
;
; KEYWORD PARAMETERS:
;
; OUTPUTS:
;
; OPTIONAL OUTPUTS:
;
; COMMON BLOCKS:
;
; SIDE EFFECTS:
;
; RESTRICTIONS:
;
; PROCEDURE:
;
; EXAMPLE:
;
; SEE ALSO:
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 2.1  1998/05/26 13:18:47  kupper
;               NASE-Colortables neu eingeführt.
;                STANDARD, EXPONENTIAL und MULTI
;
;-

Pro SelectNASETable, STANDARD=standard, EXPONENTIAL=exponential, MULTICOLOR=multicolor

   Default, STANDARD, 1

   If Keyword_Set(EXPONENTIAL) then begin
      !NASETABLE.POS          =  4
      !NASETABLE.NEGPOS       =  5
      !NASETABLE.PAPER_POS    =  6
      !NASETABLE.PAPER_NEGPOS          =  7
      Message, /INFORM, "Setze exponentielle NASE-Farbtabellen."
      Return
   Endif

   If Keyword_Set(MULTICOLOR) then begin
      !NASETABLE.POS          =  8
      !NASETABLE.NEGPOS       =  9
      !NASETABLE.PAPER_POS    =  2
      !NASETABLE.PAPER_NEGPOS =  3
      Message, /INFORM, "Setze Multi-Color NASE-Farbtabellen für die Bildschirmdarstellung."
      Return
   Endif

   If Keyword_Set(STANDARD) then begin
      !NASETABLE.POS          =  0
      !NASETABLE.NEGPOS       =  1
      !NASETABLE.PAPER_POS    =  2
      !NASETABLE.PAPER_NEGPOS =  3
      Message, /INFORM, "Setze lineare Standard-NASE-Farbtabellen."
   Endif

End
