
;+
; NAME:
;  InitMemoryTrace
;
; VERSION:
;  $Id$
;
; AIM:
;  Initializes the slow feature learning rule
;
; PURPOSE:
;  Initilaizes the slow feature learning rule
;
; CATEGORY:
;  NASE
;  Plasticity
;  Simulation
;
; CALLING SEQUENCE:
;* myLearningStrcut = InitMemoryTrace(T, EXPO=[ampl,tau]
;*                                      [,DELAY=delay] [,DELEARN=delearn])
;
; INPUTS:
;  T: The Layer, for which Learning Potentials (Memory Traces) should
;  be initialized
;  ampl, tau: The parameters of the exp-function which describes the
;  decay of the learning potentials
; OPTIONAL INPUTS:
;  DELAY: the effect of a postsynaptic spike on the learning potential
;  is delayed by DELAY time-steps
;  DELEARN: Weights are reduced by DELEARN every time-step
;  MAXWEIGHT: weights (connection weights, not memory-trace
;  potentials!!!) are always smaller/equal than MAXWEIGHT
;
; OUTPUTS:
;  myLearningStruct: An initialized learning structure  
;
; EXAMPLE:

;*
;*> myLearningStruct = InitMemoryTrace(MyLayer, EXPO=[0.1,100.0],
;*                                     DELAY=5, DELEARN=0.0002,MAXWEIGHT=0.2)
;
; SEE ALSO:
;  <A>update_lp</A>, <A>learn_lp</A>
;-


FUNCTION InitMemoryTrace, T,EXPO=expo,DELAY=delay,DELEARN=delearn,MAXWEIGHT=maxweight

Default,DELAY,0
Default,DELEARN,0.
Default,maxweight, 50.0

deltat = 0.001*1000.

size = LayerSize(T)


IF N_Elements(expo) NE 2 THEN Message, 'amplification and time-constant expected with keyword expo'
IF expo(0) LE 0.0        THEN Message, 'amplification <= 0 senseless'
IF expo(1) LE 0.0        THEN Message, 'time-constant <= 0 senseless'

if delay ne 0 then begin
    trace=lonarr(delay+1)-1
    LP = { v        : expo(0) ,$
           dec      : exp(-deltat/expo(1)) ,$
           values   : FltArr( size) ,$
           trace    : trace, $
           delay    : delay , $
           delearn  : delearn, $
           maxweight : maxweight, $
           last     : -1l }
end else begin
    LP = { v        : expo(0) ,$
           dec      : exp(-deltat/expo(1)) ,$
           values   : FltArr( size ) ,$
           delay    : delay , $
           delearn  : delearn, $
           maxweight : maxweight, $
           last     : -1l }
end

RETURN, Handle_Create(!MH, VALUE=LP, /NO_COPY)
end
