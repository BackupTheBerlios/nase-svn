;+
; NAME:
;  Event_set_value
;
; AIM:
;  Set a widget value and trigger the associated event. (Imitate user
;  interaction.) 
;  
; PURPOSE:
;  Setting widget values using the WIDGET_CONTROL procedure has one
;  major drawback: The value is changed without calling the event
;  handlers that are associated to the "normal" modification by user
;  interaction. This is very likely to cause inconsistencies, as the
;  associated event handlers very often have important side effects
;  that may not be skipped.
;  This is considered a design error in IDL's widget system.
;  This routine aims to fix the problem by combining the modification
;  of the widget's value with triggering an according event. That is,
;  the routine tries to imitate a real user interaction.
;  Note, however, that this is not well supported by IDL's widget
;  system, and that individual actions have to be taken for different
;  (compound) widgets. This routine needs to be extended for every new
;  compund widget to be handled!
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
;  Note, that this procedure is not well supported by IDL's widget
;  system, and that individual actions have to be taken for different
;  (compound) widgets. This routine needs to be extended for every new
;  compund widget to be handled!
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
;        Revision 1.2  2000/10/01 14:51:58  kupper
;        Added AIM: entries in document header. First NASE workshop rules!
;
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
