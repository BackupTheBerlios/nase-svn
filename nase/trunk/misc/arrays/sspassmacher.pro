;+
; NAME:
;  SSpassmacher()
;
; VERSION:
;  $Id$
;
; AIM:
;  Reduce binary array to sparse version.
;
; PURPOSE:
;  <C>SSpassmacher</C> converts an array containing 0s and 1s
;  (e.g. spiketrains) into a sparse version that saves indices of
;  elements that are NE 0.<BR>
;  Advantages:<BR>
;  + Lower memory consumption in case of few elements
;                being 1.<BR>
;  + Routines working with active elements dont have to
;                extract them if they are already provided by a
;                sparse array.<BR>
;  Disadvantage:<BR>
;   - Large memory consumption for many elements being 1.<BR>
;  The reverse operation may be executed by <A>SSpassbeiseite()</A>.
;
; CATEGORY:
;  Array
;  DataStructures
;
; CALLING SEQUENCE:
;* ssparse = SSpassmacher( array [/DIMENSIONS] )
;
; INPUTS:
;  array:: A binary array.
;
; INPUT KEYWORDS:
;  /DIMENSIONS:: Saves dimensions of array at the end of
;                <*>ssparse</*> to enable later reconstruction. 
;
; OUTPUTS:
;  ssparse:: Long array of the following structure:<BR>
;            <*>ssparse(0)</*>: Number of elements NE 0 in array<BR>
;            <*>ssparse(1)</*>: Total number of elements in array<BR>
;            <*>ssparse(i)</*> with i > 1: Indices of elements ne 0 in array.<BR>
;           If <*>/DIMENSION</*> is set:<BR>
;            <*>ssparse(ssparse(0)+2)</*>: Number of dimensions in array<BR>
;            <*>ssparse(ssparse(0)+2+j)</*>: jth dimension
;
; RESTRICTIONS:
;  Only binary information (element is 0 or NE 0) is stored in
;  <*>ssparse</*>. For conversion of non-binary arrays use
;  <A>Spassmacher()</A>. 
;
; PROCEDURE:
;  Search for elements NE 0 and store their indices.
;
; EXAMPLE:
;* IDL> a=[[0,1,1,0,1,1,1,0,0],[0,1,0,0,1,1,0,1,0]]  
;* IDL> print, sspassmacher(a)
;*            9          18           1           2           4           5
;*            6          10          13          14          16
;* IDL> print, sspassbeiseite(sspassmacher(a))
;*     0   1   1   0   1   1   1   0   0   0   1   0   0   1   1   0   1   0
;* IDL> print, sspassbeiseite(sspassmacher(a,/DIM),/DIM)
;*     0   1   1   0   1   1   1   0   0
;*     0   1   0   0   1   1   0   1   0
;*
;
; SEE ALSO:
;  <A>SSpassBeiseite</A>, <A>Spassmacher</A>, <A>SpassBeiseite</A>.
;
;-


FUNCTION SSpassmacher, a, DIMENSIONS=dimensions

   Default, dimensions, 0

   s = Size(a)
   d = s(0) ; the number of dimensions of a

   actNeurons = WHERE(a NE 0, count)

   IF Keyword_Set(DIMENSIONS) THEN BEGIN
      ; make longer array with space for size information at the end
      ssparse = Make_Array(count+d+3, TYPE=3, /NOZERO)
      ; store size info at end of sparse array
      ssparse(count+2:count+d+2) = s(0:d)
   ENDIF ELSE BEGIN
      ; conventional sparse array
      ssparse = Make_Array(count+2, TYPE=3, /NOZERO)
   ENDELSE

   ssparse(0,0) = count
   ssparse(1,0) = s(d+2)        ; get total number of elements from Size

   IF count NE 0 THEN ssparse(2:count+1) = actNeurons
  
   RETURN, ssparse


END
