;+
; NAME:
;   InSet()
;
; AIM:
;   checks if an element is part of a set (array)
;
; PURPOSE:
;   Check wether the first argument (element) is contained in the second (set).<BR>
;   This is a modification of IDLs' <*>EQ</*> where the first argument is a scalar
;   and the second an array. In contrast to <*>EQ</*> here only a TRUE or FALSE (1B or 0B)
;   will be returned instead of an array of the size of the input array.<BR>
;   The first argument has neccessarily to be a scalar.
;   In contradiction to the concept of a set the second argument can
;   be an array containing multiple entries of the same value.
;   This function is obsolete as it is a special case of the newer function <A>SubSet</A>.
;
; CATEGORY:
;   Array
;   Math
;
; CALLING SEQUENCE:
;*   yn = InSet(I,S)
;
; INPUTS:
;   I:: the element to be searched for (any type, scalar)
;   S:: the set (array) of to be searched through (any type, any dimension)
;
; OUTPUTS:
;   yn:: TRUE(=1B), if I is element of S; FALSE(=0B), else.
;
; RESTRICTIONS:
;  If one argument is of type string, then the other has to be as well.
;
; EXAMPLE:
;*     IF InSet(1,[4,65,7,3,7,4]) THEN print, 'YUPP' ELSE print, 'NOPE'
;*     >NOPE
;*     IF InSet(7,[4,65,7,3,7,4]) THEN print, 'YUPP' ELSE print, 'NOPE'
;*     >YUPP
;
; SEE ALSO:
;  <*>EQ</*>, <A>Equal</A>, <A>SubSet</A>, <A>CutSet</A>, <A>UniSet</A>, <A>DiffSet</A>
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 1.5  2000/12/20 15:11:04  gail
;     * result restricted to byte 1B or 0B (no more float)
;     * 'message' calls replaced by 'console'
;     * updated header
;
;     Revision 1.4  2000/09/25 09:12:55  saam
;     * added AIM tag
;     * update header for some files
;     * fixed some hyperlinks
;
;     Revision 1.3  1999/09/22 12:41:28  kupper
;     Changed algorithm from a loop (uargh!) to an array-operation.
;
;     Revision 1.2  1999/02/05 19:14:10  saam
;           + return if an error occurs
;
;     Revision 1.1  1998/06/23 19:15:44  saam
;           scarcely worth to talk of
;
;
;-

FUNCTION InSet, I, S

   On_Error, 2

   IF NOT Set(S) THEN Console, 'invalid second argument', /FATAL

   NI = N_Elements(I)
   IF NI NE 1 THEN Console, 'first argument has to be scalar or a one-element-array', /FATAL

   Return, Total( I(0) EQ S ) NE 0

END
