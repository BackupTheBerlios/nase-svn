;; ------------ Widget support routines ---------------------
Pro WIF_size_handler, event
    Widget_Control, event.id, Get_Uvalue=object
    object->size, event.value
End

Pro WIF_brightness_handler, event
    Widget_Control, event.id, Get_Uvalue=object
    object->brightness, event.value
End

Pro WIF_type_handler, event
    Widget_Control, event.id, Get_Uvalue=object
    object->type, (object->types())[event.index]
End


;; ------------ Member access methods -----------------------
;; these are overridden:
Pro widget_image_factory::width, value
   self->image_factory::width, value
   self->recompute ;; we have an external pointer to the image data, so we must
                   ;; recompute explicitely 
   self->renew_plot, Range_In=[0, 1], /NASE ;we need to redraw whole plot!
   self->paint
End

Pro widget_image_factory::height, value
   self->image_factory::height, value
   self->recompute ;; we have an external pointer to the image data, so we must
                   ;; recompute explicitely
   self->renew_plot, Range_In=[0, 1], /NASE ;we need to redraw whole plot!
   self->paint
End

Pro widget_image_factory::type, string
   self->image_factory::type, string
   self->recompute ;; we have an external pointer to the image data, so we must
                   ;; recompute explicitely
   Widget_Control, self.w_type, SET_DROPLIST_SELECT=(Where(strupcase(*self.types) eq strupcase(string)))[0]
   self->paint
End

Pro widget_image_factory::size, value
   self->image_factory::size, value
   self->recompute ;; we have an external pointer to the image data, so we must
                   ;; recompute explicitely
   Widget_Control, self.w_size, SET_VALUE=value
   self->paint
End

Pro widget_image_factory::brightness, value
   self->image_factory::brightness, value
   self->recompute ;; we have an external pointer to the image data, so we must
                   ;; recompute explicitely
   Widget_Control, self.w_brightness, SET_VALUE=value
   self->paint
End



;; ------------ Constructor, Destructor & Resetter --------------------
Function widget_image_factory::init, POST_PAINT_HOOK=post_paint_hook, _REF_EXTRA=_ref_extra
   message, /Info, "I am created."
 
   ;; Try to initialize the superclass-portion of the
   ;; object. If it fails, exit returning false:
   ;; (we let my image container watch the image factory, so we can't use the
   ;; Init_Superclasses routine):
   If not self->image_factory::init(_EXTRA=_ref_extra) then return, 0
   If not $
    self->widget_image_container::init(IMAGE=self->image_factory::imageptr(), $
                                       /NASE, $                                    
                                       _EXTRA=_ref_extra) then begin
      self->image_factory::cleanup
      return, 0
   End

   ;; Try whatever initialization is needed for a MyClass object,
   ;; IN ADDITION to the initialization of the superclasses:

   ;; let the image factory create the image:
   self->recompute

   ;; fill in the types data member:
   self.types = Ptr_New(self->image_factory::types())


   ;; all widgets we add here will have self as their user-value.

   
   ;; add a drop-list-widget to select the image type
   self.w_type = widget_droplist(self.widget, Value=self->types(), UValue=self, $
                                 Event_Pro="WIF_type_handler")
   subbase = widget_base(self.widget, /row)
   ;; add a slider to select image size
   self.w_size = CW_fslider2(subbase, /Vertical, Minimum=0.0, Maximum=1.0, $
                             StepWidth=0.01, Value=self.size, Title="size", $
                             UValue=self, $
                             Event_Pro="WIF_size_handler")
   ;; add a slider to select image brighness
   self.w_brightness = CW_fslider2(subbase, /Vertical, Minimum=0.0, Maximum=1.0, $
                                   StepWidth=0.01, Value=self.brightness, Title="bright", $
                                   UValue=self, $
                                   Event_Pro="WIF_brightness_handler")
   ;; note: this will never fail.

   ;; If we reach this point, initialization of the
   ;; whole object succeeded, and we can return true:

   default, post_paint_hook, ""
   self.post_paint_hook = post_paint_hook
   
   return, 1                    ;TRUE
End

Pro widget_image_factory::cleanup, _REF_EXTRA = _ref_extra
   message, /Info, "I'm dying!"
   Ptr_Free, self.types

   Cleanup_Superclasses, self, "widget_image_factory", _EXTRA = _ref_extra
   ;; note that destroying the basic_widget_object also destroys the widget.
End

Pro widget_image_factory::reset
   self->prevent_paint          ;We don't want to have the image re-computed for 
                                ;every single slider that is reset!
   self->image_factory::reset
   self->allow_paint
   self->paint
End

;; ------------ Public --------------------

;; ------------ Protected --------------------
Pro widget_image_factory::paint_hook_
   self->widget_image_container::paint_hook_
   If self.post_paint_hook ne "" then Call_Procedure, self.post_paint_hook, self
End

Pro widget_image_factory::initial_paint_hook_
   self->widget_image_container::initial_paint_hook_
   ;; make droplist selection consistent with object's image type:
   self->type, self->type()     ;this will also paint the picture.
End

;; ------------ Object definition ---------------------------
Pro widget_image_factory__DEFINE
   dummy = {widget_image_factory, $
            $
            inherits widget_image_container, $
            inherits image_factory, $
            $
            types: PTR_NEW(), $ ;This will point to a string array containing
            $                   ;the image types. (We do not want to ask
            $                   ;image_factory::types() to scan the directory 
            $                   ;whenever the droplist widget should be set!)
            $
            post_paint_hook: "", $
            $
            w_size: 0l, $
            w_brightness: 0l, $
            w_type: 0l $
           }
End

