;+
; NAME: 
;  ShowLogo
;
; AIM: 
;  Display the well known NASE logo.
;
; PURPOSE: 
;  Display the NASE logo. Optionally wait for a specified amount of
;  time and then delete it.
;
; CALLING SEQUENCE: ShowLogo [,SECS=secs]
;
; INPUT KEYWORDS: 
;   SECS:: If SECS is not specified, the routine returns immediately,
;          leaving the logo on the screen. If SECS is specified, the
;          routine waits for the given number of seconds, then deletes
;          the logo from the screen and returns.
;
; RESTRICTIONS:
;  <B>Warning:</B> In its current form, the logo uses a full 256-entry
;  palette. The full logo-specific palette is loaded, breaking the
;  NASE colortable conventions! Note that after a call to
;  <C>ShowLogo</C>, your private NASE plotting colors will be
;  overwritten, and have to be restored by calling <A>Foreground</A>,
;  <A>Background</A> and <A>RGB</A> respectively.<BR>
;  <B>Todo:</B> We should really transformthe logo not to use the
;  upper 10 color entries, which are by default protected (as
;  specified in <A>DefGlobVars</A>).
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
   window, /free, xsize=320, ysize=191, title="Welcome to N.A.S.E.!", xpos=ss(0)/2-150, ypos=ss(1)*0.6-95
   win = !D.WINDOW
   
   ;; Do NOT use U-routines here:
   ;; this is a bitmap using all 256 colors!! It
   ;; breaks NASE color conventions!!
   Tvlct, r, g, b
   Tv, logo

   if Keyword_Set(SECS) then begin
      wait, SECS
      ;;hide the window
      wshow, win, 0
      ;;wait needed for refreshing the color table (KDE 2.1.x 8-bit Display)
      wait, 0.01
      wdelete, win
   endif
end
