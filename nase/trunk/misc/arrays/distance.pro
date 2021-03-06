;+
; NAME:
;  Distance()
;
; VERSION:
;  $Id$
;
; AIM:
;  Generates array containing distance from a given point. Scaling/shearing possible.
;
; PURPOSE:
;  1. Basic usage:<BR> 
;
;    Same as IDL's <C>DIST()</C>, but without cyclic edges.<BR>
;
;    <C>Distance()</C> returns an array with every element set to the
;    distance this element has to a given point in the array. Distance
;    is <I>not</I> measured accross the edges.
;    Optionally, the square distance can be returned.<BR>
;
;    For those of us having a more visual view on things: 
;    <C>Distance()</C> returns a conic profile with a half opening
;    angle of 45�, open to the top, and it's tip located at a given
;    point.
;    Optionally, a second order paraboloid can be returned, open to
;    the top, and it's tip located at a given point.<BR>
;
;  2. Extended usage:<BR>
;
;    In addition to the above described capabilities, <C>Distance()</C> has
;    the possibility of scaling the values independently in the x- and
;    y-direction, to shear the values in a given direction, and to
;    rotate the result around the array center.<BR>
;
;    I.e., <C>Distance()</C> can return a cone with specified opening angles
;    for the x- and y- direction, rotarted in the x/y plane, and in a
;    coordinate system with an oblique z-axis.<BR>
;
;    In short: <C>Distance()</C> can return a rotated warped elliptic cone.
;
; CATEGORY:
;  Array
;  Image
;
; CALLING SEQUENCE:
;  1. Basic usage:
;*    result = Distance( h [,w] [,ch ,cw] [,/QUADRATIC] )
;
;  2. Extended usage:
;*    result = Distance( h [,w] [,ch ,cw] [,/QUADRATIC]
;*                       [,SCALE=..]
;*                       [,WARP=.. [,/ABSWARP]]
;*                       [,PHI=..] )
;
; INPUTS:
;  h:: Height (first dimension) of the array to return.
;
; OPTIONAL INPUTS:
;  w:: Width (second dimension) of the array to return.
;     If w is not specified, a square array of dimensions h is returned.
;
;  ch,cw:: Center relative to which the distance values are computed. These are
;         not required to be integer values, nor to be lacated inside th array.
;         Default: ch=(h-1)/2.0, cw=(w-1)/2.0, i.e. the center of the array.
;  
;
; INPUT KEYWORDS:
;  QUADRATIC:: If set, the values returned are quadratic distances.
;             A call to Distance(..., /QUADRATIC) is completely equivalent to
;             calling (Distance(...)^2). However, if the WARP keyword
;             is not used, quadratic distances are always 
;             computed as a sub-result. (In fact, the routine returns
;             the square root of this value.) Thus, using the
;             QUADRATIC keyword reduces the computational overhead of
;             taking the root and restoring the original values
;             afterwards. (If the WARP keyword is used, the
;             computational cost is exactly the same as calling
;             Distance(...)^2.)
;
;  SCALE:: This keyword determines the opening angle of the returned
;         conic profile. Set this keyword to a scalar floating value
;         for symmetric scaling in w- and h-direction. Set it to a two
;         element floating array [w_scl,h_scl] to specify independent
;         scaling for w- and h- direction. The specified value is the
;         slope along the w- and h-axis. A value of 1.0 is the default
;         and means a half opening angle of 45�. A higher value means
;         smaller opening angles.
;
;  WARP:: Set this keyword to a three element floating array
;        [angle,strength,ground].
;        The three values specify warping of the returned conic
;        profile: dissections of the cone are displaced in proportion
;        to their z-value. This means shearing of the coordinate
;        system parallel to the x/y-plane in the specified direction.
;        Please note that shearing is not rotation! Given identical
;        scale factors for x- and y-directions, all intersections
;        parallel to the x/y-plane are circular.<BR>
;
;        "angle", specified in degrees and measured in the x/y-plane
;        anti-clockwise from the w-axis (which, by the way, always is
;        the second coordinate by NASE conventions), is the direction
;        in which to shear the coordinate system (i.e. the direction
;        of inclination of the z-axis).<BR>
;
;        "strength" specifies the amount of shearing.
;        If the ABSWARP keyword is not set, this is a value in the
;        range (-1,1), 0 meaning no shearing and 1 meaning the maximum
;        shearing possible. The maximal shearing is determined by the
;        cone's opening angle in the specified direction. Please note
;        that values of 1.0 and above will yield corrupted results.
;        If the ABSWARP keyword is set, this value is the slope of the
;        z-axis. A value of 0 means a rectangular z-axis, i.e. no
;        shearing. Please note that the maximum allowed value is the
;        cone's opening slope in the specified direction. This and
;        bigger values will yield corrupted results.
;        Negative values for "strength" specify shearing in the
;        opposite direction.<BR>
;
;        "ground" specifies the center of shearing, i.e. the z-value
;        of the plane that will not be displaced. 0 means the tip of
;        the cone. All planes with higher z-values will be displaced
;        in the specified direction, all planes with lower z-values
;        will be displaced in the opposite direction.<BR>
;
;        Please see the examples for a demonstration of the WARP
;        keyword.
;
;  ABSWARP:: (see keyword WARP, component "strength".)
;
;  PHI:: The result will be rotated by the angle specified by that
;       keyword. Please note that rotation is the last operation,
;       i.e. this angle adds to the value specified as the warping
;       direction. Please note also that this value is measured in the
;       x/y-plane CLOCKWISE from the w-axis (which, by the way, always
;       is the second coordinate by NASE conventions). The angle is
;       measured clockwise for compatibility reasons.
;       If keyword WARP is used, or if different scaling factors for
;       the x- and y-direction are specified, then specifying a value
;       for PHI is the same as calling
;         ROT(Direction(...), phi, CUBIC=-0.5, /PIVOT).
;       Hence, distortion and missing values should be expected,
;       especially in the corners of the array.
;       If keyword WARP is not used, and scaling is the same for the
;       x- and y-direction, rotation is computed directly, resulting
;       in a distortion-free profile, even for tip locations outside
;       the array boundaries.
;  
; OUTPUTS:
;  result:: Array of floats, containing the distance values or the
;          warped conic profile.
;
; RESTRICTIONS:
;  Please note that angles are measured from the w-axis, which is the
;  second coordinate. For use with non-NASE-routines, you probably
;  will want to subtract a value of 90� off all angles.
;  Please note also, that angles supplied in PHI are measured
;  clockwise due to compatibility reasons. Angles specified in WARP
;  are measured anti-clockwise.
;
; PROCEDURE:
;  Some array operations. No loops.
;
; EXAMPLE:
; 1. Basic usage:
;*   Surfit, /NASE, Distance(23)
;*   Surfit, /NASE, Distance(23,5,5)
;*   Surfit, /NASE, 50 < Distance(100)
;*   Surfit, /NASE, 2500 < Distance(100, /QUADRATIC)
; 2. Extended usage:
;*   Surfit, /NASE, 50 < Distance(100, SCALE=[0.5,1])
;*   Surfit, /NASE, 50 < Distance(100, SCALE=[0.5,1], PHI=45)
;*
;*   Surfit, /NASE, 50 < Distance(100, 0, -10) 
;*   Surfit, /NASE, 50 < Distance(100, 0, -10, PHI=45)
;*
;*   for i=-0.99,0.99,0.01 do surface, 10<Distance(30, WARP=[90,i,0])
;*   for i=-0.99,0.99,0.01 do surface, 10<Distance(30, WARP=[90,i,10])
;*   for i=-0.99,0.99,0.01 do surface, 10<Distance(30, WARP=[90,i,5])
;*
;*   for i=0, 360 do surface, 10<Distance(30, WARP=[i,0.99,0])
;*   for i=0, 360 do surface, 10<Distance(30, WARP=[i,0.99,10])
;*   for i=0, 360 do surface, 10<Distance(30, WARP=[i,0.99,5])
;
; The difference of the two angles:
;*   for i=0, 360 do surface, 10<Distance(30, SCALE=[0.5,1], WARP=[i,0.99,0])
;*   for i=0, 360 do surface, 10<Distance(30, SCALE=[0.5,1], WARP=[0,0.5,0], PHI=-i) 
;
; SEE ALSO:
;  IDL's <C>DIST()</C>, <A>Gauss_2d()</A>.
;-


