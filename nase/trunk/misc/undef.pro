;+
; NAME:               UNDEF
;
; PURPOSE:            Loescht eine Variable. Der von der Variable benutzte Speicher
;                     wird freigegeben und die Variable ist undefiniert.
;    
; CATEGORY:           MISC
;
; CALLING SEQUENCE:   UNDEF, x
;
; INPUTS:             x : eine zu loechende Variable
;
; PROCEDURE:          transferiert die Variable via /NO_COPY in einen
;                     Handle und gibt diesen dann frei
;
; EXAMPLE:            IDL> x =827637
;                     IDL> undef, x
;                     IDL> help, x
;                     X               UNDEFINED = <Undefined> 
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 1.1  1998/08/14 11:12:56  saam
;           thanks to Ruediger for the idea
;
;
;-
PRO UNDEF, var

   IF Set(var) THEN BEGIN
      tmp = Handle_Create(!MH, VALUE=var, /NO_COPY)
      Handle_Free, tmp
   END

END
