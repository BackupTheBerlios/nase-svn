;+
; NAME: ShowLogo
;
; PURPOSE: Stellt das NASE-Logo auf dem Bildschirm dar.
;          Außerdem wird im WINDOW-Command COLORS=256, also eine
;          private Colormap  verlangt.
;
; CALLING SEQUENCE: ShowLogo [,SECS=secs]
;
; KEYWORDS: SECS: Wird SECS nicht angegeben, so kehrt die Routine
;                 sofort zurück. Das Logo bleibt stehen.
;                 Wird SECS angegeben, so wartet die Routinen die
;                 angegebene Zahl von Sekunden und löscht dann das
;                 Logo wieder.
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 1.4  1999/03/11 17:42:05  kupper
;        KLeinigkeit, aber wichtig: WINDOW muß vor TVLCT kommen, damit man eine private Colormap bekommt!
;
;        Revision 1.3  1999/03/11 17:32:06  kupper
;        Showlogo hat jetzt das SECS Keyword.
;
;        In startup wird jetzt getestet, ob eine interaktive IDL-Session vorliegt.
;        (Test von stdout). Außerdem wird die Umgebungsvariable NASELOGO abgefragt:
;
;        	NASELOGO=FALSE: Es wird nie   ein Logo angezeigt, auch nicht bei interaktiven Sessions.
;        	NASELOGO=TRUE : Es wird stets ein Logo angezeigt, auch bei nicht-interaktiven (nohup) Sessions.
;        	In allen anderen Fällen wird bei interaktiven Sessions ein Logo gezeigt, sonst nicht.
;
;        Revision 1.2  1998/09/02 13:10:24  kupper
;        minor changes
;
;        Revision 1.1  1998/09/02 10:24:41  kupper
;        Fuer Startup!
;
;-

Pro ShowLogo, SECS=secs

   Read_GIF, GETENV("NASEPATH")+"/graphic/naselogo2.gif", logo, r, g, b

   device, get_screen_size=ss
   window, /free, COLORS=256, xsize=320, ysize=191, title="Welcome to N.A.S.E.!", xpos=ss(0)/2-150, ypos=ss(1)*0.6-95
   tvlct, r, g, b
   tv, logo

   if Keyword_Set(SECS) then begin
      wait, SECS
      caw
      loadct, 0
   endif
end
