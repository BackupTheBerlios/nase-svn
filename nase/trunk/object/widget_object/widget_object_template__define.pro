;; Welcome to the NASE definition template for widget objects.
;; These are objects derived from the superclass "basic_widget_object".
;; Please use your editor's replace option to replace all occurrences of
;; "widget_MyClass" by your desired classname. You might also want to replace all
;; occurrences of "MyOtherSuperClass" by the name of your
;; classes superclass. Then change header and object definition to suit your
;; object. All methods described in this header are examples.
;; Do not forget to delete this text.
;; Have fun! (And always remember: Don't drink and derive ;-) )

;+
; NAME:
;   class widget_MyClass
;
; PURPOSE: 
;
; CATEGORY: 
;
; SUPERCLASSES:
;   <A>class basic_widget_object</A>
;   <A>class MyOtherSuperClass</A>
;
; CONSTRUCTION: 
;*  o = Obj_New("widget_MyClass"
;*              [,KEYWORD=value]
;*              [-keywords inherited from <A>class basic_widget_object</A>-]
;*              [-keywords inherited from <A>class MyOtherSuperClass</A>-])
;
; DESTRUCTION:
;*  Obj_Destroy, o
;*              [,KEYWORD=value]
;*              [-keywords inherited from <A>class basic_widget_object</A>-]
;*              [-keywords inherited from <A>class MyOtherSuperClass</A>-]
;                                               
; INPUTS:
;  *please remove any sections that do not apply*
;
; OPTIONAL INPUTS:
;  *please remove any sections that do not apply*
;
; INPUT KEYWORDS:
;  *please remove any sections that do not apply*
;
; SIDE EFFECTS: 
;  *please remove any sections that do not apply*
;
; METHODS:
;  public: Public methods may be called from everywhere.
;   
;   foo(parameter)       : computes the meaning of life.
;   bar, parameter       : crashes the system. Delay: parameter.
;
;  protected: Protected methods may only be called from within a derived class's
;             methods.
;   *please remove any sections that do not apply*
;
;  private: Private methods are not intended to be called by the user and are
;           not decribed in this header. Refer to the source code for information.
;   *please remove any sections that do not apply*
;
;  -plus those inherited from <A>class basic_widget_object</A> (see there for details)-
;  -plus those inherited from <A>class MyOtherSuperClass</A> (see there for details)-
;
; ABSTRACT METHODS:
;  Abstract methods are used to indicate that a class is designed to have a
;  respective method, but that functionality needs to be defined
;  in a derived class. Abstract methods must be overriden in derived classes.
;  Classes containing abstract methods (so-called abstract classes) are designed
;  for derivation only. Instantiation of abstract classes is an error.
;
;  public:
;   *please remove any sections that do not apply*
;
;  protected:
;   *please remove any sections that do not apply*
;
;  private:
;   override_me_ : insert abstract-to-paper filter here.
;
; RESTRICTIONS: 
;  *please remove any sections that do not apply*
;
; PROCEDURE: 
;
; EXAMPLE: 
;
; SEE ALSO:
; <A>class basic_widget_object</A>, <A>class MyOtherSuperClass</A>
;-


;; ------------ Widget support routines ---------------------
Pro MyWidget_Notify_Realize, id
   COMPILE_OPT HIDDEN, IDL2
   Widget_Control, id, Get_Uvalue=object
   ;;
   ;; insert code here if necessary, remove procedure if not
   ;;
End

Pro widget_MyClass_example_handler, event
   COMPILE_OPT HIDDEN, IDL2
   Widget_Control, event.id, Get_Uvalue=object
   ;; What to do when the widget produces an event (e.g. is modified
   ;; interactively by the user)
   ;;
   ;; insert code here
   ;;
   ;; EXAMPLE:
   ;; object->example, event.value   
End



;; ------------ Static member declaration -------------------
Common widget_MyClass_static, MyStaticMember, MyOtherStaticMember
;; (This is meant to be outside any procedure or function.)
;; Static members should all be regarded private, just like the
;; non-static data members.
;; Is there any way to have static -methods-?



;; ------------ Constructor, Destructor & Resetter --------------------
Function widget_MyClass::init, _REF_EXTRA=_ref_extra
   COMPILE_OPT IDL2
   Common widget_MyClass_static
   DMsg, "I am created."

   ;; Try to initialize the superclass-portion of the
   ;; object. If it fails, exit returning false:
   If not Init_Superclasses(self, "widget_MyClass", _EXTRA=_ref_extra) then return, 0

   ;; Try whatever initialization is needed for a widget_MyClass object,
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
   ;;                           Event_Pro="widget_MyClass_size_handler")
   ;;

   ;; note: adding widgets will never fail.

   ;; If we reach this point, initialization of the
   ;; whole object succeeded, and we can return true:

   
   return, 1                    ;TRUE
End

Pro widget_MyClass::cleanup, _REF_EXTRA = _ref_extra
   COMPILE_OPT IDL2
   Common widget_MyClass_static
   DMsg, "I'm dying!"
   Cleanup_Superclasses, self, "widget_MyClass", _EXTRA=_ref_extra
   ;; Note: Destroying the basic_widget_object also destroyes the widget.

   ;; Now do what is needed to cleanup a widget_MyClass object:
   ;;
   ;; insert code here
   ;;
End

Pro widget_MyClass::reset
   COMPILE_OPT IDL2
   Common widget_MyClass_static
   ;; set all data members to defaults, using the member access methods (this
   ;; will also set the widgets correctly!)
   ;;
   ;; insert code here
   ;;
End

;; ------------ Public --------------------
;;
;; Member access methods
;;  (for any data members that should be open to the public)
Pro widget_MyClass::example, value
   COMPILE_OPT IDL2
   Common widget_MyClass_static
   ;;
   ;; insert code here
   ;;
   ;; EXAMPLE:
   ;; self.example = value
End
Function widget_MyClass::example
   COMPILE_OPT IDL2
   Common widget_MyClass_static
   ;;
   ;; insert code here
   ;;
   ;; EXAMPLE:
   ;; return, self.example
End
;;
;; Other public methods:
Function widget_MyClass::foo, parameter
   COMPILE_OPT IDL2
   Common widget_MyClass_static
End

Pro widget_MyClass::bar, parameter
   COMPILE_OPT IDL2
   Common widget_MyClass_static
End


;; ------------ Protected ------------------


;; ------------ Private --------------------
Pro widget_MyClass::override_me_; -ABSTRACT-
   COMPILE_OPT IDL2
   Common widget_MyClass_static
   ;; use this template for all abstract methods.
   On_error, 2
   Console, /Fatal, "This abstract method was not overridden in derived class '"+Obj_Class(self)+"'!"
End




;; ------------ Object definition ---------------------------
Pro widget_MyClass__DEFINE
   COMPILE_OPT IDL2

   ;; initialization of static members:
   Common widget_MyClass_static
   MyStaticMember      = "foo"
   MyOtherStaticMember = "bar"


   ;; class definition
   dummy = {widget_MyClass, $
            $
            inherits basic_widget_object, $
            inherits MyOtherSuperClass, $
            $
            example: 0 $
           }
End

