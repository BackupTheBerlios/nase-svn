;+
; NAME:
;  DefGlobVars
;
; VERSION:
;  $Id$
; 
; AIM:
;  defines all NASE specific system variables
;
; PURPOSE:
;  Defines a bunch of system variables, used by several NASE routines.
;  This routine is part of the NASE startup sequence and you will
;  generally not call it by hand.<BR>
;  <*>!CREATEDIR</*>:: if set to 1, <A>UOpenW</A> will automatically create
;  non-existent directories. Default is not to do so.   
;  <*>!FILESEP</*>:: contains the operating system dependent file
;  separator, namely a slash on unix and a backslash on windows platforms.
;  <*>!NASE_LIB</*>:: path to the system-dependent dynamic NASE library
;  <*>!REVERTPSCOLORS</*> :: Swaps foreground and background colors
;  when using postscript output. This is useful, since IDLs standard
;  colors are white on black (screen), while a postscript always has a
;  white background, so this option assures that you see something in
;  the output, when not changing any color. This option is turned on
;  by default and is used by <A>ResetCM</A> and <A>OpenSheet</A> as
;  far as i know. 
;  <*>!TOPCOLOR</*> :: maximal user color index. All color indices
;  above this value are used by the NASE color managment and <B>MUST
;  NOT</B> be modified by the user. All NASE
;  color routines like <A>ULoadCT</A>, <A>Foreground</A>,
;  <A>Background</A> respect these
;  settings. <*>!TOPCOLOR <= !D.Table_Size-3</*> must apply, default
;  value is <*>!D.Table_Size-11</*> reserving 10 colors for NASE.<BR> 
;  <*>NOTE!</*>:: several variables are still undocumented
;
; CATEGORY:
;  Startup 
;
; CALLING SEQUENCE:
;  DefGlobvars
;
; SIDE EFFECTS:
;  sets several system variables
;
;-
PRO DefGlobVars

;;;NASEMARK: simulation_variables ----------------------------------------------

DefSysV, '!NONE' , -999999.0, 1
DefSysV, '!NONEl', -999999  , 1
DefSysV, '!NOMERCYFORPOT', 0.01, 1



;;;NASEMARK: constants ---------------------------------------------------------

DefSysV, '!SIGMA2HWB', sqrt(alog(4d)), 1
DefSysV, '!HWB2SIGMA', 1d/sqrt(alog(4d)), 1
DefSysV, '!KEY',       {UP	: string(27b)+'[A', $   ; ESC has ASCII 27
			DOWN	: string(27b)+'[B', $
			RIGHT	: string(27b)+'[C', $
			LEFT	: string(27b)+'[D', $
			INS	: string(27b)+'[2~', $
			DEL	: string(27b)+'[3~', $
			PGUP	: string(27b)+'[5~', $
			PGDOWN	: string(27b)+'[6~', $
			POS1	: string(27b)+'[H', $
			_END	: string(27b)+'[F', $
			CLEAR   : string(27b)+'[H'+string(27b)+'[2J',$
			F1	: string(27b)+'[11~', $
			F2	: string(27b)+'[12~', $
			F3	: string(27b)+'[13~', $
			F4	: string(27b)+'[14~', $
			F5	: string(27b)+'[15~', $
			F6	: string(27b)+'[17~', $
			F7	: string(27b)+'[18~', $
			F8	: string(27b)+'[19~', $
			F9	: string(27b)+'[20~', $
			F10	: string(27b)+'[21~', $
			F11	: string(27b)+'[23~', $
			F12	: string(27b)+'[24~', $
			BACK	: string(127b), $
			ENTER	: string(10b), $
			TAB	: string(9b), $
			ESC	: string(27b), $
			BEL	: string(7b)}, 1



;;;NASEMARK graphics_variables ------------------------------------------------

DefSysV, '!REVERTPSCOLORS', 1

DefSysV, '!TOPCOLOR', !D.Table_Size-11 ;;; protect some colors from being overwritten by uloadct (here: 10)
                                       ;;; maximal accetable value is
                                       ;;; !D.Table_Size-3 (to protect
                                       ;;; white and black)

DefSysV, '!NASEP', {!NASEPLT, $ ; according to !P, !PLT of standard IDL
                    TABLESET: {!NASETABLESET, $
                               SETNUMBER   : -1, $
                               POS         : -1, $
                               NEGPOS      : -1, $
                               PAPER_POS   : -1, $
                               PAPER_NEGPOS: -1}, $
                    INTERPOLATION: -1l, $ ; 0:none, 1:linear, 2:cubic, 3:none(polygons)
                    FOREGROUND: {!NASECOLOR, $
                                 NAME: "uninitialized", $
                                 R   : 0B, $
                                 G   : 0B, $
                                 B   : 0B}, $
                    BACKGROUND: {!NASECOLOR}}
;; the !NASEP variable will be corretly initialized at the end of "misc/startup".





;;;NASEMARK: filesystem_variables ----------------------------------------------

; der Pfad zu unserer Shared Library für CALL_EXTERNAL
DefSysV, '!NASE_LIB', !NASEPATH+'/shared/'+!VERSION.OS+'_'+!VERSION.ARCH+'/nasec.so', 0

; if set to 1, UOPENW will create directories if they dont exist
DefSysV, '!CREATEDIR', 0, 0

; os independent file separator
DefSysV, '!FILESEP', StrMid(filepath("", root_dir=" ", SUBDIR=[""]),1,1)




; Master Handle
DefSysV, '!MH', Handle_Create()

; defines a standard console
DefSysV, '!CONSOLE', InitConsole(TITLE='Standard Output')

; input buffer (history) erhoehen
!EDIT_INPUT = 200



END
