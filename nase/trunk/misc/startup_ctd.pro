;+
; NAME: Startup_Ctd
;
; VERSION:
;   $Id$
;
; AIM: central NASE startup routine
;  
; PURPOSE: Does nearly everything that is needed to run NASE.<BR> 
;   * NASE search paths<BR> 
;   * calls several satellite routines like <A>Check_Nase_Lib</A>, <A>DefGlobVars</A><BR> 
;   * sets graphics device properly, and initializes NASE color management<BR> 
;   * shows the NASE logo via <A>ShowLogo</A><BR>
;   You probably do not want to call this routine, because it is only used during NASE's startup 
;   process.
;    
; CATEGORY:
;   NASE
;   MIND
;   Startup
;
; CALLING SEQUENCE:
;*  Startup_Ctd
;
; COMMON BLOCKS:
;  COMMON_RANDOM
;
; SEE ALSO:
;   <A>Check_Nase_Lib</A>, <A>DefGlobVars</A>, <A>ShowLogo</A>,
;   <A>ResetCM</A>, <A>Interactive()</A>, <A>XAllowed()</A>. 
;
;-

;; This procedure is not called again, if misc/startup is executed for
;; the second time by mistake.

Pro Startup_ctd
common commonrandom, seed


   ;; we need to define !PATHSEP here, since we need it for Path
   ;; modification. All other global vars are defined in defglobvars.
   
   ; os independent path separator
   if  StrUpcase(!version.OS_FAMILY) eq "UNIX" then DefSysV, '!PATHSEP', ":", 1
   if  Strupcase(!version.OS_FAMILY) eq "WINDOWS"      then DefSysV, '!PATHSEP', ";", 1
   if  Strupcase(!version.OS_FAMILY) eq "VMS"           then DefSysV, '!PATHSEP', ",", 1
   if  Strupcase(!version.OS_FAMILY) eq "MACOS"        then  DefSysV, '!PATHSEP', ",", 1


