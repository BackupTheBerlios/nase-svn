;+
; NAME:               NoisyRhythm
;
; PURPOSE:            Erzeugt fuer eine Layer einen rhythmischen Input, der auf 
;                     unterschiedliche Arten verrauscht werden. Der erste Aufruf
;                     initialisiert die Struktur, folgende Aufrufe liefern eine
;                     Spass-Liste fuer den jeweils naechsten Zeitschritt zurueck.
;                     Das Rauschen ist nicht additiv, sondern verschiebt vielmehr
;                     die Feuerzeitpunkte individuell nach vorne oder hinten.
;
; CATEGORY:           INPUT
;
; CALLING SEQUENCE:   INITIALISIERUNG:    structure = NoisyRhythm([RATE=rate] 
;                                                     [,GAUSS=gauss] [,CONST=const]
;                                                     { ,LAYER=Layer | ,WIDTH=width, HEIGHT=height }
;                                                     [,RANDOM=random], [OVERSAMP=oversamp])
;                     NORMAL:             input = NoisyRhythm(structure)
;
; INPUTS:             structure : eine Struktur, die Informationen ueber den Zustand 
;                                 des inputs enthaelt
;
; KEYWORD PARAMETERS: V     : die Amplitude mit der Pulse erzeugt werden (default: 1.0)
;                     RATE  : die mittlere Rate in Hz, mit der die Neuronen feueren sollen
;                     GAUSS : gaussfoermiges Rauschen mit Amplitude GAUSS
;                     CONST : gleichfoermiges Rauschen mit Amplitude CONST
;                     LAYER : die Neuronenschicht, fuer die der Input erzeugt werden soll
;                     WIDTH ,
;                     HEIGHT: Hoehe und Breite der Schicht (nur erforderlich, wenn Layer
;                             nicht angegeben wurde)
;                     RANDOM: Ist dieses Keyword gesetzt, werden die Pulse stochastisch
;                             mit folgenden Nebenbedingungen ausgeloest:
;                               Puls bei tp:  tp+1000/Rate <= naechster Puls <= tp+1000/Rate + Random
;                     OVERSAMP: Beruecksichtigt 1 BIN != 1 ms bei Berechnung der Raten...
;                            
;
; OUTPUTS:            structure : s.o.
;                     input     : eine SpassListe, die die aktiven Pulswerte fuer den
;                                 aktuellen Zeitschritt enthaelt.
;
; COMMON BLOCKS:      Common_Random
;
; EXAMPLE:
;                     InLayer = NoisyRhythm( V=1, RATE=40, GAUSS=0.5, WIDTH=10, HEIGHT=10)
;                     FOR t=0,10 DO BEGIN
;                        Input = NoisyRhythm(InLayer)
;                        ;dann z.B.: InputLayer, L1, FEEDING=Input
;                     END
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 2.6  1998/01/28 12:28:14  saam
;           cares about oversampling by new keyword OVERSAMP
;
;     Revision 2.5  1998/01/21 22:11:50  saam
;           Erzeugt nun Spass- statt SSpass-Liste
;           Neue Keywords
;
;     Revision 2.4  1997/12/02 11:31:22  saam
;           Leider hat Revision 2.3 entgegen Docu und Modification-
;           History doch noch die SDev mit der Rate multipliziert.
;           Jetzt ist das endlich behoben.
;
;     Revision 2.3  1997/11/26 09:30:25  saam
;           Rauschamplitude wird nun nicht mehr mit der Rate multipliziert
;
;     Revision 2.2  1997/10/29 09:13:41  saam
;           Set statt Keyword_Set
;           Bug beim gleichverteilten Rauschen korrigiert
;
;     Revision 2.1  1997/10/28 14:54:46  saam
;           vom Himmel gefallen
;
;
;-
FUNCTION NoisyRhythm, Input, RATE=rate, GAUSS=gauss, CONST=const, LAYER=layer, $ 
                      WIDTH=width, HEIGHT=height, RANDOM=random, V=v, OVERSAMP=oversamp

   COMMON Common_Random, seed
   
   ; initialization ??
   IF (N_Params() EQ 0) THEN BEGIN
      Default, rate, 40
      Default, gauss, 0.0
      Default, v, 1.0
      Default, oversamp, 1.

 

      IF Keyword_Set(LAYER) THEN BEGIN
         size = Layer.w * Layer.h
      END ELSE BEGIN
         IF Keyword_Set(WIDTH) AND Keyword_Set(HEIGHT) THEN BEGIN
            size = width*height
         END ELSE BEGIN
            Message, 'LAYER or keywords WIDTH and HEIGHT must be set' 
         END
      END
      
      IF Set(GAUSS) THEN BEGIN
         sdev = gauss
         type = 'Gauss'
      END
      IF Set(CONST) THEN BEGIN
         sdev = const
         type =  'Const'
      END
      IF Set(RANDOM) THEN rand = random ELSE rand = 0

      newInput =  { bins  : LONG(1000.*oversamp/FLOAT(rate)) ,$
                    sdev  : sdev*oversamp                    ,$
                    size  : size                             ,$
                    time  : 0l                               ,$
                    spike : LonArr(size)                     ,$
                    next  : LONG(1000.*oversamp/FLOAT(rate)) ,$ ; time of next burst for random
                    type  : type                             ,$
                    rand  : rand                             ,$
                    v     : v                                 }

      RETURN, newInput
   END

   IF Keyword_Set(RATE) OR Keyword_Set(SDEV) OR Keyword_Set(LAYER) THEN Message, 'no Parameters allowed in this case'
   

   ; generate new spiketimes if needed
   IF Input.rand THEN BEGIN
      IF (Input.time GE Input.next) THEN BEGIN
         IF Input.type EQ 'Gauss' THEN Input.spike = Input.time + Input.bins/2 + Input.sdev*RandomN(seed, Input.size)
         IF Input.type EQ 'Const' THEN Input.spike = Input.time + Input.sdev*RandomU(seed, Input.size)
         Input.next = Input.time + Input.bins + Input.rand*(RandomU(seed,1))(0)
      END
   END ELSE BEGIN
      IF (Input.time MOD Input.bins) EQ Input.bins/2 THEN BEGIN
         IF Input.type EQ 'Gauss' THEN Input.spike = Input.time + Input.bins/2 + Input.sdev*RandomN(seed, Input.size)
         IF Input.type EQ 'Const' THEN Input.spike = Input.time + Input.sdev*RandomU(seed, Input.size)
      END
   END
   
   ; generate latest spikepattern as sparsearray
   firing = WHERE(Input.spike EQ Input.time, count)
   Input.time = Input.time + 1

   ;
   vector = FltArr(Input.size)
   IF count NE 0 THEN vector(firing) = Input.v

   RETURN, Spassmacher(vector)

END
