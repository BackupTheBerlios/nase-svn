;+
; NAME: SelectNASEtable
;
; PURPOSE: Ausw�hlen eines der vordefinierten NASE-Colortable-S�tze
;          (Bildschirm und Postscript).
;
; CATEGORY: Graphic
;
; CALLING SEQUENCE: SelectNASEtable [,/STANDARD | ,/EXPONENTIAL | ,/MULTICOLOR]
;
; KEYWORD PARAMETERS: STANDARD (Default): Es werden die altbekannten
;                                         linearen Farnverl�ufe
;                                         verwendet.
;                     EXPONENTIAL       : Die gleichen Farbverl�ufe
;                                         exponentiell, zur besseren
;                                         Aufl�sung niedriger Werte.
;                     MULTICOLOR        : Vielfarbtabellen (bisher nur 
;                                         f�r Bildschirm)
;
; SIDE EFFECTS: Die !NASETABLE-Variable wird ver�ndert.
;
; PROCEDURE: ebendies.
;
; EXAMPLE: SelectNASEtable, /EXPONENTIAL
;
; SEE ALSO: <A HREF="#SHOWWEIGHTS">ShowWeights</A>, <A HREF="#SHOWWEIGHTS_SCALE">ShowWeights_Scale()</A>.
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 2.3  1998/06/10 12:30:34  kupper
;               Multicolor auch fuer Postscript (identische Farbtabelle wie Bildschirm...)
;
;        Revision 2.2  1998/05/26 13:27:44  kupper
;               Header erg�nzt.
;
;        Revision 2.1  1998/05/26 13:18:47  kupper
;               NASE-Colortables neu eingef�hrt.
;                STANDARD, EXPONENTIAL und MULTICOLOR
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
      !NASETABLE.PAPER_POS    =  8
      !NASETABLE.PAPER_NEGPOS =  9
      Message, /INFORM, "Setze Multi-Color NASE-Farbtabellen (f�r die Bildschirmdarstellung)."
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
