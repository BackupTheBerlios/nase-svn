;+
; NAME: Startup_Ctd
;
; VERSION:
;   $Id$
;
; AIM: central NASE startup routine
;  
; PURPOSE: Does nearly everything that is needed to run NASE.
;   * NASE search paths
;   * calls several satellite routines like <A>Check_Nase_Lib</A>, <A>DefGlobVars</A>
;   * sets graphics device properly, and initializes NASE color management 
;   * shows the NASE logo via <A>ShowLogo</A>
;   You probably do not want to call this routine, because it is only used during NASE's startup 
;   process.
;    
; CATEGORY:
;   NASE/MIND Startup
;
; CALLING SEQUENCE:
;   Startup_Ctd
;
; SEE ALSO:
;   <A>Check_Nase_Lib</A>, <A>DefGlobVars</A>, <A>ShowLogo</A>, <A>ResetCM</A> 
;
;-

;; This procedure is not called again, if misc/startup is executed for
;; the second time by mistake.

Pro Startup_ctd

   if (fix(!VERSION.Release) ge 4) then OS_FAMILY=!version.OS_FAMILY else OS_FAMILY='unix'

   if  StrUpcase(OS_FAMILY) eq "UNIX"     then separator=":"
   if  Strupcase(OS_FAMILY) eq "WINDOWS" then separator=";"
   if  Strupcase(OS_FAMILY) eq "VMS"     then separator=","
   if  Strupcase(OS_FAMILY) eq "MACOS"   then separator=","

   ;; warning: FilePath changes the variable passed to ROOT_DIR
   ;;          argument! Hence, using read-only !NASEPATH.

;   NASEDIRS = FilePath("", ROOT_DIR=!NASEPATH, SUBDIRECTORY=["alien"]) + separator
   NASEDIRS = FilePath("", ROOT_DIR=!NASEPATH, SUBDIRECTORY=["control"]) + separator
   NASEDIRS = NASEDIRS + FilePath("", ROOT_DIR=!NASEPATH, SUBDIRECTORY=["control","counter"]) + separator
   NASEDIRS = NASEDIRS + FilePath("", ROOT_DIR=!NASEPATH, SUBDIRECTORY=["control","loops"]) + separator
   NASEDIRS = NASEDIRS + FilePath("", ROOT_DIR=!NASEPATH, SUBDIRECTORY=["control","output"]) + separator
   NASEDIRS = NASEDIRS + FilePath("", ROOT_DIR=!NASEPATH, SUBDIRECTORY=["control","time"]) + separator
   NASEDIRS = NASEDIRS + FilePath("", ROOT_DIR=!NASEPATH, SUBDIRECTORY=["control","videotape"]) + separator
   NASEDIRS = NASEDIRS + FilePath("", ROOT_DIR=!NASEPATH, SUBDIRECTORY=["graphic"]) + separator
   NASEDIRS = NASEDIRS + FilePath("", ROOT_DIR=!NASEPATH, SUBDIRECTORY=["graphic","colors"]) + separator
   NASEDIRS = NASEDIRS + FilePath("", ROOT_DIR=!NASEPATH, SUBDIRECTORY=["graphic","nase"]) + separator
   NASEDIRS = NASEDIRS + FilePath("", ROOT_DIR=!NASEPATH, SUBDIRECTORY=["graphic","plotcilloscope"]) + separator
   NASEDIRS = NASEDIRS + FilePath("", ROOT_DIR=!NASEPATH, SUBDIRECTORY=["graphic","sheets"]) + separator
   NASEDIRS = NASEDIRS + FilePath("", ROOT_DIR=!NASEPATH, SUBDIRECTORY=["graphic","support"]) + separator
   NASEDIRS = NASEDIRS + FilePath("", ROOT_DIR=!NASEPATH, SUBDIRECTORY=["graphic","widgets"]) + separator
   NASEDIRS = NASEDIRS + FilePath("", ROOT_DIR=!NASEPATH, SUBDIRECTORY=["graphic","widgets","faceit_demo"]) + separator
   NASEDIRS = NASEDIRS + FilePath("", ROOT_DIR=!NASEPATH, SUBDIRECTORY=["math"]) + separator
   NASEDIRS = NASEDIRS + FilePath("", ROOT_DIR=!NASEPATH, SUBDIRECTORY=["methods"]) + separator
   NASEDIRS = NASEDIRS + FilePath("", ROOT_DIR=!NASEPATH, SUBDIRECTORY=["methods","fits"]) + separator
   NASEDIRS = NASEDIRS + FilePath("", ROOT_DIR=!NASEPATH, SUBDIRECTORY=["methods","corrsspecs"]) + separator
   NASEDIRS = NASEDIRS + FilePath("", ROOT_DIR=!NASEPATH, SUBDIRECTORY=["methods","rfscan"]) + separator
   NASEDIRS = NASEDIRS + FilePath("", ROOT_DIR=!NASEPATH, SUBDIRECTORY=["methods","signals"]) + separator
   NASEDIRS = NASEDIRS + FilePath("", ROOT_DIR=!NASEPATH, SUBDIRECTORY=["methods","stat"]) + separator
   NASEDIRS = NASEDIRS + FilePath("", ROOT_DIR=!NASEPATH, SUBDIRECTORY=["misc"]) + separator
   NASEDIRS = NASEDIRS + FilePath("", ROOT_DIR=!NASEPATH, SUBDIRECTORY=["misc","arrays"]) + separator
   NASEDIRS = NASEDIRS + FilePath("", ROOT_DIR=!NASEPATH, SUBDIRECTORY=["misc","assoziativ"]) + separator
   NASEDIRS = NASEDIRS + FilePath("", ROOT_DIR=!NASEPATH, SUBDIRECTORY=["misc","bugs"]) + separator
   NASEDIRS = NASEDIRS + FilePath("", ROOT_DIR=!NASEPATH, SUBDIRECTORY=["misc","depression"]) + separator
   NASEDIRS = NASEDIRS + FilePath("", ROOT_DIR=!NASEPATH, SUBDIRECTORY=["misc","filesdirs"]) + separator
   NASEDIRS = NASEDIRS + FilePath("", ROOT_DIR=!NASEPATH, SUBDIRECTORY=["misc","filesdirs","compress"]) + separator
   NASEDIRS = NASEDIRS + FilePath("", ROOT_DIR=!NASEPATH, SUBDIRECTORY=["misc","handles"]) + separator
   NASEDIRS = NASEDIRS + FilePath("", ROOT_DIR=!NASEPATH, SUBDIRECTORY=["misc","keywords"]) + separator
   NASEDIRS = NASEDIRS + FilePath("", ROOT_DIR=!NASEPATH, SUBDIRECTORY=["misc","regler"]) + separator
   NASEDIRS = NASEDIRS + FilePath("", ROOT_DIR=!NASEPATH, SUBDIRECTORY=["misc","strings"]) + separator
   NASEDIRS = NASEDIRS + FilePath("", ROOT_DIR=!NASEPATH, SUBDIRECTORY=["misc","structures"]) + separator
   NASEDIRS = NASEDIRS + FilePath("", ROOT_DIR=!NASEPATH, SUBDIRECTORY=["object"]) + separator
   NASEDIRS = NASEDIRS + FilePath("", ROOT_DIR=!NASEPATH, SUBDIRECTORY=["object","widget_object"]) + separator
   NASEDIRS = NASEDIRS + FilePath("", ROOT_DIR=!NASEPATH, SUBDIRECTORY=["simu"]) + separator
   NASEDIRS = NASEDIRS + FilePath("", ROOT_DIR=!NASEPATH, SUBDIRECTORY=["simu","input"]) + separator
   NASEDIRS = NASEDIRS + FilePath("", ROOT_DIR=!NASEPATH, SUBDIRECTORY=["simu","connections"]) + separator
   NASEDIRS = NASEDIRS + FilePath("", ROOT_DIR=!NASEPATH, SUBDIRECTORY=["simu","layers"]) + separator
   NASEDIRS = NASEDIRS + FilePath("", ROOT_DIR=!NASEPATH, SUBDIRECTORY=["simu","plasticity"]) + separator
   NASEDIRS = NASEDIRS + FilePath("", ROOT_DIR=!NASEPATH, SUBDIRECTORY=["demo"])
   SetEnv, "NASEDIRS="+NASEDIRS ;for compatibility reasons
   !PATH = !PATH+separator+NASEDIRS
