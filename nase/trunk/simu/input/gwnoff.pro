;+
; NAME:               GwnOff
;
; PURPOSE:            Erzeugt fuer eine Layer einen konstanten, analogen Input, der  
;                     mit Gauss'schem Weissen Rauschen ueberlagert wird. Der Rueck- 
;                     gabewert ist ein Float-Array, das direkt an InputLayer_?
;                     uebergeben werden kann. 
;
; CATEGORY:           INPUT
;
; CALLING SEQUENCE:   Input = GwnOff( [Layer] ( ,LAYER=Layer | ,WIDTH=width, HEIGHT=height )
;                                     [, OFFSET=offset] [,DEVIATION=deviation]
;
; OPTIONAL INPUTS:    Layer    : die Neuronenschicht, fuer die der Input erzeugt werden soll
;
; KEYWORD PARAMETERS: LAYER    : die Neuronenschicht, fuer die der Input erzeugt werden soll
;                     WIDTH ,
;                     HEIGHT   : Hoehe und Breite der Schicht (nur erforderlich, wenn Layer
;                                nicht angegeben wurde)
;                     OFFSET   : der kontinuierliche, konstante Offset 
;                     DEVIATION: die Standardabweichung des weissen Rauschens
;
; OUTPUTS:            Input     : das Float-Array 
;
; COMMON BLOCKS:      Common_Random
;
; EXAMPLE:
;                     Input = GwnOff( WIDTH=10, HEIGHT=20, OFFSET=0.1, DEVIATION=0.01)
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 2.2  1997/11/11 16:05:22  saam
;           Doc-Header hatte kein '-'
;
;     Revision 2.1  1997/11/03 11:34:51  saam
;           Gefunden, angepasst und dokumentiert
;
;-

FUNCTION GwnOff, Layer, LAYER=klayer, WIDTH=width, HEIGHT=height, OFFSET=offset, DEVIATION=deviation

   COMMON Common_Random, seed


   IF Keyword_Set(KLAYER) THEN BEGIN
      w = KLayer.w
      h = KLayer.h
   END ELSE BEGIN
      IF N_Params() EQ 1 THEN BEGIN
         w = Layer.w
         h = Layer.h
      END ELSE IF Keyword_Set(WIDTH) AND Keyword_Set(HEIGHT) THEN BEGIN
         w = width
         h = height
      END ELSE BEGIN
         Message, 'LAYER or keywords WIDTH and HEIGHT must be set' 
      END
   END
   
   Default, offset, 0.0
   Default, deviation, 0.0
   
   signal = offset + deviation*RandomN(seed, w, h)
   
   RETURN, signal
   
END
