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

   if (fix(!VERSION.Release) ge 4) then OS_FAMILY=!version.OS_FAMILY else OS_FAMILY='unix'

   if  StrUpcase(OS_FAMILY) eq "UNIX"     then separator=":"
   if  Strupcase(OS_FAMILY) eq "WINDOWS" then separator=";"
   if  Strupcase(OS_FAMILY) eq "VMS"     then separator=","
   if  Strupcase(OS_FAMILY) eq "MACOS"   then separator=","

   ;; warning: FilePath changes the variable passed to ROOT_DIR
   ;;          argument! Hence, using read-only !NASEPATH.

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
   
   ;;Initialise (and restore, if logo was displayed) color map,
   ;;according to NASE color management:
   ULoadCt, 0 ;;(This is nohup-protected itself)

   ;;Initialise random seed, so that routines can expect it to be
   ;;defined:
   dummy = randomu(seed)
   Message, "Initialising random seed.", /Informational
End
