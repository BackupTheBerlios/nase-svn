;+
; NAME:	LayerSize()
;
; PURPOSE: liefert die Gesamtneuronenzahl eines Layers (oder eines
;           mit einer DelayWeigh-Struktur verbundenen Layers) zurück 	
;
; CATEGORY: Basic
;
; CALLING SEQUENCE: Neuronenzahl = LayerSize( { Struktur [,/SOURCE] [,/TARGET] | WIDTH, HEIGHT} )
;
; INPUTS: Struktur: Layer-Struktur ODER DW-Struktur
;
; KEYWORDS: Ist die übergebene Struktur eine DW-Struktur, so muß durch
;           setzen von SOURCE oder TARGET der betrachtete Layer
;           angegeben werden.
;
; OPTIONAL INPUTS: WIDTH, HEIGHT, falls gar keine Struktur vorliegt.
;
; OUTPUTS: klar!
;
; EXAMPLE: klar!
;
; MODIFICATION HISTORY: erstellt am 24.7.1997, Rüdiger Kupper
;
;       $Log$
;       Revision 1.3  1997/11/08 14:35:16  kupper
;              Die layer...-Routinen können nun auch auf
;               DW-Strukturen angewandt werden.
;
;
;       Sun Aug 3 23:48:12 1997, Ruediger Kupper
;       <kupper@sisko.physik.uni-marburg.de>
;
;		WIDTH, HEIGHT zugefügt.
;
;-

Function LayerSize, Layer, WIDTH=width, HEIGHT=height, SOURCE=source, TARGET=target

        if not set(Layer) then return, width * height

        If contains(Layer.info, 'LAYER', /IGNORECASE) then return, Layer.w * Layer.h

	If contains(Layer.info, 'DW', /IGNORECASE) then begin
           if Keyword_set(SOURCE) then return, Layer.Source_w * Layer.Source_h
           if Keyword_set(TARGET) then return, Layer.Target_w * Layer.Target_h
           message, "Structure is Delay-Weigh - Please define Layer by setting Keyword /SOURCE or /TARGET!"
        endif

end
