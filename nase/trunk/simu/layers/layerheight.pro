;+
; NAME:	LayerHeight()
;
; PURPOSE: liefert die H�he eines Layers (oder eines
;           mit einer DelayWeigh-Struktur verbundenen Layers) zur�ck 	
;
; CATEGORY: Basic
;
; CALLING SEQUENCE: H�he = LayerHeight( Struktur [,/SOURCE] [,/TARGET] )
;
; INPUTS: Struktur: Layer-Struktur ODER DW-Struktur
;
; KEYWORDS: Ist die �bergebene Struktur eine DW-Struktur, so mu� durch
;           setzen von SOURCE oder TARGET der betrachtete Layer
;           angegeben werden.
;
; OUTPUTS: H�he: H�he des Layers (Integer)
;
; EXAMPLE: klar!
;
; MODIFICATION HISTORY:
;
;       $Log$
;       Revision 2.1  1998/01/28 16:04:07  kupper
;       *** empty log message ***
;
;-

Function LayerHeight, Layer, SOURCE=source, TARGET=target

        If contains(Layer.info, 'LAYER', /IGNORECASE) then return, Layer.h

	If contains(Layer.info, 'DW', /IGNORECASE) then begin
           if Keyword_set(SOURCE) then return, Layer.Source_h
           if Keyword_set(TARGET) then return, Layer.Target_h
           message, "Structure is Delay-Weigh - Please define Layer by setting Keyword /SOURCE or /TARGET!"
        endif

end
