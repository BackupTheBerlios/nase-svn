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
;        Revision 1.3  2000/03/16 13:21:11  kupper
;        Removed leftover keyword=keyword.
;
;        Revision 1.2  2000/03/15 19:00:45  kupper
;        Looks perfect!
;        No Header yet.
;
;        Revision 1.1  2000/03/15 16:56:31  kupper
;        Initial revision
;
;-



;; ------------ Constructor, Destructor & Resetter --------------------
Function widget_leaky_integrator_array::init, MAX_IN=max_in, _REF_EXTRA=_ref_extra
   message, /Info, "I am created."

   ;; Try to initialize the superclass-portion of the
   ;; object. If it fails, exit returning false:
   ;; (we let my image container watch the LIA, so we can't use the
   ;; Init_Superclasses routine):
   If not self->leaky_integrator_array::init(_EXTRA=_ref_extra) then return, 0
   If not self->widget_image_container::init(IMAGE=self->resultptr(), $
                                             Range_In=[0, self->asymptote(max_in)], $
                                             _EXTRA=_ref_extra) then begin
      self->leaky_integrator_array::cleanup
      return, 0
   End

   ;; Try whatever initialization is needed for a widget_leaky_integrator_array object,
   ;; IN ADDITION to the initialization of the superclasses:
   ;;
   ;; insert code here
   ;;

   ;; If we reach this point, initialization of the
   ;; whole object succeeded, and we can return true:
   
   return, 1                    ;TRUE
End

Pro widget_leaky_integrator_array::cleanup, _REF_EXTRA = _ref_extra
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
   self->leaky_integrator_array::reset
   self->paint
End


;; ------------ Public --------------------
;;
;; Member access methods
;;  (for any data members that should be open to the public)
;;
;; Other public methods:
Pro widget_leaky_integrator_array::input, val
   self->leaky_integrator_array::input, val
   self->paint
End

;; ------------ Protected ------------------

;; ------------ Private --------------------




;; ------------ Object definition ---------------------------
Pro widget_leaky_integrator_array__DEFINE
   dummy = {widget_leaky_integrator_array, $
            $
            inherits widget_image_container, $
            inherits leaky_integrator_array $
           }
End
