;+
; NAME:
;  (Hint: Insert name in THIS line, if you want it to appear in the
;  HTML-help. If you put it elsewhere, the HTML-help item will be 
;  generated from the filename.)
;
; AIM: -please enter a short description of routine (a single line!)-
;  
; PURPOSE:
;  -please specify-
;  
; CATEGORY:
;  -please specify-
;  
; CALLING SEQUENCE:
;  -please specify-
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
;        Revision 1.1  2000/09/07 17:33:15  kupper
;        Was missing for f...ing IDL.
;
;

Pro Event_Set_Value, w, value, No_Copy=No_Copy, Type=Type

   ;; Send appropriate event:
   Default, Type, Widget_Info(w, /Name)
   Type = Strupcase(Temporary(Type))
   If Type eq "BASE" then Message, "The type of compound widgets can not be " + $
    "auto-detected. Please specify TYPE=..."

   Case Type of
      
      "CW_FSLIDER2": $
       begin
         ;; Set new value:
         Widget_Control, w, Set_Value=value, No_Copy=No_Copy
         ;; Send appropriate event:
         event = {CW_FSLIDER2, $
                  ID: 0l, TOP: 0l, HANDLER: 0l, $
                  VALUE: value, DRAG: 0}
         Widget_Control, w, Send_Event=event, /No_Copy
      end
      
      "SLIDER": $
       begin
         ;; Set new value:
         Widget_Control, w, Set_Value=value, No_Copy=No_Copy
         ;; Send appropriate event:
         event = {WIDGET_SLIDER, $
                  ID: 0l, TOP: 0l, HANDLER: 0l, $
                  VALUE: value, DRAG: 0}
         Widget_Control, w, Send_Event=event, /No_Copy
      end
      
      "BUTTON": $
       begin
         ;; Set new value:
         Widget_Control, w, Set_Button=value, No_Copy=No_Copy
         ;; Send appropriate event:
         event = {WIDGET_BUTTON, $
                  ID: 0l, TOP: 0l, HANDLER: 0l, $
                  SELECT: value}
         Widget_Control, w, Send_Event=event, /No_Copy
       end

       "CW_BGROUP": $
        begin
          ;; determine first button:
          b = Widget_info(w, /Child)
          for i=1, 2 do b = Widget_info(b, /Child)
          If size(value, /N_Dimensions) eq 0 then begin
             ;; assume it was an exclusive base:
             for i=1, value do b = Widget_info(b, /Sibling)
             Event_Set_Value, b, 1, No_Copy=No_Copy
          Endif else begin
             ;; assume it was a non-exclusive base:
             for i=0, n_elements(value)-1 do begin
                Event_Set_Value, b, value[i], No_Copy=No_Copy
                b = Widget_info(b, /Sibling)
             endfor
          EndElse
       end
       
       else: Message, "Type "+Widget_Info(w, /Name)+" not " + $
        "supported. Please add to list in event_set_value.pro."
       
    Endcase



End
