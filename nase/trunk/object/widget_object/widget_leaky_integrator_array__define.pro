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
;   class widget_leaky_integrator_array
;
; PURPOSE: 
;
; CATEGORY: 
;
; SUPERCLASSES:
;   <A HREF="#CLASS WIDGET_IMAGE_CONTAINER">class widget_image_container</A>
;   <A HREF="#CLASS LEAKY_INTEGRATOR_ARRAY">class leaky_integrator_array</A>
;
; CONSTRUCTION: 
;
;   o = Obj_New("widget_leaky_integrator_array"
;               [,KEYWORD=value]
;               [-keywords inherited from <A HREF="#CLASS WIDGET_IMAGE_CONTAINER">class widget_image_container</A>-]
;               [-keywords inherited from <A HREF="#CLASS LEAKY_INTEGRATOR_ARRAY">class leaky_integrator_array</A>-])
;
; DESTRUCTION:
;
;   Obj_Destroy, o
;               [,KEYWORD=value]
;               [-keywords inherited from <A HREF="#CLASS WIDGET_IMAGE_CONTAINER">class widget_image_container</A>-]
;               [-keywords inherited from <A HREF="#CLASS LEAKY_INTEGRATOR_ARRAY">class leaky_integrator_array</A>-]
;                                               
; INPUTS: *please remove any sections that do not apply*
;
; OPTIONAL INPUTS:
;  *please remove any sections that do not apply*
;
; KEYWORD PARAMETERS:
;  *please remove any sections that do not apply*
;
; SIDE EFFECTS: 
;  *please remove any sections that do not apply*
;
; METHODS:
;
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
;  -plus those inherited from <A HREF="#CLASS WIDGET_IMAGE_CONTAINER">class widget_image_container</A> (see there for details)-
;  -plus those inherited from <A HREF="#CLASS LEAKY_INTEGRATOR_ARRAY">class leaky_integrator_array</A> (see there for details)-
;
; ABSTRACT METHODS:
;
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
; SEE ALSO: <A HREF="#MY_ROUTINE">My_Routine()</A>
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 1.1  2000/03/15 16:56:31  kupper
;        Initial revision
;
;-



;; ------------ Constructor, Destructor & Resetter --------------------
Function widget_leaky_integrator_array::init, KEYWORD = keyword, _REF_EXTRA=_ref_extra
   message, /Info, "I am created."

   ;; Try to initialize the superclass-portion of the
   ;; object. If it fails, exit returning false:
   If not Init_Superclasses(self, "widget_leaky_integrator_array", _EXTRA=_ref_extra) then return, 0

   ;; Try whatever initialization is needed for a widget_leaky_integrator_array object,
   ;; IN ADDITION to the initialization of the superclasses:
   ;;
   ;; insert code here
   ;;

   ;; If we reach this point, initialization of the
   ;; whole object succeeded, and we can return true:
   
   return, 1                    ;TRUE
End

Pro widget_leaky_integrator_array::cleanup, KEYWORD = keyword, _REF_EXTRA = _ref_extra
   message, /Info, "I'm dying!"

   ;; Cleanup the superclass-portion of the object:
   Cleanup_Superclasses, self, "widget_leaky_integrator_array", _EXTRA=_ref_extra

   ;; Now do what is needed to cleanup a widget_leaky_integrator_array object:
   ;;
   ;; insert code here
   ;;
End

Pro widget_leaky_integrator_array::reset
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
Pro widget_leaky_integrator_array::example, value
   ;;
   ;; insert code here
   ;;
   ;; EXAMPLE:
   ;; self.example = value
End
Function widget_leaky_integrator_array::example
   ;;
   ;; insert code here
   ;;
   ;; EXAMPLE:
   ;; return, self.example
End
;;
;; Other public methods:
Function widget_leaky_integrator_array::foo, parameter
End

Pro widget_leaky_integrator_array::bar, parameter
End


;; ------------ Protected ------------------


;; ------------ Private --------------------
Pro widget_leaky_integrator_array::override_me_; -ABSTRACT-
   ;; use this template for all abstract methods.
   On_error, 2
   message, "This abstract method was not overridden in derived class '"+Obj_Class(self)+"'!"
End




;; ------------ Object definition ---------------------------
Pro widget_leaky_integrator_array__DEFINE
   dummy = {widget_leaky_integrator_array, $
            $
            inherits widget_image_container, $
            inherits leaky_integrator_array, $
            $
            example: 0 $
           }
End
