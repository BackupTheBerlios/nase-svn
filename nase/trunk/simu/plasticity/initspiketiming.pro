;+
; NAME: InitSpikeTiming.pro
;
;
; PURPOSE: Initialisiert eine Struktur, welche von DoSpikeTiming zum Zaehlen der Anzahl
;          von prae- und postsynaptischen Spikes, in Abhaengigkeit von deren gegenseitigen
;          Abstand benutzt wird
;
; CATEGORY: SIMULATION PLASTICITY
;
;
; CALLING SEQUENCE:  Counter = InitSpikeTiming(LearnWindow)
;
; 
; INPUTS:  LearnWindow : Lernfenster welches z.B.  mit InitLearnBiPoo definiert wurde
;

;
; OUTPUTS:     Counter: Zaehlstruktur, welche von DoSpikeTiming benutzt wird.     
;
;
; EXAMPLE:  LearnWindow =  InitLearnBiPoo(postv=0.005,posttau=10,prev=0.005,pretau=10) 
;           Counter =  initspiketiming(LearnWindow) 
;
;
; MODIFICATION HISTORY:
;
;
;     $Log$
;     Revision 2.1  1999/11/10 15:06:00  alshaikh
;           initial version
;
;
;-

FUNCTION InitSpikeTiming, LW

temp = FLTARR(N_Elements(LW))*0
temp(0) = LW(0)
temp(1) = LW(1)
tmp =  { LWPos : temp}
_COUNT = HANDLE_CREATE(!MH, VALUE=tmp, /NO_COPY)
 

RETURN, _COUNT
END
