;+
; NAME:                opID
;
; PURPOSE:             This routine assigns integer values to various
;                      Boolean & non-Boolean operators. It works together
;                      with <A HREF=http://neuro.physik.uni-marburg.de/mind/sim#OPERATOR>Operator</A>.
;
; CATEGORY:            MIND SIM
;
; CALLING SEQUENCE:    id = opID(operatorString)
;
; INPUTS:              operatorString: currently the following strings are
;                                      allowed: ADD, OR, AND (case insensitive)
;
; OUTPUTS:             id : a numeric value for the specified operation and
;                           !NONE if the operation is unknown
;
; EXAMPLE:             print, opid('and'), opid('OR')
;
; SEE ALSO:            <A HREF=http://neuro.physik.uni-marburg.de/mind/sim/#OPERATOR>operator</A>
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 1.1  2000/01/21 12:45:19  saam
;           extracted from iftemplate2
;
;
;-



FUNCTION opID, logicStr
   
   On_Error, 2
   
   logiclist = ['AND','OR','ADD']
   mylogic = WHERE(STRUPCASE(logicStr) EQ STRUPCASE(logiclist),c)
   
   IF c EQ 0 THEN BEGIN
      Print, "opID: (WARNING) unknown operator '",logicStr,"'"
      RETURN, !NONE 
   END ELSE RETURN, mylogic(0)

END
