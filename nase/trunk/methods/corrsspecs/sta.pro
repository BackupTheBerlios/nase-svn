;+
; NAME:
;  STA()
;
; AIM:
;  spike triggered average
; 
; PURPOSE:
;  Computes the spike triggered average for one or several
;  signals. This averages an arbitrary signal <*>C</*> in the
;  neighborhood of several events, that are deteremined by a second
;  (binary) signal <*>B</*>.
;
; CATEGORY:
;  Statistics
;  Signals
;
; CALLING SEQUENCE:
;* s = STA(C , B [,t] [,PSHIFT=pshift])
;
; INPUTS:
;  C :: the signal(s) to be averaged (time, other-dims)
;  B :: the trigger (binary) signals (time, other-dims)
;
; INPUT KEYWORDS:
;  PSHIFT:: the average is computed in the interval of
;           <*>[-PSHIFT,PSHIFT]</*> around every trigger signal (default: 64)
;
; OUTPUTS:
; s :: the spike triggered average (delta_t, other-dims)
;
; OPTIONAL OUTPUTS:
; t :: the optional time axis belonging to delta_a
;
; EXAMPLE:
;* C = 20*RandomU(seed,1000)
;* B = ROUND(0.6*RANDOMU(seed,1000))
;* s = STA(C, B, t, PSHIFT=128)
;* plot, t, s
;
;-

FUNCTION STA, C, B, t, PSHIFT=pshift

ON_ERROR, 2

   ;----->
   ;-----> CHECK & COMPLETE COMMAND LINE SYNTAX
   ;----->
   IF N_Params() LT 2 THEN console, /fatal, 'at least two parameters expected'
   ; C : continuous signal
   ; B : binary signal
   SC = SIZE(C)
   SB = SIZE(B)

   IF (NOT InSet(SB(SB(0)+1), [1,2,3])) OR (Min(B) LT 0) OR (MAX(B) GT 1) THEN Message, 'second signal has to be a spike train!'

   Default, PShift, 64
   


   ;----->
   ;-----> AVERAGE SIGNAL C AROUND EACH SPIKE
   ;----->

                                ; determine number of signals in c,
                                ; assume first dimension as time and
                                ; iterate over the others
   dc = adims(c)
   IF N_Elements(dc) GT 1 THEN nc = PRODUCT(dc(1:N_Elements(dc)-1)) ELSE nc=1

                                ; do the same for spike train(s)...
   db = adims(b)
   IF N_Elements(db) GT 1 THEN nb = PRODUCT(db(1:N_Elements(db)-1)) ELSE nb=1

   IF nb NE nc THEN Console, "B and C have to have same number of iterations", /FATAL

   c = REFORM(c, dc(0), nc, /OVERWRITE)
   b = REFORM(b, db(0), nb, /OVERWRITE)
   s = FltArr(2*PShift+1, nc)
   FOR i=0l, nc-1 DO BEGIN
       
       BI = WHERE(B(*,i) EQ 1, SpikeCount)
       IF SpikeCount NE 0 THEN BEGIN
           _C = [FltArr(PShift),C(*,i),FltArr(PShift)] ; extend signal to simplify summation
           FOR j=0l, SpikeCount-1 DO s(*,i) = s(*,i) + _C( BI(j) : BI(j)+2*PShift )
           S(*,i) = S(*,i)/FLOAT(SpikeCount)
       END
   END
   b = REFORM(b, db, /OVERWRITE)
   c = REFORM(c, dc, /OVERWRITE)
   s = REFORM(S, [2*pshift+1, dc(1:N_ELEMENTS(dc)-1)])
   

   t = IndGen(2*PShift+1)-PShift ; time axis is an optional output

   RETURN, s

END
