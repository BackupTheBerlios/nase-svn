;+
; NAME:                Operator
;
; PURPOSE:             This function applies an operator to some arguments. Its main
;                      purpose is the simplify the writing of input filters.          
;
; CATEGORY:            MIND SIM
;
; CALLING SEQUENCE:    result = Operator(A,B,op)
;
; INPUTS:              A ,
;                      B : the two arguments to be applied to the operator
;                      op: numeric id of the operator to be used. This number
;                          is received by <A HREF=http://neuro.physik.uni-marburg.de/mind/sim#OPID>opID</A>.ü
;
; RESTRICTIONS:        This function doesn't do any kind of syntax checking for performance reasons.
;
; EXAMPLE:             id = opID('and')
;                      print, operator(id, [0,0,1,1], [0,1,0,1])
;
; SEE ALSO:    <A HREF=http://neuro.physik.uni-marburg.de/nase/#xx>xx</A>
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 1.1  2000/01/21 12:45:19  saam
;           extracted from iftemplate2
;
;
;-
FUNCTION Operator, op, A, B
   
   ON_ERROR, 2

   CASE op OF
      0   : RETURN, A AND B
      1   : RETURN, A OR  B
      2   : RETURN, A +   B
      ELSE: Message, 'unknown operator'
   ENDCASE

END
