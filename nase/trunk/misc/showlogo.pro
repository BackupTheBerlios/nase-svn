;+
; NAME:
;
; PURPOSE:
;
; CATEGORY:
;
; CALLING SEQUENCE:
;
; INPUTS:
;
; OPTIONAL INPUTS:
;
; KEYWORD PARAMETERS:
;
; OUTPUTS:
;
; OPTIONAL OUTPUTS:
;
; COMMON BLOCKS:
;
; SIDE EFFECTS:
;
; RESTRICTIONS:
;
; PROCEDURE:
;
; EXAMPLE:
;
; SEE ALSO:
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 1.1  1998/09/02 10:24:41  kupper
;        Fuer Startup!
;
;-

Pro ShowLogo

   Read_GIF, GETENV("NASEPATH")+"/graphic/naselogo2.gif", logo, r, g, b
   tvlct, r, g, b

   device, get_screen_size=ss
   window, /free, xsize=320, ysize=191, title="Welcome to N.A.S.E.!", xpos=ss(0)/2-150, ypos=ss(1)/2-50
   plot, indgen(10)

   tv, logo
end
