;+
; NAME:  DoSpikeTiming.pro
;
;
; PURPOSE: Zaehlt alle Kombinationen der pro Simulationsschritt vorkommenden Abstaende von
;          prae- und postsynaptischen Spikes, welche in das mittels InitSpikeTiming festgelegte
;          Lernfenster fallen.
;
;
; CATEGORY: SIMULATION PLASTICITY
;
;
; CALLING SEQUENCE:  DoSpikeTiming, LP, Counter
;
; 
; INPUTS:  LP : eine mit InitPrecall initialisierte und mit Totalprecall aktualisierte Lernstruktur
;          Counter : mit InitSpikeTiming initialisierte Struktur 
;
; OUTPUTS : aktualisiert Counter
;
;
; EXAMPLE: LearnWindow =  InitLearnBiPoo(postv=0.005,posttau=10,prev=0.005,pretau=10)
;          Counter =  initspiketiming(LearnWindow)
;          LP = InitPrecall(DW_structure,LearnWindow)              
;                 ...
;          Totalprecall, LP,DW_structure, L1
;          dospiketiming, LP_EXC, Counter
;          ....
;          ShowSpikeTiming, Counter
;          FreeSpikeTiming, Counter
;
; MODIFICATION HISTORY:
;
;
;     $Log$
;     Revision 2.1  1999/11/10 15:06:01  alshaikh
;           initial version
;
;
;-

PRO DoSpikeTiming, _PC, _COUNT

  HANDLE_VALUE, _PC, PC,/NO_COPY
  HANDLE_VALUE, PC.postpre, ConTiming, /NO_COPY
 

; wenn nichts zu tun ist :
  IF ConTiming(0) EQ !NONEl THEN BEGIN          
     Handle_Value, PC.postpre, ConTiming, /NO_COPY, /SET
     Handle_Value, _PC, PC, /NO_COPY, /SET
     RETURN
  END

  HANDLE_VALUE, _COUNT, COUNT, /NO_COPY

 
  wi = ConTiming(*,0)
  FOR i=0, N_Elements(wi)-1 DO BEGIN
       COUNT.LWPos(2+ConTiming(i,1)+COUNT.LWPos(0)) = COUNT.LWPos(2+ConTiming(i,1)+COUNT.LWPos(0)) +1
  ENDFOR
  
  HANDLE_VALUE, PC.postpre, ConTiming, /No_Copy,/SET
  HANDLE_VALUE, _PC, PC,  /NO_COPY,/SET
  HANDLE_VALUE, _COUNT, COUNT,  /NO_COPY,/SET
  
END 
