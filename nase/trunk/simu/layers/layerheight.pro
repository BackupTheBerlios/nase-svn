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
;       Revision 2.5  1998/11/09 13:44:22  saam
;            never worked with a delayweigh-structure!
;
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

FUNCTION LayerHeight, L, SOURCE=source, TARGET=target

   ON_ERROR, 2

   IF Contains(info(L), 'LAYER') THEN BEGIN
      Handle_Value, L, Ltmp, /NO_COPY
      h = Ltmp.h
      Handle_Value, L, Ltmp, /NO_COPY, /SET
   END

   IF Contains(info(L), 'DW') THEN BEGIN
      IF KEYWORD_SET(SOURCE) THEN h = DWDim(L, /SH)
      IF KEYWORD_SET(TARGET) THEN h = DWDim(L, /TH)
      IF NOT SET(h) THEN MESSAGE, "Structure is Delay-Weigh - Please define Layer by setting Keyword /SOURCE or /TARGET!"
   ENDIF

   RETURN, h
END
