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
; SEE ALSO:
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 1.2  2000/01/17 11:13:26  kupper
;        Broke on devices other than X.
;        Fixed.
;
;        Revision 1.1  1999/10/28 16:16:06  kupper
;        Color-Management with sheets was not correct on a
;        true-color-display.
;        (Table was not set when the sheet was opened).
;        We now do different things for pseudocolor and
;        truecolor-displays, to make them "feel" alike... (hopefully).
;
;-

Function PseudoColor_Visual
   
   Case !D.NAME of

      "X" : $
       If IDLVersion() ge 5 then begin
         Device, GET_VISUAL_NAME=v
         v = strupcase(temporary(v))
         Return, Not( (v eq "TRUECOLOR") or (v eq "DIRECTCOLOR") )
      Endif Else Begin
         Return, !D.N_COLORS le 256
      Endelse

      "WIN" : $
       Return, !D.N_COLORS le 256
      
      else: begin
         Message, /INFO, "You are trying to determine the Visual-Class of a "+!D.NAME+"-Device."
         Return, 1
      endelse

   Endcase

End
   
