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
   
   __device = device
   if TOTAL((IdlVersion(/FULL))(0:1) GT [5,3]) GE 1 then begin
      CALL_PROCEDURE,'CATCH', Error_status

      IF Error_status NE 0 THEN BEGIN
         printf,-2, "% WARN: (USET_PLOT) Cannot set device to '"+ __Device+"'"
         printf,-2, "% WARN: (USET_PLOT) Setting device to 'Z'"
         __Device = 'Z'
      endif
     
   end else begin
      if __Device EQ 'X' and GetEnv('DISPLAY') EQ "" then begin
         printf,-2, "% WARN: (USET_PLOT) DISPLAY environment variable not set: cannot set device to '"+ __Device+"'"
         printf,-2, "% WARN: (USET_PLOT) Setting device to 'Z'"
         __Device = 'Z'
      end
   endelse

   set_plot, __Device, _EXTRA=extra

   case 1 of
      !D.Name EQ ScreenDevice() AND !D.NAME NE 'NULL' : begin
         DEVICE, GET_DECOMPOSED=DECOMPOSED
         if !D.N_COLORS EQ 16777216 and DECOMPOSED EQ 1 THEN return
         !P.BACKGROUND = !D.TABLE_SIZE-2
         !P.COLOR      = !D.TABLE_SIZE-1
         return
      end
      !D.Name EQ 'PS': begin 
         !P.BACKGROUND = !D.TABLE_SIZE-1
         !P.COLOR      = !D.TABLE_SIZE-2
         return
      end
      else: return
   endcase
end
