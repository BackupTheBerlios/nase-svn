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
;       Revision 2.3  1998/11/08 17:34:02  saam
;             adapted to new layer type
;
;       Revision 2.2  1998/02/19 15:32:26  kupper
;              Es sollten jetzt alle Layer?-Funktionen mit Layer- und DW-Strukturen richtig funktionieren!
;
;       Revision 2.1  1998/01/28 16:19:08  kupper
;              Warjanuwohlschonlangeüberfällig...
;
;-
FUNCTION LayerWidth, _L, SOURCE=source, TARGET=target

   ON_ERROR, 2

   Handle_Value, _L, L, /NO_COPY

   IF Contains(info(L), 'LAYER', /IGNORECASE) THEN w = L.w
   
   IF Contains(info(L), 'DW', /IGNORECASE) THEN BEGIN
      IF KEYWORD_SET(SOURCE) THEN w = DWDim(L, /SW)
      IF KEYWORD_SET(TARGET) THEN w = DWDim(L, /TW)
      MESSAGE, "Structure is Delay-Weigh - Please define Layer by setting Keyword /SOURCE or /TARGET!"
   ENDIF

   Handle_Value, _L, L, /NO_COPY, /SET
   RETURN, w

END
