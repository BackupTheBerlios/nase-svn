;+
; NAME: LAST
;
;
; PURPOSE:               This function results the last element(s) of an array.
;
;
; CATEGORY: ARRAY
;
;
; CALLING SEQUENCE:      result = last(A, [index])
;
; 
; INPUTS:
;                        A: An array
;
; OPTIONAL INPUTS:
;                        index: dimension of array A   from which to extract the last element(s) 
;	
; OUTPUTS:
;                        result: last element(s) of array A at the dimesion called by index  
;
; EXAMPLE:                
;                        a = indgen(10)
;                        print,a(0),last(a)
;                        ;IDL prints:
;                        ;  0       9   
;
;
; MODIFICATION HISTORY:
;
;
;     $Log$
;     Revision 1.2  1999/03/12 14:43:01  gabriel
;          Error bei index EQ 1 entfernt
;
;     Revision 1.1  1998/08/11 12:32:08  gabriel
;           Neue praktische Array Routine
;
;
;-

FUNCTION last , A , index
   default,index , 1
   S = size(A)
  
   IF index GT S(0) THEN Message, 'index too large for array'
   IF S(0) EQ 1 THEN return, A(S(index)-1)
   CASE 1 EQ 1 OF
      index EQ 1 : return, A(S(index)-1,*,*,*,*,*,*)
      index EQ 2 : return, A(*,S(index)-1,*,*,*,*,*)
      index EQ 3 : return, A(*,*,S(index)-1,*,*,*,*)
      index EQ 4 : return, A(*,*,*,S(index)-1,*,*,*)
      index EQ 5 : return, A(*,*,*,*,S(index)-1,*,*)
      index EQ 6 : return, A(*,*,*,*,*,S(index)-1,*)
      index EQ 7 : return, A(*,*,*,*,*,*,S(index)-1)
   ENDCASE
END 
