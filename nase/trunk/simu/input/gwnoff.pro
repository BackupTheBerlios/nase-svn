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
; CALLING SEQUENCE:   Input = GwnOff( [Layer] { ,LAYER=Layer | ,WIDTH=width, HEIGHT=height }
;                                     [, OFFSET=offset] [,DEVIATION=deviation] [,NORM=norm])
;
; OPTIONAL INPUTS:    Layer    : die Neuronenschicht, fuer die der Input erzeugt werden soll
;
; KEYWORD PARAMETERS: LAYER    : die Neuronenschicht, fuer die der Input erzeugt werden soll
;                     WIDTH ,
;                     HEIGHT   : Hoehe und Breite der Schicht (nur erforderlich, wenn Layer
;                                nicht angegeben wurde)
;                     OFFSET   : der kontinuierliche, konstante Offset 
;                     DEVIATION: die Standardabweichung des weissen Rauschens
;                     NORM     : multipliziert das Ergebnis mit dem Faktor Norm
;                     NOSPASS  : normalerweise wird ein Spassarray zurueckgegeben, mit dieser 
;                                Option wird ein normales Array zurueckgegeben
;
; OUTPUTS:            Input     : das (Spass)-Array 
;
; COMMON BLOCKS:      Common_Random
;
; EXAMPLE:
;                     Input = GwnOff( WIDTH=10, HEIGHT=20, OFFSET=0.1, DEVIATION=0.01)
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 2.5  1998/03/03 17:09:38  saam
;           new Keyword NOSPASS
;
;     Revision 2.4  1998/01/28 12:25:19  saam
;           new keyword NORM
;
;     Revision 2.3  1997/11/14 16:37:01  saam
;           Rueckgabewert nun SpassVector
;
;     Revision 2.2  1997/11/11 16:05:22  saam
;           Doc-Header hatte kein '-'
;
;     Revision 2.1  1997/11/03 11:34:51  saam
;           Gefunden, angepasst und dokumentiert
;
;-

FUNCTION GwnOff, Layer, LAYER=klayer, WIDTH=width, HEIGHT=height, OFFSET=offset, DEVIATION=deviation,$
                 NORM=NORM, NOSPASS=NOSPASS

   COMMON Common_Random, seed

   Default, NORM, 1.0

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

   signal = norm*(offset + deviation*RandomN(seed, w, h))
   
   IF NOT Keyword_Set(NOSPASS) THEN RETURN, SpassMacher(signal) ELSE RETURN, signal
   
END
