;+
; NAME:
;  Background
;
; VERSION:
;  $Id$
;
; AIM:
;  Set the background color for new windows.
;
; PURPOSE: 
;  This procedure sets the background color for all subsequently
;  opened windows. It replaces the standard IDL way of setting
;  !P.Background manually, which is not compatible with NASE color
;  management. <BR>
; <I>During a NASE session, the value contained in !P.Background shall
;  not be modified by the user. Use this procedure instead.</I>
;
; CATEGORY:
;  Color
;
; CALLING SEQUENCE:
;*Background, ( colorstring | r, g, b )
;
; INPUTS:
;  colorstring:: A string containing a color name according to the
;                NASE color naming conventions. See <A>RGB</A> or
;                <A>Color</A> for details, or look for a document
;                describing the NASE color management.
;  r, g, b:: Three byte-range scalar values defining the red, green
;            and blue composition of the desired color.
;
; SIDE EFFECTS:
;  The index <C>!D.TABLE_SIZE-2</C> of the current color table is
;  changed. In NASE color management, this special index is
;  exclusively reserved to contain the background color.<BR>
;  <I>No manual modifications of explicit color indices or the values
;  contained in !P.Background and !P.Color shall be done by the user!</I>
;
; RESTRICTIONS:
;  <I>No manual modifications of explicit color indices or the values
;  contained in <C>!P.Background<C> and </C>!P.Color</C> shall be done by the user!</I>
;
; PROCEDURE:
;  Call <A>SetColorIndex</A> on <*>!D.TABLE_SIZE-2</*>.
;
; EXAMPLE:
;*Background, "white"
;*Foreground, 0,0,0
;*Plot, indgen(10)
;
; SEE ALSO:
;  <A>Foreground</A>, <A>RGB</A>, <A>Color</A>, or look for a document
;  describing the NASE color management.
;
;-

Pro Background, col, g, b

   assert, (N_Params() eq 1) or (N_Params() eq 3), "Either one or " + $
    "three arguments expected."

   If set(g) then begin ;; col argument is red parameter
      SetColorIndex, !D.TABLE_SIZE-2, col, g, b
      ;; set plotting options:
      !NASEP.BACKGROUND.NAME = "(custom)"
      !NASEP.BACKGROUND.R    = col
      !NASEP.BACKGROUND.G    = g
      !NASEP.BACKGROUND.B    = b
   endif else begin
      color, col, red=red, gree=green, blue=blue, /exit
      SetColorIndex, !D.TABLE_SIZE-2, red, green, blue
      ;; set plotting options:
      !NASEP.BACKGROUND.NAME = col
      !NASEP.BACKGROUND.R    = red
      !NASEP.BACKGROUND.G    = green
      !NASEP.BACKGROUND.B    = blue
   endelse

End
