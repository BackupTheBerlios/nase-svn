;+
; NAME: defglobvars
;
;
; PURPOSE:
;
;
; CATEGORY: MISC
;
;
; CALLING SEQUENCE:
;
; 
; INPUTS:
;
;
; OPTIONAL INPUTS:
;
;	
; KEYWORD PARAMETERS:
;
;
; OUTPUTS:
;
;
; OPTIONAL OUTPUTS:
;
;
; COMMON BLOCKS:
;
;
; SIDE EFFECTS:
;
;
; RESTRICTIONS:
;
; PROCEDURE:
;
;
; EXAMPLE:
;
;
; MODIFICATION HISTORY:
;
;
;     $Log$
;     Revision 1.3  1999/01/14 14:15:42  saam
;           + thereis now !NONEl for integer nones
;
;     Revision 1.2  1998/07/14 12:33:14  gabriel
;          History-Buffer auf 200 Lines erhoeht
;
;     Revision 1.1  1998/06/18 12:28:27  gabriel
;          Startup in Procedure
;
;
;-
PRO defglobvars
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

DefSysV, '!TOPCOLOR', !D.Table_Size-1
DefSysV, '!NASETABLE', {POS         : 0, $
			NEGPOS      : 1, $
			PAPER_POS   : 2, $
			PAPER_NEGPOS: 3}


DefSysV, '!SIGMA2HWB', sqrt(alog(4d)), 1
DefSysV, '!HWB2SIGMA', 1d/sqrt(alog(4d)), 1

; input buffer (history) erhoehen
!EDIT_INPUT = 200

END
