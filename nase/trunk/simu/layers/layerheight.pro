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
;       Revision 2.4  1998/11/08 17:34:01  saam
;             adapted to new layer type
;
;       Revision 2.3  1998/02/19 15:32:26  kupper
;              Es sollten jetzt alle Layer?-Funktionen mit Layer- und DW-Strukturen richtig funktionieren!
;
;       Revision 2.2  1998/01/28 16:15:28  kupper
;              Warjanuwohlschonlangeüberfällig.
;
;
;-

FUNCTION LayerHeight, _L, SOURCE=source, TARGET=target

   ON_ERROR, 2

   Handle_Value, _L, L, /NO_COPY

   IF Contains(info(L), 'LAYER', /IGNORECASE) THEN h = L.h
   
   IF Contains(info(L), 'DW', /IGNORECASE) THEN BEGIN
      IF KEYWORD_SET(SOURCE) THEN h = DWDim(L, /SH)
      IF KEYWORD_SET(TARGET) THEN h = DWDim(L, /TH)
      MESSAGE, "Structure is Delay-Weigh - Please define Layer by setting Keyword /SOURCE or /TARGET!"
   ENDIF

   Handle_Value, _L, L, /NO_COPY, /SET
   RETURN, h

END
