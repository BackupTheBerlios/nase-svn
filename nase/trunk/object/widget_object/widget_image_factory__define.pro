;; ------------ Widget support routines ---------------------
Pro WIF_Notify_Realize, showit_id
   Widget_Control, showit_id, Get_Uvalue=object
   object->initial_paint_
End

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
   self->initial_paint_
End

Pro widget_image_factory::height, value
   self->image_factory::height, value
   self->initial_paint_
End

Pro widget_image_factory::type, string
   self->image_factory::type, string
   Widget_Control, self.w_type, SET_DROPLIST_SELECT=(Where(strupcase(*self.types) eq strupcase(string)))[0]
   self->paint_
End

Pro widget_image_factory::size, value
   self->image_factory::size, value
   Widget_Control, self.w_size, SET_VALUE=value
   self->paint_
End

Pro widget_image_factory::brightness, value
   self->image_factory::brightness, value
   Widget_Control, self.w_brightness, SET_VALUE=value
   self->paint_
End



;; ------------ Constructor & Destructor --------------------
Function widget_image_factory::init, POST_PAINT_HOOK=post_paint_hook, _REF_EXTRA=_ref_extra
   message, /Info, "I am created."

   ;; Try to initialize the superclass-portion of the
   ;; object. If it fails, exit returning false:
   If not Init_Superclasses(self, _EXTRA=_ref_extra) then return, 0

   ;; Try whatever initialization is needed for a MyClass object,
   ;; IN ADDITION to the initialization of the superclasses:

   ;; fill in the types data member:
   self.types = Ptr_New(self->image_factory::types())

   ;; all widgets we add here will have self as their user-value.

   ;; add showit to present picture
   self.showit_id = widget_showit(self.widget, /Private_Colors, $
                                  UValue=self, $
                                  Notify_Realize="WIF_Notify_realize")
   
   ;; add a drop-list-widget to select the image type
   self.w_type = widget_droplist(self.widget, Value=self->types(), UValue=self, $
                                 Event_Pro="WIF_type_handler")
   ;; make droplist selection consistent with object's image type:
   self->type, self->type()

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

Pro widget_image_factory::cleanup
   message, /Info, "I'm dying!"
   Ptr_Free, self.types
   self->basic_widget_object::cleanup ;This also destroyes the widget 
   self->image_factory::cleanup
End



;; ------------ Public --------------------

;; ------------ Private --------------------
Pro widget_image_factory::paint_
   Widget_Control, self.showit_id, Get_Uvalue=object
   Showit_open, self.showit_id
   PlotTvScl_Update, $
    object->image(), object->plotinfo_()
   Showit_close, self.showit_id
   
   If self.post_paint_hook ne "" then Call_Procedure, self.post_paint_hook, self
End

Pro widget_image_factory::initial_paint_
   Widget_Control, self.showit_id, UPDATE=0 ;prevent screen updates

   Showit_open, self.showit_id

   tmp = self->brightness()
   self->image_factory::brightness, 1.0

   PlotTvScl, /NASE, Get_Info=pltinfo, $
    self->image(), 0.2, 0.2
   
   self->image_factory::brightness, tmp

   Showit_close, self.showit_id
   self->plotinfo_, pltinfo

   self->paint_                 ;oce again with correct brightness

   Widget_Control, self.showit_id, UPDATE=1 ;re-allow screen updates
End

Function widget_image_factory::plotinfo_
   return, self.plotinfo
End
Pro widget_image_factory::plotinfo_, value
   self.plotinfo = value
End

;; ------------ Object definition ---------------------------
Pro widget_image_factory__DEFINE
   dummy = {widget_image_factory, $
            $
            inherits basic_widget_object, $
            inherits image_factory, $
            $
            types: PTR_NEW(), $ ;This will point to a string array containing
            $                   ;the image types. (We do not want to ask
            $                   ;image_factory::types() to scan the directory 
            $                   ;whenever the droplist widget should be set!)
            $
            showit_id: 0l, $
            plotinfo: {PLOTTVSCL_INFO}, $
            post_paint_hook: "", $
            $
            w_size: 0l, $
            w_brightness: 0l, $
            w_type: 0l $
           }
End

