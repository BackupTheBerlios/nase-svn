;+
; NAME:
;  Operator
;
; AIM:
;  applies various operators to one or more arguments
;
; PURPOSE:
;  This function applies an operator to some arguments. Its main
;  purpose is the simplify the writing of input filters.          
;
; CATEGORY:
;  MIND / SIMULATION ROUTINES
;
; CALLING SEQUENCE:
;  result = Operator(op,A,B)
;
; INPUTS:
;  op: numeric id of the operator to be used. This number is received
;      by <A HREF=http://neuro.physik.uni-marburg.de/mind/sim#OPID>opID</A>.
;  A, B: the two arguments to be applied to the operator
;
; RESTRICTIONS:
;  This function doesn't do any kind of syntax checking for
;  performance reasons.
;  To allow XOR-Operation on non-INTEGER arguments, A and B are
;  converted to INTEGE type and back to the original type after the
;  operation.
;
; EXAMPLE:
;  id = opID('and')
;  print, operator(id, [0,0,1,1], [0,1,0,1])
;
; SEE ALSO:
;  <A HREF=http://neuro.physik.uni-marburg.de/mind/sim#OPID>opID</A>.
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 1.5  2000/09/29 08:10:38  saam
;     added the AIM tag
;
;     Revision 1.4  2000/09/01 14:14:41  saam
;          replaced size by nase typeof
;          to allow idl 3.6 compatibility
;
;     Revision 1.3  2000/08/11 09:56:44  thiel
;         Added XOR support.
;
;     Revision 1.2  2000/05/17 08:22:01  saam
;           added new operators "*" and "/"
;
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
      2   : RETURN, A + B
      3   : RETURN, A * B
      4   : RETURN, A / B
      5   : BEGIN
         IF typeof(A) EQ 'INT' THEN Return, A XOR B
         resultfix = Fix(A) XOR Fix(B)
         Return, Call_FUNCTION(type, resultfix)
      END
      ELSE: Message, ' unknown operator.'
   ENDCASE

END