;------------------------------------------------------------------
   ;; warning: FilePath changes the variable passed to ROOT_DIR
   ;;          argument! Hence, using read-only !NASEPATH.

   NASEDIRS = FilePath("", ROOT_DIR=!NASEPATH, SUBDIRECTORY=["control"]) + !PATHSEP
   NASEDIRS = NASEDIRS + FilePath("", ROOT_DIR=!NASEPATH, SUBDIRECTORY=["control","counter"]) + !PATHSEP
   NASEDIRS = NASEDIRS + FilePath("", ROOT_DIR=!NASEPATH, SUBDIRECTORY=["control","loops"]) + !PATHSEP
   NASEDIRS = NASEDIRS + FilePath("", ROOT_DIR=!NASEPATH, SUBDIRECTORY=["control","output"]) + !PATHSEP
   NASEDIRS = NASEDIRS + FilePath("", ROOT_DIR=!NASEPATH, SUBDIRECTORY=["control","time"]) + !PATHSEP
   NASEDIRS = NASEDIRS + FilePath("", ROOT_DIR=!NASEPATH, SUBDIRECTORY=["control","videotape"]) + !PATHSEP
   NASEDIRS = NASEDIRS + FilePath("", ROOT_DIR=!NASEPATH, SUBDIRECTORY=["graphic"]) + !PATHSEP
   NASEDIRS = NASEDIRS + FilePath("", ROOT_DIR=!NASEPATH, SUBDIRECTORY=["graphic","colors"]) + !PATHSEP
   NASEDIRS = NASEDIRS + FilePath("", ROOT_DIR=!NASEPATH, SUBDIRECTORY=["graphic","nase"]) + !PATHSEP
   NASEDIRS = NASEDIRS + FilePath("", ROOT_DIR=!NASEPATH, SUBDIRECTORY=["graphic","plotcilloscope"]) + !PATHSEP
   NASEDIRS = NASEDIRS + FilePath("", ROOT_DIR=!NASEPATH, SUBDIRECTORY=["graphic","sheets"]) + !PATHSEP
   NASEDIRS = NASEDIRS + FilePath("", ROOT_DIR=!NASEPATH, SUBDIRECTORY=["graphic","support"]) + !PATHSEP
   NASEDIRS = NASEDIRS + FilePath("", ROOT_DIR=!NASEPATH, SUBDIRECTORY=["graphic","widgets"]) + !PATHSEP
   NASEDIRS = NASEDIRS + FilePath("", ROOT_DIR=!NASEPATH, SUBDIRECTORY=["graphic","widgets","faceit_demo"]) + !PATHSEP
   NASEDIRS = NASEDIRS + FilePath("", ROOT_DIR=!NASEPATH, SUBDIRECTORY=["math"]) + !PATHSEP
   NASEDIRS = NASEDIRS + FilePath("", ROOT_DIR=!NASEPATH, SUBDIRECTORY=["methods"]) + !PATHSEP
   NASEDIRS = NASEDIRS + FilePath("", ROOT_DIR=!NASEPATH, SUBDIRECTORY=["methods","fits"]) + !PATHSEP
   NASEDIRS = NASEDIRS + FilePath("", ROOT_DIR=!NASEPATH, SUBDIRECTORY=["methods","corrsspecs"]) + !PATHSEP
   NASEDIRS = NASEDIRS + FilePath("", ROOT_DIR=!NASEPATH, SUBDIRECTORY=["methods","rfscan"]) + !PATHSEP
   NASEDIRS = NASEDIRS + FilePath("", ROOT_DIR=!NASEPATH, SUBDIRECTORY=["methods","signals"]) + !PATHSEP
   NASEDIRS = NASEDIRS + FilePath("", ROOT_DIR=!NASEPATH, SUBDIRECTORY=["methods","stat"]) + !PATHSEP
   NASEDIRS = NASEDIRS + FilePath("", ROOT_DIR=!NASEPATH, SUBDIRECTORY=["misc"]) + !PATHSEP
   NASEDIRS = NASEDIRS + FilePath("", ROOT_DIR=!NASEPATH, SUBDIRECTORY=["misc","arrays"]) + !PATHSEP
   NASEDIRS = NASEDIRS + FilePath("", ROOT_DIR=!NASEPATH, SUBDIRECTORY=["misc","assoziativ"]) + !PATHSEP
   NASEDIRS = NASEDIRS + FilePath("", ROOT_DIR=!NASEPATH, SUBDIRECTORY=["misc","bugs"]) + !PATHSEP
   NASEDIRS = NASEDIRS + FilePath("", ROOT_DIR=!NASEPATH, SUBDIRECTORY=["misc","depression"]) + !PATHSEP
   NASEDIRS = NASEDIRS + FilePath("", ROOT_DIR=!NASEPATH, SUBDIRECTORY=["misc","filesdirs"]) + !PATHSEP
   NASEDIRS = NASEDIRS + FilePath("", ROOT_DIR=!NASEPATH, SUBDIRECTORY=["misc","filesdirs","compress"]) + !PATHSEP
   NASEDIRS = NASEDIRS + FilePath("", ROOT_DIR=!NASEPATH, SUBDIRECTORY=["misc","handles"]) + !PATHSEP
   NASEDIRS = NASEDIRS + FilePath("", ROOT_DIR=!NASEPATH, SUBDIRECTORY=["misc","keywords"]) + !PATHSEP
   NASEDIRS = NASEDIRS + FilePath("", ROOT_DIR=!NASEPATH, SUBDIRECTORY=["misc","regler"]) + !PATHSEP
   NASEDIRS = NASEDIRS + FilePath("", ROOT_DIR=!NASEPATH, SUBDIRECTORY=["misc","strings"]) + !PATHSEP
   NASEDIRS = NASEDIRS + FilePath("", ROOT_DIR=!NASEPATH, SUBDIRECTORY=["misc","structures"]) + !PATHSEP
   NASEDIRS = NASEDIRS + FilePath("", ROOT_DIR=!NASEPATH, SUBDIRECTORY=["misc","language"]) + !PATHSEP
   NASEDIRS = NASEDIRS + FilePath("", ROOT_DIR=!NASEPATH, SUBDIRECTORY=["object"]) + !PATHSEP
   NASEDIRS = NASEDIRS + FilePath("", ROOT_DIR=!NASEPATH, SUBDIRECTORY=["object","widget_object"]) + !PATHSEP
   NASEDIRS = NASEDIRS + FilePath("", ROOT_DIR=!NASEPATH, SUBDIRECTORY=["simu"]) + !PATHSEP
   NASEDIRS = NASEDIRS + FilePath("", ROOT_DIR=!NASEPATH, SUBDIRECTORY=["simu","input"]) + !PATHSEP
   NASEDIRS = NASEDIRS + FilePath("", ROOT_DIR=!NASEPATH, SUBDIRECTORY=["simu","connections"]) + !PATHSEP
   NASEDIRS = NASEDIRS + FilePath("", ROOT_DIR=!NASEPATH, SUBDIRECTORY=["simu","layers"]) + !PATHSEP
   NASEDIRS = NASEDIRS + FilePath("", ROOT_DIR=!NASEPATH, SUBDIRECTORY=["simu","plasticity"]) + !PATHSEP
   NASEDIRS = NASEDIRS + FilePath("", ROOT_DIR=!NASEPATH, SUBDIRECTORY=["demo"])
   SetEnv, "NASEDIRS="+NASEDIRS ;for compatibility reasons
   !PATH = !PATH+!PATHSEP+NASEDIRS
