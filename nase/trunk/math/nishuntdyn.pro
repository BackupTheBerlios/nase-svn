;+
; NAME:
;  NIShuntDyn()
;
; VERSION:
;  $Id$
;
; AIM:
;  Numerically integrate the shunting dynamics differential equation.
;
; PURPOSE:
;  This routine numerically integrates the shunting dynamics
;  differential equation using the exponential euler method. Shunting
;  dynamics equation is taken from Gaudiano, Vision Res. 34:1767,
;  1994, equation (5). The equation reads:
;*  dv(t)/dt = -Av(t) + [B-v(t)]*e(t) - [D+v(t)]*i(t)
;  This has the advantage that <*>v(t)</*> is automatically bounded
;  between the saturation potentials <*>B</*> and <*>D</*>.  Note that
;  Gaudiano's parameter D (the inhibitory saturation point) is
;  reversed in sign here. So if you want the inhibitory saturation to
;  be negative, you must specify <*>ISATURATION < 0</*>.
;
; CATEGORY:
;  Math
;  Simulation
;
; CALLING SEQUENCE:
;* vnew = NIShuntDyn(vold [, EXCITATION=...][, INHIBITION=...] $
;*                 , TAUINVSERSE=... [, DT=...] $
;*                 , ESATURATION=..., ISATURATION=...)
;
; INPUTS:
;  vold:: State of potential <*>v</*> at time <*>t</*>. 
;
; INPUT KEYWORDS:
;  EXCITATION/INHIBITION:: Excitatory and inhibitory inputs
;                          respectively, defaults=0. <*>e(t)</*> and
;                          <*>i(t)</*> in the equation above.
;  TAUINVERSE:: Inverse time constant, <*>A</*> in the above
;               equation. This argument is mandatory.
;  DT:: Time resolution, default=1.
;  ESATURATION/ISATURATION:: Excitatory and inhibitory saturation
;                            potentials, mandatory. <*>B</*> and
;                            <*>-D</*> in Gaudiano's notation. 
;
; OUTPUTS:
;  vnew:: State of potential <*>v</*> at time <*>t+dt</*>.
;
; PROCEDURE:
;  Compute the new solution using <A>NIExpEul()</A>.
;
; EXAMPLE:
;* v = fltarr(900)
;* e = fltarr(900)
;* e(150:599) = .1
;* i = fltarr(900)
;* i(300:749) = .1
;* 
;* FOR t=0, 898 DO $
;*    v[t+1] = NIShuntDyn(v[t], EXC=e[t], INH=i[t] $
;* , ESAT=1., ISAT=-0.5 $
;* , TAU=0.01)
;* 
;* Plot, v
;
; SEE ALSO:
;  <A>NIExpEul()</A>
;-

FUNCTION NIShuntDyn $
                  ;; former state
                 , v $
                  ;; input
                 , EXCITATION=excitation, INHIBITION=inhibition $
                  ;; time constant and resolution
                 , TAUINVSERSE=tauinverse, DT=dt $
                  ;; saturation potentials
                 , ESATURATION=esaturation, ISATURATION=isaturation

   IF NOT Set(excitation) THEN excitation = 0.
   IF NOT Set(inhibition) THEN inhibition = 0.

   Return, NIExpEul(v, A=esaturation*excitation+isaturation*inhibition $
                  , B=tauinverse+excitation+inhibition, DT=dt)

END
