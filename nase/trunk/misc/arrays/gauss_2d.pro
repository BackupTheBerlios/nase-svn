;+
; NAME: Gauss_2D()
;
; AIM: constructs array containing a two dimensional Gaussian
;
; PURPOSE: Erzeugt ein Array mit einer zweidimensionalen Gaussverteilung mit Maximum 1.
;
; CATEGORY: Allgemein, Kohonen, X-Zellen, Basic
;
; CALLING SEQUENCE: 
;   Array = Gauss_2D ( {
;                       /AUTOSIZE,
;                       { {sigma|HWB=..} | {XHWB=..,YHWB=..} }
;                       [,PHI=..] 
;                      |
;                       x_Laenge, y_Laenge 
;                       [(,sigma|,HWB=..)|,XHWB=..,YHWB=..] 
;                       [,x0|,X0_ARR=..] [,y0|,Y0_ARR=..]
;                       [,PHI=..]
;                      }
;                      [,/NORM]
;                      [,WARP=.. [,/ABSWARP] [,/GROUNDWIDTH]])
;
; OPTIONAL INPUTS:
;   x_Lange/y_Laenge : Dimensionen des gewuenschten Arrays.  Fuer
;                      y_Laenge=1 wird ein eindimensionales Array
;                      erzeugt.  Diese Parameter entfallen bei
;                      Gebrauch des AUTOSIZE-Schluesselwortes (s.u.)
;
;   sigma: Die Standardabweichung in Gitterpunkten. (Default =
;          X_Laenge/6)
;
;   x0, y0: Die Position der Bergspitze(relativ zum
;           Arraymittelpunkt). Fuer x0=0, y0=0 (Default) liegt der Berg
;           in der Mitte des Feldes. (Genauer: bei Laenge/2.0).
;
; KEYWORD PARAMETERS:
;   X0_ARR, Y0_ARR: wie x0,y0, aber relativ zur linken oberen Arrayecke.
;
;   AUTOSIZE: Wenn gesetzt, werden die Ausmasse des zurueckgelieferten
;             Arrays auf die sechsfache Standardabweichung
;             eingestellt. (D.h. dreifache Standardabweichung in beide
;             Richtungen.)  Die Parameter x_Laenge und y_Laenge
;             duerfen in diesem Fall nicht uebergeben werden.  Es ist
;             zu beachten, dass bei gesetztem AUTOSIZE maximal ein
;             Positionsparameter (sigma) uebergeben werden kann. In
;             anderen Faellen ist das Verhalten der Routine
;             undefiniert!
;
;   NORM: Volumen der Gaussmaske wird auf eins normiert.
;
;   HWB: Die Halbwertsbreite in Gitterpunkten. Kann alternativ zu
;        sigma angegeben werden.
;
;   XHWB, YHWB: Die Halbwertsbreite in Gitterpunkten bzgl. x und y
;               (alternativ zu sigma und HWB)
;
;  PHI: The result will be rotated by the angle specified by that
;       keyword. Please note that rotation is the last operation,
;       i.e. this angle adds to the value specified as the warping
;       direction. Please note also that this value is measured in the
;       x/y-plane CLOCKWISE from the w-axis (which, by the way, always
;       is the second coordinate by NASE conventions). The angle is
;       measured clockwise for compatibility reasons.
;       This argument is passed to the Distance() function. Please
;       note that, if keyword WARP is used, or if different standard
;       deviations for the x- and y-direction are specified,
;       distortion and missing values should be expected, especially
;       in the corners of the array.
;       If keyword WARP is not used, and standard deviations are the
;       same for the x- and y-direction, rotation is computed
;       directly, resulting in a distortion-free profile, even for tip
;       locations outside the array boundaries.
;       Please see Documentation of the Distance() function for
;       further information.
;
;  WARP: Set this keyword to a three element floating array
;        [angle,strength,ground].
;        The three values specify warping of the returned gaussian
;        profile: dissections of the profile are displaced in proportion
;        to their z-value. This means shearing of the coordinate
;        system parallel to the x/y-plane in the specified direction.
;        Please note that shearing is not rotation! Given identical
;        standard deviations for x- and y-directions, all intersections
;        parallel to the x/y-plane are circular.
;
;        "angle", specified in degrees and measured in the x/y-plane
;        anti-clockwise from the w-axis (which, by the way, always is
;        the second coordinate by NASE conventions), is the direction
;        in which to shear the coordinate system (i.e. the direction
;        of inclination of the z-axis).
;
;        "strength" specifies the amount of shearing.  If the ABSWARP
;        keyword is not set, this is a value in the range (-1,1),
;        0 meaning no shearing and 1 meaning the maximum shearing
;        possible. The maximal shearing is determined by the profile's
;        standard deviation in the specified direction. Please note
;        that values of 1.0 and above will yield corrupted results.
;        If the ABSWARP keyword is set, this value is the slope of the
;        z-axis. A value of 0 means a rectangular z-axis, i.e. no
;        shearing. (Please note that the maximum allowed value is the
;        underlying cone's opening slope in the specified
;        direction. See description of the Distance() routine for
;        further explanation.) This and bigger values will yield
;        corrupted results.
;        Negative values for "strength" specify shearing in the
;        opposite direction.
;
;        "ground" specifies the center of shearing, i.e. the plane
;        parallel to the x/y-plane that will not be displaced.
;        If keyword GROUNDWIDTH is not set, this value is the z-value
;        of the plane that will not be displaced. 1.0 means the tip of the
;        cone. All planes with higher z-values will be displaced in
;        the specified direction, all planes with lower z-values will
;        be displaced in the opposite direction.
;        This value must be in (0,1].
;        If keyword GROUNDWIDTH is set, this value is the width of the
;        gaussian profile at the plane that will not be displaced,
;        specified in units of sigma. (I.e., specifying 1.0 for "ground"
;        means that the plane that dissects the Gaussian at the
;        standard derivation is not displaced.)
;        If keyword GROUNDWIDTH is set, "ground" must be in [0,oo).
;
;        Please see the examples for a demonstration of the WARP
;        keyword.
;
;  ABSWARP: (see keyword WARP, component "strength".)
;
; OUTPUTS: Array: Ein ein- oder zweidimensionales Array vom Typ Double und der angegebenen Dimension mit Maximum 1.
;
; RESTRICTIONS: Man beachte, dass die Arraydimensionen ungerade sein müssen,
;               wenn der Berg symmetrisch im Array liegen soll!
;
;               Für XHWB != YHWB liefert die Funktion das Produkt zweier
;               eindimensionaler Gaussfunktionen. (Dies ist 
;               äquivalent zu einer elliptischen Gaussfunktion.)
;
;               Es ist zu beachten, dass bei gesetztem AUTOSIZE maximal 
;               ein Positionsparameter (sigma) uebergeben werden
;               kann. In anderen Faellen ist das Verhalten der Routine undefiniert!
;
;
; PROCEDURE: Put a Distance() cone through a Gaussian function.
;
; EXAMPLE: 
;  SurfIt, /NASE, Gauss_2D (31,31)
;  SurfIt, /NASE, Gauss_2D (31,21, HWB=2, 5, 5)
;
;  Surfit, /NASE, Gauss_2D(100, 100, 10, -50, 0)
;  Surfit, /NASE, Gauss_2D(100, 100, 10, -50, 0, PHI=45)
;
;  for i=-0.99,0.99,0.01 do surface, Gauss_2D(30, 30, WARP=[90,i,1.0])
;  for i=-0.99,0.99,0.01 do surface, Gauss_2D(30, 30, WARP=[90,i,0.01])
;  ;; central shearing plane at width sigma:
;  for i=-0.99,0.99,0.01 do surface, Gauss_2D(30, 30, WARP=[90,i,1.0], /GROUNDWIDTH)
;  ;; see it better here:
;  for i=-0.99,0.99,0.01 do surface, exp(-0.5)<Gauss_2D(30, 30, WARP=[90,i,1.0], /GROUNDWIDTH)
;  
;  for i=0, 360 do surface, Gauss_2D(30, 30, WARP=[i,0.6,1.0])
;  for i=0, 360 do surface, Gauss_2D(30, 30, WARP=[i,0.6,0.01])
;  ;; central shearing plane at height 0.5:
;  for i=0, 360 do surface, Gauss_2D(30, 30, WARP=[i,0.6,0.5])
;  ;; see it better here:
;  for i=0, 360 do surface, 0.5<Gauss_2D(30, 30, WARP=[i,0.6,0.5])
;  
;  ;; The difference of the two angles:
;  for i=0, 360 do surface, 0.5<Gauss_2D(30, 30, XHWB=2, YHWB=5, WARP=[i,0.99,0.01]), zrange=[0,1] 
;  for i=0, 360 do surface, 0.5<Gauss_2D(30, 30, XHWB=2, YHWB=5, WARP=[0,0.99,0.01], PHI=-i), zrange=[0,1] 
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 1.25  2000/09/27 15:59:32  saam
;        service commit fixing several doc header violations
;
;        Revision 1.24  2000/09/25 09:12:54  saam
;        * added AIM tag
;        * update header for some files
;        * fixed some hyperlinks
;
;        Revision 1.23  2000/09/08 22:51:35  kupper
;        Result contained NaNs, if one of the sigmas was 0. Now this is checked
;        and a array of zeros is returned instead.
;
;        Revision 1.22  2000/09/08 16:38:02  kupper
;        Now ignoring floating underflows.
;
;        Revision 1.21  2000/09/01 14:17:36  saam
;              replaced [] by () array indexing
;
;        Revision 1.20  2000/08/11 14:38:44  kupper
;        Polished Header. (Not translated, sorry...)
;        Now using extended form of Distance() to scale to standard
;        deviation. Warping also supported.
;        Added documentation for new features, and a lot of examples.
;
;        Revision 1.19  2000/07/19 14:21:48  kupper
;        Added auxiliary functions.
;        Will be used later :-)
;
;        Revision 1.18  2000/07/19 14:00:49  kupper
;        Now making use of Distanc()s quick /QUADRATIC oprion!
;
;        Revision 1.17  2000/07/19 13:54:44  kupper
;        Added comment on order of shifting/roztation.
;
;        Revision 1.16  2000/07/19 13:36:47  kupper
;        Now using non-cyclic Distance() instead of dist().
;        Hence, for non-centered tip-locations, mask is not cyclic shifted but
;        properly computed. Tip locations my now be outside the array, too.
;
;        Revision 1.15  2000/07/18 13:32:02  kupper
;        Changed /CUBIC to CUBIC=-0.5 in ROT() call.
;
;        Revision 1.14  2000/06/19 13:25:15  saam
;              + new keyword PHI to rotate assymmetric distributions
;
;        Revision 1.13  2000/02/29 18:53:10  kupper
;        Removed stupid ABS in normalization (gaussians are always positive!)
;        Corrected use of Temporary() in normalization.
;
;        Revision 1.12  2000/02/29 17:44:01  kupper
;        Added 1 to the sizes computed by AUTOSIZE. Thus, the array has odd size again.
;
;        Revision 1.11  2000/02/29 17:29:33  kupper
;        Added AUTOSIZE Keyword.
;
;        Revision 1.10  2000/02/29 15:03:05  kupper
;        Added comment on case XHWB != YHWB.
;
;        Revision 1.9  2000/02/29 14:56:10  kupper
;        Added a "Temporary" here and there.
;
;        Revision 1.8  1999/04/13 17:10:30  thiel
;               Noch ein Bugfix bei XHWB/YHWB und NORM-Zusammenarbeit.
;
;        Revision 1.7  1999/04/13 14:39:19  thiel
;               'Set' bei der NORM-Abfrage durch 'Keyword_Set' ersetzt.
;
;        Revision 1.6  1997/11/25 18:07:14  gabriel
;              Blow geloescht, Halbwertsbreiten fuer x und y hinzugefuegt
;
;        Revision 1.5  1997/11/25 17:03:32  gabriel
;              Blow Keyword eingesetzt
;
;        Revision 1.4  1997/11/10 19:08:44  gabriel
;             Option: /NORM fuer Volumennormierte Gaussmaske
;
;
;        Urversion irgendwann 1995 (?), Rüdiger Kupper
;        Keyword HWB zugefügt am 21.7.1997, Rüdiger Kupper
;        Standard-Arbeitsgruppen-Header angefügt am 25.7.1997, Rüdiger Kupper
;        Keywords X0_ARR und Y0_ARR zugefügt, 30.7.1997, Rüdiger Kupper
;-

