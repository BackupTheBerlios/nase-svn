;+
; NAME:
;  GRNTF_ThreshLinear()
;
; VERSION:
;  $Id$
;
; AIM:
;  Transfer function for Graded Response Neurons: Linear above threshold. 
;
; PURPOSE:
;  <C>GRNTF_ThreshLinear()</C> can be used as a transfer function for
;  graded response neurons. It results in a linear transfer as long as
;  the input to the neuron is above a given threshold. Otherwise, the 
;  constant threshold value is returned.
;
; CATEGORY:
;  Layers
;  NASE
;  Simulation
;
; CALLING SEQUENCE:
;*ProcedureName, par [,optpar] [,/SWITCH] [,KEYWORD=...]
;*result = FunctionName( par [,optpar] [,/SWITCH] [,KEYWORD=...] )
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
;  <A>InitPara_GRN()</A>, <A>InitLayer_GRN()</A>,
;  <A>InputLayer_GRN</A>, <A>ProceedLayer_GRN()</A>.
;-



FUNCTION grntf_threshlinear, m, slope, thresh

   Return, slope*m > thresh

END
