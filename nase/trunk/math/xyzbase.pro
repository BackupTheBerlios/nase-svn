;+
; NAME:
;  XYBase
;
; VERSION:
;  $Id$
;
; AIM:
;  Generates two 2-dimensional or three 3-dimensional arrays giving x-, y- and z-coordinates, respectively.
;
; PURPOSE:
;  This routine returns one 1-dimensional, two 2-dimensional or three 3-dimensional arrays, containing the x-, y- and
;  z-coordinates for each point of the corresponding grid. The variables <*>x</*>, <*>y</*> and <*>z</*> allow convenient
;  definitions of analytical expressions especially over the 2-dimensional plane (i.e., functions of x and y) or in
;  3-dimensional space (functions of x, y and z), respectively. For example, to get a 2-dimensional gaussian, you can use
;  the intuitive expression <*>exp(-(x^2+y^2))</*> after obtaining <*>x</*> and <*>y</*> as the output of this
;  procedure.<BR>
;  Of course, the content of the output variables <*>x</*>, <*>y</*> and/or <*>z</*> is highly redundant, and you should
;  only use this procedure when both computing time and memory consumption play a minor part in your calculations.
;
; CATEGORY:
;  Algebra
;  Array
;  Image
;  Math
;
; CALLING SEQUENCE:
;* XYZBase, intx, wx, x
;* XYZBase, intx, wx, x,  inty, wy, y
;* XYZBase, intx, wx, x,  inty, wy, y,  intz, wz, z
;
; INPUTS:
;  intx:  A 2-elements integer or float array specifying the <*>x</*> interval in the form [Min,Max].
;  wx:    An integer or float scalar giving the sample step width in the <*>x</*> direction. Setting, for example,
;         <*>intx</*> to <*>[-2,2]</*> and <*>wx</*> to <*>0.1</*> results in a grid with 41 samples in the <*>x</*>
;         direction.
;  inty:  The <*>y</*> analogue of <*>intx</*> in the 2- or 3-dimensional case.
;  wy:    The <*>y</*> analogue of <*>wx</*> in the 2- or 3-dimensional case.
;  intz:  The <*>z</*> analogue of <*>intx</*> in the 3-dimensional case.
;  wz:    The <*>z</*> analogue of <*>wx</*> in the 3-dimensional case.
;
; OUTPUTS:
;  x:  A 1-, 2- or 3-dimensional array, respectively, giving the x-coordinates for each point of the 1-, 2- or
;      3-dimensional grid. In the 2-dimensional case, for example, with <*>intx</*>=[-2,2], <*>inty</*>=[-3,3],
;      <*>wx</*>=0.1 and <*>wy</*>=0.3, <*>x</*> would be a 41X21-array with values increasing linearly from -2 to 2
;      along each vector <*>x[*,j]</*> (and therefore values being constant along each vector <*>x[i,*]</*>).
;  y:  The <*>y</*> analogue of <*>x</*> in the 2- or 3-dimensional case. In the above example, <*>y</*> would also
;      be a 41X21-array, but with values increasing linearly from -3 to 3 along each vector <*>y[i,*]</*> and values
;      being constant along each vector <*>y[*,j]</*>.
;  z:  The <*>z</*> analogue of <*>x</*> in the 3-dimensional case.
;
; PROCEDURE:
;  The outputs <*>x</*>, <*>y</*> and <*>z</*> are generated using IDL's ReBin function with the <*>SAMPLE</*> keyword
;  set. This is a rather efficient way of inflating an array in multiple dimensions.
;
; EXAMPLE:
;  Generate a 2-dimensional coordinate system and use it for easily defining a 2-dimensional function:
;* XYZBase, [-3,3], 0.1, x,  [-3,3], 0.1, y
;* Shade_Surf, atan(1/x) * (atan(100*(y+1))-atan(100*(y-1)))
;
;-



PRO  XYZBase, IntX_, wX, X,   IntY_, wY, Y,   IntZ_, wZ, Z


   ;----------------------------------------------------------------------------------------------------------------------
   ; Checking parameters for errors:
   ;----------------------------------------------------------------------------------------------------------------------

   On_Error, 2

   IF  NOT((N_Params() EQ 3) OR (N_Params() EQ 6) OR (N_Params() EQ 9))  THEN  Console, '  Number of arguments must be 3, 6, or 9.', /fatal

   TypeIntX = Size(IntX_, /type)
   TypeIntY = Size(IntY_, /type)
   TypeIntZ = Size(IntZ_, /type)
   TypewX   = Size(wX  , /type)
   TypewY   = Size(wY  , /type)
   TypewZ   = Size(wZ  , /type)
   IF  (TypeIntX GE 6) AND (TypeIntX LE 11)               THEN  Console, '  IntX is of wrong type'      , /fatal
   IF  (TypeIntY GE 6) AND (TypeIntY LE 11)               THEN  Console, '  IntY is of wrong type'      , /fatal
   IF  (TypeIntZ GE 6) AND (TypeIntZ LE 11)               THEN  Console, '  IntZ is of wrong type'      , /fatal
   IF  (TypewX   GE 6) AND (TypewX   LE 11)               THEN  Console, '  wX is of wrong type'        , /fatal
   IF  (TypewY   GE 6) AND (TypewY   LE 11)               THEN  Console, '  wY is of wrong type'        , /fatal
   IF  (TypewZ   GE 6) AND (TypewZ   LE 11)               THEN  Console, '  wZ is of wrong type'        , /fatal
   IF                             N_Elements(IntX_) LE 1  THEN  Console, '  IntX must have two elements', /fatal
   IF  N_Params() GE 6  THEN  IF  N_Elements(IntY_) LE 1  THEN  Console, '  IntY must have two elements', /fatal
   IF  N_Params() GE 9  THEN  IF  N_Elements(IntZ_) LE 1  THEN  Console, '  IntZ must have two elements', /fatal
   IF                             N_Elements(wX)    EQ 0  THEN  Console, '  wX is not specified'        , /fatal
   IF  N_Params() GE 6  THEN  IF  N_Elements(wY)    EQ 0  THEN  Console, '  wY is not specified'        , /fatal
   IF  N_Params() GE 9  THEN  IF  N_Elements(wZ)    EQ 0  THEN  Console, '  wZ is not specified'        , /fatal

   ;----------------------------------------------------------------------------------------------------------------------
   ; Assigning default values, converting types, initializing variables:
   ;----------------------------------------------------------------------------------------------------------------------

   ; To avoid integer division traps, the arguments are converted to float type:
                              IntX = Float(IntX_[0:1])
   IF  N_Params() GE 6  THEN  IntY = Float(IntY_[0:1])
   IF  N_Params() GE 9  THEN  IntZ = Float(IntZ_[0:1])
                              NX   = Floor((Max(IntX)-Min(IntX)) / Float(wX[0])) + 1
   IF  N_Params() GE 6  THEN  NY   = Floor((Max(IntY)-Min(IntY)) / Float(wY[0])) + 1
   IF  N_Params() GE 9  THEN  NZ   = Floor((Max(IntZ)-Min(IntZ)) / Float(wZ[0])) + 1

   ;----------------------------------------------------------------------------------------------------------------------
   ; Generating the X and Y planes:
   ;----------------------------------------------------------------------------------------------------------------------

   IF  N_Params() EQ 3  THEN  X = Float(wX[0]) * FIndGen(NX) + Min(IntX)
   IF  N_Params() EQ 6  THEN  BEGIN
     X =           ReBin( Float(wX[0]) * FIndGen(NX) + Min(IntX) , NX, NY , /sample )
     Y = Transpose(ReBin( Float(wY[0]) * FIndGen(NY) + Min(IntY) , NY, NX , /sample ))
   ENDIF
   IF  N_Params() EQ 9  THEN  BEGIN
     X =           ReBin( Float(wX[0]) * FIndGen(NX) + Min(IntX) , NX, NY, NZ , /sample )
     Y = Transpose(ReBin( Float(wY[0]) * FIndGen(NY) + Min(IntY) , NY, NX, NZ , /sample ), [1,0,2])
     Z = Transpose(ReBin( Float(wZ[0]) * FIndGen(NZ) + Min(IntZ) , NZ, NX, NY , /sample ), [1,2,0])
   ENDIF


END
