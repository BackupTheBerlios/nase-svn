;+
; NAME:
;  LayerWidth()
;
; AIM:
;  Return width (the number of columns) of given layer. 
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
;       Revision 2.5  2000/09/28 13:05:26  thiel
;           Added types '9' and 'lif', also added AIMs.
;
;       Revision 2.4  1998/11/09 13:44:21  saam
;            never worked with a delayweigh-structure!
;
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
FUNCTION LayerWidth, L, SOURCE=source, TARGET=target

   ON_ERROR, 2


   IF Contains(info(L), 'LAYER') THEN BEGIN
      Handle_Value, L, Ltmp, /NO_COPY
      w = Ltmp.w
      Handle_Value, L, Ltmp, /NO_COPY, /SET
   END
   
   IF Contains(info(L), 'DW') THEN BEGIN
      IF KEYWORD_SET(SOURCE) THEN w = DWDim(L, /SW)
      IF KEYWORD_SET(TARGET) THEN w = DWDim(L, /TW)
      IF NOT SET(w) THEN MESSAGE, "Structure is Delay-Weigh - Please define Layer by setting Keyword /SOURCE or /TARGET!"
   ENDIF

   RETURN, w

END
