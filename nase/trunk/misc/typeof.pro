;+
; NAME:                TYPEOF
;
; PURPOSE:             Ermittelt den Typ einer beliebigen Variable und gibt 
;                      NAME sowie INDEX zurueck. Folgende Zuordnung wird
;                      IDL-conform definiert:
;                           0 : UNDEFINED
;                           1 : BYTE
;                           2 : INT
;                           3 : LONG
;                           4 : FLOAT
;                           5 : DOUBLE
;                           6 : COMPLEX
;                           7 : STRING
;                           8 : STRUCT
;                           9 : DCOMPLEX 
;                          10 : POINTER
;                          11 : OBJECT
;
; CATEGORY:            MISC 
;
; CALLING SEQUENCE:    ti = TYPEOF(t [,INDEX=index])
;
; INPUTS:              t : eine beliebige Variable
;
; OUTPUTS:             ti: der Variablentyp als STRING, s.o.
;
; OPTIONAL OUTPUTS:    Index: der Variablentyp als Index 
;
; EXAMPLE:             a={a:1}
;                      print, typeof(a, index=b) & print, b
;                      ;STRUCT
;                      ;8
;
; SEE ALSO:            SIZE (IDL-Doku)
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 1.1  1998/11/17 11:25:17  saam
;           it was necessary
;
;
;-
FUNCTION TYPEOF, V, INDEX=index

   IF SET(V) THEN BEGIN   
      S = Size(V)
      Index = S(S(0)+1)
   END ELSE BEGIN
      Index = 0
   END
   
   DATATYPES = ['UNDEFINED','BYTE','INT','LONG','FLOAT', 'DOUBLE', 'COMPLEX', 'STRING', 'STRUCT', 'DCOMPLEX', 'POINTER', 'OBJECT']

   IF Index LT 0 OR Index GT 11 THEN Message, 'unknown type....this should not happen'
   NAME = DATATYPES(Index)
   RETURN, NAME

END