;------------------------------------------------------------------

   defglobvars                  ;Muss vor ShowLogo stehen, weil das UTVLCT benutzt, was die Systemvariablen abfragt

   check_NASE_LIB               ;Check NASE C-library, make it if it does'n exist.


   ;; ----------- Are we running an interactive session? -----
   stdout_fstat = fstat(-1)
   if fix(!version.release) lt 4 then $
    IsInteractiveSession = stdout_fstat.isatty $
   else $
    IsInteractiveSession = stdout_fstat.interactive
   ;; --------------------------------------------------------

   ;; --- in a nohup-session, don't connect to X-Server ------
   ;; --- but always connect to X-Server, if display of ------
   ;; --- the NASE logo was requested!                  ------
   if IsInteractiveSession or (GetEnv("NASELOGO") eq "TRUE") then $
    if (!D.NAME EQ 'X') or (!D.NAME EQ 'MAC') THEN DEVICE, TRUE_COLOR=24       ; try to get it, if available, but no DIRECT_COLOR!
   if IsInteractiveSession or (GetEnv("NASELOGO") eq "TRUE") then $
    DEVICE, DECOMPOSED=0
   ;; --------------------------------------------------------

   ;; ----------- Show Logo on startup? ----------------------
   WillShowLogo = (GetEnv("NASELOGO") eq "TRUE")
   WillShowLogo = (WillShowLogo or IsInteractiveSession)
   if (GetEnv("NASELOGO") eq "FALSE") then WillShowLogo = 0
   If WillShowLogo then ShowLogo, SECS=3
   ;; --------------------------------------------------------


   ResetCM
   Foreground, 255, 255, 255 ; default foreground is white
   Background,   0,   0,   0 ; default background is black

End
