;+
; NAME:
;       Cleanup_SuperClasses
;
; PURPOSE: Cleanup of an object's superclasses.
;            When deriving a new class from one or more superclasses, the user
;          is responsible for explicitely calling the CLEANUP methods of all
;          superclasses in the new class' CLEANUP method.
;            In contrast to the initialization cycle (see <A HREF="#INIT_SUPERCLASSES">Init_SuperClasses()</A>,
;          this is a straightforward process. Nevertheless,
;          Cleanup_SuperClasses is supplied as the counterpart of <A HREF="#INIT_SUPERCLASSES">Init_SuperClasses()</A>
;          and for convenience.
;
;          Init_SuperClasses() calls the CLEANUP methods of an object's
;          direct superclasses.
;
; CATEGORY: Objects
;
; CALLING SEQUENCE: Cleanup_SuperClasses, self, _EXTRA=_extra
;
; INPUTS: self: A reference to the object to destroy. This is always "self".
;
; KEYWORD PARAMETERS: Any keyword parameters are passed to the superclasses'
;                     CLEANUP methods through _REF_EXTRA.
;                       See also RESTRICTIONS below.
;
; RESTRICTIONS: This function is designed to be called from an
;               object's CLEANUP method only.
;                 Note that only keyword parameters, not positional parameters
;               can be passed. Note also, that _REF_EXTRA is used for passing. 
;               Hence, the CLEANUP methods of all direct superclasses should have
;               unique keywords. Otherwise, the keyword is passed to all CLEANUP
;               methods it matches.
;
; PROCEDURE: o Query superclasses using OBJ_CLASS(/SUPERCLASS)
;            o Call CLEANUP methods using CALL_METHOD
;
; EXAMPLE: May Class "MyClass" inherit from "Class_A" and "Class_B".
;          It's CLEANUP method should look somewhat like the following:
;
;          Function MyClass::CLEANUP, MY_KEYWORD=m, _REF_EXTRA=other_keywords
;
;           ; Do whatever cleanup is needed for a MyClass object,
;           ; IN ADDITION to cleaning up the superclasses:
;           [...]
;
;           ; Clean up the superclass-part of the object:
;           Cleanup_SuperClasses, self, _EXTRA=other_keywords
;
;          End
;            
; SEE ALSO: <A HREF="#CLEANUP_SUPERCLASSES">Cleanup_SuperClasses</A>
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 1.1  2000/02/21 18:27:42  kupper
;        Why is the fucking IDL compiler not doing all this work???
;
;
;-

Pro Cleanup_Superclasses, self, _REF_EXTRA=_ref_extra
   superclasses =  Obj_Class(self, /SUPERCLASS)

   for i=0, n_elements(superclasses)-1 do $ 
       Call_Method,  superclasses[i]+"::CLEANUP", self, _EXTRA=_ref_extra
   
End
