;+
; NAME:
;  SoftClip()
;
; AIM: Transfer function for smooth clipping of values.
;  
; PURPOSE:
;   The function implements a sigmoid transfer function of the
;   following shape:
;
;                           out
;                            ^
;                            |
;                         top+                         oooooo
;                            |                o
;                            |            o
;     ---               upper+         o
;      ^                     |       o
;      |                     |     o
;    linear                  |   o
;    range                   | o
;      |   ------------------o-------------------------> in
;      v                   o |
;     ---                o   +lower
;                     o      |
;     oooooo                 +bottom
;                            |
;                            |
;                            |
;  
;  This function can be used for restricting values to a given range,
;  not by hard clipping, but by softly squashing the values exceeding
;  a certain threshold:
;  1. Values in the range [lower,upper] are passed without modification.
;  2. Values in the range (upper,oo) are squashed to (upper,top) by
;     the upper half of a fermi function. (See Fermi().) 
;  3. Values in the range (-oo,lower) are squashed to (bottom,lower)
;     by the lower half of a fermi function.
;
; CATEGORY:
;  MATH
;  
; CALLING SEQUENCE:
;  result = SoftClip( val, {  UPPER=.., TOP=..
;                           | LOWER=.., BOTTOM=..
;                           | UPPER=.., TOP=.., LOWER=.., BOTTOM=..
;                          } )
;                          
; INPUTS:
;  val: The value(s) to be clipped.
;  
; KEYWORD PARAMETERS:
;  UPPER, LOWER, TOP, BOTTOM:
;    The resulting values are restricted to the range (BOTTOM,TOP).
;    Values in the range [LOWER,UPPER] stay unchanged.
;    Values in the range (UPPER,oo) are squashed to (UPPER,TOP).
;    Values in th range (-oo,LOWER) are squashed to (BOTTOM,LOWER).
;
;  If BOTTOM and LOWER are not specified, they default to -oo.
;  If TOP and UPPER are not specified, they default to +oo.
;  
; OUTPUTS:
;  The input value(s), soft clipped to the range (BOTTOM,TOP).
;  
; RESTRICTIONS:
;  TOP > UPPER
;  BOTTOM < LOWER
;  
; PROCEDURE:
;  Extract ranges and pass through appropriate fermi functions.
;  
; EXAMPLE:
;  ;Try this:
;    for i=0.0,0.8,0.01 do $
;     surface,softclip(gauss_2d(32,32),lower=i+0.01,bottom=i),zrange=[0,1]
;  ;and this:
;    for i=0.0,0.8,0.01 do $
;     surface,softclip(gauss_2d(32,32),lower=i+0.2,bottom=i),zrange=[0,1]
;  
; SEE ALSO:
;  <A HREF="#FERMI">Fermi()</A>, IDL's operators < and >.
;  
;-
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 2.2  2000/07/21 16:15:03  kupper
;        Added some Temporary().
;
;        Revision 2.1  2000/07/21 15:49:10  kupper
;        First version.
;        Thanks to Etel and Hans-Jörg for running into that problem :-).
;
;

Function _SoftClip_top, val, thresh, top
   lower = (val < thresh)
   upper = (val > thresh)-thresh

   range = (top-thresh)
   upper = range*2*(fermi(upper,0.5*range)-0.5)

   return, Temporary(lower)+Temporary(upper)
End

Function SoftClip, val, UPPER=upper, TOP=top, LOWER=lower, $
                   BOTTOM=bottom
   If Set(TOP) and Set(BOTTOM) then $
    return, _SoftClip_top(-_SoftClip_top(-val, -lower, -bottom), $
                          upper, top)

   If Set(BOTTOM) then $
    return, -_SoftClip_top(-val, -lower, -bottom)
    
   return, _SoftClip_top(val, upper, top)
   
End
