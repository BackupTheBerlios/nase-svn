;+
; NAME:                PrettyArr
;
; AIM:                 pretty-print arrays 
;  
; PURPOSE:             Printing an array in IDL works, but often you
;                      don't see, where one entry ends and the other
;                      one starts. This is especially annoying for
;                      string arrays. This routine delimits arrays
;                      with brackets and separates entries via commata.
;  
; CATEGORY:            MISC
;  
; CALLING SEQUENCE:    S = PrettyArr(A)
;  
; INPUTS:              A: an array (should not be too large)
;  
; OUTPUTS:             S: string containing the pretty printed version
;                         of A
;  
; EXAMPLE:
;                      IDL> A = ['',' a', 'b ','c ']
;                      IDL> print, A 
;                       a b  c
;                      IDL> print, prettyArr(A)
;                      ['',' a','b ','c ']
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 1.1  2000/06/19 14:31:41  saam
;              ok, its short...but its useful
;
;-
FUNCTION PrettyArr, A

nA = N_Elements(A)
isString = (TypeOf(A) EQ 'STRING')

IF isString THEN BEGIN
    r = "['"
    E = "']"
END ELSE BEGIN
    r = "["
    E = "]"
END

FOR i=0, nA-2 DO BEGIN
    IF isString THEN r = r + A(i) + "','" ELSE r = r + STR(A(i)) + "," ; this is because STR removes whitespaces
END
r = r + STR(A(nA-1)) + E

RETURN, r
END
