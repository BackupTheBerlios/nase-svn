;+
; NAME:
;  Normalize
;
; VERSION:
;  $Id$
;
; AIM:
;  Cares for normalizing of learned weight matrixes
;
; PURPOSE:
; <C>Normalize</C> is a mind wrapper for <A>NormalizeWeights</A>. It
; passes the parameters from the 'NORMALIZE' structure (defined in
; simulation definition program as part of the 'LEARN' structure) to
; <A>NormalizeWeights</A>. 
; <C>Normalize</C> is called from <A>Sim</A>. It makes nearly no sense to call it directly. 
;
; CATEGORY:
;  Connections
;  Internal
;  MIND
;  Plasticity
;  Simulation
;
; CALLING SEQUENCE:
;*Normalize, L, CON, _LS, t, _EXTRA=e
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
;*  in your LEARNW structure you insert for instance:
;*                                    NORMALIZE: {INFO:'NORMALIZE',$
;*                                                QUADRATIC:0,$
;*                                               WeightSum:0.8,$
;*                                               NoLowSum:1},$
;
; SEE ALSO:
;  <A>RoutineName</A>
;-

;;; look in headerdoc.pro for explanations and syntax,
;;; or view the NASE Standards Document


PRO Normalize, L, CON, _LS, t, _EXTRA=e

   COMMON ATTENTION
   COMMON SH_LEARN
   
   Handle_Value, _LS, LS, /NO_COPY
   if ExtraSet(LS, 'NORMALIZE') then begin
       curDW = Handle_Val(P.DWW(LS.DW))
       NormalizeWeights, Con(LS.DW), SSpassTarget=Handle_Val(LayerOut(L(curDW.TARGET))), $
                         WeightSum=LS.NORMALIZE.WeightSum,$
                         nolowsum=LS.NORMALIZE.NoLowSum, $
                         quadratic=LS.NORMALIZE.Quadratic
   endif
   Handle_Value, _LS, LS, /NO_COPY, /SET
END
