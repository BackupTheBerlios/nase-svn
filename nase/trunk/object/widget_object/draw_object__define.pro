;+
; NAME:
;   class draw_object
;
; PURPOSE:
;
;   Provides a non-abstract version of a basic_draw_object without additional
;   functionality. The user does not need to define a new class just to get a
;   simple draw widget object.
;
; CATEGORY: 
;
; SUPERCLASSES:
;   <A HREF="#CLASS BASIC_DRAW_OBJECT">class basic_draw_object</A>
;
; CONSTRUCTION: 
;
;   o = Obj_New("draw_object",
;               PAINT_HOOK=routine_name,
;               INITIAL_PAINT_HOOK=routine_name
;               [-keywords inherited from <A HREF="#CLASS BASIC_DRAW_OBJECT">class basic_draw_object</A>-])
;
; DESTRUCTION:
;
;   Obj_Destroy, o
;                                               
; KEYWORD PARAMETERS:
;
;   PAINT_HOOK, INITIAL_PAINT_HOOK:
;     Set these keywords to the name of routines that are to be called as the
;     object's paint_hook_ and initial_paint_hook_ methods (see <A HREF="#CLASS
;     BASIC_DRAW_OBJECT">class basic_draw_object</A> for details).
;     The procedures must accept one parameter, which is a reference to the
;     object. You may want to use this to distinguish between several draw
;     objects using the same paint hook. (For example, you could retrieve it's
;     uservalue).
;     Both keywords have to be specified. Pass an empty string to disable a hook.
;
; SIDE EFFECTS:
; 
;   A widget is created.
;
; METHODS:
;
;   -those inherited from <A HREF="#CLASS BASIC_DRAW_OBJECT">class basic_draw_object</A> (see there for details)-
;
; PROCEDURE: Straightforward. Derive-and-conquer :-)
;
; EXAMPLE: 
;
; SEE ALSO: <A HREF="#CLASS BASIC_DRAW_OBJECT">class basic_draw_object</A>
;           <A HREF="../../graphic/widgets/#WIDGET_SHOWIT">Widget_Showit()</A>
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 1.1  2000/03/13 17:52:28  kupper
;        Initial revision
;
;-



;; ------------ Constructor, Destructor & Resetter --------------------
Function draw_object::init, PAINT_HOOK=paint_hook, $
                    INITIAL_PAINT_HOOK=initial_paint_hook, _REF_EXTRA=_ref_extra
   message, /Info, "I am created."

   ;; Try to initialize the superclass-portion of the
   ;; object. If it fails, exit returning false:
   If not Init_Superclasses(self, "draw_object", _EXTRA=_ref_extra) then return, 0

   ;; Try whatever initialization is needed for a draw_object object,
   ;; IN ADDITION to the initialization of the superclasses:
   self.paint_hook = PAINT_HOOK
   self.initial_paint_hook = INITIAL_PAINT_HOOK
   
   ;; If we reach this point, initialization of the
   ;; whole object succeeded, and we can return true:
   
   return, 1                    ;TRUE
End

Pro draw_object::cleanup, _REF_EXTRA = _ref_extra
   message, /Info, "I'm dying!"

   ;; Cleanup the superclass-portion of the object:
   Cleanup_Superclasses, self, "draw_object", _EXTRA=_ref_extra

   ;; Now do what is needed to cleanup a draw_object object:
   ;;
   ;; (nothing!)
   ;;
End

;;Pro draw_object::reset
   ;; Set all data members to defaults. You may want to use the member access
   ;; methods, in case they perform any side effects.
   ;; Remove this method if nothing is to reset on your object.
   ;;
   ;; insert code here
   ;;
;;End


;; ------------ Public --------------------
;;
;; Member access methods
;;  (for any data members that should be open to the public)
;;
;; Other public methods:


;; ------------ Protected ------------------


;; ------------ Private --------------------
Pro draw_object::paint_hook_
   If self.paint_hook ne "" then Call_Procedure, self.paint_hook, self
End
Pro draw_object::initial_paint_hook_
   If self.initial_paint_hook ne "" then Call_Procedure, self.initial_paint_hook, self
End



;; ------------ Object definition ---------------------------
Pro draw_object__DEFINE
   dummy = {draw_object, $
            $
            inherits basic_draw_object, $
            $
            paint_hook: "", $
            initial_paint_hook: "" $
           }
End
