;+
; NAME: LayerCol()
;
; PURPOSE: Liefert zum eindimensionalen Layerindex (Entsprechend den Arrays in der Layer-Struktur) den
;	   zweidimensionalen Spaltenindex.
;
;          Diese Funktion bildet zusammen mit LayerRow() das Gegenst�ck zu LayerIndex().
;
;	   Die Umrechnung ist kompatibel zur IDL-Funktion REFORM().
;
; CATEGORY: Simulation, Basic
;
; CALLING SEQUENCE: Spaltenindex = LayerCol( {Struktur [,/SOURCE] [,/TARGET] | WIDTH ,HEIGHT} ,INDEX=Index_1D  )
;
; INPUTS: Struktur   : eine mit InitLayer_? initialisierte Layer-Struktur
;                      ODER eine mit InitDW initialisierte DW-Struktur
;	INDEX   : Der eindimensionale Index
;
; KEYWORDS: Ist die �bergebene Struktur eine DW-Struktur, so mu� durch
;           setzen von SOURCE oder TARGET der betrachtete Layer
;           angegeben werden.
;
; OPTIONAL INPUTS: WIDTH, HEIGHT: Falls gar keine Struktur vorliegt.
;
; OUTPUTS: Spaltenindex: klar!
;
; RESTRICTIONS: Index sollte Integer sein, mu� aber nicht!
;
; EXAMPLE: Bspl 1:	Print, LayerCol ( My_Layer, INDEX=5 )
;	   Bspl 2:	Print, LayerCol ( My_Layer, INDEX=Layerindex( My_Layer, ROW=23, COL=17) )
;				-> Ausgabe: 17
;	   Bspl 3:	Print, LayerIndex ( My_Layer, ROW=LayerRow(My_Layer, INDEX=My_Neuron), COL= 1 + LayerCol(My_Layer, INDEX=My_Neuron) )
;				-> Liefert Index des "rechten Nachbarn" von My_Neuron.
;
; MODIFICATION HISTORY: Urversion, 25.7.1997, R�diger Kupper
;
;       $Log$
;       Revision 1.4  1997/11/08 14:35:14  kupper
;              Die layer...-Routinen k�nnen nun auch auf
;               DW-Strukturen angewandt werden.
;
;
;       Sun Aug 3 23:38:48 1997, Ruediger Kupper
;       <kupper@sisko.physik.uni-marburg.de>
;
;		Optionale Keywords WIDTH,HEIGHT zugef�gt.
;
;-

Function LayerCol, Layer, _Index, INDEX=index, WIDTH=width, HEIGHT=height, SOURCE=source, TARGET=target

        Default,  index,  _Index
	if Index ge LayerSize(Layer, WIDTH=width, HEIGHT=height, SOURCE=source, TARGET=target) then message, 'Layerindex ist zu gro�!'
	
        if set(HEIGHT) then return,  fix(Index) / fix(height)

        if contains(Layer.info, 'LAYER', /IGNORECASE) then return, fix(Index) / fix(Layer.h)

	if contains(Layer.info, 'DW', /IGNORECASE) then begin
            if Keyword_set(SOURCE) then return, fix(Index) / fix(Layer.Source_h)
            if Keyword_set(TARGET) then return, fix(Index) / fix(Layer.Target_h)
            message, "Structure is Delay-Weigh - Please define Layer by setting Keyword /SOURCE or /TARGET!"
        endif
    
end
