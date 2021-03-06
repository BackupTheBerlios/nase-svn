;; Welcome to the NASE object definition template.
;; Please use your editor's replace option to replace all occurrences of
;; "MyClass" by your desired classname. You might also want to replace all
;; occurrences of "MySuperClass" and "MyOtherSuperClass" by the names of your
;; class's superclasses. Then change header and object definition to suit your
;; object. All methods described in this header are examples.
;; Do not forget to delete this text.
;; Have fun! (And always remember: Don't drink and derive ;-) )

;+
; NAME:
;   class MyClass
;
; PURPOSE: 
;
; CATEGORY: 
;
; SUPERCLASSES:
;   <A>class MySuperClass</A>
;   <A>class MyOtherSuperClass</A>
;
; CONSTRUCTION: 
;*  o = Obj_New("MyClass"
;*              [,KEYWORD=value]
;*              [-keywords inherited from <A>class MySuperClass</A>-]
;*              [-keywords inherited from <A>class MyOtherSuperClass</A>-])
;
; DESTRUCTION:
;*  Obj_Destroy, o
;*              [,KEYWORD=value]
;*              [-keywords inherited from <A>class MySuperClass</A>-]
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
;  -plus those inherited from <A>class MySuperClass</A> (see there for details)-
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
; <A>class MySuperClass</A>, <A>class MyOtherSuperClass</A>
;-



;; ------------ Static member definition -------------------
Pro MyClass__init_static
   COMPILE_OPT IDL2, HIDDEN
   ;; This member function is called from MyClass__DEFINE. However, we
   ;; need it to be the /first/ procedure in the file, because it defines
   ;; the common-block th other member functions will refer to.
   ;; MyClass__DEFINE on the other hand needs to be the /last/
   ;; procedure in the file. For this great IDL design, we need this
   ;; special function...

   Common MyClass_static, MyStaticMember, MyOtherStaticMember

   MyStaticMember      = "foo"
   MyOtherStaticMember = "bar"

   ;; Static members should all be regarded private, just like the
   ;; non-static data members.

   ;; Note that this is no method, but a normal procedure: static
   ;; class information is initialized as soon as this file was
   ;; compiled, and exists independent of any object instantiations.

   ;; Is there any way to have static -methods-?
End


;; ------------ Constructor, Destructor & Resetter --------------------
Function MyClass::init, KEYWORD = keyword, _REF_EXTRA=_ref_extra
   COMPILE_OPT IDL2
   Common MyClass_static
   DMsg, "I am created."

   ;; Try to initialize the superclass-portion of the
   ;; object. If it fails, exit returning false.
   ;; Note that here any keyword options to the superclass can be
   ;; passed.
   If not Init_Superclasses(self, "MyClass", _EXTRA=_ref_extra) then return, 0

   ;; Try whatever initialization is needed for a MyClass object,
   ;; IN ADDITION to the initialization of the superclasses:
   ;;
   ;; insert code here
   ;;

   ;; If we reach this point, initialization of the
   ;; whole object succeeded, and we can return true:
   
   return, 1                    ;TRUE
End

Pro MyClass::cleanup, KEYWORD = keyword, _REF_EXTRA = _ref_extra
   COMPILE_OPT IDL2
   Common MyClass_static
   DMsg, "I'm dying!"

   ;; Cleanup the superclass-portion of the object:
   Cleanup_Superclasses, self, "MyClass", _EXTRA=_ref_extra

   ;; Now do what is needed to cleanup a MyClass object:
   ;;
   ;; insert code here
   ;;
End

Pro MyClass::reset
   COMPILE_OPT IDL2
   Common MyClass_static
   ;; Set all data members to defaults. You may want to use the member access
   ;; methods, in case they perform any side effects.
   ;; Remove this method if nothing is to reset on your object.
   ;;
   ;; insert code here
   ;;
End


;; ------------ Public --------------------
;;
;; Member access methods
;;  (for any data members that should be open to the public)
Pro MyClass::example, value
   COMPILE_OPT IDL2
   Common MyClass_static
   ;;
   ;; insert code here
   ;;
   ;; EXAMPLE:
   ;; self.example = value
End
Function MyClass::example
   COMPILE_OPT IDL2
   Common MyClass_static
   ;;
   ;; insert code here
   ;;
   ;; EXAMPLE:
   ;; return, self.example
End
;;
;; Other public methods:
Function MyClass::foo, parameter
   COMPILE_OPT IDL2
   Common MyClass_static
End

Pro MyClass::bar, parameter
   COMPILE_OPT IDL2
   Common MyClass_static
End


;; ------------ Protected ------------------


;; ------------ Private --------------------
Pro MyClass::override_me_; -ABSTRACT-
   COMPILE_OPT IDL2
   Common MyClass_static
   ;; use this template for all abstract methods.
   On_error, 2
   Console, /Fatal, "This abstract method was not overridden in derived class '"+Obj_Class(self)+"'!"
End




;; ------------ Object definition ---------------------------
Pro MyClass__DEFINE
   COMPILE_OPT IDL2
   Common MyClass_static

   ;; initialization of static members:
   MyClass__init_static

   ;; class definition
   dummy = {MyClass, $
            $
            inherits MySuperClass, $
            inherits MyOtherSuperClass, $
            $
            example: 0 $
           }
End
