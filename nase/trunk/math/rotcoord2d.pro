;+
; NAME:
;  RotCoord2D
;
; VERSION:
;  $Id$
;
; AIM:
;  Rotates 2-dimensional cartesian coordinates by a given angle.
;
; PURPOSE:
;  This procedure performs a coordinate rotation in 2-dimensional space for cartesian coordinates (for polar coordinates,
;  this would be trivial because only a constant value would have to be added to the phase values). Note that the concept
;  of this routine is different from the IDL rotation tools, which are useful for rotating bitmaps rather than explicitly
;  specified coordinates. The procedure performs the rotation directly on the passed <*>x</*> and <*>y</*> variables,
;  i.e., the variables are usually altered by the procedure!
;
; CATEGORY:
;  Algebra
;  Math
;
; CALLING SEQUENCE:
;* RotCoord2D, x, y, phi
;
; INPUTS:
;  x::   An integer or float variable, giving the x coordinates, and containing the transformed x coordinates afterwards.
;  y::   An integer or float variable of the same dimensional structure as <*>x</*>, giving the y coordinates, and
;        containing the transformed y coordinates afterwards.
;  phi:: An integer or float scalar, giving the angle by which to rotate the coordinates. By default, <*>phi</*> is
;        assumed to be specified in radiants. If you want <*>phi</*> to be interpreted as degrees, set the keyword
;        <*>DEGREES</*>. If omitted, no rotation is performed on the coordinates.
;
; INPUT KEYWORDS:
;  DEGREES:: Set this keyword if you want <*>phi</*> to be interpreted as degrees (default: radiants).
;
; OUTPUTS:
;  x:: The new x coordinates obtained by rotation.
;  y:: The new y coordinates obtained by rotation.
;
; SIDE EFFECTS:
;  The result is stored into the very same variables <*>x</*> and <*>y</*> which are initially passed to the procedure,
;  thereby altering their contents. If necessary, make a copy of these variables before calling the routine.
;
; EXAMPLE:
;* x = [1,-1]
;* y = [0, 1]
;* RotCoord2D, x, y, 45, /DEG
;* Print, x, y
;  IDL prints:
;* >     0.707107     -1.41421
;        0.707107     0.000000
;
;-



PRO  RotCoord2D, X, Y, Phi_,  $
                 degrees = degrees

   ;----------------------------------------------------------------------------------------------------------------------
   ; Checking parameters for errors, assigning default values:
   ;----------------------------------------------------------------------------------------------------------------------

   On_Error, 2

   IF  NOT(Set(X) AND Set(Y))  THEN  Console, '   X or Y are not defined.', /fatal
   Default, Phi, 0.0

   IF  ((Size(X))[0] NE (Size(Y))[0]) OR (Max(Size(X,/dim) NE Size(Y,/dim)) EQ 1)  THEN  Console, '  X and Y must have the same size.', /fatal

   IF  (Size(X  ,/type) GE 6) AND (Size(X,  /type) LE 11)  THEN  Console, '  X is of wrong type', /fatal
   IF  (Size(Y  ,/type) GE 6) AND (Size(Y,  /type) LE 11)  THEN  Console, '  Y is of wrong type', /fatal
   IF  (Size(Phi,/type) GE 6) AND (Size(Phi,/type) LE 11)  THEN  Console, '  Phi is of wrong type', /fatal

   Phi = Float(Phi_[0])   ; If Phi is an array, only the first value is taken seriously.
   IF  Keyword_Set(degrees)  THEN  Phi = Phi * !pi / 180.

   ;----------------------------------------------------------------------------------------------------------------------
   ; Coordinate transformation:
   ;----------------------------------------------------------------------------------------------------------------------

   IF  Phi NE 0  THEN  BEGIN
     XNew = X*cos(Phi) - Y*sin(Phi)
     YNew = X*sin(Phi) + Y*cos(Phi)
     X = XNew
     Y = YNew
   ENDIF


END
