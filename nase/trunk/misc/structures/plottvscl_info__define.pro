;+
; NAME: PLOTTVSCL_INFO__Define
;
; AIM: defines a <A>PlotTVScl</A> support structure (internal)
;
; PURPOSE: Support: Definiert den PLOTTVSCL_INFO Struktur.
;
; CATEGORY: Internal
;
; CALLING SEQUENCE: -implizit-
;
; SIDE EFFECTS: Die PLOTTVSCL_INFO Struktur wird definiert.
;
; PROCEDURE: Die Definition wurde aus <A>PlotTvScl</A>
;            übernommen.
;            Die Routine wird implizit (ab IDL 5) aufgerufen,
;            wenn ein PLOTTVSCL_INFO Struct verwendet wird, und
;            dieser noch nicht definiert wurde.
;
; EXAMPLE:
;* my_plotinfos = Replicate({PLOTTVSCL_INFO}, 23)
;
; SEE ALSO: <A>PlotTvScl</A>, <A>PlotTvScl_Update</A>
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
               norder  : 0b, $
               nscale  : 0b, $
               neutral : 0, $
               noscale : 0, $
               polygon : 0, $
               top     : 0l, $
               cubic   : float(0), $
               interp  : 0, $
              minus_one: 0, $
              colormode: 0, $
               setcol  : 0, $
          allowcolors  : 0, $
;
; Scaling Information to be stored by PlotTvScl_update:
               range_in: [-1.0d, -1.0d], $
                       $;;
                       $;;Data needed to (re)produce the legend:
                       leg_x: 0.0, $
                       leg_y: 0.0, $
                       leg_hstretch: 0.0, $
                       leg_vstretch: 0.0, $
                       charsize: 0.0, $
                       legend: 0, $
                       leg_min: 0.0, $
                       leg_mid_str: '', $
                       leg_max: 0.0 $
              }

End
