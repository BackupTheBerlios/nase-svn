;+
; NAME: SIGNUM
;
;                                                                    
; PURPOSE:   The signum funktion in mathematical sense. 
;                                                                   
;
; CATEGORY: MATH
;
;
; CALLING SEQUENCE:     result = signum(x)
;
; 
; INPUTS:               Single value or array
;
;                                                                                1  if x > 0 
; OUTPUTS:              Singned value or array in following manner signum(x) =   0  if x = 0 
;                                                                               -1  if x < 0
;
; EXAMPLE:              X = [-10,0,0,20,-3,3,90]
;                       result = signum(x)
;                       print, result
;
; MODIFICATION HISTORY:
;
;
;     $Log$
;     Revision 2.1  1998/06/30 13:31:37  gabriel
;          hat schon immer gefehlt
;
;
;-
FUNCTION signum ,X
   
   return,((X GT 0) + (X LT 0)*(-1))

END
