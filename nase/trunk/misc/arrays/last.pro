;+
; NAME: LAST
;
; VERSION: $Id$
; 
; AIM: returns last (or N-i) element(s) of an array or a specified array dimension
;
; PURPOSE:               This function results the last element(s) of an array.
;
;
; CATEGORY: ARRAY
;
;
; CALLING SEQUENCE:      
;*                    result = last(A, [index][,POS=POS])
;
; 
; INPUTS:
;                        A:: An array
;
; OPTIONAL INPUTS:
;                        index:: dimension of array A   from which to extract the last element(s) 
;	
; KEYWORD INPUTS:
;                        pos::   relative position from the last
;                                element of the array (default 0),
;                                array of pos also possible. Pos
;                                should be negative or zero.    
; OUTPUTS:
;                        result:: last (or last-pos) element(s) of array A at the dimesion called by index  
;
; EXAMPLE:                
;*                        a = indgen(10)
;*                        print,a(0),last(a)
;*                        ;IDL prints:
;*                        ;  0       9 
;*                        ;take the n-1 element of a      
;*                        print,a(0),last(a,pos=-1)
;*                        ;IDL prints:
;*                        ;  0       8 
;
;
; MODIFICATION HISTORY:
;
;
;     $Log$
;     Revision 1.4  2000/11/02 18:10:20  gabriel
;          relative position like N-1, N-2 etc. implemented
;
;     Revision 1.3  2000/09/25 09:12:55  saam
;     * added AIM tag
;     * update header for some files
;     * fixed some hyperlinks
;
;     Revision 1.2  1999/03/12 14:43:01  gabriel
;          Error bei index EQ 1 entfernt
;
;     Revision 1.1  1998/08/11 12:32:08  gabriel
;           Neue praktische Array Routine
;
;
;-

FUNCTION last , A , index, pos=pos
   default,index , 1
   default, pos, 0
 
   S = size(A)
   if total(pos GT 0) GT 0 then  Console, 'pos should be zero or negativ', /fatal
   if (s(index) + min(pos) -1) LT 0 or (s(index) + min(pos) -1) GT s(index)-1  then  Console, 'pos too large for array', /fatal
   IF index GT S(0) THEN Console, 'index too large for array', /fatal
   IF S(0) EQ 1 THEN return, A(S(index)-1+pos)

   CASE 1 EQ 1 OF
      index EQ 1 : return, A(S(index)-1+pos,*,*,*,*,*,*)
      index EQ 2 : return, A(*,S(index)-1+pos,*,*,*,*,*)
      index EQ 3 : return, A(*,*,S(index)-1+pos,*,*,*,*)
      index EQ 4 : return, A(*,*,*,S(index)-1+pos,*,*,*)
      index EQ 5 : return, A(*,*,*,*,S(index)-1+pos,*,*)
      index EQ 6 : return, A(*,*,*,*,*,S(index)-1+pos,*)
      index EQ 7 : return, A(*,*,*,*,*,*,S(index)-1+pos)
   ENDCASE
END 
