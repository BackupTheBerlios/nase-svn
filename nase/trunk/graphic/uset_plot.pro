;+
; NAME:
;  USet_Plot
;
; VERSION:
;  $Id$
;
; AIM:
;  NASE compliant way to set the plot device (use instead of IDL's <C>SET_PLOT</C>)  
;
; PURPOSE:
;  This is a simple wrapper for IDLs internal <C>SET_PLOT</C> routine, that
;  ensures NASE color management guidelines. Calling conventions are
;  identical to <C>SET_PLOT</C>. <BR>
;  In cases, where setting the specified device fails, the 'Z' device
;  is set instead. Program execution is not interrupted. <BR> 
;  When the 'X' device is requested, but connecting to the X server is
;  forbidden (see <A>XAllowed()</A>), the 'Z' device is set
;  instead. Program execution is not interrupted.
;
; CATEGORY:
;  Color
;  Graphic
;
; CALLING SEQUENCE:
;*USet_Plot, Device [, /COPY] [, /INTERPOLATE]
;
; SIDE EFFECTS:
;  Since it internally calls <A>ResetCM</A>, background and foreground
;  colors for postscript devices may be swapped (feature!).
;
; SEE ALSO:
;  <A>ResetCM</A>, <A>XAllowed()</A>
;
;-

pro uset_plot, Device, _EXTRA=extra
   
   __device = device
   if TOTAL((IdlVersion(/FULL))(0:1) GT [5,3]) GE 1 then begin
      CALL_PROCEDURE,'CATCH', Error_status

      IF Error_status NE 0 THEN BEGIN
         printf,-2, "% WARN: (USET_PLOT) Cannot set device to '"+ __Device+"'"
         printf,-2, "% WARN: (USET_PLOT) Setting device to 'Z'"
         flush, -2
         __Device = 'Z'
      endif
     
   end else begin
      if __Device EQ 'X' and GetEnv('DISPLAY') EQ "" then begin
         printf,-2, "% WARN: (USET_PLOT) DISPLAY environment variable not set: cannot set device to '"+ __Device+"'"
         printf,-2, "% WARN: (USET_PLOT) Setting device to 'Z'"
         flush, -2
         __Device = 'Z'
      end
   endelse

   If __Device eq 'X' and not XAllowed() then begin
      printf, -2, "% WARN: (USET_PLOT) "+ $
        "Connecting to X server is forbidden. Setting device to 'Z'."
      flush, -2
      __Device = 'Z'
      return
   endif 



   set_plot, __Device, _EXTRA=extra



   case 1 of
      !D.Name EQ ScreenDevice() AND !D.NAME NE 'NULL' : begin
         DEVICE, GET_DECOMPOSED=DECOMPOSED
         if !D.N_COLORS EQ 16777216 and DECOMPOSED EQ 1 THEN return
         ;;DEVICE, /INSTALL_COLOR is a secret keword given from
         ;;CREASO support
         ;;necessary for 8 bit Displays under KDE 2.1.x
         ;;without this keyword private color switching is disabled
         if pseudocolor_visual() and  (ScreenDevice() eq 'X') then DEVICE, /INSTALL_COLOR
         ResetCM
         return
      end
      !D.Name EQ 'PS': begin 
          ResetCM
          return
      end
      !D.Name EQ 'Z': begin 
         ResetCM
         return
      end
      else: return
   endcase
end
