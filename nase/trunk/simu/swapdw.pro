;+
; NAME: SwapDW()
;
; PURPOSE: Vertauscht in einer DW-Struktur Source- und TargetLayer
;
; CATEGORY: Simulation
;
; CALLING SEQUENCE: NeuDW = SwapDW( AltDW )
; 
; INPUTS:
;
; OPTIONAL INPUTS:
;	
; KEYWORD PARAMETERS:
;
; OUTPUTS:
;
; OPTIONAL OUTPUTS:
;
; COMMON BLOCKS:
;
; SIDE EFFECTS:
;
; RESTRICTIONS:
;
; PROCEDURE: Erzeugt eine neue DW-Struktur. Das ist recht speicherintensiv, aber erst mal das einfachste.
;
; EXAMPLE:
;
; MODIFICATION HISTORY:
;
;       Fri Aug 22 15:20:42 1997, Ruediger Kupper
;       <kupper@sisko.physik.uni-marburg.de>
;
;		Urversion. Nicht speichersparend...
;
;-

Function SwapDW, DW

   return, {source_w = DW.target_w, $
            source_h = DW.target_h, $
            target_w = DW.source_w, $
            target_h = DW.source_h, $
            weights=TRANSPOSE(DW.weights), $
            delays=TRANSPOSE(DW.delays)}

end

   
