;+
; NAME:
;  InitNormalize
;
; VERSION:
;  $Id$
;
; AIM:
;  Prepares weight normalization (used by <A>Sim</A>).
;
; PURPOSE:
; For all learning structures wich contain a 'Normalize' structure
; <A>NormalizeWeights</A> is called one time with paramter '/all'. All
; weights are normalized one time, so the weight sum ist constant from
; the begining on.
;
;
; CATEGORY:
;  Connections
;  Internal
;  MIND
;  Simulation
;
; CALLING SEQUENCE:
;* InitNormalize, MaxWin,_CON, _LS, _EXTRA=e
;
; INPUTS:
;  
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
;  <A>Normalize</A>, <A>Sim</A>, <A>NormalizeWeights</A>
;-

;;; look in headerdoc.pro for explanations and syntax,
;;; or view the NASE Standards Document

PRO InitCrossNorm, NORMmax,_CON, NORMWptrarr, _EXTRA=e
   
On_Error, 2

COMMON ATTENTION
COMMON SH_LEARN, LEARNwins, LEARN_1, LEARN_2, LEARN_3, LEARN_4

;normalize complete DW structures, so each connection is normalized at
;the begining

FOR NormLoop=0, NORMmax DO BEGIN  ; Layer-Loop
  
    NormalizeAllWeights, _con[(*NORMWptrArr[normloop]).dwarr] $
                         ,ALL=1 $
                         ,NoLowSum = (*NORMWptrArr[normloop]).NoLowSum $
                         ,WeightSum = (*NORMWptrArr[normloop]).WeightSum $
                         ,quadratic= (*NORMWptrArr[normloop]).Quadratic


ENDFOR                          ; NormLoop
   
  
END