;------------------------------------------------------------------

   defglobvars                  ;Muss vor ShowLogo stehen, weil das
                                ;UTVLCT benutzt, was die Systemvariablen abfragt
   check_NASE_LIB               ;Check NASE C-library, make it if it does'n exist.


   ;; We need the following statement to have the next lines compiled
   ;; properly:
   FORWARD_FUNCTION Interactive, XAllowed

   ;;NASEMARK:--- Flush_stdin/stdout_in_non_interactive_session -----
   if NOT Interactive() then begin
      Flush, -2
      Flush, -1
   endif
   ;; --------------------------------------------------------

   ;;NASEMARK:--- Request_TRUECOLOR_device_if_allowed --------
   ;; --- Connect to X server only if allowed, which is    ---
   ;; --- determined by the XAllowed() function. If so, do ---
   ;; --- request the TRUE_COLOR device, set DECOMPOSED=0  ---
   ;; --- and request a private color map.                 ---
   ;; --- XAllowed() returns TRUE also, if an X connection ---
   ;; --- was expicitely requested by setting the environ- ---
   ;; --- ment variable NASELOGO='TRUE'.                   ---
   if XAllowed() then begin
      ;; try to get TRUE_COLOR, if available, but no DIRECT_COLOR!
      if (!D.NAME EQ 'X') or (!D.NAME EQ 'MAC') THEN DEVICE, TRUE_COLOR=24
      DEVICE, DECOMPOSED=0
      ;; request private color map:
      Window, 0, COLORS=256, XSIZE=1, YSIZE=1, /PIXMAP

      ;; NOTE: the following section is not needed any more, as RSI
      ;;       seem to have fixed the bug. I'll leave it here for some
      ;;       time anyway, in case any problems arise... 
      ;; -- BEGIN OBSOLETE SECTION -------------------------------------------------------------
      ;;       The following BYPASS_TRANSLATION=0 call seems to fix
      ;;       the problem of wrong color management with IDL 5.5.
      ;;       Why, by heaven's sake, IDL bypasses it's internal
      ;;       translation table, when on the other hand, 
      ;;       HELP, /DEVICE reports that it uses a -shared-
      ;;       colortable, I suppose no-one can and will and would
      ;;       ever want to know.
      ;;       To be exact, after getting the TRUE_COLOR-visual, the
      ;;       translation table is still enabled, and a shared color
      ;;       map is reported. Then, after the first window is
      ;;       opened, it switches to bypassed, while still reporting
      ;;       a shared color table. So we have to turn the translation
      ;;       table back on in the following call.
      ;;       Perhaps I'll try and ask RSI about it.
      ;;       By the way: DIRECT_COLOR visuals don't work in any
      ;;                   case, still. Just don't ask.
      ;;
      ;;;;;not needed anymore: if float(strmid(!version.release,0,3)) gt 5.4 then DEVICE, BYPASS_TRANSLATION=0
      ;; -- END OBSOLETE SECTION --------------------------------------------------------------

      WDelete, 0
   endif

   uset_plot, !D.NAME  

   ;;NASEMARK---- Show_Logo_on_startup? ----------------------
   ;; --- Show logo, if X connections are allowed.         ---
   ;; --- Furthermore, do not show the logo, if environment---
   ;; --- variable NASELOGO is explicitely set to 'FALSE'. ---
   if XAllowed() and (StrUpcase(GetEnv("NASELOGO")) ne "FALSE") then begin
      ShowLogo, SECS=3
   endif else begin
      print, "========================="
      print, "     Welcome to NASE. "
      print, "========================="
   endelse
   ;; --------------------------------------------------------
   
   ;;Initialisation (and restoring, if logo was displayed) of color map,
   ;;according to NASE color management, is done in the remaining
   ;;section of file misc/startup!

   ;;Initialise random seed, so that routines can expect it to be
   ;;defined:
   dummy = randomu(seed)
   Message, "Initialising random seed.", /Informational
End
