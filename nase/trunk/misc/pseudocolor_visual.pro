;+
; NAME:
;   Pseudocolor_Visual()
;
; AIM: checks if the graphics device uses pseudocolor mode
;
; PURPOSE:
;   On the X or WIN graphics device, determine whether the device runs in Pseudocolor 
;   mode or not.
;    Pseudocolor mode means, that only one color table is maintained for all
;   windows. The on-screen appearance of colors depends on the actually loaded
;   color table, i.e., the color of already plotted graphics changes, whenever a
;   different color table is loaded. In contrast, on non-pseudocolor devices,
;   the appearance of already plotted graphics on the display does not change,
;   when a different color table is loaded. The new color table only applies for 
;   subsequent graphics output.
;    Examples for pseudocolor graphic systems are the usual 8-bit VGA-like
;   graphic boards (private as well as shared colormaps). Examples for
;   non-pseudocolor systems are 24-bit "TrueColor" graphic boards. In contrast
;   to the WIN graphics device, the X device supports differnt so-called
;   "visuals". I.e. different graphics sub-modes may be requested from the
;   X-Server, depending on it's hardware capabilities. IDL supports six such
;   "visuals" (see IDL reference manual for details). Only two of these are
;   pseudocolor visuals:
;
;   Visual Name         Pseudocolor
;  ----------------------------------
;   StaticGray             no
;   GrayScale              yes
;   StaticColor            no	
;   PseudoColor            yes
;   TrueColor              no
;   DirectColor            no
;
; CATEGORY: Graphics
;   
; CALLING SEQUENCE:
;   result = Pseudocolor_Visual()
;
; OUTPUTS:
;   True or false, depending on the visual currently running.
;
; RESTRICTIONS and PROCEDURE:
;   This function works reliable only for the X graphics device and IDL version
;   5 or higher.
;     The WIN graphics device does not support "visuals". The distinction is made by 
;   checking the value of !D.N_COLORS. If this value is less or equal to 256,
;   the graphics mode is expected to be pseudocolor. (This produces reliable
;   results on the WIN device.)
;     In IDL versions up to IDL 4, the name of the running X visual could not be
;   retrieved from within IDL. For these versions, !D.N_COLORS is checked as
;   described above. However, the result is not reliable for the X device. To be 
;   concrete, Pseudocolor_Visual() will yield false results for StaticGray and
;   StaticColor visuals, as these are 8-bit, but not pseudocolor
;   systems. Anyway, these visuals are seldom used.
;
; EXAMPLE:
;
; SEE ALSO:
;   <A HREF="../graphic/colors/#RGB">RGB()</A>
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 1.7  2000/09/25 09:10:32  saam
;        * appended AIM tag
;        * some routines got a documentation update
;        * fixed some hyperlinks
;
;        Revision 1.6  2000/08/31 10:19:51  kupper
;        Added handling of MAC device (hope it's correct, can't test it.)
;
;        Revision 1.5  2000/03/07 14:43:51  kupper
;        Updated Header.
;
;        Revision 1.4  2000/03/07 14:19:15  kupper
;        Added StaticGrey and StaticColor visual check.
;        Added header.
;
;        Revision 1.3  2000/01/17 12:49:27  kupper
;        Added informational message.
;
;        Revision 1.2  2000/01/17 11:13:26  kupper
;        Broke on devices other than X.
;        Fixed.
;
;        Revision 1.1  1999/10/28 16:16:06  kupper
;        Color-Management with sheets was not correct on a
;        true-color-display.
;        (Table was not set when the sheet was opened).
;        We now do different things for pseudocolor and
;        truecolor-displays, to make them "feel" alike... (hopefully).
;
;-

Function PseudoColor_Visual
   
   Case !D.NAME of

      "X" : $
       If IDLVersion() ge 5 then begin
         Device, GET_VISUAL_NAME=v
         v = strupcase(temporary(v))
         Return, Not( (v eq "TRUECOLOR") or $
                      (v eq "DIRECTCOLOR") or $
                      (v eq "STATICGRAY") or $
                      (v eq "STATICCOLOR") $
                    )
      Endif Else Begin
         Return, !D.N_COLORS le 256
      Endelse

      "WIN" : $
       Return, !D.N_COLORS le 256
      
      "MAC" : $
       Return, !D.N_COLORS le 256
      
      else: begin
         Message, /INFO, "You are trying to determine the visual-class of a "+!D.NAME+"-device."
         Message, /INFO, "(Returning true.)"
         Return, 1
      endelse

   Endcase

End
   
