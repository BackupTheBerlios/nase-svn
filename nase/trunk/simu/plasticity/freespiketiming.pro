;+
; NAME:
;  FreeSpikeTiming
;
; AIM: Free memory allocated by InitSpikeTiming.
;
;
; PURPOSE: Gibt den von InitSpikeTiming belegten dynamischen Speicher frei
;
;
; CATEGORY:
;  Simulation / Plasticity
;
;
; CALLING SEQUENCE: FreeSpikeTiming, COUNT
;                   
; 
; INPUTS:           COUNT -> eine mit InitSpiketiming initialisierte Struktur
;
; SIDE EFFECTS :    Man kann COUNT nach dem Aufruf nicht mehr benutzen 
;
; KEYWORD PARAMETERS:  keine
;
;
; OUTPUTS: keine
;

; EXAMPLE:                LearnWindow =  InitLearnBiPoo(postv=0.005,posttau=10,prev=0.005,pretau=10)
;                         Counter =  InitSpikeTiming(learnwindow)
;                         ....
;                         FreeSpikeTiming, Counter 
;                          
;-
;
; MODIFICATION HISTORY:
;
;
;     $Log$
;     Revision 2.2  2000/09/26 15:13:43  thiel
;         AIMS added.
;
;     Revision 2.1  1999/11/10 15:06:02  alshaikh
;           initial version
;


PRO FreeSpikeTiming, _COUNT

  Handle_free, _COUNT    ; nothing more 

END
