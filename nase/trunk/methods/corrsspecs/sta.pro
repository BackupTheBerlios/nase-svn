;+
; NAME:                STA
; 
; PURPOSE:             Berechnet den Spike-Triggered Average. Dieser mittelt
;                      ein Signal C in einer bestimmten Umgebung um Events, die
;                      von einem anderen (binaeren) Signal B kommen.
;
; CATEGORY:            METHODS CORRS+SPECS STAT
;
; CALLING SEQUENCE:    s = STA(C , B [,t] [,PSHIFT=pshift])
;
; INPUTS:              C : das zu untersuchende Signal
;                      B : der Spiketrain
;
; KEYWORD PARAMETERS:  PSHIFT: gibt die zu untersuchende Umgebung um den
;                              Spike t an [t-PSHIFT,t+PHSIFT]. Default ist 64.
;
; OUTPUTS:             s : der Spike-Triggered-Average
;
; OPTIONAL OUTPUTS:    t : die zu s gehoerige Zeitachse
;
; EXAMPLE:
;                      C = 20*RandomU(seed,1000)
;                      B = ROUND(0.6*RANDOMU(seed,1000))
;                      s = STA(C, B, t, PSHIFT=128)
;                      plot, t, s
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 1.1  1998/06/23 19:09:48  saam
;           damned &^!%@$(&^$#
;
;
;-
FUNCTION STA, C, B, t, PSHIFT=pshift

   ;----->
   ;-----> CHECK & COMPLETE COMMAND LINE SYNTAX
   ;----->
   IF N_Params() LT 2 THEN Message, 'at least two parameters expected'
   ; C : continuous signal
   ; B ; binary signal
   SC = SIZE(C)
   SB = SIZE(B)
   NC = N_Elements(C)
   NB = N_Elements(B)

   IF (SC(0) NE 1) OR (SB(0) NE 1) THEN Message, 'only one-dimensional signals will be processed'
   IF (NOT InSet(SB(SB(0)+1), [1,2,3])) OR (Min(B) LT 0) OR (MAX(B) GT 1) THEN Message, 'second signal has to be a spike train!'
   IF (NC NE NB) THEN Message, 'signal have to have same size' 

   Default, PShift, 64
   


   ;----->
   ;-----> AVERAGE SIGNAL C AROUND EACH SPIKE
   ;----->
   s = FltArr(2*PShift+1)
   t = IndGen(2*PShift+1)-PShift

   BI = WHERE(B EQ 1, SpikeCount)
   IF SpikeCount EQ 0 THEN RETURN, s       ; no spike, no sta
   _C = [FltArr(PShift),C,FltArr(PShift)]  ; extend signal to simplify summation
   FOR i=0l, SpikeCount-1 DO s = s + _C( BI(i) : BI(i)+2*PShift )

   RETURN, s / FLOAT(SpikeCount)

END
