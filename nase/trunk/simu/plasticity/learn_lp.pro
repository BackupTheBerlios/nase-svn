;+
; NAME:
;  learn_lp
;
; VERSION:
;  $Id$
;
; AIM:
;  changes a weight structure according to a previously initialized  MemoryTrace
;
; PURPOSE:
;  changes a weight structure according to a previously initialized  MemoryTrace
;
;
; CATEGORY:
;  NASE
;  Plasticity
;  Simulation
;
; CALLING SEQUENCE:
;* learn_lp, dwstruct, learn_struct, SOURCE_L=source_l
;
; INPUTS:
;  dwstruct: a delay-weight-structure
;  learn_struct: an initialized learn-structure
;  source_l    : the source layer
;
; OPTIONAL INPUTS:
;  
;
; INPUT KEYWORDS:
;  
;
; OUTPUTS:
;  
;
; OPTIONAL OUTPUTS:
;  
;
; COMMON BLOCKS:
;  
;
; SIDE EFFECTS:
;  
;
; RESTRICTIONS:
;  
;
; PROCEDURE:
;  
;
; EXAMPLE:
;*
;*>
;
; SEE ALSO:
;  <A>update_lp</A>
;-

pro learn_lp, _DW,_LP,source_l=source_l
Handle_Value, _LP, LP, /NO_COPY
Handle_Value, _DW, DW, /NO_COPY



;; decay all weights by LP.delearn
;; weights are _ALWAYS_ greater than 0
dw.w=(dw.w - LP.delearn)

;; get all active presynaptic neurons
Pre = Handle_Val(LayerOut(source_l))
if pre(0) ne 0 then begin
    ; if there was at least one active presynaptic neuron we continue here
    for ti = 2, pre(0)+1 do begin
        tn = pre(ti)
        handle_value,dw.s2c(tn),wi
        if dw.s2c(tn) ne -1 then dw.w(wi) = (( dw.w(wi) + lp.values(dw.c2t(wi))) < LP.maxweight) > 0.0

    endfor
endif
handle_value,_lp,lp,/NO_COPY,/SET
handle_value,_dw,dw,/NO_COPY,/SET
end

