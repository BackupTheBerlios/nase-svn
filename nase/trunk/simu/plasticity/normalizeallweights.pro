;+
; NAME:
;  NormalizeAllWeights
;
; VERSION:
;  $Id$
;
; AIM:
;  Normalize weights to keep total synaptic weight of every
;  Target-Neurnon constant; works like NormalizeWeights, but for
;  multiple weight matrices
; 
; PURPOSE:
;  Weights of a Target-Neuron are multiplied with
;  (MaxWeightSum/CurWeightSum), so the sum of weights remains
;  MaxWeightSum after some weights were increased. 
;
;
; For biological plausibility of weight normalisation see:
; (Sebastian Royer and Denis Pare. Conservation of total synaptic
; weight through balan-ced synaptic depression and
; potentiation. Nature, 2003.)
;
;
; CATEGORY:
;  Connections
;  NASE
;  Plasticity
;  Simulation
;
; CALLING SEQUENCE:
;* NormalizeWeights, _DW, LP, SPASSTARGET=SpassTarget, SSPASSTARGET=SSpassTarget, WEIGHTSUM=WeightSum, NOLOWSUM=NOLOWSUM, ALL=all
; INPUTS:
;  _DW:: Handle to Weight structure (initialized with InitDW)
;
; OPTIONAL INPUTS:
;  LP:: LearnPotential, Input is not used yet (maybe needed for trace
;  learning rule)
;
; INPUT KEYWORDS:
;  ALL:: normalize all Weights of _DW
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
;  <A>NormalizeWeights</A>
;-

;;; look in headerdoc.pro for explanations and syntax,
;;; or view the NASE Standards Document


PRO NormalizeAllWeights, _DWARR, SPASSTARGET=SpassTarget, SSPASSTARGET=SSpassTarget, WEIGHTSUM=WeightSum, NOLOWSUM=NOLOWSUM, Quadratic=Quadratic, ALL=all
;Target: 

default, WeightSum, 1.
WeightSum = float(WeightSum)

if (n_elements(SpassTarget) ne 0) then begin
    if SpassTarget[0] eq 0 then return
    Target = SpassTarget[0,*]
endif else if (n_elements(SSpassTarget) ne 0) then begin
    if SSpassTarget[0] eq 0 then return
    Target = [SSpassTarget[0],SSpassTarget[2:*]]
endif

layercount = n_elements(_DWARR)
DWARR=ptrarr(layercount)
for idx=0,layercount-1 do begin
    Handle_Value, _DWARR(idx), temp, /NO_COPY   
    dwarr(idx)=ptr_new(temp)
endfor                          ;idx

if keyword_set(all) then begin
    ;; RESTRICTION:
    ;; we assume that all dw-structures share the same
    ;; target layer (which isn't too far off, though)                          
    NConnections = n_elements((*DWARR(0)).T2C)
    target = [NConnections, indgen(NConnections)]
endif

if keyword_set(Quadratic) then begin
;;;;;;;;;Quadratic Normalization
    if keyword_set(NoLowSum) then begin
        FOR ti=1,target(0) DO BEGIN
            tn = target(ti)                 
            w_count=0
            for idx=0,layercount-1 do begin            
                IF (*DWARR(idx)).T2C(tn) NE -1 THEN BEGIN
                    Handle_Value, (*DWARR(idx)).T2C(tn), wix               
                    w_count=w_count+total(((*DWARR(idx)).W(reform(wix)))^2)
                endif
            endfor
            for idx=0,layercount-1 do begin
                Handle_Value, (*DWARR(idx)).T2C(tn), wix
                (*DWARR(idx)).W[wix] = sqrt(WeightSum/w_count)*(*DWARR(idx)).W[wix]
            endfor
        endfor
    endif else begin
        FOR ti=1,target(0) DO BEGIN 
            tn = target(ti)
            w_count=0
            for idx=0,layercount-1 do begin            
                IF (*DWARR(idx)).T2C(tn) NE -1 THEN BEGIN
                    Handle_Value, (*DWARR(idx)).T2C(tn), wix
;                    wix = reform(wix)   ;wahrscheinlich ueberfluessig
                    w_count=w_count+total(((*DWARR(idx)).W(wix))^2)
                endif
            endfor
            if w_count gt WeightSum then begin
                for idx=0,layercount-1 do begin
                    IF (*DWARR(idx)).T2C(tn) NE -1 THEN BEGIN
                        Handle_Value, (*DWARR(idx)).T2C(tn), wix
                        (*DWARR(idx)).W[wix] = sqrt(WeightSum/w_count)*(*DWARR(idx)).W[wix]
                    endif
                endfor
            endif
        endfor
    endelse
endif else begin
;;;;;;;;;Linear Normalization
    if keyword_set(NoLowSum) then begin
        FOR ti=1,target(0) DO BEGIN
            tn = target(ti)                 
            w_count=0
            for idx=0,layercount-1 do begin            
                IF (*DWARR(idx)).T2C(tn) NE -1 THEN BEGIN
                    Handle_Value, (*DWARR(idx)).T2C(tn), wix               
                    if total((*DWARR(idx)).W(reform(wix))) lt 0 then begin
                        print,(*DWARR(idx)).W(reform(wix))
                        stop
                    end else begin
                        w_count=w_count+total((*DWARR(idx)).W(reform(wix)))
                    end
                endif
            endfor
            for idx=0,layercount-1 do begin
                Handle_Value, (*DWARR(idx)).T2C(tn), wix
                (*DWARR(idx)).W[wix] = (WeightSum/w_count)*(*DWARR(idx)).W[wix]
            endfor
        endfor
    endif else begin
        FOR ti=1,target(0) DO BEGIN 
            tn = target(ti)
            w_count=0
            for idx=0,layercount-1 do begin            
                IF (*DWARR(idx)).T2C(tn) NE -1 THEN BEGIN
                    Handle_Value, (*DWARR(idx)).T2C(tn), wix
                    wix = reform(wix)
                    w_count=w_count+total((*DWARR(idx)).W(wix))
                endif
            endfor
            if w_count gt WeightSum then begin
                for idx=0,layercount-1 do begin
                    IF (*DWARR(idx)).T2C(tn) NE -1 THEN BEGIN
                        Handle_Value, (*DWARR(idx)).T2C(tn), wix
                        (*DWARR(idx)).W[wix] = (WeightSum/w_count)*(*DWARR(idx)).W[wix]
                    endif
                endfor
            endif
        endfor
    endelse
endelse

for idx=0, layercount-1 do begin
    Handle_Value, _DWARR(idx), *DWARR(idx), /NO_COPY, /SET
    ptr_free, DWARR(idx)
endfor

END
