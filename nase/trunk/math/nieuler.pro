;+
; NAME:
;  NIEuler()
;
; VERSION:
;  $Id$
;
; AIM:
;  Numerically solve a differential equation using the Euler method.
;
; PURPOSE:
;  This routine iteratively computes the approximative solution of
;  a single or a set of differential equations
;* dx<SUB>i</SUB>(t)/dt = f(x<SUB>1</SUB>...x<SUB>n</SUB>) ,
;  with <*>i=1...n</*>.<BR> 
;  <C>NIEuler()</C> is more flexible than <A>NIExpEul()</A> and
;  <A>NIShuntDyn()</A>, since it allows the user to specify an arbitray
;  differential equation. It also is able to compute the solution of the
;  stochastic differential equation 
;* dx<SUB>i</SUB>(t)/dt = f(x<SUB>1</SUB>...x<SUB>n</SUB>)+g(x<SUB>i</SUB>)*GWN(t) ,
;  with <*>i=1...n</*> and <*>GWN(t)</*> being Gaussian white noise of zero mean
;  and standard deviation of 1. The routine cares for correctly scaling the noise
;  amplitude as a function of time resolution.
;
; CATEGORY:
;  Math
;
; CALLING SEQUENCE:
;* xnew =  NIEuler( xold, deqname [, deqpara] 
;*                 [, DT=...][, G=...][, DW=...]
;*                 [, _EXTRA=...] )
;
; INPUTS: 
;  xold:: A numerical array with dimension <*>n</*> describing the
;         states of the variables <*>x<SUB>i</SUB></*> at time <*>t</*>.
;  deqname:: String specifying the name of the function that describes
;            the differential equation, ie the derivatives of
;            <*>x<SUB>i</SUB></*> with respect to time <*>t</*>. The
;            function <*>deqname</*> should accept as inputs an
;            <*>n</*>-dimensional array <*>x</*> containing the
;            current state and either an 
;            array of parameters named <*>deqpara</*> and/or an
;            arbitrary number of input keywords to supply it with its
;            parameters. It should return an array of numerical type
;            the same dimension as <*>x</*>.
;
; OPTIONAL INPUTS:
;  deqpara:: An array of numerical type containing various
;            parameters that are passed to the function
;            <*>deqname</*>. More complex parameters like
;            arrays may be passed to<*>deqname</*> using input
;            keywords.
;
; INPUT KEYWORDS:
;  DT:: Time resolution, default <*>DT=1.0</*>. Note that the
;       precision of the result depends on the choice of <*>dt</*>. 
;  G:: The standard deviation of the additive noise. This may either
;      be a scalar value, in this case it is applied uniformly to all
;      <*>x<SUB>i</SUB></*>. It is also possible to specify a
;      <*>g<SUB>i</SUB></*> seperately for each <*>x<SUB>i</SUB></*>
;      by passing an array of dimension <*>n</*>.
;  DW:: Array of normally distributed random numbers with mean of zero
;       and standard deviation of 1. This is only
;       needed when <C>NIEuler()</C> is used by another routine which
;       has generated its own noise and wants this noise to be used by
;        <C>NIEuler()</C> as well. As default, <C>NIEuler()</C> generates
;        its noise itself.
;  _EXTRA:: Additional input keywords are passed along to the
;           differention equation function <*>deqname</*>.
;
; OUTPUTS:
;  xnew:: An array of numerical type containing the values of
;         <*>x<SUB>i</SUB></*> at time <*>t+dt</*>.
;
; COMMON BLOCKS:
;  common_random
;
; RESTRICTIONS:
;  The euler method is the simplest and therefore most inaccurate
;  method to numerically solve a differential equation, so its results
;  should be treated with care, especially if large values of
;  <*>dt</*> are used.
;
; PROCEDURE:
;  + Compute the additive noise.<BR>
;  + Compute the derivative via <C>Call_Function()</C>.<BR>
;  + Calculate the new value.
;
; EXAMPLE:
;  Solve the differential equation describing the temperature decrease
;  of an object that is hotter than its surroundings: Change in
;  temperature is proportional to the difference between the objct's
;  present temperture T(t) and the surround's temperature
;  T0=23. Include some noise as well. 
;* dT(t)/dt = k(T0-T(t)) + g*GWN(t)
;  First define the derivative function, with the parameter k passed
;  as a positional argument named <*>p</*> and the parameter T0 passed via
;  an input keyword called <*>KEY</*>:
;* FUNCTION nieul_test, x, p, KEY=key
;*   return, key*(p-x)
;* END
; Now computation looks like this:
;*  y1=FltArr(20)
;*  time1=FIndgen(20)*5.
;*  y1[0]=100. ;; start at T(0)=100.
;*  FOR t=0,18 DO y1(t+1)=NIEuler(y1(t),'nieul_test', 23., KEY=0.1, DT=5., g=1.)
; Finer time resolution:
;*  y2=FltArr(10000)
;*  time2=FIndgen(10000)*0.01
;*  y2[0]=100. ;; start at T(0)=100.
;*  FOR t=0,9998 DO y2(t+1)=NIEuler(y2(t),'nieul_test', 23., KEY=0.1, DT=0.01, g=1.)
;*  Plot, time1, y1
;*  OPlot, time2, y2, COLOR=RGB('red')
;
; SEE ALSO:
;  <A>NIExpEul()</A>, <A>NIShuntDyn()</A>, IDL's <C>RK4()</C>.
;-

FUNCTION NIEuler, x, deqname, deqpara, DT=dt, G=g, DW=dw $
                  , _EXTRA=_extra
   
   COMMON common_random, seed

   Default, dt, 1.
   Default, g, 0.

   IF g NE 0. THEN BEGIN
      IF NOT Set(dw) THEN dw = Sqrt(dt)*RandomN(seed, N_Elements(x))
      addnoise = g*dw
   ENDIF ELSE addnoise = 0.

   CASE N_Params() OF
      2: dxdt = Call_FUNCTION(deqname, x, _EXTRA=_extra)
      3: dxdt = Call_FUNCTION(deqname, x, deqpara, _EXTRA=_extra)
      ELSE: Console, /FATAL, 'Wrong number of arguments.'
   ENDCASE

   Return, x+dxdt*dt+addnoise

END
