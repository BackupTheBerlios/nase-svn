;+
; NAME:
;  Value[()]
;
; AIM: Get or set widget values with a convenient call.
;  
; PURPOSE:
;  -please specify-
;  
; CATEGORY:
;  -please specify-
;  
; CALLING SEQUENCE:
;  Set value:
;    Value, my_widget, new_value
;  Get value:
;    Value = Value(my_widget)
;  
; INPUTS:
;  -please remove any sections that do not apply-
;  
; OPTIONAL INPUTS:
;  -please remove any sections that do not apply-
;  
; KEYWORD PARAMETERS:
;  -please remove any sections that do not apply-
;  
; OUTPUTS:
;  -please remove any sections that do not apply-
;  
; OPTIONAL OUTPUTS:
;  -please remove any sections that do not apply-
;  
; COMMON BLOCKS:
;  -please remove any sections that do not apply-
;  
; SIDE EFFECTS:
;  -please remove any sections that do not apply-
;  
; RESTRICTIONS:
;  -please remove any sections that do not apply-
;  
; PROCEDURE:
;  -please specify-
;  
; EXAMPLE:
;  -please specify-
;  
; SEE ALSO:
;  -please remove any sections that do not apply-
;  <A HREF="#MY_ROUTINE">My_Routine()</A>
;  
;-
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 1.1  2000/09/06 12:13:04  kupper
;        new and simple, but useful.
;
;

Pro value, w, val, No_Copy=No_Copy
   Widget_Control, w, Set_Value=val, No_Copy=No_Copy
End

Function value, w, No_Copy=No_Copy
   Widget_Control, w, Get_Value=val, No_Copy=No_Copy
   return, val
End
