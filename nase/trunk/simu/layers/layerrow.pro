;+
; NAME: LayerRow()
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
; CALLING SEQUENCE: Zeilenindex = LayerCol( {Struktur [,/SOURCE] [,/TARGET] | WIDTH ,HEIGHT} ,INDEX=Index_1D )
;
; INPUTS: Struktur   : eine mit InitLayer_? initialisierte Layer-Struktur
;                      ODER eine mit InitDW initialisierte DW-Struktur
;	INDEX   : Der eindimensionale Index
;
; KEYWORDS: Ist die übergebene Struktur eine DW-Struktur, so muß durch
;           setzen von SOURCE oder TARGET der betrachtete Layer
;           angegeben werden.
;
; OPTIONAL INPUTS: WIDTH, HEIGHT, falls keine Layer-Struktur vorliegt
;
; OUTPUTS: Zeilenindex: klar!
;
; RESTRICTIONS: Index sollte Integer sein, muß aber nicht!
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
;       $Log$
;       Revision 1.3  1997/11/08 14:35:16  kupper
;              Die layer...-Routinen können nun auch auf
;               DW-Strukturen angewandt werden.
;
;
;       Sun Aug 3 23:49:06 1997, Ruediger Kupper
;       <kupper@sisko.physik.uni-marburg.de>
;
;		WIDTH, HEIGHT zugefügt.
;
;-

Function LayerRow, Layer, _Index, INDEX=index, WIDTH=width, HEIGHT=height, SOURCE=source, TARGET=target
   
        Default,  index, _Index
	if Index ge LayerSize(Layer, WIDTH=width, HEIGHT=height, SOURCE=source, TARGET=target) then print, 'LayerRow WARNUNG: Layerindex ist zu groß!'
	
        if set(HEIGHT) then return, Index mod height
	
        if contains(Layer.info, 'LAYER', /IGNORECASE) then return, Index mod Layer.h

	if contains(Layer.info, 'DW', /IGNORECASE) then begin
            if Keyword_set(SOURCE) then return, Index mod Layer.Source_h
            if Keyword_set(TARGET) then return, Index mod Layer.Target_h
            message, "Structure is Delay-Weigh - Please define Layer by setting Keyword /SOURCE or /TARGET!"
        endif
	
end
