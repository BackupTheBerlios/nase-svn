;+
; NAME:
;   Class basic_draw_object
;
; PURPOSE: 
;
; CATEGORY: 
;
; SUPERCLASSES:
;   <A HREF="#CLASS BASIC_WIDGET_OBJECT">class basic_widget_object</A>
;-
; CONSTRUCTION: 
;
;   o = Obj_New("basic_draw_object"
;               [,PAINT_INTERVAL=secs]
;               [,/PRIVATE_COLORS]
;               [,/BUTTON_EVENTS]
;               [,/EXPOSE_EVENTS] 
;               [,/MOTION_EVENTS] 
;               [,COLOR_MODEL=cm] 
;               [,COLORS=c] 
;               [,GRAPHICS_LEVEL=gl] 
;               [,RENDERER=r] 
;               [,RETAIN=rt] 
;               [,SCR_XSIZE=scr_xsize] 
;               [,SCR_YSIZE=scr_ysize] 
;               [,/SCROLL] 
;               [,/TRACKING_EVENTS] 
;               [,/VIEWPORT_EVENTS] 
;               [,XSIZE=xsize] 
;               [,YSIZE=ysize] 
;               [,X_SCROLL_SIZE=x_scroll_size]
;               [,Y_SCROLL_SIZE=y_scroll_size]
;               [-keywords inherited from <A HREF="#CLASS BASIC_WIDGET_OBJECT">class basic_widget_object</A>-])
;
; DESTRUCTION:
;
;   Obj_Destroy, o
;                                               
; INPUTS: -please remove any sections that do not apply-
;
; OPTIONAL INPUTS: -please remove any sections that do not apply-
;
; KEYWORD PARAMETERS: 
;
;   PAINT_INTERVAL   : enables auto-paint with interval secs.
;
;   All remaining keywords are passed to <A HREF="../../graphic/widgets/#WIDGET_SHOWIT">Widget_Showit()</A>.
;
; METHODS:
;
;  public: Public methods may be called from everywhere.
;   
;   showit()             : returns widget id of the contained ShowIt widget.
;   paint                : calls the user-defined method paint_hook_ (see
;                          below), if painting is allowed.
;   paint_interval()     : return paint interval in seconds. Negative value means
;                          auto-paint is off.
;   paint_interval, secs : enables auto-paint with interval secs. Set secs to a
;                          negative value to turn off auto-painting.
;   allow_paint          : allows updating via the paint method (default).
;   prevent_paint        : disallows updating via the paint method.
;   save_colors          : tell the object to save the current colormap when
;                          closing the ShowIt widget (see <A HREF="../../graphic/widgets/#WIDGET_SHOWIT">Widget_Showit()</A>).
;                          This is default, if /PRIVATE_COLORS was specified
;                          upon initialization.
;   ignore_colors        : tell the object not to save the current colormap when 
;                          closing the ShowIt widget (see <A HREF="../../graphic/widgets/#WIDGET_SHOWIT">Widget_Showit()</A>).
;                          This is default, unless /PRIVATE_COLORS was specified
;                          upon initialization.
;                          It may be admirable to disable color saving in special 
;                          cases, e.g. when frequent updates happen, or when
;                          connecting to an X server accross a network.
;
;   -plus those inherited from class <A HREF="#CLASS BASIC_WIDGET_OBJECT">class basic_widget_object</A> (see there for details)-
;
;  protected: Protected methods may only be called from within a derived class's
;             methods.
;
;  private: Private methods are not intended to be called by the user and are
;           not decribed in this header. Refer to the source code for information.
;
; ABSTRACT METHODS:
;
;  Abstract methods must be overridden in derived classes:
;
;  public:
;
;  protected:
;
;  private:
;
;   paint_hook_          : Here goes the code to update the ShowIt widget. The
;                          ShowIt widget is already opened when this method is
;                          called, and will be closed automatically when it
;                          returns.
;                          This method is intended to be private and is called
;                          from the objects paint method. It should never be
;                          called directly.
;                          Note the trailing underscore.
;
;   initial_paint_hook_  : Here goes the code to paint whatever is necessary
;                          when the widget is realized. The ShowIt widget is
;                          already opened when this method is called, and will
;                          be closed automatically when it returns.
;                          Note: paint_hook_ is not called upon
;                                realization. However, you are free to call
;                                self->paint_hook_ from within initial_paint_hook_
;                                when this comes handy.
;                          This method is intended to be private and is called
;                          from the objects Notify_Realize routine. It should
;                          never be called directly.
;                          Note the trailing underscore.
;
;
; SIDE EFFECTS: 
;
; RESTRICTIONS: 
;
; PROCEDURE: 
;
; EXAMPLE: 
;
; SEE ALSO: <A HREF="../../graphic/widgets/#WIDGET_SHOWIT">Widget_Showit()</A>
;           <A HREF="#CLASS BASIC_WIDGET_OBJECT">class basic_widget_object</A>
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 1.13  2000/09/27 15:59:37  saam
;        service commit fixing several doc header violations
;
;        Revision 1.12  2000/03/15 19:07:10  kupper
;        Hm, postponing solution of the added-to-realized-widget-problem to future...
;        Changed update_info method not to break on unrealized objects.
;
;        Revision 1.11  2000/03/14 15:42:53  kupper
;        Paint requests for unrealized widgets are now ignored.
;
;        Revision 1.10  2000/03/13 16:36:18  kupper
;        Polished header (needs mor polishing!)
;
;        Revision 1.9  2000/03/13 15:47:34  kupper
;        initial_paint_hook_ now issues abstract method warning.
;
;        Revision 1.8  2000/03/13 14:04:25  kupper
;        Polished header.
;
;        Revision 1.7  2000/03/13 13:22:48  kupper
;        paint_hook_ is now not called upon realization any more.
;
;        Revision 1.6  2000/03/12 17:00:41  kupper
;        Adjusted to new classname argument of Init/Cleanup_Superclasses.
;
;        Revision 1.5  2000/03/12 15:16:10  kupper
;        Extended object.
;        Now including save_colors/ignore_colors and allow_paint/prevent_paint methods.
;        Added paint_hook_ and initial_paint_hook_ methods.
;
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

   showit_open, object->showit()
   object->initial_paint_hook_
   showit_close, object->showit(), Save_Colors=object->save_colors_()

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
   If Widget_Info(self->widget(), /Realized) then $
    widget_control, self.w_showit, Timer=value
