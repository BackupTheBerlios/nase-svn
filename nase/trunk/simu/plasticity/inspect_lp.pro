;+
; NAME:
;  Inspect_LP
;
; VERSION:
;  $Id$
;
; AIM:
;  returns the current "memory-trace"-potentials
;
; PURPOSE:
;  returns the current "memory-trace"-potentials
;
; CATEGORY:
;  NASE
;  Plasticity
;  Simulation
;
; CALLING SEQUENCE:
;* Inspect_LP, LP, target_l=target_l, tracepot = tracepot
;
; INPUTS:
;  LP: an initialized (trace-)larning-potential
;  target_l: the postsynaptic neuron layer
;
; OPTIONAL OUTPUTS:
;  tracepot: memory-trace potential
;
; EXAMPLE:
;*
;*> myLearningStruct = InitMemoryTrace(MyLayer, EXPO=[0.1,100.0],
;*                                     DELAY=5, DELEARN=0.0002)
;*> Inspect_LP, myLearningStruct, target_l = MyLayer, tracepot = dummy
;*> ptvs, dummy, title="memory traces"
;
; SEE ALSO:
;  <A>update_lp</A>, <A>learn_lp</A>, <A>InitMemoryTrace</A>
;-


pro inspect_lp, _LP, tracepot=tracepot,target_l=tlayer

Handle_Value, _LP, LP, /NO_COPY
w1=layerwidth(tlayer)
h1=layerheight(tlayer)
tracepot = reform(LP.values,h1,w1)
handle_value,_lp,lp,/NO_COPY,/SET
end

