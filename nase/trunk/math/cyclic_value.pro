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
;            [min, max].
;  
; OUTPUTS:
;  The value's norm equivalent in the interval [min, max).
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
; SEE ALSO:
;  Rad(), Deg(), Floor(), MOD
;  
;-
;
; MODIFICATION HISTORY:
;
;        $Log$
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
