;+
; NAME:               COR
;
; AIM:                or-operator (shortened boolean evaluation)
;  
; PURPOSE:            Implements an OR-Operator with a shortened
;                     boolean evaluation. The second argument will
;                     only be evaluated, if the the first is TRUE.
;                     This is especially useful, because the second
;                     argument is only executed if the first argument
;                     is FALSE. The syntax can be signficantly shortend
;                     or is better to read:
;       
;                     IF COR("Set(P)", CorrectTheSituationThatPIsNotDefined) THEN ....
;
;                     instead of 
;                     
;                     IF (Set(P)) THEN BEGIN
;                       IF (TypeOf(P) EQ 'STRING') THEN ...
;                     END
;
; CATEGORY:           MISC MATH BOOLEAN OPERATOR
;  
; CALLING SEQUENCE:   tf = COR(a1, a2)
;  
; INPUTS:             a1: a defined string that evaluates to BOOLEAN
;                     a2: a string that evaluated to BOOLEAN, but this
;                         only checked if a1 evaluates to FALSE
;  
; OUTPUTS:            tf: the boolean result of the OR-operation
;  
; EXAMPLE:
;                     if COR('1', 'notEvaluated') THEN notEvaluated
;                     if COR('0', '0')            THEN notEvaluated
;                     if COR('0', '1')            THEN Evaluated
;  
; SEE ALSO:           CAND
;  
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 1.1  2000/06/19 14:13:55  saam
;              long used, finally committed
;
;-

FUNCTION COR, a, b

ON_ERROR,2 

IF NOT SET(a) THEN Console, '1st arg undefined', /FATAL
IF TypeOf(a) NE 'STRING' THEN Console, '1st arg has to be a string', /FATAL
IF NOT Execute("ba = "+a) THEN Console, 'syntax error in 1st arg', /FATAL
IF ba THEN RETURN, 1 EQ 1 ; TRUE


IF NOT SET(b) THEN Console, '2nd arg undefined', /FATAL
IF TypeOf(b) NE 'STRING' THEN Console, '2nd arg has to be a string', /FATAL
IF NOT Execute("bb = "+b) THEN Console, 'syntax error in 2nd arg', /FATAL
RETURN, bb

END
