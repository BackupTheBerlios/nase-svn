;; ------------ Widget Support Routines ---------------------
Function basic_widget_object_get_value, widid
   COMPILE_OPT HIDDEN, IDL2
   ;; Returns the VALUE of the widget_object. This is the object 
   ;; reference of the associated object. It is stored in a
   ;; private subwidget:
;   Widget_Control, $
;    Widget_Info(widid, $
;                Find_By_Uname="basic_widget_object_private_value_container"), $
;    Get_UValue=object_reference
   Widget_Control, widid, Get_UValue=object_reference

   return, object_reference
End

Pro basic_widget_object_kill_notify, private_base_id
   COMPILE_OPT HIDDEN, IDL2
   ;; This Procedure is called when the private value container
   ;; widget dies. It is used to destroy the associated object
   ;; as well:
   Widget_Control, private_base_id, $
    Get_UValue=object_reference
   Obj_Destroy, object_reference
End

Pro basic_widget_object_TLB_eventhandler, e
   COMPILE_OPT HIDDEN, IDL2
   ;; This Procedure is called when the top-level-base receives an
   ;; event. E.g. resize events arrive here naturally, but also all
   ;; other events from subwidgets that have not been caught
   ;; elsewhere. Hence, we handle the events we know, and leave the
   ;; rest to specify by the user.

   ;; our (top-level) basic_widget_object:
   o = uvalue(e.top)
   
   case tag_names(e, /structure_name) of
      'WIDGET_BASE': begin      ; a top-level-base resize event
         
;         message, /info, "handler called with x:"+str(e.x)+", y:"+str(e.y)

;         g = widget_info(e.top, /GEOMETRY)
;         message, /info, "start of handler******************"
;         help,  g,  /struct

         o = uvalue(e.top)

;         widget_control, e.top, update=0

         ;; if we are a scrolling base, we have to update the scroll
         ;; bars to reflect the new widget size. We do this by setting
         ;; our scr_size.
         ;; resize the top level base. What happens here can differ
         ;; from window manager to window manager.
         if o->scroll_() then widget_control, e.top, scr_xsize=e.x, scr_ysize=e.y
         ;; nothing has to be done to the client area in this case, we
         ;; just adjust the scrollbars and that's it.

         ;; if we are a non-scrolling base, the client area of our
         ;; base widget shall be changed, and the user should decide
         ;; how to react to this request. That's
         ;; why we call the resize hook.
         if not o->scroll_() then o->resize_hook_, e.x, e.y

;         widget_control, e.top, update=1

;         g = widget_info(e.top, /GEOMETRY)
;         message, /info, "end of handler******************"
;         help,  g,  /struct
         
      end
      
      else: dummy_eventhandler, e
   endcase
   
End



;; ------------ Constructor & Destructor --------------------
Function basic_widget_object::init, PARENT=Parent, OPARENT=OParent, $
                                    TITLE=title, $
                                    TLB_SIZE_EVENTS=tlb_size_events, $
                                    SCROLL=scroll, $
                                    X_SCROLL_SIZE=x_scroll_size, $
                                    Y_SCROLL_SIZE=y_scroll_size, $
                                    _REF_EXTRA=_extra
   COMPILE_OPT IDL2
   DMsg, "I am created."

   Default, title, Obj_Class(self)
   self.title = title

   ;; The default is that our widget produces size events (only
   ;; relevant, if it is a top level base)
   Default, TLB_SIZE_EVENTS, 1

   ;; we need to remember if we are scrolling or not for resize
   ;; handling:
   if keyword_set(scroll) or keyword_set(x_scroll_size) or $
     keyword_set(y_scroll_size) then self.scroll = 1
   If Keyword_Set(OParent) then Parent = OParent->widget()
   
   If Keyword_Set(Parent) then begin
      self.widget = widget_base(Parent, $
                                TITLE=title, $
                                UValue=self, $;; all widgets have self
                                $  ;; as uvalue
                                UName="basic_widget_object", $
                                Func_Get_Value="basic_widget_object_get_value", $
                                Kill_Notify="basic_widget_object_kill_notify", $
                                SCROLL=scroll, $
                                X_SCROLL_SIZE=x_scroll_size, $
                                Y_SCROLL_SIZE=y_scroll_size, $
                                _EXTRA=_EXTRA)

   endif else begin             ;create top-level-base
      self.widget = widget_base(UName="basic_widget_object", $
                                TITLE=title, $
                                UValue=self, $;; all widgets have self
                                $  ;; as uvalue
                                Func_Get_Value="basic_widget_object_get_value", $
                                Kill_Notify="basic_widget_object_kill_notify", $
                                TLB_SIZE_EVENTS=tlb_size_events, $
                                SCROLL=scroll, $
                                X_SCROLL_SIZE=x_scroll_size, $
                                Y_SCROLL_SIZE=y_scroll_size, $
                                _EXTRA=_EXTRA)
   Endelse

   return, 1                    ;TRUE
