;+
; NAME:
;  NormalizeWeights
;
; VERSION:
;  $Id$
;
; AIM:
;  Normalize weights to keep total synaptic weight of every Target-Neurnon constant
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
;  LP:: LearnPotential, Input is not used yet (maybe needet for trace
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
;  <A>RoutineName</A>
;-

;;; look in headerdoc.pro for explanations and syntax,
;;; or view the NASE Standards Document


PRO NormalizeWeights, _DW, LP, SPASSTARGET=SpassTarget, SSPASSTARGET=SSpassTarget, WEIGHTSUM=WeightSum, NOLOWSUM=NOLOWSUM, ALL=all
;Target: 

;SPASSTARGET: Sparse Array of active neurons 
;SpassTarget[0,0] = NumOfActive
;SpassTarget[1,0] = maxNumOfActive
;SpassTarget[0,1:*] = ListOfActiveNeurons
;SpassTarget[1,1:*] = ActivityValues
;nur aktive Neuronen werden abgearbeitet

default, WeightSum, 1.
WeightSum = float(WeightSum)

if (n_elements(SpassTarget) ne 0) then begin
    if SpassTarget[0] eq 0 then return
    Target = SpassTarget[0,*]
endif else if (n_elements(SSpassTarget) ne 0) then begin
    if SSpassTarget[0] eq 0 then return
    Target = [SSpassTarget[0],SSpassTarget[2:*]]
endif

;Target[0] = NumberOfActiveNeurons
;Target[1:*] = ListOfNumbers
                                ; ti : index to target neuron
                                ; wi : weight indices belonging to neuron
                                ; tn : to ti belonging target neuron

Handle_Value, _DW, DW, /NO_COPY

if keyword_set(all) then begin
    NConnections = n_elements(DW.T2C)
    target = [NConnections, indgen(NConnections)]
endif

;IF DW.info EQ 'SDW_WEIGHT' THEN BEGIN

if keyword_set(NoLowSum) then begin
    FOR ti=1,target(0) DO BEGIN
        tn = target(ti) 
        IF DW.T2C(tn) NE -1 THEN BEGIN
            Handle_Value, DW.T2C(tn), wi
            wi = reform(wi)
            DW.W[wi] = (WeightSum/total(DW.W[wi]))*DW.W[wi]
        endif
    endfor
endif else begin
    FOR ti=1,target(0) DO BEGIN 
        tn = target(ti)
        IF DW.T2C(tn) NE -1 THEN BEGIN
            Handle_Value, DW.T2C(tn), wi
            wi = reform(wi)
            CurSum = total(DW.W[wi])
            if CurSum gt WeightSum then DW.W[wi] = (WeightSum/CurSum)*DW.W[wi]
        endif
    endfor
endelse

;ENDIF  ELSE BEGIN 
;    IF DW.Info EQ 'SDW_DELAY_WEIGHT' THEN BEGIN
;        Message, 'illegal first argument'
;    ENDIF ELSE Message, 'illegal first argument'
;ENDELSE

Handle_Value, _DW, DW, /NO_COPY, /SET



END


;IDL/NASE> help, dw, /str 
;** Structure <829aa5c>, 13 tags, length=468828, data length=468828, refs=1:
;   INFO            STRING    'SDW_WEIGHT'
;   SOURCE_W        INT             20
;   SOURCE_H        INT             20
;   TARGET_W        INT             20
;   TARGET_H        INT             20
;   S2C             LONG      Array[400]           
; Handels auf Arrays mit den Nummern der Synapsen 
; dieses Source-Neurons (Indices in W, C2T und C2S)
;   C2S             LONG      Array[38800] ;Nummern der Source-Neurone
;   T2C             LONG      Array[400] ;Handel auf Array mit Synapsen-Nummern
;   C2T             LONG      Array[38800] ;Nummern der Target-Neurone
;   W               FLOAT     Array[38800] ;Gewichte
;   DEPRESS         INT              0
;   CONJUNCTION_METHOD
;                   INT              1
;   LEARN           LONG              4038
