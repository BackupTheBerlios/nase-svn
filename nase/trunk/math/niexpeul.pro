;+
; NAME:
;  NIExpEul()
;
; VERSION:
;  $Id$
;
; AIM:
;  Numerically integrate a first order linear differential equation. 
;
; PURPOSE:
;  <C>NIExpEul()</C> can be used to successively compute an
;  approximative solution of a differential equation of the form
;*  dy(t)/dt = A - B*y(t)
;  using the "Exponential Euler" method
;  described in the <I>Book of GENESIS</I> by Bower and Beeman
;  (1998). Both <*>A</*> and <*>B</*> may vary as a function of time,
;  although it is assumed that they do so on a longer time scale than
;  the integration step size. This method offers a good compromise
;  between simplicity 
;  (nad thus, fast computation) and
;  sufficient precision without the need to choose extremely short
;  time steps. Its disadavantage is that it can only be applied to
;  first order linear differential equations.<BR>
;  To be on the safe side with the routine's
;  results, they should occasionally be cross-checked with a numerical
;  integration method that is more precise, like the Runge-Kutta
;  method (see IDL's <C>RK4()</C> routine).
;
; CATEGORY:
;  Math
;
; CALLING SEQUENCE:
;* ynew = NIExpEul(yold, A=..., B=..., [DT=...])
;
; INPUTS:
;  yold:: State of the variable y at time t, a floating point
;         number. You may supply an array of floats here as well.
;
; INPUT KEYWORDS:
;  A:: The inhomogenity of the differential equation. Has to have the
;      same dimension as <*>yold</*>. Mandatory.
;  B:: Multiplicative argument of the differential equation. Has to
;      have the same dimension as <*>yold</*>. Also note the sign of
;      <*>B</*>. Mandatory.
;  dt:: The integration time step size, default: <*>dt=1</*>
;
; OUTPUTS:
;  ynew:: The state of y at time t+dt. Computed by
;             <*>y(t+dt)=y(t)*D+(A/B*(1-D)</*> with
;             <*>D=Exp(-B*dt)</*>. The dimension of <*>ynew</*>
;             is identical to the one of <*>yold</*>.
;
; PROCEDURE:
;  Small syntax check, then compute the result.
;
; EXAMPLE:
;  Solve the differential equation describing the temperature decrease
;  of an object that is hotter than its surroundings: Change in
;                                                     temperature is
;                                                     proportional to
;                                                     the difference
;                                                     between the
;                                                     objct's
;                                                     present temperture T(t) and
;                                                     the surround's
;                                                     temperature T0=23.
;* dT(t)/dt = k(T0-T(t))  =>  A=k*T0, B=k
; The code looks like this:
;* y1=FltArr(10)
;* time1=FIndgen(10)*10.
;* y1[0]=100. ;; start at T(0)=100.
;* FOR t=0,8 DO y1(t+1)=NIExpEul(y1(t),A=0.1*23.,B=0.1,DT=10.)
;* Plot, time1, y1
; Change the time resolution just for fun:
;* y2=FltArr(10000)
;* time2=FIndgen(10000)*0.01
;* y2[0]=100. ;; start at T(0)=100.
;* FOR t=0,9998 DO y2(t+1)=NIExpEul(y2(t),A=0.1*23.,B=0.1,DT=0.01)
;* Plot, time1, y1
;* OPlot, time2, y2, COLOR=RGB('red')
;
; SEE ALSO:
;  IDL's <C>RK4()</C>.
;-


FUNCTION NIExpEul, y, A=a, B=b, DT=dt

   On_Error, 2

   Default, dt, 1.

   IF N_Params() NE 1 THEN $
    Console, /FATAL, 'Previous state of variable needed.'
   IF (NOT Set(a)) OR (NOT Set(b)) THEN $
    Console, /FATAL, 'Parameters A and B need to be specified.'

   d = Exp(-b*dt)

   Return, y*d+a*(1.-d)/b

END
 
