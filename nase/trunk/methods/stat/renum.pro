;+
; NAME:
;  ReNum()
;
; VERSION:
;  $Id$
;
; AIM:
;  Allocates rank numbers for the elements of an array.
;
; PURPOSE:
;  This function assigns rank numbers in ascending order to the elements of an array <*>x</*> and returns them in a long
;  integer array of the same dimensional structure as <*>x</*>. In principle, this is also done by IDL's <*>Ranks</*>
;  function, <B>BUT</B> the latter requires an already sorted array <*>x</*>, and in the case of two or more identical
;  elements assigns to each of these the arithmetic mean of the corresponding successive rank numbers (such that the
;  ranks, e.g., could be 1-2-4.5-4.5-4.5-4.5-7-8-...). This routine, in contrast, has no "jumps" in the rank numbers
;  (i.e., the sequence would be 1-2-3-3-3-3-4-5-...) and also accepts unsorted arrays. On the other hand, the expression
;  <*>Sort(Sort(x))</*> also does something similar, but again not the same, because identical elements will be assigned
;  different ranks. The name suggests the main application of this routine, namely <I>re-numbering</I> of a sequence after
;  some elements have been removed.
;
; CATEGORY:
;  Array
;  Math
;  Statistics
;
; CALLING SEQUENCE:
;* r = ReNum(x)
;
; INPUTS:
;  x::  Any integer or float array whose elements are to be re-numbered (or assigned rank numbers).
;
; OUTPUTS:
;  r::  A long-integer array of the same dimensional structure as <*>x</*>, containing for each element of <*>x</*> the
;       corresponding rank number at the corresponding position within the array. The rank numbers start with 1. If you
;       prefer a different starting number n, just add (n-1) to the result.
;
; PROCEDURE:
;  Look in the source code. It's essentially 3 lines.
;
; EXAMPLE:
;* Print, ReNum([2,6,4,3,6,2,8,4,4])
;
;  IDL prints:
;
;* >           1           4           3           2           4           1           5           3           3
;
; SEE ALSO:
;  IDL routines: <*>Ranks</*>, <*>Sort</*>; NASE routine used by this routine: <A>Elements</A>.
;
;-



FUNCTION  ReNum, X


   ;----------------------------------------------------------------------------------------------------------------------
   ; Checking parameters for errors:
   ;----------------------------------------------------------------------------------------------------------------------

   On_Error, 2

   IF  NOT Set(X)  THEN  Console, '   Argument X not defined.', /fatal
   SizeX = Size(X)
   TypeX = Size(X, /type)
   NX    = N_Elements(X)
   IF  (TypeX GE 6) AND (TypeX LE 11)  THEN  Console, '  X is of wrong type.', /fatal

   ;----------------------------------------------------------------------------------------------------------------------
   ; The algorithm itself is quite simple:
   ;----------------------------------------------------------------------------------------------------------------------

   Rank = Make_Array(size = SizeX, /long, /nozero)

   ; The three lines referred to in the doc header:
   Y  = Elements(X)     ; all different elements occurring in X
   NY = N_Elements(Y)   ; the number of different elements of X
   FOR  i = 0L, NY-1  DO  Rank[Where(X EQ Y[i])] = i   ; the ranks are allocated one after the other

   Rank = Rank + 1      ; the ranks start with 1

   RETURN, Rank


END
