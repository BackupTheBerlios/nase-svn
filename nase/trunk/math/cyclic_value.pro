;+
; NAME:
;  cyclic_value()
;
; AIM: project a cyclic value onto it's norm interval (e.g. angle on [0,360)).
;  
; PURPOSE:
;  For a given value and a given norm interval, cyclic_value() returns
;  the value's norm equivalent. This is useful for all values with a
;  cyclic definition, such as angles.
;  
; CATEGORY:
;  MATH
;  
; CALLING SEQUENCE:
;  result = cyclic_value(value, interval)
;  
; INPUTS:
;  val: value in (-oo, oo)
;  interval: the norm interval, specified as a 2-element array
;            [b1, b2].
;  
;            This interval is half-open: [.), or (.], depending on
;            the following rules:
;
;            b1 must not equal b2.                   
;            b1 always denotes the closed end of the interval.
;            b2 always denotes the open   end of the interval.                 
;            If b1<b2, the norm interval used is [b1,b2).
;            If b1>b2, the norm interval used is (b2,b1].
;
;            See below for examples.  
; OUTPUTS:
;  The value's norm equivalent in the interval [b1, b2).
;  The output is always of type double, regardless of the input
;  type.
;  
; PROCEDURE:
;  Basic computations using Floor().
;  
; EXAMPLE:
;  ;; project angle in degrees onto [0,360):
;  print, cyclic_value(-3601, [0,360])
;
;  ;; project angle in radians onto [-pi,pi):
;  print, cyclic_value(23, [-!DPI,!DPI])
;  
;  ;; this demonstrates the handling of open/closed interval ends:
;  ;;   project number onto [1,4):
;  Print, cyclic_value(1, [1, 4])   -> 1
;  Print, cyclic_value(2, [1, 4])   -> 2
;  Print, cyclic_value(3, [1, 4])   -> 3
;  Print, cyclic_value(4, [1, 4])   -> 1
;  ;;   project number onto (1,4]:
;  Print, cyclic_value(1, [4, 1])   -> 4
;  Print, cyclic_value(2, [4, 1])   -> 2
;  Print, cyclic_value(3, [4, 1])   -> 3
;  Print, cyclic_value(4, [4, 1])   -> 4
;
; SEE ALSO:
;  Rad(), Deg(), Floor(), MOD
;  
;-
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 2.2  2003/03/14 10:23:29  kupper
;        Extended documentation.
;
;        Revision 2.1  2000/08/09 17:23:02  kupper
;        Some useful routines...
;
;

Function Cyclic_Value, val, int
   min = int[0]
   max = int[1]
   interval = double(max-min)
   return, val - floor(double(val-min)/interval)*interval
End
