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
;  NASE keywords do this, e.g. in calls to <A>PlotTvScl</A>, <A>SymbolPlot</A>    
;
; CATEGORY:
;  Color
;  NASE
;
; CALLING SEQUENCE:
;* ResetCM
;
; SEE ALSO:
;  <A>Foreground<A>, <A>Background</A>, <A>GetForeground<A>,
;  <A>GetBackground</A>, <A>CIndex2RGB</A>, <A>ULoadCT</A>
;
;-

PRO ResetCM

!P.COLOR      = !D.TABLE_SIZE-1 ; highest color index is reserved
                                ; for foreground
!P.BACKGROUND = !D.TABLE_SIZE-2 ; second highest color index is reserved
                                ; for background

END
