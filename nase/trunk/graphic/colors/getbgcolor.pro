;+
; NAME: GetBGColor()
;
; PURPOSE:
;
; CATEGORY:
;
; CALLING SEQUENCE:
;
; INPUTS:
;
; OPTIONAL INPUTS:
;
; KEYWORD PARAMETERS:
;
; OUTPUTS:
;
; OPTIONAL OUTPUTS:
;
; COMMON BLOCKS:
;
; SIDE EFFECTS:
;
; RESTRICTIONS:
;
; PROCEDURE:
;
; EXAMPLE:
;
; SEE ALSO:
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 2.2  1998/05/26 13:16:08  kupper
;               Noch nicht alle Routinen kannten das !PSGREY. Daher mal wieder
;                  Änderungen an der Postcript-Sheet-Verarbeitung.
;                  Hoffentlich funktioniert alles (war recht kompliziert, wie immer.)
;
;-

FUNCTION GetBGColor

   If !D.NAME eq "PS" and !PSGREY then Return, [!P.Background, !P.Background, !P.Background] 
   RETURN, CIndex2RGB(!P.Background) 

END
