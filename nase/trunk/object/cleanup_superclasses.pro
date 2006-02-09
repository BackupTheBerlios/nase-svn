;+
; NAME:
;       Cleanup_SuperClasses
;
; PURPOSE: Cleanup of an object's superclasses.
;            When deriving a new class from one or more superclasses, the user
;          is responsible for explicitely calling the CLEANUP methods of all
;          superclasses in the new class' CLEANUP method.
;            In contrast to the initialization cycle (see <A HREF="#INIT_SUPERCLASSES()">Init_SuperClasses()</A>,
;          this is a straightforward process. Nevertheless,
;          Cleanup_SuperClasses is supplied as the counterpart of <A HREF="#INIT_SUPERCLASSES()">Init_SuperClasses()</A>
;          and for convenience.
;
;          Init_SuperClasses() calls the CLEANUP methods of an object's
;          direct superclasses.
;
; CATEGORY: Objects
;
; CALLING SEQUENCE: Cleanup_SuperClasses, self, classname, _EXTRA=_extra
;
; INPUTS: self     : A reference to the object to destroy. This is always
;                    "self".
;         classname: A string containing the classname of the object to
;                    destroy.
;                    CAUTION: do NOT refer to this as OBJ_CLASS(self), as this
;                             will cause infinite recursion. Do always specify
;                             the classname as a string constant.
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
;                 Note that all CLEANUP methods must accept at least one keyword
;               parameter for the _EXTRA-mechanism to work. (IDL issues an
;               error, if it is tried to pass keywords to a procedure that does
;               not accept any keyword parameters. This is true even if the passed
;               _EXTRA parameter doesn't contain any entries at all (sic!)).
;               If necessary, add something like "dummy=for_extra" to your
;               procedure definition. Sorry for this inconvenience.
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
;           Cleanup_SuperClasses, self, "MyClass", _EXTRA=other_keywords
;
;          End
;            
; SEE ALSO: <A HREF="#INIT_SUPERCLASSES()">Init_SuperClasses()</A>
;
; MODIFICATION HISTORY:
;
;        $Log: cleanup_superclasses.pro,v $
;        Revision 1.4  2000/03/12 16:59:16  kupper
;        Added classname argument.
;        This was necessary to avoid infinite recursion when calling the init methods
;        recursively.
;
;        Revision 1.3  2000/02/21 19:34:23  kupper
;        Added comment on restriction due to _EXTRA mechanism.
;
;        Revision 1.2  2000/02/21 19:00:57  kupper
;        Corrected hyperlings.
;
;        Revision 1.1  2000/02/21 18:27:42  kupper
;        Why is the fucking IDL compiler not doing all this work???
;
;
;-

Pro Cleanup_Superclasses, self, classname, _REF_EXTRA=_ref_extra
   superclasses =  Obj_Class(classname, /SUPERCLASS, Count=count)
   if count eq 0 then return

   for i=0, n_elements(superclasses)-1 do $ 
       Call_Method,  superclasses[i]+"::CLEANUP", self, _EXTRA=_ref_extra
   
End
