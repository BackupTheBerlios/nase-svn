;+
; NAME:
;   class Widget_Gabor_Factory
;
; PURPOSE: 
;
; CATEGORY: 
;
; SUPERCLASSES:
;   <A HREF="#CLASS WIDGET_IMAGE_CONTAINER">class widget_image_container</A>
;
; CONSTRUCTION: 
;
;   o = Obj_New("widget_gabor_factory"
;               [,KEYWORD=value]
;               [-keywords inherited from <A HREF="#CLASS WIDGET_IMAGE_CONTAINER">class widget_image_container</A>-])
;
; DESTRUCTION:
;
;   Obj_Destroy, o
;               [,KEYWORD=value]
;               [-keywords inherited from <A HREF="#CLASS WIDGET_IMAGE_CONTAINER">class widget_image_container</A>-]
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
;        Revision 1.2  2001/08/02 14:28:52  kupper
;        Replaced IDL-style "MESSAGE" calls by NASE-style "Console" commands.
;
;        Revision 1.1  2000/08/16 12:09:41  kupper
;        Initial revision
;
;-

Pro __gf_event_handler, event
   ;; This is called whenever a slider or button is modified.
   ;; recreate (and paint) gabor patch!
   Widget_Control, event.handler, Get_Uvalue=object

   object->image, object->compute_gabor_()
End



;; ------------ Constructor, Destructor & Resetter --------------------
Function widget_gabor_factory::init, WIDTH = width, _REF_EXTRA=_ref_extra
   DMsg, "I am created."

   ;; Try whatever initialization is needed for a widget_gabor_factory object,
   ;; IN ADDITION to the initialization of the superclasses:
   self.gf_data.width = width
   
   HWB = width/6.0
   ORIENT = 0.0
   PHASE = 0.0
   WAVE = width/3.0
   NICE = 0b
   MAXONE = 0b

   ;; Try to initialize the superclass-portion of the
   ;; object. If it fails, exit returning false:
   If not self->widget_image_container::INIT(IMAGE = Gabor(WIDTH, HWB=HWB, Orientation=ORIENT, Phase=PHASE,$
                                                           Wavelength=WAVE, Nicedetector=NICE, MAXONE=MAXONE), $
                                             /NASE, Range_In=[-1.1,1.1], $
                                             _EXTRA=_ref_extra) then return, 0

   gf_base = Widget_Base(self->widget(), /Column,$
                         /ALign_center, Frame=3, $
                         Event_Pro="__gf_event_handler", $
                         Uvalue=self)


   self.gf_data.hwb_slider = Cw_Fslider2(gf_base, /Drag, Minimum=0.1, $
                                         Maximum=width/3.0, Stepwidth=0.1, $
                                         Format='(F5.1," pixels")', $
                                         Title="half mean width",$
                                         /Label_Right, $
                                         Frame=2, $
                                         Value=HWB)
   self.gf_data.orientation_slider = Cw_Fslider2(gf_base, /Drag, Minimum=0.0, $
                                                 Maximum=360, Stepwidth=1, $
                                                 Format='(I6,"°")', $
                                                 Frame=2, $
                                                 /Label_Right, $
                                                 Title="orientation", Value=ORIENT)
   self.gf_data.phase_slider = Cw_Fslider2(gf_base, /Drag, Minimum=-180, $
                                           Maximum=180, Stepwidth=1, $
                                           Format='(I6,"°")', $
                                           Title="phase", $
                                           Frame=2, $
                                           /Label_Right, $
                                           Value=Rad(PHASE, /symmetric))
   self.gf_data.wavelength_slider = Cw_Fslider2(gf_base, /Drag, Minimum=0.1, $
                                                Maximum=width, Stepwidth=0.1,$
                                                Format='(F5.1," pixels")', $
                                                Frame=2, $
                                                /Label_Right, $
                                                Title="wavelength", Value=WAVE)
   self.gf_data.buttons= Cw_Bgroup(gf_base, ["nice detector", "max. one"], $
                                   /Nonexclusive, /Row, $
                                   Set_Value=[NICE, MAXONE])
   
   ;; If we reach this point, initialization of the
   ;; whole object succeeded, and we can return true:
   
   return, 1                    ;TRUE
End

Pro widget_gabor_factory::cleanup, KEYWORD = keyword, _REF_EXTRA = _ref_extra
   DMsg, "I'm dying!"

   ;; Cleanup the superclass-portion of the object:
   Cleanup_Superclasses, self, "widget_gabor_factory", _EXTRA=_ref_extra

   ;; Now do what is needed to cleanup a widget_gabor_factory object:
   ;;
   ;; insert code here
   ;;
End

;Pro widget_gabor_factory::reset
;   ;; Set all data members to defaults. You may want to use the member access
;   ;; methods, in case they perform any side effects.
;   ;; Remove this method if nothing is to reset on your object.
;   ;;
;   ;; insert code here
;   ;;
;End


;; ------------ Public --------------------
;;
;; Member access methods
;;  (for any data members that should be open to the public)
;Pro widget_gabor_factory::example, value
;   ;;
;   ;; insert code here
;   ;;
;   ;; EXAMPLE:
;   ;; self.example = value
;End
;Function widget_gabor_factory::example
;   ;;
;   ;; insert code here
;   ;;
;   ;; EXAMPLE:
;   ;; return, self.example
;End


;; ------------ Protected ------------------


;; ------------ Private --------------------
Function widget_gabor_factory::gf_data_
   return, self.gf_data
End

Function widget_gabor_factory::compute_gabor_
   WIDTH = self.gf_data.width
   Widget_Control, self.gf_data.hwb_slider, Get_Value=HWB
   Widget_Control, self.gf_data.orientation_slider, Get_Value=ORIENT
   Widget_Control, self.gf_data.phase_slider, Get_Value=PHASE
   Widget_Control, self.gf_data.wavelength_slider, Get_Value=WAVE
   Widget_Control, self.gf_data.buttons,Get_Value=buttonval
   NICE = buttonval[0]
   MAXONE = buttonval[1]

   return, Gabor(WIDTH, HWB=HWB, Orientation=ORIENT, Phase=Rad(PHASE, /symmetric),$
                 Wavelength=WAVE, Nicedetector=NICE,  Maxone=MAXONE)
End

;Pro widget_gabor_factory::override_me_; -ABSTRACT-
;   ;; use this template for all abstract methods.
;   On_error, 2
;   Console, /Fatal, "This abstract method was not overridden in derived class '"+Obj_Class(self)+"'!"
;End




;; ------------ Object definition ---------------------------
Pro widget_gabor_factory__DEFINE
   dummy = {widget_gabor_factory, $
            $
            inherits widget_image_container, $
            $
            gf_data: { gf_data, $
                       width: 0, $
                       $
                       hwb_slider: 0l, $
                       orientation_slider: 0l, $
                       phase_slider: 0l, $
                       wavelength_slider: 0l, $
                       buttons: 0l $
                     } $
            }
End
