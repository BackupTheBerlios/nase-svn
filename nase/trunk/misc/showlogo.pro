;+
; NAME: ShowLogo
;
; PURPOSE: Stellt das NASE-Logo auf dem Bildschirm dar.
;;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 1.2  1998/09/02 13:10:24  kupper
;        minor changes
;
;        Revision 1.1  1998/09/02 10:24:41  kupper
;        Fuer Startup!
;
;-

Pro ShowLogo

   Read_GIF, GETENV("NASEPATH")+"/graphic/naselogo2.gif", logo, r, g, b
   tvlct, r, g, b

   device, get_screen_size=ss
   window, /free, xsize=320, ysize=191, title="Welcome to N.A.S.E.!", xpos=ss(0)/2-150, ypos=ss(1)*0.6-95
   plot, indgen(10)

   tv, logo
end
