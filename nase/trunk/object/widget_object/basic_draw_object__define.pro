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
;               [,FRAME=...]
;               [,SUBFRAME=...]
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
;   FRAME, SUBFRAME  : Frame thickness of the widget itself, and of
;                      the included scrollit widget.
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
;                          connecting to an X server accross a
;                          network.
;   ct, n, ...           : set the color table that is to be used for
;                          the display (see IDL's <C>LoadCT</C> for an
;                          overview of available color tables). <BR>
;                          The color table is initialized to <*>0</*>
;                          (linear grey ramp) upon construction of the
;                          object.<BR>
;                          Takes all additional arguments that
;                          <A>ULoadCT</A> takes.
;   ct()                 : return the current color table.<BR>
;                          The color table is initialized to <*>0</*>
;                          (liear grey ramp) upon construction of the
;                          object.<BR>   
;                          Additional keywords passed to the ct
;                          setting method are currently not returned.                   
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
;   xct_callback_hook_   : This method is called during interactive
;                          palette selection using the xct method. Its
;                          purpose is to renew the portions of the
;                          display that may be affected by a changed
;                          colormap. The ShowIt widget is already
;                          opened when this method is called, and will
;                          be closed automatically when it returns.
;                          The default implementation of this method
;                          simply calls the pain_hook_ method to redraw the
;                          whole display. Override this implementation
;                          in a subclass, if more sophisticated update
;                          methods exist.
;                          This method is intended to be private and is called
;                          from the objects UXLoadCT_callback routine. It should
;                          never be called directly.
;                          Note the trailing underscore.
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
;-


;; ------------ Widget support routines ---------------------
Pro BDO_Notify_Realize, id
   COMPILE_OPT HIDDEN
   On_Error, 2
   Widget_Control, id, Get_Uvalue=object

   showit_open, object->showit()
   object->set_ct_
   object->initial_paint_hook_
   showit_close, object->showit(), Save_Colors=object->save_colors_()

   Widget_Control, object->showit(), Timer=object->paint_interval()
End

Function BDO_ShowIt_Event_Func, event
   COMPILE_OPT HIDDEN
   If TAG_NAMES(event, /STRUCTURE_NAME) EQ 'WIDGET_TIMER' then begin 
      ;; handle and swallow timer event:
      Widget_Control, event.id, Get_Uvalue=object
      Widget_Control, event.id, Timer=object->paint_interval()
      object->paint
      return, 0
   Endif 

   return, event                ;pass-through
End

Pro BDO_Event_Pro_xct_button, event
   COMPILE_OPT HIDDEN
   ;; only events from the xct-button arrive here.
   ;; All our widgets have self
   ;; as uvalue.
   Widget_Control, event.id, Get_Uvalue=object
   object -> xct
End

Pro BDO_UXLoadCT_Callback, DATA=o
   COMPILE_OPT HIDDEN
   o->paint, /XCT_CALLBACK_
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
                          Y_SCROLL_SIZE = y_scroll_size, $
                          FRAME=frame, $
                          SUBFRAME=subframe, $
                          PALETTE_BUTTON=palette_button
   ;;all other keywords are passed to the base
   ;;constructor through _ref_extra

   DMsg, "I am created."

   ;; Try to initialize the superclass-portion of the
   ;; object. If it fails, exit returning false:
   If not Init_Superclasses(self, "basic_draw_object", FRAME=frame, _EXTRA=_ref_extra) then return, 0

   ;; Try whatever initialization is needed for a MyClass object,
   ;; IN ADDITION to the initialization of the superclasses:
   Default, private_colors, 1
   self.save_colors = private_colors ;colors must only be saved when they are to 
                                     ;be set!

   ;; add any widgets
   ;; all widgets we add here should have self as their user-value.
   ;;
   ;; use column subbase for buttons and showit:
   w_column = widget_base(self.widget, UValue=self, $
                          /Column, Space=0, XPad=0, YPad=0)
   ;;
   ;; use row subbase for buttons:
   w_buttons = widget_base(w_column, UValue=self, $
                           /Row, Space=0, XPad=0, YPad=0)

   ;;
   ;; add button for interactive palette selection:
   ;; all widgets shall have self as UVALUE.
   ;; we use the UNAME to identify our buttons.
   self.b_xct = widget_button(w_buttons, UValue=self, $
                              frame=0, $
                              Event_Pro="BDO_Event_Pro_xct_button", $
                              Value=CvtToBm([[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1], $ 
                                             [1, 0, 0, 0, 0, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1], $
                                             [1, 0, 0, 0, 0, 1, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1], $
                                             [1, 0, 0, 0, 0, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1], $
                                             [1, 0, 0, 0, 0, 1, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1], $
                                             [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]]))
   ;; let pointer point to something:
   self.ct_extra = ptr_new({dummy:0b})

   ;; 
   ;; add showit to present picture
   self.w_showit = widget_showit(w_column, Private_Colors=private_colors, $
                                 UValue=self, $
                                 Notify_Realize="BDO_Notify_realize", $
                                 Event_Func="BDO_ShowIt_Event_Func", $
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
                                 Y_SCROLL_SIZE = y_scroll_size, $
                                 FRAME=subframe)

   ;; the showit widget will also produce the timer events

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
   DMsg, "I'm dying!"
   Cleanup_Superclasses, self, "basic_draw_object", _EXTRA=_ref_extra
   ;; Note: Destroying the basic_widget_object also destroyes the widget.

   ;; Now do what is needed to cleanup a MyClass object:
   ptr_free, self.ct_extra
End

;; ------------ Public --------------------
Pro basic_draw_object::paint, XCT_CALLBACK_ = xct_callback_
   ;; note: the XCT_CALLBACK_ keyword is for internal use only, and is
   ;;       not documented in the header. It is set, when interactive
   ;;       palette selection using the xct method is used. In this
   ;;       case, xct_callback_hook_ is called for updating the
   ;;       display, otherwise paint_hook_ is called. The default
   ;;       implementation of xct_callback_hook_ just calls
   ;;       paint_hook_, but the user is free to reimplement it.
   If self.prevent_paint_flag then begin
      self.delayed_paint_request_flag = 1;store the request
   endif else begin ;;paint
      If Widget_Info(self.widget, /Realized) then begin
         showit_open, self.w_showit
         If keyword_set(XCT_CALLBACK_) then $
           self -> xct_callback_hook_ else $
           self -> paint_hook_
         showit_close, self.w_showit, Save_Colors=self.save_colors
      Endif else begin
         console, /Warning, "Warning: Ignored paint request for unrealized " + $
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

;;private:
Pro basic_draw_object::set_ct_
      showit_open, self.w_showit
      ULoadCt, self.ct, _EXTRA=*(self.ct_extra)
      showit_close, self.w_showit, Save_Colors=self.save_colors
      self->paint, /XCT_CALLBACK_
End
;;public:
Pro basic_draw_object::ct, n, _EXTRA=_extra
   default, _extra, {dummy:0b}

   self.ct = n
   *(self.ct_extra) = _extra

   If Widget_Info(self.widget, /Realized) then begin
      self->set_ct_
  Endif else begin
      console, /Debug, "Postponed ct request for unrealized " + $
          "widget-object."
   endelse
End
Function basic_draw_object::ct
   return, self.ct
End

Pro basic_draw_object::xct, _EXTRA=_extra

   If Widget_Info(self.widget, /Realized) then begin

      ;; will we have auto-painting during XLoadCT?
      If self.prevent_paint_flag then begin
         self.delayed_paint_request_flag = 1 ;store a paint request
         ;; so data will be painted as soon as possible.
      endif else begin
         ;; use call back during XLoadCT:
         updatecallback="BDO_UXLoadCT_Callback"
         updatecbdata = self
      endelse
      
      ;; do it:
      showit_open, self.w_showit
      UXLoadCt, GROUP=self->widget(), /MODAL, _EXTRA=_extra, UPDATECALLBACK=updatecallback, UPDATECBDATA=updatecbdata
      showit_close, self.w_showit, Save_Colors=self.save_colors
   Endif else begin
      console, /Warning, "Skipping xct call for unrealized widget."
   endelse
End

;; ------------ Private --------------------
Pro basic_draw_object::xct_callback_hook_
   ;; the default implementation of this routine simply calls the
   ;; paint_hook_ method. Override as desired.
   self -> paint_hook_
End

Pro basic_draw_object::paint_hook_; -ABSTRACT-
   ;; for overriding in subclass!
   On_error, 2
   console, /Fatal, "This abstract method was not overridden in derived class '"+Obj_Class(self)+"'!"
End

Pro basic_draw_object::initial_paint_hook_; -ABSTRACT-
   ;; for overriding in subclass!
   On_error, 2
   console, /Fatal, "This abstract method was not overridden in derived class '"+Obj_Class(self)+"'!"
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
            delayed_paint_request_flag: 0b, $
            $
            ct: 0l, $ ;; color table
            ct_extra: ptr_new(), $ ;; extra keywords for ct method
            $
            b_xct: 0l $ ;; button for interactive palette selection
           }
End
