;; ------------ Widget support routines ---------------------
Pro BDO_Notify_Realize, id
   Widget_Control, id, Get_Uvalue=object
   object->paint
End



;; ------------ Member access methods -----------------------
Function basic_draw_object::showit
   return, self.w_showit
End

;; ------------ Constructor, Destructor & Resetter --------------------
Function basic_draw_object::init, _REF_EXTRA=_ref_extra
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
                                 Notify_Realize="BDO_Notify_realize")

   ;; note: adding widgets will never fail.

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
End

;; ------------ Private --------------------

;; ------------ Object definition ---------------------------
Pro basic_draw_object__DEFINE
   dummy = {basic_draw_object, $
            $
            inherits basic_widget_object, $
            $
            w_showit: 0l $
           }
End
