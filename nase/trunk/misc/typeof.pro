;+
; NAME:
;  TypeOf()
;
; AIM:
;  returns the type of an arbitrary variable
;
; PURPOSE:
;  returns the type of an arbitrary variable and returns a STRING as
;  well the INDEX. Following IDL conform strings are returned
;* 0 : UNDEFINED
;* 1 : BYTE
;* 2 : INT
;* 3 : LONG
;* 4 : FLOAT
;* 5 : DOUBLE
;* 6 : COMPLEX
;* 7 : STRING
;* 8 : STRUCT
;* 9 : DCOMPLEX 
;* 10 : POINTER
;* 11 : OBJECT
;* 12 : UINT
;* 13 : ULONG
;* 14 : LONG64 
;
; CATEGORY:
;  DataStructures
;  Help
;
; CALLING SEQUENCE:
;* ti = TypeOf(t [,INDEX=...])
;
; INPUTS:
;  t :: arbitrary variable
;
; OUTPUTS:
;  ti:: variable type as string (see above)
;
; OPTIONAL OUTPUTS:
;  INDEX:: if set, the corresponding index will be returned (see above)
;
; EXAMPLE:
;* a={a:1}
;* print, typeof(a, index=b) & print, b
;* >STRUCT
;* >8
;
; SEE ALSO:
;  <C>SIZE</C> (IDL-Doku)
;
;-
FUNCTION TYPEOF, V, INDEX=index

   IF SET(V) THEN BEGIN   
      S = Size(V)
      Index = S(S(0)+1)
   END ELSE BEGIN
      Index = 0
   END
   
   DATATYPES = ['UNDEFINED','BYTE','INT','LONG','FLOAT', 'DOUBLE', 'COMPLEX', 'STRING', 'STRUCT', 'DCOMPLEX', 'POINTER', 'OBJECT', 'UINT', 'ULONG', 'LONG64']

   IF Index LT 0 OR Index GT 14 THEN Message, 'unknown type....this should not happen'
   NAME = DATATYPES(Index)
   RETURN, NAME

END
