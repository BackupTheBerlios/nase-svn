;+
; NAME:
;	GAUSS2__FUNCT
; PURPOSE:
;	Evaluate function for gauss2fit.
; CALLING SEQUENCE:
;	FUNCT,X,A,F,PDER
; INPUTS:
;	X : values of independent variables, encoded as: [nx, ny, x, y]
;	A : parameters of equation described below.
; OUTPUTS:
;	F : value of function at each X(i,j), Y(i,j).
;	Function is:
;	        F(x,y) = A0*EXP(-U/2)
;	        where U = ABS((yp/A2)^A1 + (xp/A2)^A1)
;               and yp=y-A4, xp=x-A3
;
; Optional outputs:
;	PDER : (n_elements(z),6 or 7) array containing the
;		partial derivatives.  pder(i,j) = derivative
;		at ith point w/respect to jth parameter.
; PROCEDURE:
;	Evaluate the function and then if requested, eval partials.
;-
; MODIFICATION HISTORY:
;	WRITTEN, DMS, RSI, June, 1995.
;

PRO	GAUSSN2__FUNCT, X, A, F, PDER
nx = long(x(0))		;Retrieve X and Y vectors
ny = long(x(1))

xp = (x(2:nx+1)-a(3)) # replicate(1.0/a(2), ny)	;Expand X values
yp = replicate(1.0/a(2), nx) # (x(nx+2:*)-a(4))	;expand Y values
s = 0.0 & c = 1.0

n = nx * ny
u = sqrt(xp^2+yp^2)
u = reform(exp(-0.5 * (u^A(1))), n)	;Exp() term, Make it 1D
F = A(0) * u

if n_params(0) le 3 then return ;need partial?  No.

message,'fix me: i thought derivatives are needed??'

END



Function Gaussn2d_fit, z, a, x, y, XCENTER=xcenter, YCENTER=ycenter, NEGATIVE = neg,$
                CONVERGED=converged, WEIGHTS=weights
