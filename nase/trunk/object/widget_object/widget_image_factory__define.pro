
;; ------------ Member access methods -----------------------
;Function widget_image_factory::width
;   return, self.width
;End
;Pro widget_image_factory::width, value
;   self.width = value
;   self.recompute = 1
;End

;; ------------ Constructor & Destructor --------------------
Function widget_image_factory::init, _REF_EXTRA=_ref_extra
   message, /Info, "I am created."

   ;; Try to initialize the superclass-portion of the
   ;; object. If it fails, exit returning false:
   If not Init_Superclasses(self, _EXTRA=_ref_extra) then return, 0

   ;; Try whatever initialization is needed for a MyClass object,
   ;; IN ADDITION to the initialization of the superclasses:
   ;; add a drop-list-widget to select the image type
   dummy = widget_droplist(self.widget, Value=self->types(), _EXTRA=_ref_extra)

   ;; note: this will never fail.

   ;; If we reach this point, initialization of the
   ;; whole object succeeded, and we can return true:
   
   return, 1                    ;TRUE
End

Pro widget_image_factory::cleanup
   message, /Info, "I'm dying!"
   self->basic_widget_object::cleanup ;This also destroyes the widget 
   self->image_factory::cleanup
End



;; ------------ Public --------------------

;; ------------ Private --------------------






;; ------------ Object definition ---------------------------
Pro widget_image_factory__DEFINE
   dummy = {widget_image_factory, $
            $
            inherits basic_widget_object, $
            inherits image_factory $
           }
End

