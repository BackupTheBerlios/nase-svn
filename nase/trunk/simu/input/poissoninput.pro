;+
; NAME:              PoissonInput
;
; PURPOSE:           Erzeugt poissonverteilte Spiketrains einer mittleren
;                    Rate als Input fuer eine Layer oder eine DW-Struktur.
;
; CATEGORY:          INPUT STAT
;
; CALLING SEQUENCE:  p = PoissonInput( {Layer, | LAYER=Layer | WIDTH=width, HEIGHT=height }
;                                  [,RATE=rate] [,OVERSAMP=oversamp])
;
; INPUTS:            Layer : die Neuronenschicht, fuer die der Input erzeugt werden soll oder
;                            die den Ouput erzeugt
;
; KEYWORD PARAMETERS  LAYER   : die Neuronenschicht, fuer die der Input erzeugt werden soll
;                               oder die den Ouput erzeugt
;                     WIDTH ,
;                     HEIGHT  : Hoehe und Breite der Schicht (nur erforderlich, wenn Layer
;                               nicht angegeben wurde)
;                     RATE    : die mittlere Feuerrate pro Neuron (Default: 40Hz)
;                     OVERSAMP: der Oversamplingfaktor der verwendeten Neuronen (Default: 1)
;                     V       : ist Option gesetzt wird statt einem SSpassarray ein normales
;                               Array zurueckgegeben, wobei die Aktionspotentiale Amplitude V
;                               haben.
;                     NOSPASS : es wird eine normales Array zurueckgegeben
;
; OUTPUTS:            V gesetzt: 
;                          p: Spass-Array, das Aktionspotentiale mit Amplitude V enthaelt. Dies 
;                             ist zur Weiterverarbeitung mit InputLayer_? gedacht.
;                     V NICHT gesetzt:
;                          p: SSpass-Array mit Aktionspotentialen zur Weiterverarbeitung mit
;                             DelayWeigh
;                     V beliebig, NOSPASS gesetzt:
;                          p: Array mit Aktionspotentialen der Amplitude V (oder 1.0)
; 
; COMMON BLOCKS:      Common_Random
;
; EXAMPLE:            
;                     sa = BytArr(200,1000)
;                     FOR t=0,999 DO sa(*,t) = PoissonInput(WIDTH=200, HEIGHT=1, RATE=40, /NOSPASS)
;                     plottvscl, transpose(sa), XTITLE='t [ms]', ytitle='Neuron #'    
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 2.2  1998/03/03 18:00:38  saam
;           little bug
;
;     Revision 2.1  1998/03/03 17:27:37  saam
;           schwere Geburt, simple Funktion
;
;
;-
FUNCTION PoissonInput, Layer, LAYER=klayer, WIDTH=width, HEIGHT=height, RATE=rate, OVERSAMP=oversamp, $
                       V=v, NOSPASS=nospass

   COMMON Common_Random, seed

   IF NOT Set(v) THEN sspass = 1 ELSE sspass = 0
   Default, rate    , 40.0
   Default, oversamp,  1
   default, v       ,  1.0

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

   p = rate/FLOAT(1000*OverSamp)
   
   vec = RandomU(seed, w, h) LE p
   IF Keyword_Set(NOSPASS) THEN RETURN, vec*v
   IF sspass THEN RETURN, SSpassmacher(vec) ELSE RETURN, Spassmacher(vec*v)
END
