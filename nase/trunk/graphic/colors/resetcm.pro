;+
; NAME:
;  ResetCM
;
; VERSION:
;  $Id$
;
; AIM:
;  enables or resets NASE color managment settings
;
; PURPOSE:
;  Enables or resets NASE color managment settings. This is
;  automatically done during NASE startup. Call <*>ResetCM</*> if a
;  graphics operation has destroyed this settings; unfortunately, most
;  NASE keywords do this, e.g. in calls to <A>PlotTvScl</A>, <A>SymbolPlot</A>.    
;
; CATEGORY:
;  Color
;  NASE
;
; CALLING SEQUENCE:
;* ResetCM
;
; SIDE EFFECTS:
;  Swaps background and foreground colors for postscript devices if
;  <C>!REVERTPSCOLORS</C> is set (feature!). Anyway, this does never
;  affect display on the screen.
;  
; SEE ALSO:
;  <A>Foreground</A>, <A>Background</A>, <A>GetForeground</A>,
;  <A>GetBackground</A>, <A>CIndex2RGB</A>, <A>ULoadCT</A>, <A>USet_Plot</A>
;
;-

PRO ResetCM

IF (!D.Name EQ 'PS') AND !REVERTPSCOLORS THEN BEGIN
    ; this option lets postscript plots be done with
    ; the standard background color (eg. black) 
    ; !! NOTE that postscript backgrounds are always white !! 
    ; so setting !P.BACKGROUND will have no effect at all
    !P.COLOR      = !D.TABLE_SIZE-2 
    !P.BACKGROUND = !D.TABLE_SIZE-1
END ELSE BEGIN 
    !P.COLOR      = !D.TABLE_SIZE-1 ; highest color index is reserved
                                    ; for foreground
    !P.BACKGROUND = !D.TABLE_SIZE-2 ; second highest color index is reserved
                                    ; for background
END

END
