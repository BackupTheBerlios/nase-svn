;+
; NAME:
;  PrettyArr()
;
; VERSION:
;  $Id$
;
; AIM:
;  pretty-print arrays as strings
;  
; PURPOSE:
;   Printing an array in IDL works, but often you
;   don't see, where one entry ends and the other
;   one starts. This is especially annoying for
;   string arrays. This routine delimits arrays
;   with brackets and separates entries via commata.
;  
; CATEGORY:
;  Array
;  Help
;  IO
;  Strings
;  
; CALLING SEQUENCE:
;*S = PrettyArr(A)
;  
; INPUTS:
;  A:: an array (should not be too large)
;  
; OUTPUTS:
;  S:: string containing the pretty printed version
;     of A
;  
; EXAMPLE:
;*A = ['',' a', 'b ','c ']
;*print, A 
;*;a b  c
;*
;*print, prettyArr(A)
;*;['',' a','b ','c ']
;
;*print, prettyArr(indgen(2,5))
;*;[[0,1],[2,3],[4,5],[6,7],[8,9]]
;-
FUNCTION PrettyArr, A

sA = SIZE(A)
nA = sA(sA(0))
isString = (TypeOf(A) EQ 'STRING')

IF isString THEN BEGIN
    r = "['"
    E = "']"
END ELSE BEGIN
    r = "["
    E = "]"
END

IF sA(0) EQ 0 THEN RETURN, A
FOR i=0,nA-1 DO BEGIN 
    IF sA(0) GT 1 THEN BEGIN
        r = r + PrettyArr(REFORM(iselect(A,-1,i)))
    END ELSE BEGIN        
        IF isString THEN r = r + A(i) ELSE r = r + STR(A(i)) ; this is because STR removes whitespaces
    END
    IF i LT nA-1 THEN $
      IF isString THEN r = r + "','" ELSE r = r + ","    
END
r = r + E

RETURN, r
END