Function distance, xlen, ylen, cx, cy, QUADRATIC=quadratic, $
                   WARP=WARP, $;; [phi,strength,ground]
                   ABSWARP=ABSWARP, $
                   SCALE=scale, PHI=phi
                   
   On_Error, 2

   case N_Params() of
      1: Begin ;;only xlen was given
            ylen = xlen
            cx = (xlen-1)/2.0
            cy = (ylen-1)/2.0
         End
      2: Begin ;;cx and cy were not given
            cx = (xlen-1)/2.0
            cy = (ylen-1)/2.0                   
         End
      3: Begin ;;ylen was not given
            cy = cx
            cx = ylen
            ylen = xlen
         End
      4: ;; do nothing
        
      else: message, "Please specify one to four parameters."
   endcase


   Default, scale, [1, 1]
   If N_Elements(scale) eq 1 then scale = [scale, scale]


   If Not(Keyword_Set(WARP)) then begin
      ;; The easy case: no oblique coord. system:

      ;; If scale[0]=scale[1], we only need to rotate the center:
      if keyword_set(phi) and (scale(0) EQ scale(1)) then begin
         p = Scl(cyclic_value(phi, [0, 360]), [0, 2*!DPI], [0, 360])
         
         p = -p                 ;Rot counts clockwise by default!
         
         ;; center relative to array center:
         xrel = cx-(xlen-1)/2d
         yrel = cy-(ylen-1)/2d
         
         newxrel = xrel*cos(p)-yrel*sin(p)
         newyrel = xrel*sin(p)+yrel*cos(p)
         
         cx = Temporary(newxrel)+(xlen-1)/2d
         cy = Temporary(newyrel)+(ylen-1)/2d

         ;now set phi=0:
         phi = 0
      endif
      
      xa = (FIndgen(xlen)-cx)/scale(0)
      ya = (FIndgen(ylen)-cy)/scale(1)
      
      xa = REBIN(           Temporary(xa)^2  , xlen, ylen)
      ya = REBIN( Transpose(Temporary(ya)^2) , xlen, ylen)
      
      quadresult = Temporary(xa)+Temporary(ya)

      ;; rotation?
      If Keyword_Set(phi) then $
       quadresult = ROT(Temporary(quadresult),phi,1,Cubic=-0.5,/Pivot)

      If Keyword_Set(QUADRATIC) then $
       return, quadresult $
      else $
       return, Sqrt(quadresult)
      
   endif else begin
      ;; The complicated case, oblique coord.system:

      a1 = scale(0)
      b1 = scale(1)

      ;; WARP=[phi,strength,ground]
      ph = Rad(WARP(0)+90);;+90� because of NASE coord system!
      
      cp = cos(ph)
      sp = sin(ph)

      ;; berechne m: Steigung der Mittelachse. m=tan(theta)
      If Keyword_Set(ABSWARP) then m = WARP(1) $
       else $
      ;; WARP[1]: strength
      ;; strength=0: Steigung der Mittelachse=0
      ;; strength=1: Maximale erlaubt Steigung der Mittelachse
      ;; maximal erlaubt ist die Steigung des ungescherten Kegels
      ;; in der Richtung von phi: elliptic_r(a1,b1,phi)
      ;; (Dies ist der Radius(phi) in der Ellipse mit den Halbachsen
      ;; a1 und b1.)
      m = WARP(1)*sqrt( a1^2*b1^2 / ((a1*sp)^2+(b1*cp)^2) )


      ;; ground: M(z) = (cos(phi),sin(phi))*z*m)
      cx = cx-cp*WARP(2)*m
      cy = cy-sp*WARP(2)*m


      x = Hill(xlen, cx, Top=0, Lslope=1, Rslope=-1)
      y = Hill(ylen, cy, Top=0, Lslope=1, Rslope=-1)

      x = REBIN(           Temporary(x) , xlen, ylen)
      y = REBIN( Transpose(Temporary(y)), xlen, ylen)

      zaehler_links = m*(cp*x*b1^2+sp*y*a1^2)
      nenner = m^2*( (b1*cp)^2+(a1*sp)^2 ) - (a1*b1)^2
      wurzel = a1*b1 * sqrt( (b1*x)^2 + (a1*y)^2 - (m*(sp*x-cp*y))^2 )


      erg = (zaehler_links-wurzel)/nenner
;     other part: (zaehler_links+wurzel)/nenner

      ;; rotation?
      If Keyword_Set(phi) then $
       erg = ROT(Temporary(erg),phi,1,Cubic=-0.5,/Pivot)

      if Keyword_Set(QUADRATIC) then $
       return, erg^2 $
      else $
       return, erg

   endelse

End
