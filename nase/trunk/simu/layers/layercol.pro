;+
; NAME: LayerCol()
;
;
;
; PURPOSE: Liefert zum eindimensionalen Layerindex (Entsprechend den Arrays in der Layer-Struktur) den
;	   zweidimensionalen Spaltenindex.
;
;          Diese Funtion bildet zusammen mit LayerRow() das Gegenstück zu LayerIndex().
;
;	   Die Umrechnung ist kompatibel zur IDL-Funktion REFORM().
;
; CATEGORY: Simulation, Basic
;
;
;
; CALLING SEQUENCE: Spaltenindex = LayerCol( Layer, Index_1D [,WIDTH ,HEIGHT] )
;
;
; 
; INPUTS: Layer   : eine mit InitLayer_? initialisierte Layer-Struktur
;	  Index_1D: Der eindimensionale Index
;
;
; OPTIONAL INPUTS: WIDTH, HEIGHT: Falls keine Layerstruktur vorliegt.
;
;
;	
; KEYWORD PARAMETERS: ---
;
;
;
; OUTPUTS: Spaltenindex: klar!
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
; EXAMPLE: Bspl 1:	Print, LayerCol ( My_Layer, 5 )
;	   Bspl 2:	Print, LayerCol ( My_Layer, Layerindex( My_Layer, ROW=23, COL=17) )
;				-> Ausgabe: 17
;	   Bspl 3:	Print, LayerIndex ( My_Layer, ROW=LayerRow(My_Layer, My_Neuron), COL= 1 + LayerCol(My_Layer, My_Neuron) )
;				-> Liefert Index des "rechten Nachbarn" von My_Neuron.
;
;
;
; MODIFICATION HISTORY: Urversion, 25.7.1997, Rüdiger Kupper
;
;       Sun Aug 3 23:38:48 1997, Ruediger Kupper
;       <kupper@sisko.physik.uni-marburg.de>
;
;		Optionale Keywords WIDTH,HEIGHT zugefügt.
;
;-

Function LayerCol, Layer, Index, WIDTH=width, HEIGHT=height

	if Index ge LayerSize(Layer) then print, 'LayerCol WARNUNG: Layerindex ist zu groß!'
	
        if set(HEIGHT) then return,  fix(Index) / fix(height)
	return, fix(Index) / fix(Layer.h)
	
end
