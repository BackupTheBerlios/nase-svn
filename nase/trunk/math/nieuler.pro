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
;  <C>NIEuler</C> is more flexible than <A>NIExpEul</A> and
;  <A>NIShuntDyn</A> since it allows the user to specify an arbitray
;  differential equation. It also allows the addition of noise to the
;  solution of the equation and cares for correctly scaling the noise
;  amplitude as a function of time resolution.
;
; CATEGORY:
;  Math
;
; CALLING SEQUENCE:
;* xnew =  NIEuler( xold, deq_name [, deqpara] 
;*                                 [, DT=...][, G=...][, DW=...]
;*                                 [, _EXTRA=_extra] )
;
; INPUTS: 
;  xold:: A numerical array describing the state of the variables
;         <*>x<SUB>i</SUB></*> at time <*>t</*>.
;  deq_name:: String specifying the name of the function that describes
;            the differential equation, ie the derivatives of
;            <*>x<SUB>i</SUB></*> with respect to time <*>t</*>. The
;            function <*>deq_name</*> should accept as inputs an
;            array <*>x<*> containing the current state .
;
; OPTIONAL INPUTS:
;  deqpara:: An array of numerical type containing various
;            parameters that are passed to the function
;            <*>deq_name</*>. Passing of more complex parameters like
;            arrays is accomplished by using input keywords.
;
; INPUT KEYWORDS:
;  DT:: Time resolution, default <*>DT=1.</*>.
;  G:: Standard deviation of additive noise
;  DW:: Array of normally distributed random numbers. This is only
;       needed when <C>NIEuler</C> is used by another routine which
;       has genrated ist own noise and wants this noise to bed used by
;        <C>NIEuler</C> as well.
;  _EXTRA:: Additional input keywords are passed along to the
;           differention equation function <*>deq_name</*>.
;
; OUTPUTS:
;  xnew::
;
; COMMON BLOCKS:
;  common_random
;
; RESTRICTIONS:
;  The euler method is the simplest and therefore most inaccurate
;  method to numerically solve a differential equation, so its results
;  should be treated with care.
;
; PROCEDURE:
;  + Compute the additive noise.<BR>
;  + Compute the derivative via <C>Call_Function()</C>.<BR>
;  + Calculate the new value.
;
; EXAMPLE:
;*
;*>
;
; SEE ALSO:
;  <A>NIExpEul</A>
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