End
Function basic_draw_object::paint_interval
   return, self.paint_interval
End

;; ------------ Constructor, Destructor & Resetter --------------------
Function basic_draw_object::init, _REF_EXTRA=_ref_extra, $
                          PAINT_INTERVAL=paint_interval, $
                          $;;to be passed top widget_showit:
                          PRIVATE_COLORS=private_colors, $
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
   If not Init_Superclasses(self, "basic_draw_object", _EXTRA=_ref_extra) then return, 0

   ;; Try whatever initialization is needed for a MyClass object,
   ;; IN ADDITION to the initialization of the superclasses:
   Default, private_colors, 1
   self.save_colors = private_colors ;colors must only be saved when they are to 
                                     ;be set!

   ;; add any widgets
   ;; all widgets we add here should have self as their user-value.
   ;;
   ;; add showit to present picture
   self.w_showit = widget_showit(self.widget, Private_Colors=private_colors, $
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
      
   ;; In case we were added to an already realized widget hierarchy, we have to
   ;; call the notify_realize procedure ourselves:
   ;If Widget_Info(self->widget(), /Realized) then BDO_Notify_realize, self->showit()
   ;; NOTE: The above causes problems, as the obejct is not properly initiallized at
   ;; this moment. Solution is postponed to future.


   ;; If we reach this point, initialization of the
   ;; whole object succeeded, and we can return true:   
   return, 1                    ;TRUE
End

Pro basic_draw_object::cleanup, _REF_EXTRA = _ref_extra
   message, /Informational, "I'm dying!"
   Cleanup_Superclasses, self, "basic_draw_object", _EXTRA=_ref_extra
   ;; Note: Destroying the basic_widget_object also destroyes the widget.

   ;; Now do what is needed to cleanup a MyClass object:
   ;;
   ;; insert code here
   ;;
End

;; ------------ Public --------------------
Pro basic_draw_object::paint
   If self.prevent_paint_flag then begin
      self.delayed_paint_request_flag = 1;store the request
   endif else begin ;;paint
      If Widget_Info(self.widget, /Realized) then begin
         showit_open, self.w_showit
         self->paint_hook_
         showit_close, self.w_showit, Save_Colors=self.save_colors
      Endif else begin
         message, /Informational, "Warning: Ignored paint request for unrealized " + $
          "widget-object."
      endelse
   endelse
End

Pro basic_draw_object::prevent_paint
   self.prevent_paint_flag = 1
End
Pro basic_draw_object::allow_paint
   self.prevent_paint_flag = 0
   ;; did any paint requests arrive while painting was prohibited?
   if self.delayed_paint_request_flag then begin
      self->paint
      self.delayed_paint_request_flag = 0
   endif
End

Pro basic_draw_object::save_colors
   self.save_colors = 1
End
Pro basic_draw_object::ignore_colors
   self.save_colors = 0
End

;; ------------ Private --------------------
Pro basic_draw_object::paint_hook_; -ABSTRACT-
   ;; for overriding in subclass!
   On_error, 2
   message, "This abstract method was not overridden in derived class '"+Obj_Class(self)+"'!"
End

Pro basic_draw_object::initial_paint_hook_; -ABSTRACT-
   ;; for overriding in subclass!
   On_error, 2
   message, "This abstract method was not overridden in derived class '"+Obj_Class(self)+"'!"
End

Function basic_draw_object::save_colors_
   return, self.save_colors
End

;; ------------ Object definition ---------------------------
Pro basic_draw_object__DEFINE
   dummy = {basic_draw_object, $
            $
            inherits basic_widget_object, $
            $
            w_showit: 0l, $
            save_colors: 0b, $
            $
            paint_interval: 0.0, $
            $
            prevent_paint_flag: 0b, $
            delayed_paint_request_flag: 0b $
           }
End
