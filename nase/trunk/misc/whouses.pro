;+
; NAME: 
;  WhoUses
;
; AIM:
;  prints all NASE/MIND routines using a specific routine
;  
; PURPOSE:
;  Tell what your routine does here.   
;  
; CATEGORY:
;   Put of the following category (or categories) here:
;
;   *Animation
;   *Array Creation
;   *Array and Image Processing
;   -Font Manipulation
;   *General Graphics
;   *Graphics, Color Table Manipulation
;   *Help
;   *Image Display
;   *Input/Output
;   -Mapping
;   *Mathematics
;   *Operating System Access
;   *Plotting, Two-Dimensional and General
;   *Plotting, Multi-Dimensional
;   *Programming and IDL Control
;   *Signal Processing
;   *String Processing
;   *Type Conversion
;   *Widget and Dialog
;   *Widget, Compound
;   *Window
;
; CALLING SEQUENCE:
;  Write the calling sequence here. For procedures, use the form:
;
;    ROUTINE_NAME, in1, in2, out1 [,in3] [,out1] [,/IN4] [,IN5=in5] [,OUT2=out2]
;
;  Note that the routine name is ALL CAPS. For functions, use the form:
; 
;    out0 = ROUTINE_NAME(in1, in2, out1 [,in3] [,out2] [,/IN4] [,IN5=in5] [,OUT3=out3])
;
;  In more complex routines, certain keyword dependencies may arise.
;  Use the following compound symbols to improve understanding:
;
;      [ e1 ]    optional expressions
;    ( e1   e2 ) grouping of expressions
;      e1 | e2   alternative expressions
;
;  You may also split the calling sequence to several calls, if they are
;  too complicated to be combined.
;
;  
; INPUTS:
;  positional input arguments necessarily needed to use
;  the routine
;  in1 : text that must not contain any colon unless it appears
;        in brackets, e.g. (Default: 1).
;  
; OPTIONAL INPUTS:
;  positional input arguments that may be optionally
;  passed to the routine (here: in3)
;  
; KEYWORD PARAMETERS:
;  optional input keywords (here: in4, in5)
;  no routine should ever need required keywords!
;  
; OUTPUTS:
;  outputs the routine requires to pass to the caller,
;  including the function result (here: out0, out1)
;  
; OPTIONAL OUTPUTS:
;  outputs the routine can, but need not pass to the caller,
;  without difference for positional or keyword arguments
;  (here: out2,out3)
;  
; COMMON BLOCKS:
;  please specify at least the name of the common
;  blocks used for this routines (which routine
;  defines the variables of the common block?)
;  
; SIDE EFFECTS:
;  side effects are nasty and dangerous and MUST
;  be mentioned. what is a side effect? look at
;  the following code snip:
;     a=5
;     x=compute(a)
;     print, a
;     ; reveals that a is now 6, ouch!
;  Functions should not change their arguments.
;  Otherwise document this here!
;  
; RESTRICTIONS:
;  Does your routine check passed arguments? Can it
;  handle all data types? If not, mention this here
;  (or better write your routine, that you can skip
;  this :) )
;  
; PROCEDURE:
;  How does the routine achieve its goal? Is it
;  straightforward? Is it brute force? You can
;  also mention references for more information
;  on the implementation here.
;  
; EXAMPLE:
;  -please specify-
;  
; SEE ALSO:
;  -please remove any sections that do not apply-
;  <A HREF="#MY_ROUTINE">My_Routine()</A>
;  
; AUTHOR:
;
;-

PRO WHOUSES, routine


NASEDIR = GetEnv("NASEPATH")
IF NASEDIR EQ "" THEN Console, "environment variable NASEPATH not set", /FATAL

hasPerl = Command("perl", /NOSTOP)
IF hasPerl EQ !NONE THEN Console, 'you need perl to use this routine', /FATAL

Spawn, NASEDIR+"/doc/tools/whouses "+routine


END
