;+
; NAME: LayerRow()
;
;
;
; PURPOSE: Liefert zum eindimensionalen Layerindex (Entsprechend den Arrays in der Layer-Struktur) den
;	   zweidimensionalen Zeilenindex.
;
;          Diese Funtion bildet zusammen mit LayerCol() das Gegenstück zu LayerIndex().
;
;	   Die Umrechnung ist kompatibel zur IDL-Funktion REFORM().
;
; CATEGORY: Simulation, Basic
;
;
;
; CALLING SEQUENCE: Zeilenindex = LayerCol( Layer, Index_1D )
;
;
; 
; INPUTS: Layer   : eine mit InitLayer_? initialisierte Layer-Struktur
;	  Index_1D: Der eindimensionale Index
;
;
; OPTIONAL INPUTS: ---
;
;
;	
; KEYWORD PARAMETERS: ---
;
;
;
; OUTPUTS: Zeilenindex: klar!
;
;
;
; OPTIONAL OUTPUTS: ---
;
;
;
; COMMON BLOCKS: ---
;
;
;
; SIDE EFFECTS: ---
;
;
;
; RESTRICTIONS: Index sollte Integer sein, muß aber nicht!
;
;
;
; PROCEDURE: ---
;
;
;
; EXAMPLE: Bspl 1:	Print, LayerRow ( My_Layer, 5 )
;	   Bspl 2:	Print, LayerRow ( My_Layer, Layerindex( My_Layer, ROW=23, COL=17) )
;				-> Ausgabe: 23
;	   Bspl 3:	Print, LayerIndex ( My_Layer, ROW= 1 + LayerRow(My_Layer, My_Neuron), COL=LayerCol(My_Layer, My_Neuron) )
;				-> Liefert Index des Neurons "unterhalb" von My_Neuron.
;
;
;
; MODIFICATION HISTORY: Urversion, 25.7.1997, Rüdiger Kupper
;
;-

Function LayerRow, Layer, Index

	if Index ge LayerSize(Layer) then print, 'LayerRow WARNUNG: Layerindex ist zu groß!'
	
	return, Index mod Layer.h
	
end
