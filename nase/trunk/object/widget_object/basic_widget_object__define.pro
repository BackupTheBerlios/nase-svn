;; ------------ Widget Support Routines ---------------------
Function basic_widget_object_get_value, widid
   ;; Returns the VALUE of the widget_object. This is the object 
   ;; reference of the associated object. It is stored in a
   ;; private subwidget:
   Widget_Control, $
    Widget_Info(widid, $
                Find_By_Uname="basic_widget_object_private_value_container"), $
    Get_UValue=object_reference

   return, object_reference
End

Pro basic_widget_object_kill_notify, private_base_id
   ;; This Procedure is called when the private value container
   ;; widget dies. It is used to destroy the associated object
   ;; as well:
   Widget_Control, private_base_id, $
    Get_UValue=object_reference
   Obj_Destroy, object_reference
End



;; ------------ Member access methods -----------------------
Function basic_widget_object::widget
   return, self.widget
End

;; ------------ Constructor & Destructor --------------------
Function basic_widget_object::init, PARENT=Parent, _REF_EXREA=_extra
   message, /Info, "I am created."
   self.widget = widget_base(Parent, /Column, $
                             UName="basic_widget_object", $
                             Func_Get_Value="basic_widget_object_get_value", $
                             _EXTRA=_extra)
   ;; Our widget uses a child as a container for the
   ;; object reference. The user can query it as the VALUE of
   ;; the main widget:
   dummy = widget_base(self.widget, $
                       UName="basic_widget_object_private_value_container", $
                       UValue=self, $
                       Kill_Notify="basic_widget_object_kill_notify")

   return, 1                    ;TRUE
End

Pro basic_widget_object::cleanup, dummy=dummy
   message, /Info, "I'm dying!"
   ;; destroy associated widget as well. This would lead to
   ;; infinite recursion as the widget would try to destroy the
   ;; object. Hence, remove KILL_NOTIFY Procedure from the
   ;; private value container first:
   Widget_Control, $
    Widget_Info(self.widget, $
                Find_By_Uname="basic_widget_object_private_value_container"), $
    Kill_Notify=""
   
   ;; then destroy widget:
   Widget_Control, self.widget, /DESTROY
End



;; ------------ Public --------------------

;; ------------ Private --------------------






;; ------------ Object definition ---------------------------
Pro basic_widget_object__DEFINE
   dummy = {basic_widget_object, $
            $
            widget: 0l $
           }
End
