;+
; NAME:
;  SpikeTrainDistance()
;
; VERSION:
;  $Id$
;
; AIM:
;  Returns distance of two spike trains based on spike timing metric.
;
; PURPOSE:
; <C>SpikeTrainDistance()</C> calculates the distance between two
; spike trains based on the spike timing metric invented by Victor &
; Purpura (Victor & Purpura, Network: Comput. Neural Syst. 8:127-164,
; 1997). This metric assigns costs to three basic operations
; (adding, deleting, shifting) of spikes and finds the
; set of operations that transforms one spike train into another
; one with minimal cost. The sum of the single operations' costs
; yields the distance 
; between the two spike trains.<BR>
; Copyright (c) 1999 by Daniel Reich and Jonathan Victor.
; Translated to Matlab by Daniel Reich from FORTRAN code by Jonathan
; Victor.
;
; CATEGORY:
;  Algebra
;  Math
;  Statistics
;  Signals
;
; CALLING SEQUENCE:
;*dist = SpikeTrainDistance(sptli, sptlj, COST=...)
;
; INPUTS:
;  sptli:: Vector of spike times for first spike train (in <A NREF=SSPASSMACHER>sspass</A> format).
;  sptlj:: Vector of spike times for second spike train (in <A NREF=SSPASSMACHER>sspass</A> format).
;
; INPUT KEYWORDS:
;  COST:: Cost per unit time to move a spike. By variing this
;         parameter the metrics sensitivity to spike timing can be
;         modified. Low cost values yield distances that are more
;         sensitive to the difference in spike number, large values
;         emphasize the individual spike times. 
;
; OUTPUTS:
;  dist:: Distance of spike trains based on spike timing metric.
;
; PROCEDURE:
;  Quite sophisticated: recursion transformed into two loops, consult
;  the reference given above for details.
;
; EXAMPLE:
;  Generate two simple spike trains, with one spike shifted by two
;  time steps. Then calculating the distance with large cost parameter
;  yields a result corresponding to addition and deletion of the
;  shifted spikes, because it it too "expensive" to shift the
;  spike. With low cost, the distance equals the difference between
;  the spike times (which is 2 here) multiplied by the cost.
;* IDL/NASE> a=BytArr(20)
;* IDL/NASE> a([5,10,15])=1.
;* IDL/NASE> b=a
;* IDL/NASE> b(12)=1
;* IDL/NASE> b(10)=0
;* IDL/NASE> Print, SpikeTrainDistance(SSpassmacher(a),SSpassmacher(b),cost=2.)
;*      2.00000
;* IDL/NASE> Print, SpikeTrainDistance(SSpassmacher(a),SSpassmacher(b),cost=.1)
;*      0.200000
;
; SEE ALSO:
;  <A>SSpassmacher()</A>
;-


FUNCTION SpikeTrainDistance, sptli, sptlj, COST=cost

   On_Error, 2

   IF NOT Set(cost) THEN Console, /FATAL, 'COST parameter must be set.'

   nspi=sptli(0) ;; number of spikes
   nspj=sptlj(0)

   IF nspi GT 0 THEN tli = sptli(2:*) ;; extract spike times form sparse array
   IF nspj GT 0 THEN tlj = sptlj(2:*)
  
   ;; special cases
   IF cost EQ 0. THEN Return, Abs(nspi-nspj) $
   ELSE IF cost EQ !VALUES.F_INFINITY THEN Return, nspi+nspj

   ;; Init array need to store recursive results
   scr=FltArr(nspi+1,nspj+1)

   scr(*,0)=FIndGen(nspi+1)
   scr(0,*)=FIndGen(nspj+1)

   IF (nspi*nspj) NE 0 THEN BEGIN
      FOR i=1, nspi DO $
       FOR j=1, nspj DO BEGIN
       minarr =  [scr(i-1,j)+1 $
                  , scr(i,j-1)+1 $
                  , scr(i-1,j-1)+cost*Abs(tli(i-1)-tlj(j-1))]
       scr(i,j)=Min(minarr)
    ENDFOR
   ENDIF  

   Return, scr(nspi,nspj)

END
