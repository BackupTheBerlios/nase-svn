;+
; NAME: ShowLogo
;
; AIM: displays the well known NASE logo
;
; PURPOSE: Stellt das NASE-Logo auf dem Bildschirm dar.
;          Außerdem wird im WINDOW-Command COLORS=256, also eine
;          private Colormap  verlangt.
;
; CALLING SEQUENCE: ShowLogo [,SECS=secs]
;
; INPUT KEYWORDS: 
;   SECS:: Wird SECS nicht angegeben, so kehrt die Routine
;          sofort zurück. Das Logo bleibt stehen.
;          Wird SECS angegeben, so wartet die Routinen die
;          angegebene Zahl von Sekunden und löscht dann das
;          Logo wieder.
;
;-

Pro ShowLogo, SECS=secs

   IF TOTAL((IdlVersion(/FULL))(0:1) GT [5,3]) GE 1 THEN BEGIN
       logo = Read_PNG( FilePath("naselogo2.png", ROOT_DIR=!NASEPATH, $
                          SUBDIRECTORY=["graphic"]), r, g, b )
   END ELSE BEGIN
       Read_GIF, FilePath("naselogo2.gif", ROOT_DIR=!NASEPATH, $
                          SUBDIRECTORY=["graphic"]), logo, r, g, b
   END
   device, get_screen_size=ss
   window, /free, COLORS=256, xsize=320, ysize=191, title="Welcome to N.A.S.E.!", xpos=ss(0)/2-150, ypos=ss(1)*0.6-95
   win = !D.WINDOW
   Utvlct, r, g, b
   Utv, logo

   if Keyword_Set(SECS) then begin
      wait, SECS
      wdelete, win
      loadct, 0
   endif
end
