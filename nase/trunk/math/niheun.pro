;+
; NAME:
;  NIHeun()
;
; VERSION:
;  $Id$
;
; AIM:
;   Numerically solve a differential equation using Heun's method.
;
; PURPOSE:
;  This routine iteratively computes the approximative solution of
;  a single or a set of differential equations
;* dx<SUB>i</SUB>(t)/dt = f(x<SUB>1</SUB>...x<SUB>n</SUB>) ,
;  with <*>i=1...n</*>.<BR> 
;  <C>NIHeun()</C> is more flexible than <A>NIExpEul()</A> and
;  <A>NIShuntDyn()</A>, since it allows the user to specify an arbitray
;  differential equation. It is also more accurate than
;  <A>NIEuler()</A>, allowing time steps an order of magnitude larger
;  while offering the same precision. This increase in precision comes
;  at the cost of more 
;  function evaluations. <C>NIHeun()</C> also is able to compute the
;  solution of the stochastic differential equation 
;* dx<SUB>i</SUB>(t)/dt = f(x<SUB>1</SUB>...x<SUB>n</SUB>)+g<SUB>i</SUB>(t)*GWN(t) ,
;  with <*>i=1...n</*> and <*>GWN(t)</*> being Gaussian white noise of
;  zero mean and standard deviation of 1. The routine cares for correctly
;  scaling the noise amplitude as a function of time resolution.<BR>
;  Heun's method is described in: Gard, Introduction to
;  stochastic differential equations, Dekker, New York (1988).
;
; CATEGORY:
;  Math
;
; CALLING SEQUENCE:
;* xnew = NIHeun( xold, deqname [, deqpara] 
;*                 [, DT=...][, G=...]
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
;            arrays may be passed to <*>deqname</*> using input
;            keywords.
;  
; INPUT KEYWORDS:
;  DT:: Time resolution, default <*>DT=1.0</*>. Note that the
;       precision of the result depends on the choice of <*>dt</*>. 
;  G:: The standard deviation of the additive noise at times
;      <*>t+dt</*> and <*>t</*> (Heun's method needs both of these
;      values). This
;      may either be a two element array <*>[g(t+dt),g(t)]</*>, in this case
;      the noise amplitudes are applied uniformly to all
;      <*>x<SUB>i</SUB></*>. It is also possible to specify a
;      <*>g<SUB>i</SUB></*> seperately for each <*>x<SUB>i</SUB></*>
;      by passing an array of dimension <*>[2,n]</*>.
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
; PROCEDURE:
;  + Generate appropriate noise amplitude array and compute the
;  additive noise if needed.<BR> 
;  + Compute an approximate new value via <A>NIEuler()</A>.<BR>
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
;*  y1=FltArr(500)
;*  time1=FIndgen(500)*0.2
;*  y1[0]=100. ;; start at T(0)=100.
;*  FOR t=0,498 DO y1(t+1)=NIHeun(y1(t),'nieul_test', 23., KEY=0.1, DT=.2, g=[1.,1.])
; Compare to Euler method:
;*  y2=FltArr(10000)
;*  time2=FIndgen(10000)*0.01
;*  y2[0]=100. ;; start at T(0)=100.
;*  FOR t=0,9998 DO y2(t+1)=NIEuler(y2(t),'nieul_test', 23., KEY=0.1, DT=0.01, g=1.)
;*  Plot, time1, y1
;*  OPlot, time2, y2, COLOR=RGB('red')
;
; SEE ALSO:
;  <A>NIEuler()</A>, <A>NIExpEul()</A>, <A>NIShuntDyn()</A>, IDL's
;  <C>RK4()</C>. 
;-

FUNCTION NIHeun, x, deqname, deqpara, DT=dt, G=g, _EXTRA=_extra

   COMMON common_random, seed

   IF (N_Params() LT 2) OR (N_Params() GT 3) THEN $
    Console, /FATAL, 'Wrong number of arguments.'

   Default, dt, 1.
   Default, g, 0.


   IF Max(g) NE 0. THEN BEGIN ;; is noise needed?
      ;; generate gg array that contains individual noise gi at
      ;; present and past timestep: gg[time,i].
      sg = Size(g)
      CASE sg[0] OF
         1: BEGIN
            IF sg[1] NE 2 THEN $
             Console, /FATAL, 'Uniform G: Need two array entries.' $
            ELSE $
             gg = Rebin(g, 2, N_Elements(x), /SAMPLE)
         END
         2: BEGIN
            IF (sg[1] NE 2) OR (sg[2] NE N_Elements(x)) THEN $
             Console, /FATAL, 'Individual G: Need array of dimension 2 x n.' $
            ELSE $
             gg = g
         END
         ELSE: Console, /FATAL, 'G has to be a two dim array.'
      ENDCASE
      dw = Sqrt(dt)*RandomN(seed, N_Elements(x))
      addnoise = 0.5*(Total(gg, 1))*dw ;; in case g(t) is different from g(t-1)
      xeul =  NIEuler(x, deqname, deqpara $
                      , DT=dt, G=gg[1, *], DW=dw $
                      , _EXTRA=_extra)

   ENDIF ELSE BEGIN

      addnoise = 0.
      xeul =  NIEuler(x, deqname, deqpara $
                      , DT=dt $
                      , _EXTRA=_extra)

   ENDELSE ;; Max(g) NE 0.
   

   IF NOT Set(deqpara) THEN BEGIN
      fx = Call_FUNCTION(deqname, x, _EXTRA=_extra)
      fxeul = Call_FUNCTION(deqname, xeul, _EXTRA=_extra)
   ENDIF ELSE BEGIN
      fx = Call_FUNCTION(deqname, x, deqpara, _EXTRA=_extra)
      fxeul = Call_FUNCTION(deqname, xeul, deqpara, _EXTRA=_extra)
   ENDELSE


   Return, x+0.5*(fx+fxeul)*dt+addnoise


END
