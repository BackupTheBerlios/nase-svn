;+
; NAME:
;   Undef
;
; VERSION:
;   $Id$
;
; AIM:
;   erases an IDL variable
;
; PURPOSE:
;   Erases an arbitrary variable. If The variable is a handle, the
;   dynamic memory is also erased. After the call of <C>Undef</C>,
;   the variable is undefined. IDL provides a procedure called
;   <C>DelVar</C> that also delete variables, but it is restricted
;   to the main program level.
;    
; CATEGORY:
;  DataStorage
;  DataStructures
;  Structures
;
; CALLING SEQUENCE:
;* Undef, x
;
; INPUTS:
;* x :: variable to be deleted
;
; PROCEDURE:
;   transfers variable via <C>/NO_COPY</C> to a handle
;   and frees it
;
; EXAMPLE:
;* x =827637
;* undef, x
;* help, x
;* >X               UNDEFINED = <Undefined> 
;
;-
PRO UNDEF, var

   IF Set(var) THEN BEGIN
      tmp = Handle_Create(!MH, VALUE=var, /NO_COPY)
      Handle_Free, tmp
   END

END
