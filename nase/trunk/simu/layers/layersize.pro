;+
; NAME:	LayerSize()
;
;
;
; PURPOSE: liefert die Gesamtneuronenzahl eines Layers zur�ck 	
;
;
;
; CATEGORY: Basic
;
;
;
; CALLING SEQUENCE: Neuronenzahl = LayerSize( Layer )
;
;
; 
; INPUTS: Layer: Layer_1-Struktur
;
;
;
; OPTIONAL INPUTS: -
;
;
;	
; KEYWORD PARAMETERS: -
;
;
;
; OUTPUTS: klar!
;
;
;
; OPTIONAL OUTPUTS: -
;
;
;
; COMMON BLOCKS: -
;
;
;
; SIDE EFFECTS: -
;
;
;
; RESTRICTIONS: -
;
;
;
; PROCEDURE: -
;
;
;
; EXAMPLE: klar!
;
;
;
; MODIFICATION HISTORY: erstellt am 24.7.1997, R�diger Kupper
;
;-

Function LayerSize, Layer

	return, Layer.w * Layer.h
	
end
