;+
; NAME:
;   class vector
;
; AIM: provide a vector datatype, as known from C++
;
; PURPOSE: provide a vector datatype, as known from C++. This class
;          supercedes and obsoletes the old pool allocator array
;          datatype (see <A>PAAinit()</A>). In particular, this class
;          comes with built-in memory management that makes the append
;          operation cheap.
;
; CATEGORY: 
;  DataStructures
;
; CONSTRUCTION: 
;*  o = Obj_New("vector"
;*              [, (TYPE=...
;*                  | /BYTE | /COMPLEX | /DCOMPLEX | /DOUBLE
;*                  | /FLOAT | /INTEGER | /L64 | /LONG | /OBJ | /PTR
;*                  | /STRING | /UINT | /UL64 | /ULONG
;*                  STRUCT={...}) ]
;*              [,POOLSIZE=...]
;*              [,INCREMENTFACTOR=...]
;
; DESTRUCTION:
;*  Obj_Destroy, o
;                                               
; INPUT KEYWORDS:
;  TYPE     :: Typecode of contained elements. Passed to IDL's
;              <C>MAKE_ARRAY</C> command. Defaults and precedence, see
;              IDL's <C>MAKE_ARRAY</C> command.
;              Exception: typecode 8 (structure) is not handled by
;                         <C>MAKE_ARRAY</C> (why, the hell, why, why,
;                         why, why?). We handle it by our own allocate
;                         routine. If <C>TYPE=8</C> is set,
;                         <C>STRUCT</C> muﬂt be set to a structure template.
;  /typename:: Typename of contained elements. Passed to IDL's
;              <C>MAKE_ARRAY</C> command. Defaults and precedence, see
;              IDL's <C>MAKE_ARRAY</C> command. Exeption see above.
;  STRUCT={...}:: Set <C>STRUCT</C> to a structure template to create
;                 a vector of structures. You may, but need not, set
;                 <C>TYPE=8</C>, too.
;  POOLSIZE :: The vector reserves memory in chunks of POOLSIZE
;              elements. Upon creation of the vector, memory for
;              POOLSIZE elements is reserved. Default: 10.
;  INCREMENTFACTOR :: Each time new memory is reserved when adding new
;                     elements, POOLSIZE is multiplied by this factor.
;                     Default: 2.0.
;
; SIDE EFFECTS: 
;  Upon creation of the vector, memory for POOLSIZE elements is
;  reserved. (Default 10).
;
; RESTRICTIONS:
;  Take the usual care when pushing structures. Pushed structures are
;  mapped by brute force to the stored template, so if structure tags
;  do not match, IDL raises no error. This is "normal" IDL behaviour.
;  Blame RSI for this "feature". It's bound to spawn errors.
;
; METHODS:
;  public:
;   
;   size()             :: return number of elements in vector.
;   type()             :: return typecode of elements in vector.
;   data()             :: return whole vector as an array.
;
;   reserve, n         :: reserve memory for n elements. If the request
;                         is already fulfilled, a warning is issued.
;
;   get(i)             :: return element with index i (starts with 0)
;   push, x            :: push element x at end of vector. x needs to
;                         match the correct type.
;   push_many, [x,...] :: push an array of elements at end of vector.
;                         Elements need to match the correct type.
;   append, vector     :: appends another vector to the end of this
;                         vector. The vectors need to be of matching type.
;
; PROCEDURE: 
;   Data is reserved as a pointer to an array. Implementation is
;   straightforward.
;
; EXAMPLE: 
;
; SEE ALSO:
; <A>PAAinit()</A> (obsolete)
;-


;; ------------ Static member definition -------------------
Pro vector__init_static
   COMPILE_OPT IDL2, HIDDEN
   ;; This member function is called from vector__DEFINE. However, we
   ;; need it to be the /first/ procedure in the file, because it defines
   ;; the common-block th other member functions will refer to.
   ;; vector__DEFINE on the other hand needs to be the /last/
   ;; procedure in the file. For this great IDL design, we need this
   ;; special function...

   Common vector_static, MyStaticMember, MyOtherStaticMember

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
Function vector::init, POOLSIZE=poolsize, $
                       INCREMENTFACTOR=incrementfactor, $
                       _REF_EXTRA=_ref_extra; keywords passed to allocate_()

   COMPILE_OPT IDL2
   Common vector_static
   DMsg, "I am created."

   Default, POOLSIZE, 10
   Default, INCREMENTFACTOR, 2.0

   ;; Try to initialize the superclass-portion of the
   ;; object. If it fails, exit returning false.
   ;; Note that here any keyword options to the superclass can be
   ;; passed.
;   If not Init_Superclasses(self, "vector", _EXTRA=_ref_extra) then return, 0

   ;; Try whatever initialization is needed for a vector object,
   ;; IN ADDITION to the initialization of the superclasses:
   ;;
   self.data = self->allocate_(POOLSIZE, _STRICT_EXTRA=_ref_extra)
   self.type = size(/type, (*self.data))
   self.size = 0
   self.poolsize = POOLSIZE
   self.reserved = POOLSIZE
   self.incrementfactor = INCREMENTFACTOR
   
   ;; If we reach this point, initialization of the
   ;; whole object succeeded, and we can return true:
   
   return, 1                    ;TRUE
End

Pro vector::cleanup;, KEYWORD = keyword, _REF_EXTRA = _ref_extra
   COMPILE_OPT IDL2
   Common vector_static
   DMsg, "I'm dying!"

   ;; Cleanup the superclass-portion of the object:
;   Cleanup_Superclasses, self, "vector", _EXTRA=_ref_extra

   ;; Now do what is needed to cleanup a vector object:
   ;;
   ptr_free, self.data
End

;Pro vector::reset
;   COMPILE_OPT IDL2
;   Common vector_static
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

Function vector::size
   COMPILE_OPT IDL2
   Common vector_static

   return, self.size
End

Function vector::type
   COMPILE_OPT IDL2
   Common vector_static

   return, self.type
End

Function vector::data
   COMPILE_OPT IDL2
   Common vector_static

   If self.size eq 0 then return, !NONE
   return, (*self.data)[0:self.size-1]
End

;;
;; Other public methods:
Pro vector::reserve, nelements
   COMPILE_OPT IDL2
   Common vector_static

   If self.size gt nelements then begin
      Console, /Warning, "Vector data is already bigger " + $
               "than requested reservation. Skipping request."
      return
   EndIf
   If self.reserved eq nelements then begin
      Console, /Debug, "Requested reservation is already " + $
               "fulfilled. Skipping request."
      return
   EndIf
   
   If self.reserved gt nelements then $
     Dmsg, "Shrinking reserved memory to " + str(nelements)+" elements." $
   else $
     Dmsg, "Extending reserved memory to " + str(nelements)+" elements."
   
   If self.type eq 8 then begin
      ;; struct
      newdata = self->allocate_(nelements, Type=self.type, STRUCT=(*self.data)[0])
   endif else begin
      ;; all other types
      newdata = self->allocate_(nelements, Type=self.type)
   endelse
   
   If self.size ne 0 then (*newdata)[0:self.size-1] = (*self.data)[0:self.size-1]
   ptr_free, self.data
   self.data = newdata
   
   self.size = nelements
   self.reserved = nelements
End

Function vector::get, i
   COMPILE_OPT IDL2
   Common vector_static

   assert, i lt self.size
   return, (*self.data)[i]
End

Pro vector::push, a
   COMPILE_OPT IDL2
   Common vector_static

   assert, size(a, /Type) eq self.type
   newsize = self.size+1
   If newsize gt self.reserved then begin
      self->reserve, self.reserved+self.poolsize
      self.poolsize = self.poolsize*self.incrementfactor
   EndIf
      
   (*self.data)[newsize-1] = temporary(a)
   self.size = newsize
End

Pro vector::push_many, a2
   COMPILE_OPT IDL2
   Common vector_static

   assert, size(a2, /Type) eq self.type
   a2size = N_Elements(a2)
   newsize = self.size+a2size
   If newsize gt self.reserved then begin
      reserve = self.reserved
      repeat begin
         reserve = reserve+self.poolsize
         self.poolsize = self.poolsize*self.incrementfactor
      endrep until reserve ge newsize
      self->reserve, reserve
   EndIf
      
   (*self.data)[self.size:newsize-1] = temporary(a2)
   self.size = newsize
End

Pro vector::append, vector2
   COMPILE_OPT IDL2
   Common vector_static

   assert, vector2->type() eq self.type
   self->push_many, vector2->data()
End




;; ------------ Protected ------------------


;; ------------ Private --------------------
;Pro vector::override_me_; -ABSTRACT-
;   COMPILE_OPT IDL2
;   Common vector_static
;   ;; use this template for all abstract methods.
;   On_error, 2
;   Console, /Fatal, "This abstract method was not overridden in derived class '"+Obj_Class(self)+"'!"
;End

Function vector::allocate_, n_elements, $
                            TYPE=type, $
                            STRUCT=struct, $
                            BYTE=byte, COMPLEX=complex, DCOMPLEX=dcomplex, DOUBLE=double, $
                            FLOAT=float, INTEGER=integer, L64=l64, LONG=long, OBJ=obj, PTR=ptr, $
                            STRING=string, UINT=uint, UL64=ul64, ULONG=ulong
   COMPILE_OPT IDL2
   Common vector_static
   
   default, type, 0

   ;; consistency checks:

   ;; type 8 needs STRUCT defined:
   if (TYPE eq 8) then $
     assert, keyword_set(STRUCT), "specify structure template for array of structures"

   ;; assert that STRUCT is a structure
   if keyword_set(STRUCT) then $
     assert, size(/Type, STRUCT) eq 8, "argument STRUCT is not a structure"

   ;; end consistency checks

   if keyword_set(STRUCT) then begin
      ;; array of structs
      p = ptr_new(/no_copy, replicate(STRUCT, n_elements))
   endif else begin
      ;; array of all other types
      p = ptr_new(/no_copy, $
                  Make_Array(n_elements, /Nozero, $
                             TYPE=type, $
                             BYTE=byte, COMPLEX=complex, DCOMPLEX=dcomplex, DOUBLE=double, $
                             FLOAT=float, INTEGER=integer, L64=l64, LONG=long, OBJ=obj, PTR=ptr, $
                             STRING=string, UINT=uint, UL64=ul64, ULONG=ulong $
                            ))
   endelse

   return, p
End


;; ------------ Object definition ---------------------------
Pro vector__DEFINE
   COMPILE_OPT IDL2
   Common vector_static

   ;; initialization of static members:
   vector__init_static

   ;; class definition
   dummy = {vector, $
            $
            data: ptr_new(), $; will hold pointer to array
            type: 0l, $
            size: 0ul, $
            poolsize: 0ul, $
            reserved: 0ul, $
            incrementfactor: 0.0 $
           }
End
