;+
; NAME:
;       Init_SuperClasses()
;
; PURPOSE: Well-behaved initialization of an object's superclasses.
;            When deriving a new class from one or more superclasses, the user
;          is responsible for explicitely calling the INIT methods of all
;          superclasses.
;          This is more complicated than it may sound, as any of the
;          initialization cycles may fail. If so, it is essential to re-destroy
;          the already initialized parts of the object. Otherwise, memory
;          leakage is likely to occur.
;
;          Init_SuperClasses() calls the INIT methods of an object's
;          direct superclasses. It tracks their results and cares for proper
;          cleanup if any of it fails.
;
; CATEGORY: Objects
;
; CALLING SEQUENCE: success = Init_SuperClasses(self, classname, _EXTRA=_extra)
;
; INPUTS: self     : A reference to the object to initialize. This is always
;                    "self".
;         classname: A string containing the classname of the object to
;                    initialize.
;                    CAUTION: do NOT refer to this as OBJ_CLASS(self), as this
;                             will cause infinite recursion. Do always specify
;                             the classname as a string constant.
;
; KEYWORD PARAMETERS: Any keyword parameters are passed to the superclasses'
;                     INIT methods through _REF_EXTRA.
;                       See also RESTRICTIONS below.
;
; OUTPUTS: success: 1 (true), if initialization of all direct superclasses
;          succeeded, 0 (false) otherwise.
;
; RESTRICTIONS: This function is designed to be called from an
;               object's INIT method only.
;                 Note that only keyword parameters, not positional parameters
;               can be passed. Note also, that _REF_EXTRA is used for passing. 
;               Hence, the INIT methods of all direct superclasses should have
;               unique keywords. Otherwise, the keyword is passed to all INIT
;               methods it matches.
;                 Note that all INIT methods must accept at least one keyword
;               parameter for the _EXTRA-mechanism to work. (IDL issues an
;               error, if it is tried to pass keywords to a procedure that does
;               not accept any keyword parameters. This is true even if the passed
;               _EXTRA parameter doesn't contain any entries at all (sic!)).
;               If necessary, add something like "dummy=for_extra" to your
;               function definition. Sorry for this inconvenience.
;
; PROCEDURE: o Query superclasses using OBJ_CLASS(/SUPERCLASS)
;            o Call INIT methods using CALL_METHOD()
;            o Cleanup if necessary
;
;
; EXAMPLE: May Class "MyClass" inherit from "Class_A" and "Class_B".
;          It's INIT method should look somewhat like the following:
;
;          Function MyClass::INIT, MY_KEYWORD=m, _REF_EXTRA=other_keywords
;
;           ; Try to initialize the superclass-portion of the
;           ; object. If it fails, exit returning false:
;           If not Init_Superclasses(self, "MyClass", _EXTRA=other_keywords) then return, 0
;
;           ; Try whatever initialization is needed for a MyClass object,
;           ; IN ADDITION to the initialization of the superclasses:
;           [...]
;
;           ; If this initialization failed, cleanup whatever
;           ; necessary after this fail, then cleanup the
;           ; superclass-portion again, then exit returning false:
;           If not success then begin
;             [...]
;             <A HREF="#CLEANUP_SUPERCLASSES">Cleanup_SuperClasses</A>, self, "MyClass", KEYWORD1=k1, ...
;             return, 0
;           EndIf
;
;           ; If we reach this point, initialization of the
;           ; whole object succeeded, and we can return true:
;           return, 1
;
;          End
;            
; SEE ALSO:  <A HREF="#CLEANUP_SUPERCLASSES">Cleanup_SuperClasses</A>
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 1.4  2000/03/12 16:59:16  kupper
;        Added classname argument.
;        This was necessary to avoid infinite recursion when calling the init methods
;        recursively.
;
;        Revision 1.3  2000/02/21 19:34:23  kupper
;        Added comment on restriction due to _EXTRA mechanism.
;
;        Revision 1.2  2000/02/21 18:58:50  kupper
;        Oops! My example was wrong... sorry.
;
;        Revision 1.1  2000/02/21 18:10:18  kupper
;        Why is the fucking IDL compiler not doing all this work???
;
;-

Function Init_Superclasses, self, classname, _REF_EXTRA=_ref_extra
   superclasses =  Obj_Class(classname, /SUPERCLASS)
   success = 1

   i = 0
   while success and (i lt n_elements(superclasses)) do begin
      success = success and $
       Call_Method(superclasses[i]+"::INIT", self, _EXTRA=_ref_extra)
      i = i+1
   endwhile
   
   if not success then begin
      fail = i-1                ;Initialization of superclass i-1 failed:
      message, /info, "Initialization of object's " + superclasses[fail]+" " + $
       "part failed. Cleaning up."
      If fail ne 0 then $       ;at least one INIT was successful:
       for j=fail-1, 0 do Call_Method, superclasses[j]+"::CLEANUP", self
   endif

   return, success
End
