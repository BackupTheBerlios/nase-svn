;+
; NAME:
;  Spassmacher()
;
; VERSION:
;  $Id$
;
; AIM:
;  Reduce array to a sparse version.
;
; PURPOSE:
;  <C>Spassmacher</C> converts a numerical array into an array
;  that contains information about position and value of entries NE 0
;  in the original array, i.e. a sparse version of the original array
;  is created.<BR>
;  Advantages of sparse representaion are:<BR>
;  + less memory needed if only few elements are active (NE 0).<BR>
;  + routines that only work on active elements do not need to search
;  for them in advance.<BR>
;  Disadvantage:<BR>
;  - larger memory consumption for many active elements.<BR>
;  The inverse transformation from a sparse to a conventional array is
;  done by <A>Spassbeiseite</A>. For binary arrays, there is a special
;  conversion routine called <A>SSpassmacher</A>.
;
; CATEGORY:
;  Array
;  DataStorage
;  DataStructures
;  NASE
;  Simulation
;
; CALLING SEQUENCE:
;* sparse = Spassmacher(array [,TYPE=...][,/DIMENSIONS])
;
; INPUTS:
;  array:: An array of numerical type.
;
; INPUT KEYWORDS:
;  TYPE:: Type code of generated sparse array. For type code see IDL
;         help of the <*>Size()</*> command. It is necessary to choose
;         a type that can save both indices and values at the same
;         time, otherwise information is lost. When converting very
;         large arrays, note also that precision of floating point
;         numbers may not be large enough to save indices
;         precisely. In this case, longword integer (type 3) may do
;         better. Default: 4 (float).
;
;  /DIMENSIONS:: Set this keyword to save information about the
;                original array dimensions at the end of the sparse
;                array. This can be used to reconstruct the original
;                array from its sparse version, e.g. when displayed
;                with <A>Trainspotting</A>. The format is:<BR>
;                <*>sparse(0,sparse(0,0)+1)</*>: dimension<BR>
;                <*>sparse(0,sparse(0,0)+1+i)</*>: ith dimension<BR>
;                <*>sparse(1,sparse(0,0)+i)</*>: unused, but NE 0, since
;                                         sparse arrays are generated
;                                         with the <*>/NOZERO</*> option.
;
; OUTPUTS:
;  sparse:: Twodimensional array of the desired type. <*>sparse</*> is
;           organized as follows:<BR>
;           <*>sparse(0,0)</*>: Number of elements NE 0 in <*>array</*>.<BR>
;           <*>sparse(1,0)</*>: Total number of elements in <*>array</*>.<BR>
;           <*>sparse(0,i)</*> with <*>i >0</*>: Indices of active elements.<BR>
;           <*>sparse(1,i)</*> with <*>i >0</*>: Values corresponding
;                                               to the indices
;                                               <*>sparse(0,i)</*>. 
;
; PROCEDURE:
;  Search for elements NE 0 and remember their indices.
;
; EXAMPLE:
;* IDL/NASE> a=findgen(2,2)
;* IDL/NASE> print, spassmacher(a)
;*      3.00000      4.00000
;*      1.00000      1.00000
;*      2.00000      2.00000
;*      3.00000      3.00000
;* IDL/NASE> print, spassmacher(a, /DIM)
;*      3.00000      4.00000
;*      1.00000      1.00000
;*      2.00000      2.00000
;*      3.00000      3.00000
;*      2.00000      5.94770
;*      2.00000  5.60519e-45
;*      2.00000 -0.000789642
;
; SEE ALSO:
;  <A>Spassbeiseite</A>, <A>SSpassmacher</A>, <A>SSpassbeiseite</A>. 
;-



FUNCTION Spassmacher, a, DIMENSIONS=dimensions, TYPE=type

   Default, dimensions, 0
   Default, type, 4

   s = Size(a)
   d = s(0) ; the number of dimensions of a

   actindex = WHERE(a NE 0, count)

   IF Keyword_Set(DIMENSIONS) THEN BEGIN
      ; make longer array with space for size information at the end
      sparse = Make_Array(2, count+d+2, TYPE=type, /NOZERO)
      ; store size info at end of sparse array
      sparse(0,count+1:count+d+1) = s(0:d)
   ENDIF ELSE BEGIN
      ; conventional sparse array
      sparse = Make_Array(2, count+1, TYPE=type, /NOZERO)
   ENDELSE

   sparse(0,0) = count ; active elements
   sparse(1,0) = s(d+2) ; get total number of elements from Size

   IF count NE 0 THEN BEGIN
      sparse(0,1:count) = actindex
      sparse(1,1:count) = a(actindex)
   END
  
   
   ;; Ignore any floating underflows:
   IgnoreUnderflows

   RETURN, sparse


END
