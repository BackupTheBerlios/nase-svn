;+
; NAME: PLOTTVSCL_INFO__Define
;
; PURPOSE: Support: Definiert den PLOTTVSCL_INFO Struktur.
;
; CATEGORY: Support
;
; CALLING SEQUENCE: -implizit-
;
; SIDE EFFECTS: Die PLOTTVSCL_INFO Struktur wird definiert.
;
; PROCEDURE: Die Definition wurde aus <A HREF="../../graphic#PLOTTVSCL">PlotTvScl</A>
;            übernommen.
;            Die Routine wird implizit (ab IDL 5) aufgerufen,
;            wenn ein PLOTTVSCL_INFO Struct verwendet wird, und
;            dieser noch nicht definiert wurde.
;
; EXAMPLE: my_plotinfos = Replicate({PLOTTVSCL_INFO}, 23)
;
; SEE ALSO: <A HREF="../../graphic#PLOTTVSCL">PlotTvScl</A>, <A HREF="../../graphic#PLOTTVSCL_UPDATE">PlotTvScl_Update</A>
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 1.2  2000/03/07 17:01:04  kupper
;        Removed x0, yo tags from structure (have never been used!)
;        Added "defined" tag.
;
;        Revision 1.1  1999/11/16 16:58:47  kupper
;        For easier programming with IDL 5.
;
;-

Pro PLOTTVSCL_INFO__Define

   GET_INFO = {PLOTTVSCL_INFO, $
               defined : 0b   ,$ ;used as checkmark for undefined structures
               x1      : long(0),$
               y1      : long(0),$
               x00     : long(0),$
               y00     : long(0),$ 
               x00_norm: 0.0,$
               y00_norm: 0.0,$ 
               tvxsize : long(0),$
               tvysize : long(0),$
               subxsize: long(0),$
               subysize: long(0), $
;
; Keywords to be passed to PlotTvScl_update:
               order   : 0, $
               nase    : 0, $
               neutral : 0, $
               noscale : 0, $
               polygon : 0, $
               top     : 0l, $
               cubic   : float(0), $
               interp  : 0, $
              minus_one: 0, $
              colormode: 0, $
               setcol  : 0, $
;
; Scaling Information to be stored by PlotTvScl_update:
               range_in: [-1.0d, -1.0d]}

End
