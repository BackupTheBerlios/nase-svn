;+
; NAME:
;  STA()
;
; AIM:
;  Compute the spike triggered average.
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
;* s = STA(C , B [,t] [,PSHIFT=...] [,AVSTART=...] [AVSTOP=...])
;
; INPUTS:
;  C :: the signal(s) to be averaged (time, other-dims)
;  B :: the trigger (binary) signals (time, other-dims)
;
; INPUT KEYWORDS:
;  PSHIFT:: the average is computed in the interval of
;           <*>[-PSHIFT,PSHIFT]</*> around every trigger signal
;           (default: 64)
;  AVSTART:: The starting time of the averaging interval relative to
;            the trigger signal. Negative values denote times that lie
;            past the trigger signal.
;  AVSTOP:: The ending time of the averaging interval relative to
;            the trigger signal. <*> AVSTOP</*> has to be larger than
;            <*>AVSTART</*>. 
;
; OUTPUTS:
; s :: the spike triggered average (delta_t, other-dims)
;
; OPTIONAL OUTPUTS:
; t :: the optional time axis belonging to the averaging interval.
;
; EXAMPLE:
;* C = 20*RandomU(seed,1000)
;* B = ROUND(0.6*RANDOMU(seed,1000))
;* s = STA(C, B, t, PSHIFT=128)
;* plot, t, s
;
;-

FUNCTION STA, C, B, t, PSHIFT=pshift $
              , AVSTART=avstart, AVSTOP=avstop

;ON_ERROR, 2

   ;----->
   ;-----> CHECK & COMPLETE COMMAND LINE SYNTAX
   ;----->
   IF N_Params() LT 2 THEN console, /fatal, 'At least two parameters expected.'
   ; C : continuous signal
   ; B : binary signal
   SC = SIZE(C)
   SB = SIZE(B)

   IF (NOT InSet(SB(SB(0)+1), [1,2,3])) OR (Min(B) LT 0) OR (MAX(B) GT 1) THEN Console, /FATAL, 'Second signal has to be a spike train.'

   Default, PShift, 64 ;; old parameter is kept for compatibility

   Default, avstart, -pshift ;; compute default for new parameters
   Default, avstop, pshift

   IF avstart GE avstop THEN Console, /FATAL $
    , 'Starting time of averaging interval has to be earlier (lower) than stopping time.' 

   ;----->
   ;-----> AVERAGE SIGNAL C AROUND EACH SPIKE
   ;----->

   ;; determine number of signals in c,
   ;; assume first dimension as time and
   ;; iterate over the others
;   dc = adims(c)
   dc = sc(1:sc(0))
   IF N_Elements(dc) GT 1 THEN nc = PRODUCT(dc(1:N_Elements(dc)-1)) ELSE nc=1

   ;; do the same for spike train(s)...
;   db = adims(b)
   db = sb(1:sb(0))
   IF N_Elements(db) GT 1 THEN nb = PRODUCT(db(1:N_Elements(db)-1)) ELSE nb=1

   IF nb NE nc THEN Console, "B and C have to have same number of iterations.", /FATAL

   c = REFORM(c, dc(0), nc, /OVERWRITE)
   b = REFORM(b, db(0), nb, /OVERWRITE)
   s = FltArr(avstop-avstart+1, nc)
   FOR i=0l, nc-1 DO BEGIN
       
      BI = WHERE(B(*,i) EQ 1, SpikeCount)
      IF SpikeCount NE 0 THEN BEGIN
         ;; extend signal c at the beginning, if avstart lies in the
         ;; past  
         IF avstart LT 0 THEN _c = [FltArr(Abs(avstart)),C(*,i)] $
         ELSE _c = c(avstart:*, i)
         ;; append space at end of c if avstop lies in the future
         IF avstop GT 0 THEN _c = [_c, FltArr(avstop)] $
         ELSE _c = _c(0:N_Elements(_c)+avstop-1)
;           _C = [FltArr(Abs(avstart)),C(*,i),FltArr(avstop)] ; extend
;           signal to simplify summation (old version)
         FOR j=0l, SpikeCount-1 DO $
          s(*,i) = s(*,i) + _C( BI(j): BI(j)-avstart+avstop)
         S(*,i) = S(*,i)/FLOAT(SpikeCount)
      ENDIF 
   ENDFOR

   b = REFORM(b, db, /OVERWRITE)
   c = REFORM(c, dc, /OVERWRITE)
;   s = REFORM(S, [2*pshift+1, dc(1:N_ELEMENTS(dc)-1)])
   IF N_Elements(dc) GT 1 THEN $
    s = REFORM(S, [avstop-avstart+1, dc(1:N_ELEMENTS(dc)-1)]) $
   ELSE $
    s = REFORM(S, avstop-avstart+1)
   
   t = IndGen(avstop-avstart+1)+avstart ; time axis is an optional output

   RETURN, s

END
