;+
; NAME:  USET_PLOT
;
; VERSION:
;  $Id$
;
; AIM:      sets the output device used by the IDL graphics procedures (nase color restriction)
;
;
; PURPOSE:       see IDL's manual for SET_PLOT
;
; RESTRICTIONS:  reverts !P.BACKGROUND and !P.COLOR index for PS devices
;
; CATEGORY:
;
;  Color
;  Graphic
;
; CALLING SEQUENCE:
;*                  SET_PLOT, Device [, /COPY] [, /INTERPOLATE]
;
;
;
;-

pro uset_plot, Device, _EXTRA=extra
   set_plot, Device, _EXTRA=extra
   case 1 of
      !D.Name EQ ScreenDevice(): begin
         DEVICE, GET_DECOMPOSED=DECOMPOSED
         if !D.N_COLORS EQ 16777216 and DECOMPOSED EQ 1 THEN return
         !P.BACKGROUND = !D.TABLE_SIZE-2
         !P.COLOR      = !D.TABLE_SIZE-1
      end
      !D.Name EQ 'PS': begin 
         !P.BACKGROUND = !D.TABLE_SIZE-1
         !P.COLOR      = !D.TABLE_SIZE-2
         return
      end
      else: return
   endcase
end
