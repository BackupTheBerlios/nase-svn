;+
; NAME:
;  Foreground
;
; VERSION:
;  $Id$
;
; AIM:
;  Set the foreground (plotting) color for new windows.
;
; PURPOSE: 
;  This procedure sets the foreground (plotting) color for all
;  subsequently opened windows. It replaces the standard IDL way of
;  setting !P.Color manually, which is not compatible with NASE color
;  management. <BR>
; <I>During a NASE session, the value contained in !P.Color shall not
;  be modified by the user. Use this procedure instead.</I>
;
; CATEGORY:
;  Color
;
; CALLING SEQUENCE:
;*Foreground, ( colorstring | r, g, b )
;
; INPUTS:
;  colorstring:: A string containing a color name according to the
;                NASE color naming conventions. See <C>RGB</C> or
;                <C>Color</C> for details, or look for a document
;                describing the NASE color management.
;  r, g, b:: Three byte-range scalar values defining the red, green
;            and blue composition of the desired color.
;
; SIDE EFFECTS:
;  The index <*>!D.TABLE_SIZE-1</*> of the current color table is
;  changed. In NASE color management, this special index is
;  exclusively reserved to contain the foreground color.<BR>
;  <I>No manual modifications of explicit color indices or the values
;  contained in !P.Background and !P.Color shall be done by the user!</I>
;
; RESTRICTIONS:
;  <I>No manual modifications of explicit color indices or the values
;  contained in !P.Background and !P.Color shall be done by the user!</I>
;
; PROCEDURE:
;  Call <C>SetColorIndex</C> on <*>!D.TABLE_SIZE-1</*>.
;
; EXAMPLE:
;*Background, "white"
;*Foreground, 0,0,0
;*Plot, indgen(10)
;
; SEE ALSO:
;  <C>Background</C>, <C>RGB</C>, <C>Color</C>, or look for a document
;  describing the NASE color management.
;
;-

Pro Foreground, col, g, b

   assert, (N_Params() eq 1) or (N_Params() eq 3), "Either one or " + $
    "three arguments expected."

   If set(g) then begin ;; col argument is red parameter
      SetColorIndex, !D.TABLE_SIZE-1, col, g, b
      ;; set plotting options:
      !NASEP.FOREGROUND.NAME = "(custom)"
      !NASEP.FOREGROUND.R    = col
      !NASEP.FOREGROUND.G    = g
      !NASEP.FOREGROUND.B    = b
   endif else begin ;; col argument is a color string
      color, col, red=red, gree=green, blue=blue, /exit
      SetColorIndex, !D.TABLE_SIZE-1, red, green, blue
      ;; set plotting options:
      !NASEP.FOREGROUND.NAME = col
      !NASEP.FOREGROUND.R    = red
      !NASEP.FOREGROUND.G    = green
      !NASEP.FOREGROUND.B    = blue
   endelse

End
