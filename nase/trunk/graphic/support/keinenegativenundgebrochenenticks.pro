;+
; NAME:
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
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 2.1  1997/12/10 16:37:03  thiel
;               Ausgelagert aus 'PlotTVScl'.
;
;-


FUNCTION KeineNegativenUndGebrochenenTicks, axis, index, value
   IF (Value LT 0) OR ((Value - Fix(Value)) NE 0) THEN BEGIN
      Return, '' 
      ENDIF ELSE BEGIN
         Return, String(Value, Format='(I)')
         ENDELSE 
END
