;+
; NAME: CHCONFIDENCE
;
;
; PURPOSE:            The CHCONFIDENCE (coherenceconfidence) function 
;
;
; CATEGORY: Corrs + Specs
;
; CALLING SEQUENCE:    confidence = chconfidence(coherence, N, cfvalue)
;
; INPUTS:
;                      coherence: the result from the coherence function
;                      N:         number of trials
;                      cfvalue:   the confidencevalue for the result (default: 0.95)
;
; OUTPUTS:   
;                      confidence: an array with the confidence interval for each coherencevalue.
;                                  For example, if coherence is an array of (freqdim , timedim), the
;                                  confidence results in an array (freqdim , timedim ,2). The entry
;                                  confidence(*,*,0) is the lower  limit and the entry confidence(*,*,1) is
;                                  the upper limit of confidence interval.
;
; SEE ALSO: <A>Coherence</A>
;
;-
; MODIFICATION HISTORY:
;
;
;     $Log$
;     Revision 1.2  2000/09/27 15:59:24  saam
;     service commit fixing several doc header violations
;
;     Revision 1.1  1998/11/20 17:21:30  gabriel
;          Wird von der Coherence function  benoetigt
;


FUNCTION  chconfidence,  Kohaerenz, N, Konfidenzwert


   D1Bins = N_ELEMENTS(Kohaerenz(*,0,0,0))
   D2Bins = N_ELEMENTS(Kohaerenz(0,*,0,0))
   D3Bins = N_ELEMENTS(Kohaerenz(0,0,*,0))
   D4Bins = N_ELEMENTS(Kohaerenz(0,0,0,*))
   KOSize = SIZE(Kohaerenz)

   Varianz = (1 - 0.004^(1.6*(N*(Kohaerenz+1.0/N)/(N+1))+0.22)) * 0.5 / (N-1)
;   OHNE KORREKTUR:
;   Varianz = (1 - 0.004^(1.6*Kohaerenz+0.22)) * 0.5 / (N-1)
   StdAbw  = SQRT(Varianz)

   P = 1.0-Konfidenzwert
   FaktorZweiseitig = GAUSS_CVF(P/2)
   FaktorEinseitig  = GAUSS_CVF(P)
   Konfidenz = FLTARR(D1Bins, D2Bins, D3Bins, D4Bins, 2,  /nozero)
   Z = FZT(SQRT(Kohaerenz))
   Konfidenz(*,*,*,*,0) = Z - FaktorZweiseitig*StdAbw
   Konfidenz(*,*,*,*,1) = Z + FaktorZweiseitig*StdAbw
   IndUnten = WHERE(Konfidenz LT 0)
   IF  IndUnten(0) NE (-1)  THEN  BEGIN
     IndOben = IndUnten + D1Bins*D2Bins*D3Bins*D4Bins
     Konfidenz(IndUnten) = 0
     Konfidenz(IndOben)  = Z(IndUnten) + FaktorEinseitig*StdAbw(IndUnten)
   ENDIF
   Konfidenz = FZT(Konfidenz, 1)^2
   Konfidenz = REFORM(Konfidenz, [KOSize(1:KOSize(0)),2], /overwrite)

   RETURN, Konfidenz


END
