;+
; NAME:
;  Hill()
;
; AIM: Return array filled with hill-shaped values (two adjacent ramps)
;  
; PURPOSE:
;  Hill() returns a one-dimensional array filled with values
;  resembling the shape of a hill (or valley), i.e. two adjacent
;  linear ramps. The hill may be specified by suitable combinations of
;  the following values: position and height of the tip, the leftmost
;  or rightmost value, and the slope of the left or right ramp (or
;  their inner angles to the X-axis).
;  
; CATEGORY:
;  ARRAY
;  
; CALLING SEQUENCE:
;  result = Hill( len, [tip,]
;                  TOP=t,
;                { LEFT=l  | LSLOPE=ls | LANGLE=la }
;                { RIGHT=r | RSLOPE=rs | RANGLE=ra }
;               )
;
; INPUTS:
;  len: The length of the array to fill
;  TOP: The height of the tip
;  
; OPTIONAL INPUTS:
;  tip: The position of the tip. This value can take any floating
;       value. It may be located inside or outside the array and
;       defaults to (len-1)/2.0. For a non-integer tip position, the
;       value given in TOP may not actually be contained in the
;       array. Instead, the slopes are adjusted as to virtually meat
;       the TOP value at the tip position in between two array sample
;       points. For tip<=0 or tip>=len-1, a Ramp() is returned.  
;
;  LEFT:   value of the leftmost element (index 0)
;  RIGHT:  value of the rightmost element (index len-1)
;  LSLOPE: slope of the left ramp (dy/dx) 
;  RSLOPE: slope of the right ramp (dy/-dx)
;  LANGLE: angle between left ramp and the positive X-axis
;  RANGLE: angle between right ramp and the negative X-axis
;
;  Please note that angles and slope are specified respective to the
;  inner X-axis, i.e., in respect to the positive X-axis for the left,
;  and in respect to the negative X-axis for the right ramp. See
;  figure below.
;
;       /\
;      /  \
;     /)  (\
;  -------------> x
;
; OUTPUTS:
;  result: Array filled with hill-shaped values. The values are floats
;          by default. If one of the supplied values was a double, the
;          result is double.
;  
; RESTRICTIONS:
;  Only the documented combinations of keywords are supported. For
;  other combinations (even though possibly properly defining a
;  hill), the result is undefined.
;  
; PROCEDURE:
;  A Hill() is constructed from two Ramp()s.
;  
; EXAMPLE:
;  -please specify-
;  
; SEE ALSO:
;  Ramp(), Angle2Slope()
;  
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 1.2  2000/07/20 14:15:36  kupper
;        Tip positions outside the array are now allowed!
;
;        Revision 1.1  2000/07/18 13:44:27  kupper
;        Hope it works.
;
;-


Function hill, len, tip, LEFT=left, RIGHT=right, TOP=top, $
               LSLOPE=lslope, RSLOPE=rslope,  LANGLE=langle, RANGLE=rangle

   Default, tip, (len-1)/2.0



   ;; Length of left and right ramp:
   llen = Ceil(tip)
   rlen = Floor(len-tip)

   ;; Angle was given, not slope:
   If Set(LANGLE) then lslope = Angle2Slope(langle)
   If Set(RANGLE) then rslope = Angle2Slope(rangle)

   ;; Either value was given or the slope. We have to compute both!
   If Set(LEFT)  then lslope = (top-left)/float(tip) $
                 else left   = top - lslope*tip
   If Set(RIGHT) then rslope = (top-right)/(len-float(tip)-1) $
                 else right  = top - rslope*(len-tip-1)

   ;; at this point, left, lslope, right and rslope are known.
   

   ;; handle special cases (tip outside array):
   if tip le 0       then return, Ramp(len, RIGHT=right, SLOPE=-rslope)
;   if tip ge (len-1) then return, Rotate(Ramp(len, LEFT=top, $
;                                              RIGHT=left, SLOPE=rslope, ANGLE=rangle), 2)
   ;; have to use transpose here, because we cannot write -rslope, in
   ;; case it is not defined. Cannot default it either, as Ramp() will
   ;; read it as set then...
   if tip ge (len-1) then return, Ramp(len, LEFT=left, SLOPE=lslope)


   ;; general case (tip inside array):
   lramp = Ramp(llen, LEFT=left, SLOPE=lslope)
   rramp = Ramp(rlen, RIGHT=right, SLOPE=-rslope)

   return, [Temporary(lramp), Temporary(rramp)]

End
