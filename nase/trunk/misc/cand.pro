;+
; NAME:               CAND
;
; AIM:                and-operator (shortened boolean evaluation)
;  
; PURPOSE:            Implements an AND-Operator with a shortened
;                     boolean evaluation. The second argument will
;                     only be evaluated, if the the first is TRUE.
;                     This is especially useful, if the second
;                     argument is only defined if the first argument
;                     is TRUE. The syntax can be signficantly shortend
;                     and is better to read:
;       
;                     IF CAND("Set(P)", "TypeOf(P) EQ 'STRING'") THEN ....
;
;                     instead of 
;                     
;                     IF (Set(P)) THEN BEGIN
;                       IF (TypeOf(P) EQ 'STRING') THEN ...
;                     END
;
; CATEGORY:           MISC MATH BOOLEAN OPERATOR
;  
; CALLING SEQUENCE:   tf = CAND(a1, a2)
;  
; INPUTS:             a1: a defined string that evaluates to BOOLEAN
;                     a2: a string that evaluated to BOOLEAN, but this
;                         only checked if a1 evaluates to FALSE
;  
; OUTPUTS:            tf: the boolean result of the AND-operation
;  
; EXAMPLE:
;                     if CAND('0', 'notEvaluated') THEN notEvaluated
;                     if CAND('1', '0')            THEN notEvaluated
;                     if CAND('1', '1')            THEN Evaluated
;  
; SEE ALSO:           COR
;  
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 1.1  2000/06/19 14:13:55  saam
;              long used, finally committed
;
;-

FUNCTION CAND, a, b

ON_ERROR,2 

IF NOT SET(a) THEN Console, '1st arg undefined', /FATAL
IF TypeOf(a) NE 'STRING' THEN Console, '1st arg has to be a string', /FATAL
IF NOT Execute("ba = "+a) THEN Console, 'syntax error in 1st arg', /FATAL
IF NOT ba THEN RETURN, 1 EQ 2 ; FALSE


IF NOT SET(b) THEN Console, '2nd arg undefined', /FATAL
IF TypeOf(b) NE 'STRING' THEN Console, '2nd arg has to be a string', /FATAL
IF NOT Execute("bb = "+b) THEN Console, 'syntax error in 2nd arg', /FATAL
RETURN, bb

END
