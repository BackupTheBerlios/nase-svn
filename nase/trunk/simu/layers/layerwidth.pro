;+
; NAME:	LayerWidth()
;
; PURPOSE: liefert die Breite eines Layers (oder eines
;           mit einer DelayWeigh-Struktur verbundenen Layers) zurück 	
;
; CATEGORY: Basic
;
; CALLING SEQUENCE: Breite = LayerWidth( Struktur [,/SOURCE] [,/TARGET] )
;
; INPUTS: Struktur: Layer-Struktur ODER DW-Struktur
;
; KEYWORDS: Ist die übergebene Struktur eine DW-Struktur, so muß durch
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
;       Revision 2.1  1998/01/28 16:19:08  kupper
;              Warjanuwohlschonlangeüberfällig...
;
;-

Function LayerWidth, Layer, SOURCE=source, TARGET=target

        If contains(Layer.info, 'LAYER', /IGNORECASE) then return, Layer.w

	If contains(Layer.info, 'DW', /IGNORECASE) then begin
           if Keyword_set(SOURCE) then return, Layer.Source_w
           if Keyword_set(TARGET) then return, Layer.Target_w
           message, "Structure is Delay-Weigh - Please define Layer by setting Keyword /SOURCE or /TARGET!"
        endif

end
