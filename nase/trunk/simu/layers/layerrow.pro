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
; CALLING SEQUENCE: Zeilenindex = LayerCol( {Layer | WIDTH ,HEIGHT} ,INDEX=Index_1D )
;
;
; 
; INPUTS: Layer   : eine mit InitLayer_? initialisierte Layer-Struktur
;	INDEX   : Der eindimensionale Index
;
;
; OPTIONAL INPUTS: WIDTH, HEIGHT, falls keine Layer-Struktur vorliegt
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
; EXAMPLE: Bspl 1:	Print, LayerRow ( My_Layer, INDEX=5 )
;	   Bspl 2:	Print, LayerRow ( My_Layer, INDEX=Layerindex( My_Layer, ROW=23, COL=17) )
;				-> Ausgabe: 23
;	   Bspl 3:	Print, LayerIndex ( My_Layer, ROW= 1 + LayerRow(My_Layer, INDEX=My_Neuron), COL=LayerCol(My_Layer, INDEX=My_Neuron) )
;				-> Liefert Index des Neurons "unterhalb" von My_Neuron.
;
;
;
; MODIFICATION HISTORY: Urversion, 25.7.1997, Rüdiger Kupper
;
;       Sun Aug 3 23:49:06 1997, Ruediger Kupper
;       <kupper@sisko.physik.uni-marburg.de>
;
;		WIDTH, HEIGHT zugefügt.
;
;-

Function LayerRow, Layer, _Index, INDEX=index, WIDTH=width, HEIGHT=height
   
        Default,  index, _Index
	if Index ge LayerSize(Layer, WIDTH=width, HEIGHT=height) then print, 'LayerRow WARNUNG: Layerindex ist zu groß!'
	
        if set(HEIGHT) then return, Index mod height
	return, Index mod Layer.h
	
end
