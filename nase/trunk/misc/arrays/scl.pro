;+
; NAME: Scl
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
;        Revision 1.1  1999/09/22 13:33:50  kupper
;        Added new procompiling-feature to NASE-startup script.
;        Allowing identically named Procs/Funcs (currently NoNone and Scl).
;
;-

Function Scl, A, Range, Range_In

   Default, Range,    [0     , !D.Table_Size-1]  
   Default, Range_In, [min(A), max(A)       ]

   Return, (A - Range_In(0)) $
            * FLOAT(Range(1)-Range(0)) $
            / (Range_In(1)-Range_In(0)) $
            + Range(0)

End

Pro Scl, A, Range, Range_In

   A = Scl( Temporary(A), Range, Range_In )

End
