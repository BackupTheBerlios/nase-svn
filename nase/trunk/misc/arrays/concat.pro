;+
; NAME:
;  concat
;
; VERSION:
;  $Id$
;
; AIM:
;  concatenation of arrays 
;
; PURPOSE:
;  concatenation of arrays 
;
; CATEGORY:
;  Array
;
; CALLING SEQUENCE:
;*result=concat( A, B [, INDEX][,extend=extend][,add=add][, overwrite=overwrite] )
;
;
; INPUTS:
;                     A::  n-dimensional array (or empty, s. example 3)
;                     B::  n-dimensional array
;  
;
; OPTIONAL INPUTS:
;                     INDEX:: the index of the array over which A and B 
;                            should be concatenated (default 0).   
;                            The dimension indices of A and B must have 
;                            the same range except the choosen index.
;                            Index equal 0 is the fastest method.
;
; INPUT KEYWORDS:
;
;                     EXTEND:: concatenation of A and B over an
;                             additional index at the position of INDEX.
;                             The dimensions of A and B must have the
;                             same range. 
;
;                     OVERWRITE:: if the contents of A and B are
;                                rejected, this keyword should be 
;                                used for faster computations.;  
;
; OUTPUTS:
;                     result:: 
;                               an array with the concatenation of A and B;  
;
; SIDE EFFECTS:
;                     if keyword OVERWRITE is choosen, the dimensions
;                     of A and B could be changed.
;                     
;
;
; EXAMPLE:
;*                     1.Example:
;*                                a=indgen(10,20,30)
;*                                b=indgen(10,40,30)
;*                                ;concatenation of a and b over index 1
;*                                c=concat(a,b,1)
;*                                help,c
;*                                ;idl results ----
;*                                ;C  INT = Array[10, 60, 30]
;*
;*                     2.Example:
;*                                a=indgen(10,20,30)
;*                                b=indgen(10,20,30)
;*                                ;concatenation of a and b over an
;*                                ;additional index at position 1
;*                                c=concat(a,b,1,/extend)
;*                                help,c
;*                                ;idl results ----
;*                                ;C  INT = Array[10, 2, 20, 30]
;*                                ;now concatenate c and a at index 1
;*                                d=concat(c,a,1)
;*                                help,d
;*                                ;idl results ----
;*                                D   INT = Array[10, 3, 20, 30] ; 
;*                     3.Example:
;*                                
;*                                ;; first undef accumulation array
;*                                undef,c
;*                                for i=0,9 do begin
;*                                     ;;generate random vars       
;*                                     a=randomn(s,20,30,40)
;*                                     c=concat(c,a,/extend)
;*                                endfor
;*                                help,c
;*                                ;idl results ----
;*                                D  INT = Array[10,20, 30, 40] ; 
;*
;-

function concat,A, B, index, extend=extend, overwrite=overwrite

On_ERROR, 2

default, index, 0
default, extend, 0
default, add, 0
default, overwrite , 0
over_a = overwrite
over_b = overwrite
__extend = extend

;;if not set(a) and __extend ge 1 then begin
if not set(a) then begin
   s_a = size(b)
   if ( index GE s_a(0) and __extend eq 0 ) OR  ( index GT (s_a(0)+1) and __extend eq 1 )  then $
    Console, 'array/index dimension missmatch', /FATAL
   ;;set extend dimension index at right position
   if __extend eq 1 then begin
      dim = shift([1, shift( s_a(1:s_a(0)), -index)], index)
      return, reform(b, dim, overwrite=overwrite )
   end else return,b
end

s_a = size(a)
s_b = size(b)

if ( index GE s_a(0) and __extend eq 0 ) OR  ( index GT s_a(0) and __extend eq 1 )  then $
 Console, 'Array dimension missmatch', /FATAL

if (s_b(0) +1) EQ s_a(0) then begin 
   add = 1 
   __extend = 0
endif

s_na = s_a(1:s_a(0))
s_nb = s_b(1:s_b(0))

if __extend ge 1 then begin
      s_na = shift([1, shift( s_a(1:s_a(0)), -index)], index)
      s_nb = shift([1, shift( s_b(1:s_b(0)), -index)], index)
      s_a = [ s_a(0)+1, s_na, s_a(s_a(0)+1), s_a(s_a(0)+2) ]
      s_b = [ s_b(0)+1, s_nb, s_b(s_b(0)+1), s_b(s_b(0)+2) ]
endif
 
if add ge 1 then begin
   s_nb = shift([1, shift( s_b(1:s_b(0)), -index)], index)
   s_b = [ s_b(0)+1, s_nb, s_b(s_b(0)+1), s_b(s_b(0)+2) ]
   __extend = 1
   over_a = 1
endif

if s_a(0) ne s_b(0) then $
 Console, 'array dimension missmatch', /FATAL

shift_index = reverse(shift(lindgen(s_a(0)), s_a(0) - (index+1) ))

back_index = shift_index
for i=0l,  s_a(0)-1 do begin
ind = where(i eq shift_index)
back_index(i) = ind(0) 
endfor

if s_a(0) GE 2 THEN $
 if total(((s_a(1:s_a(0)))(shift_index))(1:s_a(0)-1)   $
          EQ ((s_b(1:s_b(0)))(shift_index))(1:s_b(0)-1) ) NE (s_a(0)-1) then $
 Console, 'array dimension missmatch', /FATAL

if __extend eq 1 then begin
   if index NE 0 then begin
      return,  utranspose([utranspose(reform(a,s_na, overwrite=over_a),shift_index),$
                           utranspose(reform(b,s_nb, overwrite=over_b),shift_index)],$
                          back_index)  
   end else  return, [ reform(a,s_na, overwrite=over_a), reform(b,s_nb, overwrite=over_b) ]  
end else begin
   if index NE 0 then begin
      return,  utranspose([utranspose(a, shift_index),utranspose(b,shift_index)], back_index)  
   end else return, [ a, b ]  
end
;;never happens
end
