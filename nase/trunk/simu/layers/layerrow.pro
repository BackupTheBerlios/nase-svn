;+
; NAME:
;  LayerRow()
;
; AIM:
;  Return row number of neuron in layer given neuron's onedimensional index.
;  
; PURPOSE: Liefert zum eindimensionalen Layerindex (Entsprechend den Arrays in der Layer-Struktur) den
;	   zweidimensionalen Zeilenindex.
;
;          Diese Funtion bildet zusammen mit LayerCol() das Gegenst�ck zu LayerIndex().
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
; KEYWORDS: Ist die �bergebene Struktur eine DW-Struktur, so mu� durch
;           setzen von SOURCE oder TARGET der betrachtete Layer
;           angegeben werden.
;
; OPTIONAL INPUTS: WIDTH, HEIGHT, falls keine Layer-Struktur vorliegt
;
; OUTPUTS: Zeilenindex: klar!
;
; RESTRICTIONS: Index sollte Integer sein, mu� aber nicht!
;
; EXAMPLE: Bspl 1:	Print, LayerRow ( My_Layer, INDEX=5 )
;	   Bspl 2:	Print, LayerRow ( My_Layer, INDEX=Layerindex( My_Layer, ROW=23, COL=17) )
;				-> Ausgabe: 23
;	   Bspl 3:	Print, LayerIndex ( My_Layer, ROW= 1 + LayerRow(My_Layer, INDEX=My_Neuron), COL=LayerCol(My_Layer, INDEX=My_Neuron) )
;				-> Liefert Index des Neurons "unterhalb" von My_Neuron.
;
;
;
; MODIFICATION HISTORY: Urversion, 25.7.1997, R�diger Kupper
;
;       $Log$
;       Revision 1.6  2000/09/28 13:05:26  thiel
;           Added types '9' and 'lif', also added AIMs.
;
;       Revision 1.5  1998/05/16 16:01:50  kupper
;              Verarbeiten nun auch Arrays von Indizes...
;
;       Revision 1.4  1998/02/19 15:32:26  kupper
;              Es sollten jetzt alle Layer?-Funktionen mit Layer- und DW-Strukturen richtig funktionieren!
;
;       Revision 1.3  1997/11/08 14:35:16  kupper
;              Die layer...-Routinen k�nnen nun auch auf
;               DW-Strukturen angewandt werden.
;
;
;       Sun Aug 3 23:49:06 1997, Ruediger Kupper
;       <kupper@sisko.physik.uni-marburg.de>
;
;		WIDTH, HEIGHT zugef�gt.
;
;-

Function LayerRow, Layer, _Index, INDEX=index, WIDTH=width, HEIGHT=height, SOURCE=source, TARGET=target
   
        Default,  index, _Index
	if total(Index ge LayerSize(Layer, WIDTH=width, HEIGHT=height, SOURCE=source, TARGET=target)) gt 0 then message, 'Layerindex ist zu gro�!'
	
        if set(HEIGHT) then return, Index mod height
	
;        if contains(Layer.info, 'LAYER', /IGNORECASE) then return, Index mod Layer.h

;	if contains(Layer.info, 'DW', /IGNORECASE) then begin
;            if Keyword_set(SOURCE) then return, Index mod Layer.Source_h
;            if Keyword_set(TARGET) then return, Index mod Layer.Target_h
;            message, "Structure is Delay-Weigh - Please define Layer by setting Keyword /SOURCE or /TARGET!"
;        endif

;Das sollte mit dem richtig funktionierenden LayerHeight hoffentlich
;so gehen:
   return,  Index mod LayerHeight(Layer, SOURCE=SOURCE, TARGET=TARGET)
	
end
