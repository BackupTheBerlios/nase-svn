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




;; ------------ Constructor & Destructor --------------------
Function basic_widget_object::init, PARENT=Parent, OPARENT=OParent, $
                            TITLE=title, $
                            _REF_EXTRA=_extra
   DMsg, "I am created."

   Default, title, Obj_Class(self)
   self.title = title

   If Keyword_Set(OParent) then Parent = OParent->widget()

   If Keyword_Set(Parent) then begin
      self.widget = widget_base(Parent, $
                                TITLE=title, $
                                UValue=self, $;; all widgets have self
                                $  ;; as uvalue
                                UName="basic_widget_object", $
                                Func_Get_Value="basic_widget_object_get_value", $
                                _EXTRA=_extra)
   endif else begin             ;create top-level-base
      self.widget = widget_base(UName="basic_widget_object", $
                                TITLE=title, $
                                UValue=self, $;; all widgets have self
                                $  ;; as uvalue
                                Func_Get_Value="basic_widget_object_get_value", $
                                _EXTRA=_extra)
   Endelse
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
   DMsg, "I'm dying!"
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
;; Member access methods:
Function basic_widget_object::widget
   return, self.widget
End
;; Other public methods:
Pro basic_widget_object::uvalue, val, NO_COPY=no_copy 
   Widget_Control, self.widget, Set_Uvalue=val, NO_COPY=no_copy
End
Function basic_widget_object::uvalue, NO_COPY=no_copy 
   Widget_Control, self.widget, Get_Uvalue=val, NO_COPY=no_copy
   return, val
End

Pro basic_widget_object::realize
   Widget_Control, self->widget(), /Realize
End

Pro basic_widget_object::register, TITLE=title, NO_BLOCK=no_block, _ref_extra=e
   ;; no_block is default!
   Default, title, self.title
   Default, no_block, 1
   widget_Control, Tlb_Set_Title=title, self->widget()
   Xmanager, title, self->widget(), NO_BLOCK=no_block, _EXTRA=e
End

;; ------------ Private --------------------






;; ------------ Object definition ---------------------------
Pro basic_widget_object__DEFINE
   dummy = {basic_widget_object, $
            $
            widget: 0l, $
            title: "" $
           }
End