;; The normal gauss function:
Function Gauss_function, x, sigma
   return, exp( -0.5 * ( double(x)^2 / sigma^2 ) )
End
;; This one starts with x_quad=x^2 already computed:
Function Gauss_function_quad, x_quad, sigma
   return, exp( -0.5 * ( double(x_quad) / sigma^2 ) )
End
;; This one starts with x already scaled by sigma (x_sigma=x/sigma):
Function Gauss_function_x_sigma, x_sigma
   return, exp( -0.5 * double(x_sigma)^2  )
End
;; This one starts with x already scaled by sigma, and quadratic
;; (x_sigma_quad=(x/sigma)^2):
Function Gauss_function_x_sigma_quad, x_sigma_quad
   return, exp( -0.5 * x_sigma_quad  )
End


Function Gauss_2D, xlen,ylen, AUTOSIZE=autosize, $
                   sigma,NORM=norm,hwb=HWB,xhwb=XHWB,yhwb=YHWB, x0, y0,$ ;(optional)
                   X0_ARR=x0_arr, Y0_ARR=y0_arr, PHI=phi, $
                   WARP=WARP, ABSWARP=ABSWARP, GROUNDWIDTH=groundwidth

   ;; Defaults:
   Default, x0, 0
   Default, y0, 0
   
   IF (set(XHWB) AND NOT set(YHWB)) OR (set(YHWB) AND NOT set(XHWB)) THEN $
    message,'Both XHWB and YHWB must be set'
   
   If set(HWB) then sigma=hwb/sqrt(alog(4))
 
   If Set(XHWB) then begin
      sigmax = xhwb/sqrt(alog(4))
      sigmay = yhwb/sqrt(alog(4))
   End

   If Keyword_Set(AUTOSIZE) then begin
      If Keyword_Set(XHWB) then begin
         xlen = 2*3*sigmax+1
         ylen = 2*3*sigmay+1
      Endif Else begin
         If not Keyword_Set(HWB) then sigma = xlen ;;the first parameter
         xlen = 2*3*sigma+1
         ylen = 2*3*sigma+1
      EndElse
   Endif
    
   Default, x0_arr, x0 + (xlen-1)/2d
   Default, y0_arr, y0 + (ylen-1)/2d
   Default, sigma,xlen/6d
   Default, sigratio, 1d

   ;; if sigma eq 0, computation would produce NaNs. Return all zero instead:
   if (sigma eq 0.0) then return, dblarr(xlen, ylen)
   if Set(XHWB) then begin
      if (sigmax eq 0.0) or (sigmay eq 0.0) then $
       return, dblarr(xlen, ylen)
   endif


   ;; compute WARP ground value. This is the width of the gauss
   ;; function with sigma=1 at height WARP[2]. (If you are confused,
   ;; remember that
   ;; the result(=y)-values of Distance() are used as the
   ;; input(=x)-value for computation of the gauss mask!)
   ;; Furthermore, Distance() will be scaled by sigma, hence the
   ;; function applied afterwards has sigma=1.
   If Keyword_Set(WARP) and not Keyword_Set(GROUNDWIDTH) then $
    WARP(2) = sqrt(-2*alog(WARP(2)))

   ;; Directions are opposite with the gauss function:
   If Keyword_Set(WARP) then WARP(1) = -WARP(1)


   ;; 2-d result, xsigma != ysigma
   IF set(XHWB) THEN BEGIN

      dist = Distance(/Quadratic, $
                      xlen,ylen,x0_arr,y0_arr, $
                      scale=[sigmax, sigmay], $
                      phi=phi, $
                      WARP=WARP, ABSWARP=ABSWARP)

      ERG = Gauss_function_x_sigma_quad(dist)

      If Keyword_Set(NORM) then begin
         i = TOTAL(ERG)
         ERG = temporary(ERG) / i
      Endif

      ;; Ignore any floating underflows:
      IF IdlVersion() GT 3 THEN dummy = Check_Math(Mask=32)
      
      return, ERG

  ENDIF


  ;; 1-d result
  if ylen eq 1 then begin
     ERG = $
      Gauss_function_x_sigma_quad(Distance(/Quadratic, $
                                           xlen,1,x0_arr,0.5, $
                                           scale=sigma, $
                                           WARP=WARP, ABSWARP=ABSWARP) $
                                 )

     ;; Ignore any floating underflows:
     IF IdlVersion() GT 3 THEN dummy = Check_Math(Mask=32)
     
     return, ERG
  endif


  ;; 2-d result, xsigma=ysigma
  If keyword_set(phi) then begin ;; rotate only center of gauss!
     p = Scl(cyclic_value(phi, [0, 360]), [0, 2*!DPI], [0, 360])
     
     p = -p                     ;Rot counts clockwise by default!
    
     newx0 = x0*cos(p)-y0*sin(p)
     newy0 = x0*sin(p)+y0*cos(p)
     
     x0_arr = Temporary(newx0)+(xlen-1)/2d
     y0_arr = Temporary(newy0)+(ylen-1)/2d
  endif

  ;; now call Distance without rotation!

  ERG = Gauss_function_x_sigma_quad(Distance(/Quadratic, $
                                             xlen,ylen,x0_arr,y0_arr, $
                                             scale=sigma, $
                                             WARP=WARP, ABSWARP=ABSWARP) $
                                   )
  
  If Keyword_Set(NORM) then begin
     i = TOTAL(ERG)
     ERG = temporary(ERG) / i
  Endif

  ;; Ignore any floating underflows:
  IF IdlVersion() GT 3 THEN dummy = Check_Math(Mask=32)

  return, ERG          
end
