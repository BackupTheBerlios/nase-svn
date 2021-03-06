; ---header would not be parsed by NASE help---
; ---need to create a proper header for objects!---

; (+)
; NAME:
;   class widget_leaky_image_container
;
; AIM:
;   An image container/displayer that also performs temporal lowpass filtering.
;
; PURPOSE: 
;   Store, display, and temporal lowpass filter a sequence of images.
;
; CATEGORY: 
;  Graphic
;  Image
;  Objects
;  Widgets
;
; SUPERCLASSES:
;   <A NREF=widget_image_container__define>class widget_image_container</A>
;
; CONSTRUCTION: 
;
;   o = Obj_New("widget_leaky_image_container"
;               IMAGE=..., MAX_IN=..., TAU=... [,/COLUMN]
;               [,FRAME=...] [,SUBFRAME=...]
;               [,L_CUBIC=...] [,/L_MINUS_ONE] [,/L_INTERP]
;               [-other keywords inherited from <A HREF="#CLASS MYSUPERCLASS">class widget_image_container</A>-]
;
; DESTRUCTION:
;
;   Obj_Destroy, o
;                                               
; INPUTS: *please remove any sections that do not apply*
;
; OPTIONAL INPUTS:
;  *please remove any sections that do not apply*
;
; KEYWORD PARAMETERS:
;  L_CUBIC, L_MINUS_ONE, L_INTERP:: interpolation keywords for the
;                                   leaky integrator widget.
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
;  -plus those inherited from <A HREF="#CLASS MYSUPERCLASS">class widget_image_container</A> (see there for details)-
;  -plus those inherited from <A HREF="#CLASS MYOTHERSUPERCLASS">class MyOtherSuperClass</A> (see there for details)-
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
;        Revision 1.7  2003/10/27 14:08:13  kupper
;        fixed bug that must have been there since the beginning:
;        write L_INTERP instead of L_MINUS_ONE in default. Made no sense, and
;        one row in display was lost!
;
;        Revision 1.6  2003/07/04 14:04:21  kupper
;        added L_CUBIC, L_INTERP, L_MINUS_ONE keywords.
;
;        Revision 1.5  2001/09/21 13:52:13  kupper
;        Implemented FRAME und SUBFRAME keywords.
;        R�
;
;        Revision 1.4  2001/09/21 12:46:35  kupper
;        integrator display is now interpolated.
;
;        Revision 1.3  2001/09/17 15:34:41  kupper
;        Range_In is now only passed to the widget_image-container-part, not to
;        the widget_leaky_intergrator_array, as there it is computed from
;        max_in.
;
;        Revision 1.2  2001/09/17 14:56:17  kupper
;        added no_copy option to input method.
;
;        Revision 1.1  2001/08/24 13:41:17  kupper
;        Useful combination.
;
;(-)



;; ------------ Constructor, Destructor & Resetter --------------------
Function widget_leaky_image_container::init, IMAGE=image, $
                                     Range_In=Range_In, $
                                     COLUMN=column, $
                                     FRAME=frame, $
                                     SUBFRAME=subframe, $
                                     L_CUBIC=l_cubic, L_MINUS_ONE=l_minus_one, L_INTERP=l_interp, $
                                    _REF_EXTRA=_ref_extra
   DMsg, "I am created."

   Default, L_CUBIC, -0.5
   Default, L_MINUS_ONE, 1

   If keyword_set(Column) then row = 0 else row = 1

   ;; Try to initialize the superclass-portion of the
   ;; object. If it fails, exit returning false:
   If not Init_Superclasses(self, "widget_leaky_image_container", $
                            COLUMN=column, ROW=row, $
                            Range_In=Range_In, $
                            FRAME=frame, SUBFRAME=subframe, $
                            IMAGE=image, _EXTRA=_ref_extra) then return, 0

   ;; Try whatever initialization is needed for a widget_leaky_image_container object,
   ;; IN ADDITION to the initialization of the superclasses:
  
   self.lia = Obj_New("widget_leaky_integrator_array", OParent=self, $
                      Dimensions=Size(IMAGE, /Dimensions), $
                      CUBIC=L_CUBIC, MINUS_ONE=L_MINUS_ONE, INTERP=L_INTERP, $
                      FRAME=subframe, $
                      _EXTRA=_ref_extra)

   ;; If we reach this point, initialization of the
   ;; whole object succeeded, and we can return true:
   
   return, 1                    ;TRUE
End

Pro widget_leaky_image_container::cleanup, KEYWORD = keyword, _REF_EXTRA = _ref_extra
   DMsg, "I'm dying!"

   ;; Cleanup the superclass-portion of the object:
   Cleanup_Superclasses, self, "widget_leaky_image_container", _EXTRA=_ref_extra

   ;; Now do what is needed to cleanup a widget_leaky_image_container object:

   Obj_Destroy, self.lia
End

Pro widget_leaky_image_container::reset
   self.lia->reset
;(has no reset method!)   self->widget_image_container::reset
End


;; ------------ Public --------------------
;;
;; Member access methods
;;  (for any data members that should be open to the public)
;Pro widget_leaky_image_container::example, value
;   ;;
;   ;; insert code here
;   ;;
;   ;; EXAMPLE:
;   ;; self.example = value
;End
;Function widget_leaky_image_container::example
;   ;;
;   ;; insert code here
;   ;;
;   ;; EXAMPLE:
;   ;; return, self.example
;End
;;
;; Other public methods:
Pro widget_leaky_image_container::input, val, NO_COPY=no_copy
   self.lia->input, val
   self->widget_image_container::image, val, NO_COPY=no_copy
End

;; Methods passed to member lia:
Function widget_leaky_image_container::result
   return, self.lia->result()
End
Function widget_leaky_image_container::resultptr
   return, self.lia->resultptr()
End
Function widget_leaky_image_container::asymptote, constin
   return, self.lia->asymptote(constin)
End
;; ------------ Protected ------------------


;; ------------ Private --------------------
;Pro widget_leaky_image_container::override_me_; -ABSTRACT-
;   ;; use this template for all abstract methods.
;   On_error, 2
;   Console, /Fatal, "This abstract method was not overridden in derived class '"+Obj_Class(self)+"'!"
;End




;; ------------ Object definition ---------------------------
Pro widget_leaky_image_container__DEFINE
   dummy = {widget_leaky_image_container, $
            $
            inherits widget_image_container, $
            $;inherits MyOtherSuperClass, $
            $
            lia: Obj_New() $;; the widget leaky image container for lowpass
           }
End
