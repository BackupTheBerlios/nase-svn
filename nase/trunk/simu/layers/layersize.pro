;+
; NAME:	LayerSize()
;
;
;
; PURPOSE: liefert die Gesamtneuronenzahl eines Layers zurück 	
;
;
;
; CATEGORY: Basic
;
;
;
; CALLING SEQUENCE: Neuronenzahl = LayerSize( {Layer | WIDTH, HEIGHT} )
;
;
; 
; INPUTS: Layer: Layer-Struktur
;
;
;
; OPTIONAL INPUTS: WIDTH, HEIGHT, falls keine Layerstruktur vorliegt.
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
; MODIFICATION HISTORY: erstellt am 24.7.1997, Rüdiger Kupper
;
;       Sun Aug 3 23:48:12 1997, Ruediger Kupper
;       <kupper@sisko.physik.uni-marburg.de>
;
;		WIDTH, HEIGHT zugefügt.
;
;-

Function LayerSize, Layer, WIDTH=width, HEIGHT=height

        if not set(Layer) then return, width * height
	return, Layer.w * Layer.h
	
end
