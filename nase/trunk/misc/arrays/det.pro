;+
; NAME:
;  det()
;
; VERSION:
;  $Id$
;
; AIM:  To calculate the determinant of a (complex) square matrix
;  
;
; PURPOSE: To calculate the determinant of a (complex) square matrix
;          (note: IDL's internal function <C>DETERM</C> cannot compute the complex 
;          determinant, but since IDL 5.6 <C>LA_DETERM</C> is the recommended
;          function for complex arrays). <C>DET</C> is modified from 
;          <C>DETERM</C> (General IDL Library 01) July 25 1984.
;
; CATEGORY:
;  Algebra
;  Array
;
; CALLING SEQUENCE:
;
;*result = det( A [,DARR] [,/DOUBLE])
;
; INPUTS:
;       A:: n x n square array for which the determinant is
;           to be calculated.
;
; OPTIONAL INPUTS:
;  
;
; INPUT KEYWORDS:
;       DOUBLE::  computes with double precision
;
; OUTPUTS:
;       result:: Determinant of square matrix.
;
; OPTIONAL OUTPUTS:
;       DARR:: diagonalized array (note off-diagonal elements
;              not zeroed)
;  
;
; PROCEDURE:
;    DET is an IDL version of Bevingtons routine by the same name (p.293)
;    As explained in Bevington, the determinant is calculated from the product
;    of the diagonal elements of a diagonalized matrix.
;
; EXAMPLE:
;*       Define an array (a).
;*         a = [[ 2.0,  1.0,  1.0], $
;*              [ 4.0, -6.0,  0.0], $
;*              [-2.0,  7.0,  2.0]]
;*       Compute the determinant.
;*         result = DET(a)
; SEE ALSO:
;
;     IDL's internal determinant routine <C>DETERM</C> or
;     since IDL 5.6 <C>LA_DETERM</C> (complex arrays implemented).
;-
;;; look in headerdoc.pro for explanations and syntax,
;;; or view the NASE Standards Document

function det,array,darr, double=double
    on_ERROR, 2
;
; Print calling sequence if no parameters have been specified.
;
 if n_params(0) eq 0 then begin
    console,'usage: result=DET(ARRAY[,darr])', /fatal
 endif  ; n_params(0)
;
; check that all parameters have been specified
;
 if idlversion(/float) GE 5.6 then begin
    console, "Since IDL Version 5.6 is DET obsolete, use IDL's LA_DETERM instead!!!", /warn
 endif

 s=size(array)
 if NOT ( s[3] eq 4 or s[3] eq 5 or s[3] eq 6 or  s[3] eq 9 ) then $
  console, /fatal, "Input array must be float or double (complex also possible)"

 default, Double, (s[s[0]+1] eq 5 or s[s[0]+1] eq 9)

 Complex = (s[3] eq 6 or  s[3] eq 9)

 if Double eq 0 then begin
    if complex then begin
       darr = complex(float(array), imaginary(array))
    end else darr = float(array)
    Zero = 1.0e-6   ;;Single-precision zero.
    det=1.
 end else begin
    if complex then begin
       darr = dcomplex(double(array), imaginary(array))
    end else darr = double(array)
    Zero = 1.0d-12  ;;Double-precision zero.  
    det = 1.0d
 end

 s1=s(1)-1


 for k=0l,s1 do begin
;
; interchange columns if diagonal element is 0
;
    if abs(darr(k,k)) LE zero then begin
       j=k
       while (j lt s1) and (abs(darr(k,j)) LE zero ) do j=j+1
;
; if matrix is singular set det=0 and end procedure
;
       if abs(darr(k,j)) LE zero then begin
          det=0
          console,'WARNING!  Determinant equals ZERO!'
          return, det   ; end procedure if matrix singular
       endif else begin
;
;  if nonzero diagonal element found, swap
;
          for i=k,s1 do begin
             save=darr(i,j)
             darr(i,j)=darr(i,k)
             darr(i,k)=save
          endfor  ; i loop
       endelse  ; j eq s1
       det=-det    ; column swap changes sign of determinant
    endif  ; darr(k,k)
;
; subtract row k from lower rows to get diagonal matrix
;
    arrkk=darr(k,k)
    
    det=det*arrkk
    if k lt s1 then begin       ; if not at last row, proceed
       k1=k+1
       for i=k1,s1 do begin
          for j=k1,s1 do darr(i,j)=darr(i,j)-darr(i,k)*(darr(k,j)/arrkk)
       endfor  ; i
    endif  ; k lt s1
 endfor  ; k
 return, det
 end  ; determ
