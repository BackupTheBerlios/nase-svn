;+
; NAME:	LayerHeight()
;
; PURPOSE: liefert die Höhe eines Layers (oder eines
;           mit einer DelayWeigh-Struktur verbundenen Layers) zurück 	
;
; CATEGORY: Basic
;
; CALLING SEQUENCE: Höhe = LayerHeight( Struktur [,/SOURCE] [,/TARGET] )
;
; INPUTS: Struktur: Layer-Struktur ODER DW-Struktur
;
; KEYWORDS: Ist die übergebene Struktur eine DW-Struktur, so muß durch
;           setzen von SOURCE oder TARGET der betrachtete Layer
;           angegeben werden.
;
; OUTPUTS: Höhe: Höhe des Layers (Integer)
;
; EXAMPLE: klar!
;
; SEE ALSO: <A HREF="#LAYERWIDTH">LayerWidth()</A>, <A HREF="#LAYERSIZE">LayerSize()</A>, 
;           <A HREF="#LAYERDATA">LayerData</A>,
;           <A HREF="#LAYERINDEX">LayerIndex()</A>, <A HREF="#LAYERROW">LayerRow()</A>, <A HREF="#LAYERCOL">LayerCol()</A>
;
; MODIFICATION HISTORY:
;
;       $Log$
;       Revision 2.3  1998/02/19 15:32:26  kupper
;              Es sollten jetzt alle Layer?-Funktionen mit Layer- und DW-Strukturen richtig funktionieren!
;
;       Revision 2.2  1998/01/28 16:15:28  kupper
;              Warjanuwohlschonlangeüberfällig.
;
;
;-

Function LayerHeight, Layer, SOURCE=source, TARGET=target

        If contains(info(Layer), 'LAYER', /IGNORECASE) then return, Layer.h

	If contains(info(Layer), 'DW', /IGNORECASE) then begin
           if Keyword_set(SOURCE) then return, DWDim(Layer, /SH)
           if Keyword_set(TARGET) then return, DWDim(Layer, /TH)
           message, "Structure is Delay-Weigh - Please define Layer by setting Keyword /SOURCE or /TARGET!"
        endif

end
