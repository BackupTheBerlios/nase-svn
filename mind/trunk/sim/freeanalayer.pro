;+
; NAME: 
;  FreeLayer
;
; AIM:
;  frees memory used by <A>AnaLayer</A> 
;  
; VERSION:
;  $Id$
;
; PURPOSE:
;  Tell what your routine does here.   
;  
; CATEGORY:
;  Put the following category (or categories, specified separate
;  lines) here.
;
;*  *Animation
;*  *Array Creation
;*  *Array and Image Processing
;*  -Font Manipulation
;*  *General Graphics
;*  *Graphics, Color Table Manipulation
;*  *Help
;*  *Image Display
;*  *Input/Output
;*  -Mapping
;*  *Mathematics
;*  *Operating System Access
;*  *Plotting, Two-Dimensional and General
;*  *Plotting, Multi-Dimensional
;*  *Programming and IDL Control
;*  +NASE/MIND Startup
;*  *Signal Processing
;*  *String Processing
;*  *Type Conversion
;*  *Widget and Dialog
;*  *Widget, Compound
;*  *Window
;
; CALLING SEQUENCE:
;  Write the calling sequence here. For procedures, use the form
;
;*    PROCEDURE_NAME, in1, in2, out1 [,in3] [,out1] [,/IN4] [,IN5=in5] [,OUT2=out2]
;
;  Note that the routine name is ALL CAPS. Positional arguments are written in lower case,
;  while all keyword arguments are written in all caps. For functions, use the form
; 
;*    out0 = FUNCTION_NAME(in1, in2, out1 [,in3] [,out2] [,/IN4] [,IN5=in5] [,OUT3=out3])
;
;  In more complex routines, certain keyword dependencies may arise.
;  Use the following compound symbols to improve understanding
;
;*      [ e1 ]    optional expressions
;*    { e1   e2 } grouping of expressions
;*      e1 | e2   alternative expressions
;
;  You may also split the calling sequence to several calls, if they are
;  too complicated to be combined.
;
;  
; INPUTS:
;  positional input arguments necessarily needed to use
;  the routine. They are written in lower case.
;  in1: description for argument in1
;  in2: description for argument in2
;  
; OPTIONAL INPUTS:
;  positional input arguments that may be optionally
;  passed to the routine. They are writen in lower case.
;  in3: description for argument in3
;  
; KEYWORD PARAMETERS:
;  Optional input keywords are specified her. The are
;  noted by all caps. No routine should ever need required keywords!
;  IN4: description for keyword IN4 
;  
; OUTPUTS:
;  outputs the routine requires to pass to the caller,
;  including the function result (here: out0, out1). They
;  are noted by lower case.
;  out0: the doumentation system can of course handle for long descriptions without
;        any problems, as long as you do not use any colons, except they are 'protected'
;        by round or curly braces (:) {:} 
;  out1: description for output out1
;  
; OPTIONAL OUTPUTS:
;  outputs the routine can, but need not pass to the caller,
;  without difference for positional or keyword arguments.
;  Depending if the outputs are positional or Keyword they are
;  written in lower case and all caps, respectively.
;  out2: description for output out2
;  
; COMMON BLOCKS:
;  please specify at least the name of the common
;  blocks used for this routines (which routine
;  defines the variables of the common block?)
;  
; SIDE EFFECTS:
;  side effects are nasty and dangerous and MUST
;  be mentioned. what is a side effect? look at
;  the following code snip
;
;*     a=5
;*     x=compute(a)
;*     print, a
;*     ; reveals that a is now 6, ouch!
;
;  Functions should not change their arguments.
;  Otherwise document this here! Also document all
;  changes to system variables, common blocks,
;  files and directories.
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
;  Please provide a simple example here. Things
;  you specifiy on IDLs command line should be indicated
;  by 
;*  IDL> print, "foobar" 
;  
;  IDLs output should be shown using
;*  >foobar
;  
; SEE ALSO:
;  Mention routines that are related to, depend on or
;  are used by your routine/implementation. Look at the
;  <A>DemoSim</A>. If you are bored, click 
; <A NREF=CVS>here</A>.
;  
; AUTHOR:
;  FORNAME SURNAME
;
;-
PRO FreeAnalayer, _AS, _EXTRA=e

   Handle_Value, _AS, AS, /NO_COPY

   DestroySheet, AS.Sh
   AS = -1

   Handle_Value, _AS, AS, /NO_COPY, /SET
   Handle_Free, _AS

END
