;+
; NAME:
;  PlotLegend
;
; VERSION:
;  $Id$
;
; AIM:
;  Add description of different lines to a plot.
;
; PURPOSE:
;  Add description of different lines to a plot.
;
; CATEGORY:
;  Graphic
;
; CALLING SEQUENCE:
;* PlotLegend, xo, yo, texts
;*           [,LCOLORS=...][,TCOLORS=...]
;*           [,LSTYLES=...][,LSPREAD=...][,LLENGTH=...]
;*           [,LTGAP=...][,TBASE=...]
;
; INPUTS:
;  xo:: x origin, left corner, normal ccords
;  yo:: y origin, lower corner,normal coords
;  texts:: labels, array of strings
;
; INPUT KEYWORDS:
;  LCOLORS:: line colors
;  TCOLORS:: textcolors
;  LSTYLES:: linestyles
;  LSPREAD:: linespread, multiples of charsize
;  LLENGTH:: line length, normal coords
;  LTGAP:: line/text gap
;  TBASE:: text baseline offset, multiples of charsize
;
; RESTRICTIONS:
;  If <*>LCOLORS</*> is set, it must have the same number of elements than
;  <*>texts</*>. If <*>TCOLORS</*> is set, it must have either one
;  entry (all texts get the same color), or the same number of elements
;  than <*>texts</*>. 
;
; PROCEDURE:
;  + Determine charsize for given device.<BR>
;  + Calculate line positions.<BR>
;  + Plot lines.<BR>
;  + Calculate text positions.<BR>
;  + Print the text.<BR>
;
; EXAMPLE:
;* PlotLegend, 0.5,0.5,['foo','bar','baz'] $
;*  , LCOLORS=[RGB('green'),RGB('yellow'),RGB('red')],TCOLORS=RGB('blue')
;
; SEE ALSO:
;  <A>TVSclLegend</A>.
;
;-



PRO PlotLegend, xo, yo, texts $
                , LCOLORS=lcolors, TCOLORS=tcolors $
                , LSTYLES=lstyles $
                , LSPREAD=lspread $
                , LLENGTH=llength $
                , LTGAP=ltgap $
                , TBASE=tbase
   
   number = N_Elements(texts)

   Default, lcolors, Make_Array(number, /INTEGER, VALUE=255)
   Default, tcolors, Make_Array(number, /INTEGER, VALUE=255)
   Default, lstyles, IndGen(number) MOD 6

   Default, llength, 0.1        ; length of lines, normal
   Default, ltgap, 1.0          ; gap between lines and text, charsize 
   Default, lspread, 1.0        ; separation between lines, charsize
   Default, tbase, 0.33         ; textbaseline relative to lines, charsize

   ;;xycharsizes in normal coordinates:
   csn = Convert_coord([!D.X_CH_SIZE, !D.Y_CH_SIZE] $
                       , /DEVICE, /TO_NORMAL)
   xcsn = !P.CHARSIZE*csn(0)
   ycsn = !P.CHARSIZE*csn(1)

   ;; Calculate line positions
   xpos = [0.0, llength]+xo
   ypos = Rebin(lspread*ycsn*Indgen(number),number,2)+yo

   ;; Plot lines
   FOR i=0, number-1 DO BEGIN
      PlotS, xpos, ypos(i,*), /NORMAL, LINESTYLE=lstyles(i) $
       ,COLOR=lcolors(i)
   ENDFOR

   ;; Calculate text positions
   xpos = Replicate(xpos(1),3)+ltgap*xcsn
   ypos = ypos(*,0)-tbase*ycsn

   ;; Write text
   XYOutS, xpos, ypos, texts, /NORMAL, COLOR=tcolors
     

END
