;+
; NAME:                 DefGlobVars
;
; AIM:                  defines all NASE specific system variables
;
; PURPOSE:              Definiert eine Reihe von Systemvariablen, die von 
;                       diversen NASE-Routinen benutzt werden (koennen).
;                       Diese Routine wird vom Start-Script misc/startup
;                       aufgerufen und braucht eigentlich nicht von Hand
;                       benutzt zu werden.
;
; CATEGORY:             MISC 
;
; CALLING SEQUENCE:     DefGlobvars
;
; SIDE EFFECTS:         sets several system variables
;
; AUTHOR:               Andreas Gabriel
;
;-
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 1.15  2000/10/05 16:24:31  saam
;     decreased !TOPCOLOR to increase number
;     of private colors
;
;     Revision 1.14  2000/09/25 09:10:32  saam
;     * appended AIM tag
;     * some routines got a documentation update
;     * fixed some hyperlinks
;
;     Revision 1.13  2000/09/18 12:44:45  saam
;           + removed !EXECPATHS because command
;             doesn't need it anymore
;
;     Revision 1.12  2000/08/31 17:20:44  saam
;           !NASE_LIB now points to an architecture
;            dependent directory and fixes the
;            broken support for multiple architecture.
;            Confusion with object files of different
;            systems is avoided.
;
;     Revision 1.11  2000/08/25 16:54:22  kupper
;     Split startup procedure to protect from double execution of startup.
;
;     Revision 1.10  2000/08/04 15:13:01  kupper
;     Added system variable !NASEDIR.
;
;     NASE C lib is now located in each users nase directory (no system wide
;     install).
;     The library is checked at startup and compiled if it doesn't exist.
;
;     Revision 1.9  2000/06/19 13:23:45  saam
;           new sysv !CREATEDIR used by uopenw to be allowed
;           to create nonexistent dirs. default is NO.
;
;     Revision 1.8  2000/03/28 12:52:08  saam
;          new SysV !CONSOLE for use with console
;
;     Revision 1.7  2000/03/27 13:48:54  saam
;           TOPCOLOR is now !D.Table_Size-2 which is
;           much better (at least for TRUE COLOR Displays)
;           cause the standard color remains white
;           when calling rgb and friends
;
;     Revision 1.6  1999/03/09 14:41:27  kupper
;     !NASE_LIB ist jetzt schreibbar, für Leute, die auf anderen Verzeichnisstrukturen arbeiten.
;
;     Revision 1.5  1999/03/05 14:27:45  kupper
;
;     !NASE_LIB hinzugefügt.
;
;     Revision 1.4  1999/02/22 11:21:57  saam
;           added !EXECPATHS
;
;     Revision 1.3  1999/01/14 14:15:42  saam
;           + thereis now !NONEl for integer nones
;
;     Revision 1.2  1998/07/14 12:33:14  gabriel
;          History-Buffer auf 200 Lines erhoeht
;
;     Revision 1.1  1998/06/18 12:28:27  gabriel
;          Startup in Procedure
;
;-
PRO DefGlobVars

DefSysV, '!NONE' , -999999.0, 1
DefSysV, '!NONEl', -999999  , 1
DefSysV, '!NOMERCYFORPOT', 0.01, 1
DefSysV, '!REVERTPSCOLORS', 1
DefSysV, '!PSGREY', 1
DefSysV, '!MH', Handle_Create()

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

DefSysV, '!TOPCOLOR', !D.Table_Size-11 ;;; protect some colors from being overwritten by uloadct (here: 10)
                                       ;;; maximal accetable value is
                                       ;;; !D.Table_Size-3 (to protect
                                       ;;; white and black)
DefSysV, '!NASETABLE', {POS         : 0, $
			NEGPOS      : 1, $
			PAPER_POS   : 2, $
			PAPER_NEGPOS: 3}


DefSysV, '!SIGMA2HWB', sqrt(alog(4d)), 1
DefSysV, '!HWB2SIGMA', 1d/sqrt(alog(4d)), 1

; input buffer (history) erhoehen
!EDIT_INPUT = 200


; der Pfad zu unserer Shared Library für CALL_EXTERNAL
DefSysV, '!NASE_LIB', !NASEPATH+'/shared/'+!VERSION.OS+'_'+!VERSION.ARCH+'/nasec.so', 0


; if set to 1, UOPENW will create directories if they dont exist
DefSysV, '!CREATEDIR', 0, 0


; defines a standard console
DefSysV, '!CONSOLE', InitConsole(TITLE='Standard Output')

END
