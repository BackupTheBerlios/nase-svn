;; ------------ Widget support routines ---------------------
Pro MyWidget_Notify_Realize, id
   Widget_Control, id, Get_Uvalue=object
   ;;
   ;; insert code here if necessary, remove procedure if not
   ;;
End

Pro widget_image_container_MyWidget_handler, event
   Widget_Control, event.id, Get_Uvalue=object
   ;; What to do when the widget produces an event (e.g. is modified
   ;; interactively by the user)
   ;;
   ;; insert code here
   ;;
End



;; ------------ Member access methods -----------------------
Pro widget_image_container::size, value
   ;;
   ;; insert code here: set data member and adjust widget
   ;;
End

Function widget_image_container::size
   ;;
   ;; insert code here
   ;;
End

;; ------------ Constructor, Destructor & Resetter --------------------
Function widget_image_container::init, _REF_EXTRA=_ref_extra
   message, /Info, "I am created."

   ;; Try to initialize the superclass-portion of the
   ;; object. If it fails, exit returning false:
   If not Init_Superclasses(self, _EXTRA=_ref_extra) then return, 0

   ;; Try whatever initialization is needed for a image_container object,
   ;; IN ADDITION to the initialization of the superclasses:
   ;;
   ;; insert code here
   ;;

   ;; add any widgets
   ;; all widgets we add here should have self as their user-value.
   ;;
   ;; insert code here
   ;;
   ;; EXAMPLE: add showit to present picture
   ;; self.showit_id = widget_showit(self.widget, /Private_Colors, $
   ;;                                UValue=self, $
   ;;                                Notify_Realize="WIF_Notify_realize")
   ;; EXAMPLE: add a slider to select image size
   ;; self.w_size = CW_fslider2(self.widget, /Vertical, Minimum=0.0, Maximum=1.0, $
   ;;                           StepWidth=0.01, Value=self.size, Title="size", $
   ;;                           UValue=self, $
   ;;                           Event_Pro="image_container_size_handler")
   ;;

   ;; note: adding widgets will never fail.

   ;; If we reach this point, initialization of the
   ;; whole object succeeded, and we can return true:

   
   return, 1                    ;TRUE
End

Pro widget_image_container::cleanup, _REF_EXTRA = _ref_extra
   message, /Info, "I'm dying!"
   Cleanup_Superclasses, self, _EXTRA=_ref_extra
   ;; Note: Destroying the basic_widget_object also destroyes the widget.

   ;; Now do what is needed to cleanup a image_container object:
   ;;
   ;; insert code here
   ;;
End

Pro widget_image_container::reset
   ;; set all data members to defaults, using the member access methods (this
   ;; will also set the widgets correctly!)
   ;;
   ;; insert code here
   ;;
End

;; ------------ Public --------------------

;; ------------ Private --------------------

;; ------------ Object definition ---------------------------
Pro widget_image_container__DEFINE
   dummy = {widget_image_container, $
            $
            inherits basic_widget_object $
           }
End
