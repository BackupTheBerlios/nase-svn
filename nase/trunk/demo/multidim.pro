;+
; NAME:
;  MultiDim
;
; VERSION:
;  $Id$
;
; AIM:
;  demonstrates how to handle arguments with various iteration
;  dimensions 
;
; PURPOSE:
;  Often routines are needed that iterate a certain action for
;  various dimensions. However handling is in IDL quite complicated,
;  because various conditions have to be distinguished. This routine
;  shows how to reform a given argument, process all dimensions and
;  reform the argument back to its initial dimensions.<BR>  
;  This routine is intended as TEMPLATE for routines you write. 
;
; CATEGORY:
;  Array
;  Demonstration
;
;-

PRO MultiDim, ti
   ; ti   : time-iterations array 
   ; sti  : size of ti
   ; tsig : number of time indices in ti
   ; isig : number of iterations in ti  
   ; d    : dimensions of original ti

   sti = SIZE(ti)
   IF sti(0) EQ 0 THEN BEGIN
       d=1
       tsig=1
       isig=1
   END ELSE BEGIN
       d = sti(1:sti(0))
       tsig = sti(1)
       isig = sti(sti(0)+2)/sti(1)
       ti = REFORM(ti, tsig, isig, /OVERWRITE)
   END    
   ; ti is now (time, iterations) even if you
   ; only have one iteration
   help, ti
   print, "time: ", tsig, ", iterations: ", isig

   IF sti(0) GT 0 THEN ti = REFORM(ti, d, /OVERWRITE)
   ; now ti has again its initial dimensions
END
