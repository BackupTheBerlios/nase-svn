;+
; NAME:
;   Class basic_draw_object
;
; PURPOSE: 
;
; CATEGORY: 
;
; CALLING SEQUENCE: 
;
; PUBLIC METHODS:
;
;   showit()             : returns widget id of the contained showit_widget
;   paint_interval()     : return paint interval in seconds. Negative value means
;                          auto-paint is off.
;   paint_interval, secs : enables auto-paint with interval secs
;   paint                : an empty procedure that issues an error message.
;                          --OVERRIDE THIS METHOD IN DERIVED CLASSES!--
;                          Do not call basic_draw_object::paint from within
;                          overridden method.
;
; INPUTS: 
;
; OPTIONAL INPUTS: -please remove any sections that do not apply-
;
; KEYWORD PARAMETERS: 
;
; OUTPUTS: 
;
; OPTIONAL OUTPUTS: 
;
; COMMON BLOCKS: 
;
; SIDE EFFECTS: 
;
; RESTRICTIONS: 
;
; PROCEDURE: 
;
; EXAMPLE: 
;
; SEE ALSO: <A HREF="#MY_ROUTINE">My_Routine()</A>
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 1.4  2000/03/10 21:06:30  kupper
;        Should work and be complete.
;
;        Revision 1.3  2000/03/10 20:49:40  kupper
;        Now passing correct keywords to wisget_showit.
;
;-
;; ------------ Widget support routines ---------------------
Pro BDO_Notify_Realize, id
   On_Error, 2
   Widget_Control, id, Get_Uvalue=object
   object->paint
   Widget_Control, object->showit(), Timer=object->paint_interval()
End

Function BDO_Event_Func, event
   If TAG_NAMES(event, /STRUCTURE_NAME) EQ 'WIDGET_TIMER' then begin 
      ;; handle and swallow timer event:
      Widget_Control, event.id, Get_Uvalue=object
      Widget_Control, event.id, Timer=object->paint_interval()
      object->paint
      return, 0
   Endif else begin
      return, event             ;pass-through
   Endelse
End



;; ------------ Member access methods -----------------------
Function basic_draw_object::showit
   return, self.w_showit
End

Pro basic_draw_object::paint_interval, value
   self.paint_interval = value
   widget_control, self.w_showit, Timer=value
End
Function basic_draw_object::paint_interval
   return, self.paint_interval
End

;; ------------ Constructor, Destructor & Resetter --------------------
Function basic_draw_object::init, _REF_EXTRA=_ref_extra, $
                          PAINT_INTERVAL=paint_interval, $
                          $;;to be passed top widget_showit:
                          BUTTON_EVENTS=button_events, $
                          EXPOSE_EVENTS =expose_events, $ 
                          MOTION_EVENTS =motion_events, $ 
                          COLOR_MODEL =color_model, $ 
                          COLORS = colors, $ 
                          GRAPHICS_LEVEL = graphics_level, $ 
                          RENDERER = renderer, $ 
                          RETAIN = retaint, $ 
                          SCR_XSIZE = scr_xsize, $ 
                          SCR_YSIZE = scr_ysize, $ 
                          SCROLL = scroll, $ 
                          TRACKING_EVENTS =tracking_events, $ 
                          VIEWPORT_EVENTS = viewport_events, $ 
                          XSIZE = xsize, $ 
                          YSIZE = ysize, $ 
                          X_SCROLL_SIZE = x_scroll_size, $ 
                          Y_SCROLL_SIZE = y_scroll_size                          
   ;;all other keywords are passed to the base
   ;;constructor through _ref_extra

   message, /Info, "I am created."

   ;; Try to initialize the superclass-portion of the
   ;; object. If it fails, exit returning false:
   If not Init_Superclasses(self, _EXTRA=_ref_extra) then return, 0

   ;; Try whatever initialization is needed for a MyClass object,
   ;; IN ADDITION to the initialization of the superclasses:

   ;; add any widgets
   ;; all widgets we add here should have self as their user-value.
   ;;
   ;; add showit to present picture
   self.w_showit = widget_showit(self.widget, /Private_Colors, $
                                 UValue=self, $
                                 Notify_Realize="BDO_Notify_realize", $
                                 Event_Func="BDO_Event_Func", $
                                 BUTTON_EVENTS=button_events, $
                                 EXPOSE_EVENTS =expose_events, $ 
                                 MOTION_EVENTS =motion_events, $ 
                                 COLOR_MODEL =color_model, $ 
                                 COLORS = colors, $ 
                                 GRAPHICS_LEVEL = graphics_level, $ 
                                 RENDERER = renderer, $ 
                                 RETAIN = retaint, $ 
                                 SCR_XSIZE = scr_xsize, $ 
                                 SCR_YSIZE = scr_ysize, $ 
                                 SCROLL = scroll, $ 
                                 TRACKING_EVENTS =tracking_events, $ 
                                 VIEWPORT_EVENTS = viewport_events, $ 
                                 XSIZE = xsize, $ 
                                 YSIZE = ysize, $ 
                                 X_SCROLL_SIZE = x_scroll_size, $ 
                                 Y_SCROLL_SIZE = y_scroll_size)

   ;; note: adding widgets will never fail.

   If Set(PAINT_INTERVAL) then begin
      self.paint_interval = paint_interval
   End else begin
      self.paint_interval = -1
   Endelse
      

   ;; If we reach this point, initialization of the
   ;; whole object succeeded, and we can return true:   
   return, 1                    ;TRUE
End

Pro basic_draw_object::cleanup, _REF_EXTRA = _ref_extra
   message, /Info, "I'm dying!"
   Cleanup_Superclasses, self, _EXTRA=_ref_extra
   ;; Note: Destroying the basic_widget_object also destroyes the widget.

   ;; Now do what is needed to cleanup a MyClass object:
   ;;
   ;; insert code here
   ;;
End

;; ------------ Public --------------------
Pro basic_draw_object::paint
   ;; for overriding on subclass!
   On_error, 2
   message, "Abstract method 'paint' was not overridden in derived class '"+Obj_Class(self)+"'!"
End

;; ------------ Private --------------------

;; ------------ Object definition ---------------------------
Pro basic_draw_object__DEFINE
   dummy = {basic_draw_object, $
            $
            inherits basic_widget_object, $
            $
            w_showit: 0l, $
            $
            paint_interval: 0.0 $
           }
End