End

Pro basic_widget_object::cleanup, dummy=dummy
   COMPILE_OPT IDL2
   DMsg, "I'm dying!"
   ;; destroy associated widget as well. This would lead to
   ;; infinite recursion as the widget would try to destroy the
   ;; object. Hence, remove KILL_NOTIFY Procedure from the
   ;; widget first:
   Widget_Control, self.widget, Kill_Notify=""
   
   ;; then destroy widget:
   Widget_Control, self.widget, /DESTROY
End



;; ------------ Public --------------------
;; Member access methods:
Function basic_widget_object::widget
   COMPILE_OPT IDL2
   return, self.widget
End
;; Other public methods:
Pro basic_widget_object::uvalue, val, NO_COPY=no_copy 
   COMPILE_OPT IDL2
   Widget_Control, self.widget, Set_Uvalue=val, NO_COPY=no_copy
End
Function basic_widget_object::uvalue, NO_COPY=no_copy 
   COMPILE_OPT IDL2
   Widget_Control, self.widget, Get_Uvalue=val, NO_COPY=no_copy
   return, val
End

;; Widget management methods:
Function basic_widget_object::subwidget, widget_function, _ref_extra=e
   ;; adds a widget of specified type to our base object
   ;; returns the WIDGET ID of the new widget.
   return, call_function(widget_function, $
                         self->widget(), $; our widget is the parent
                         UValue=self, $;; all widgets shall have self
                         ;; as uvalue!
                        _extra = e)
End

Function basic_widget_object::subobject, object_type, _ref_extra=e
   ;; adds a sub-widget-object to our base object
   ;; the type specified must be derived from basic_widget_object!
   ;; returns the OBJECT ID of the new widget_object.
   return, obj_new(object_type, $
                   OParent=self, $; we are the parent
                   UValue=self, $;; all widgets shall have self
                   ;; as uvalue!
                   _extra = e)
End

Function basic_widget_object::subbase, _ref_extra=e
   ;; adds a sub-basic-widget-object to our base object
   ;; returns the OBJECT ID of the new basic_widget_object.
   return, self -> subobject("basic_widget_object", $
                   _extra = e)
End



Pro basic_widget_object::realize
   COMPILE_OPT IDL2
   Widget_Control, self->widget(), /Realize
End

Pro basic_widget_object::register, TITLE=title, $
                                   NO_BLOCK=no_block, EVENT_HANDLER=event_handler, $
                                   _ref_extra=e
   COMPILE_OPT IDL2
   ;; no_block is default!
   Default, title, self.title
   Default, no_block, 1
   Default, EVENT_HANDLER, "basic_widget_object_TLB_eventhandler"
   widget_Control, Tlb_Set_Title=title, self->widget()
   Xmanager, title, self->widget(), $
             NO_BLOCK=no_block, EVENT_HANDLER=event_handler, $
             _EXTRA=e
End

;Pro basic_widget_object::resize, x, y
;   COMPILE_OPT IDL2
;   ;; Resizes the widget (for top level-bases: the inner area without the
;   ;; surroundings added by the window manager) to the specified values.
   
;   dmsg, "resize called with x:"+str(x)+", y:"+str(y)

;End

;; ------------ Private --------------------

;Function basic_widget_object::inner_widget_
;   COMPILE_OPT IDL2
;   return, self.inner_widget
;End

Function basic_widget_object::scroll_
   COMPILE_OPT IDL2
   return, self.scroll
End

Pro basic_widget_object::resize_hook_, x, y
   COMPILE_OPT IDL2
   ;; This is the hook that is called when our widget has been resized
   ;; through the window manager. This method is only called for
   ;; non-scrolling top-level-bases (scrolling tlbs are resized, but
   ;; no action has to been taken by the user). The values passed denote the desired
   ;; new client area of our widget (everything that is inside the
   ;; window frame). This method should do anything that must be done
   ;; to reach this new client size.

   ;; The default is to do nothing. Override as needed!
  
;   dmsg, "resize-hook called with x:"+str(x)+", y:"+str(y)
End





;; ------------ Object definition ---------------------------
Pro basic_widget_object__DEFINE
   COMPILE_OPT IDL2
   dummy = {basic_widget_object, $
            $
            widget: 0l, $
            scroll: 0b, $
            title: "" $
           }
End
