;+
; NAME:	LayerWidth()
;
; PURPOSE: liefert die Breite eines Layers (oder eines
;           mit einer DelayWeigh-Struktur verbundenen Layers) zur�ck 	
;
; CATEGORY: Basic
;
; CALLING SEQUENCE: Breite = LayerWidth( Struktur [,/SOURCE] [,/TARGET] )
;
; INPUTS: Struktur: Layer-Struktur ODER DW-Struktur
;
; KEYWORDS: Ist die �bergebene Struktur eine DW-Struktur, so mu� durch
;           setzen von SOURCE oder TARGET der betrachtete Layer
;           angegeben werden.
;
; OUTPUTS: Breite: Breite des Layers (Integer)
;
; EXAMPLE: klar!
;
; SEE ALSO: <A HREF="#LAYERHEIGHT">LayerHeight()</A>, <A HREF="#LAYERSIZE">LayerSize()</A>, 
;           <A HREF="#LAYERDATA">LayerData</A>,
;           <A HREF="#LAYERINDEX">LayerIndex()</A>, <A HREF="#LAYERROW">LayerRow()</A>, <A HREF="#LAYERCOL">LayerCol()</A>
;
; MODIFICATION HISTORY:
;
;       $Log$
;       Revision 2.2  1998/02/19 15:32:26  kupper
;              Es sollten jetzt alle Layer?-Funktionen mit Layer- und DW-Strukturen richtig funktionieren!
;
;       Revision 2.1  1998/01/28 16:19:08  kupper
;              Warjanuwohlschonlange�berf�llig...
;
;-

Function LayerWidth, Layer, SOURCE=source, TARGET=target

        If contains(info(Layer), 'LAYER', /IGNORECASE) then return, Layer.w

	If contains(info(Layer), 'DW', /IGNORECASE) then begin
           if Keyword_set(SOURCE) then return, DWDim(Layer, /SW)
           if Keyword_set(TARGET) then return, DWDim(Layer, /TW)
           message, "Structure is Delay-Weigh - Please define Layer by setting Keyword /SOURCE or /TARGET!"
        endif

end