;+
; NAME:
;	GAUSS2d_FIT
;
; PURPOSE:
; 	Fit a 2 dimensional elliptical gaussian equation to rectilinearly
;	gridded data.
;		Z = F(x,y) where:
; 		F(x,y) = A0 + A1*EXP(-U/2)
;	   And the elliptical function is:
;		U= (x'/a)^2 + (y'/b)^2
;	The parameters of the ellipse U are:
;	   Axis lengths are 2*a and 2*b, in the unrotated X and Y axes,
;		respectively.
;	   Center is at (h,k).
;	   Rotation of T radians from the X axis, in the CLOCKWISE direction.
;	   The rotated coordinate system is defined as:
;		x' = (x-h) * cos(T) - (y-k) * sin(T)  <rotate by T about (h,k)>
;		y' = (x-h) * sin(T) + (y-k) * cos(T)
;
;	The rotation is optional, and may be forced to 0, making the major/
;	minor axes of the ellipse parallel to the X and Y axes.
;
;	The coefficients of the function, are returned in a seven
;	element vector:
;	a(0) = A0 = constant term.
;	a(1) = A1 = scale factor.
;	a(2) = a = width of gaussian in X direction.
;	a(3) = b = width of gaussian in Y direction.
;	a(4) = h = center X location.
;	a(5) = k = center Y location.
;	a(6) = T = Theta the rotation of the ellipse from the X axis
;		in radians, counterclockwise.
;
;
; CATEGORY:
;	curve / data fitting
;
; CALLING SEQUENCE:
;	Result = GAUSS2D_FIT(z, a [,x,y])
;
; INPUTS:
;	Z = dependent variable in a 2D array dimensioned (Nx, Ny).  Gridding
;		must be rectilinear.
;	X = optional Nx element vector containing X values of Z.  X(i) = X value
;		for Z(i,j).  If omitted, a regular grid in X is assumed,
;		and the X location of Z(i,j) = i.
;	Y = optional Ny element vector containing Y values of Z.  Y(j) = Y value
;		for Z(i,j).  If omitted, a regular grid in Y is assumed,
;		and the Y location of Z(i,j) = j.
;
; Optional Keyword Parameters:
;	NEGATIVE = if set, implies that the gaussian to be fitted
;		is a valley (such as an absorption line).
;		By default, a peak is fit.
;       CONVERGED: If set to a named variable, the status of the fit will
;               be returned.
;
; OUTPUTS:
;	The fitted function is returned.
; OUTPUT PARAMETERS:
;	A:	The coefficients of the fit.  A is a seven element vector as
;		described under PURPOSE.
;
; COMMON BLOCKS:
;	None.
; SIDE EFFECTS:
;	None.
; RESTRICTIONS:
;	Timing:  Approximately 4 seconds for a 128 x 128 array, on a 
;		Sun SPARC LX.  Time required is roughly proportional to the 
;		number of elements in Z.
;
; PROCEDURE:
;	The peak/valley is found by first smoothing Z and then finding the
;	maximum or minimum respectively.  Then GAUSSFIT is applied to the row
;	and column running through the peak/valley to estimate the parameters
;	of the Gaussian in X and Y.  Finally, CURVEFIT is used to fit the 2D
;	Gaussian to the data.
;
;	Be sure that the 2D array to be fit contains the entire Peak/Valley
;	out to at least 5 to 8 half-widths, or the curve-fitter may not
;	converge.
;
; EXAMPLE:  This example creates a 2D gaussian, adds random noise
;	and then applies GAUSS2DFIT:
;	nx = 128		;Size of array
;	ny = 100
;	;**  Offs Scale X width Y width X cen Y cen  **
;	;**   A0  A1    a       b       h       k    **
;	a = [ 5., 10., nx/6.,  ny/10., nx/2., .6*ny]  ;Input function parameters
;	x = findgen(nx) # replicate(1.0, ny)	;Create X and Y arrays
;	y = replicate(1.0, nx) # findgen(ny)
;	u = ((x-a(4))/a(2))^2 + ((y-a(5))/a(3))^2  ;Create ellipse
;	z = a(0) + a(1) * exp(-u/2)		;to gaussian
;	z = z + randomn(seed, nx, ny)		;Add random noise, SD = 1
;	yfit = gauss2d_fit(z,b)			;Fit the function, no rotation
;	print,'Should be:',string(a,format='(6f10.4)')  ;Report results..
;	print,'Is:      :',string(b(0:5),format='(6f10.4)')
;
; MODIFICATION HISTORY:
;
;       $Log$
;       Revision 1.2  2000/09/27 15:59:26  saam
;       service commit fixing several doc header violations
;
;       Revision 1.1  1999/02/22 11:14:34  saam
;             new & cool
;
;       Revision 1.5  1998/03/14 13:58:31  saam
;             new Keyword WEIGHTS
;
;       Revision 1.4  1998/03/10 16:51:41  saam
;             new keyword CONVERGED
;
;       Revision 1.3  1998/03/10 12:58:19  saam
;             new keywords [XY]CENTER
;             now uses ucurvefit
;
;-
;
on_error,2                      ;Return to caller if an error occurs
s = size(z)
if s(0) ne 2 then $
	message, 'Z must have two dimensions'
n = n_elements(z)
nx = s(1)
ny = s(2)
np = n_params()
if np lt 3 then x = findgen(nx)
if np lt 4 then y = findgen(ny)

if nx ne n_elements(x) then $
    message,'X array must have size equal to number of columns of Z'
if ny ne n_elements(y) then $
    message,'Y array must have size equal to number of rows of Z'

if keyword_set(neg) then q = MIN(SMOOTH(z,3), i) $
    ELSE q = MAX(SMOOTH(z,3), i)	;Dirty peak / valley finder
ix = i mod nx
iy = i / nx
x0 = x(ix)
y0 = y(iy)

xfit = gaussn_fit(x, z(*,iy), ax, NTERMS=4) ;Guess at params by taking slices
yfit = gaussn_fit(y, z(ix,*), ay, NTERMS=4)


a = [	(ax(0) + ay(0))/2., $	;Amplitude
	(ax(3) + ay(3))/2., $	;Exponential factor
        (ax(2) + ay(2))/2., $   ;Width
	 ax(1), ay(1)       ]	;Centers

;print,'1st guess:',string(a,format='(8f10.4)')
IF NOT Set(Weights) THEN Weights = replicate(1.,n)
result = ucurvefit([nx, ny, x, y], reform(z, n, /OVERWRITE), $
		weights, a, itmax=50, $
		function_name = "GAUSSN2__FUNCT", /NODERIVATIVE, CONVERGED=converged)

z= REFORM(z, nx, ny, /OVERWRITE)	;Restore dimensions
return, REFORM(result, nx, ny, /OVERWRITE)
end

