;+
; NAME:               NoisyRhythm
;
; PURPOSE:            Erzeugt fuer eine Layer einen rhythmischen Input, der auf 
;                     unterschiedliche Arten verrauscht werden. Der erste Aufruf
;                     initialisiert die Struktur, folgende Aufrufe liefern eine
;                     SSpass-Liste fuer den jeweils naechsten Zeitschritt zurueck.
;                     Das Rauschen ist nicht additiv, sondern verschiebt vielmehr
;                     die Feuerzeitpunkte individuell nach vorne oder hinten.
;
; CATEGORY:           INPUT
;
; CALLING SEQUENCE:   INITIALISIERUNG:    structure = NoisyRhythm([RATE=rate] 
;                                                     [,GAUSS=gauss] [,CONST=const]
;                                                     ( ,LAYER=Layer | ,WIDTH=width, HEIGHT=height )
;                     NORMAL:             input = NoisyRhythm(structure)
;
; INPUTS:             structure : eine Struktur, die Informationen ueber den Zustand 
;                                 des inputs enthaelt
;
; KEYWORD PARAMETERS: RATE  : die mittlere Rate in Hz, mit der die Neuronen feueren sollen
;                     GAUSS : gaussfoermiges Rauschen mit Amplitude GAUSS
;                     CONST : gleichfoermiges Rauschen mit Amplitude CONST
;                     LAYER : die Neuronenschicht, fuer die der Input erzeugt werden soll
;                     WIDTH ,
;                     HEIGHT: Hoehe und Breite der Schicht (nur erforderlich, wenn Layer
;                             nicht angegeben wurde)
;
; OUTPUTS:            structure : s.o.
;                     input     : eine SSpassListe, die die aktiven Neuronen fuer den
;                                 aktuellen Zeitschritt enthaelt.
;
; COMMON BLOCKS:      Common_Random
;
; EXAMPLE:
;                     InLayer = NoisyRhythm( RATE=40, GAUSS=0.5, WIDTH=10, HEIGHT=10)
;                     FOR t=0,10 DO BEGIN
;                        Input = NoisyRhythm(InLayer)
;                     END
;
; MODIFICATION HISTORY:
;
;     $Log$
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
                      WIDTH=width, HEIGHT=height

   COMMON Common_Random, seed
   
   ; initialization ??
   IF (N_Params() EQ 0) THEN BEGIN
      Default, rate, 40
      Default, gauss, 0.0


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
         sdev = gauss*LONG(1000./FLOAT(rate))
         type = 'Gauss'
      END
      IF Set(CONST) THEN BEGIN
         sdev = const*LONG(1000./FLOAT(rate))
         type =  'Const'
      END

      newInput =  { bins  : LONG(1000./FLOAT(rate)) ,$
                    sdev  : sdev                    ,$
                    size  : size                    ,$
                    time  : 0l                      ,$
                    spike : LonArr(size)            ,$
                    type  : type}

      RETURN, newInput
   END

   IF Keyword_Set(RATE) OR Keyword_Set(SDEV) OR Keyword_Set(LAYER) THEN Message, 'no Parameters allowed in this case'
   

   ; generate new spiketimes if needed
   IF (Input.time MOD Input.bins) EQ Input.bins/2 THEN BEGIN
      IF Input.type EQ 'Gauss' THEN Input.spike = Input.time + Input.bins/2 + Input.sdev*RandomN(seed, Input.size)
      IF Input.type EQ 'Const' THEN Input.spike = Input.time + Input.sdev*RandomU(seed, Input.size)
   END
   
   
   ; generate latest spikepattern as sparsearray
   firing = WHERE(Input.spike EQ Input.time, count)
   Input.time = Input.time + 1
   IF count NE 0 THEN BEGIN
      RETURN, [count, Input.size, firing]
   END ELSE BEGIN
      RETURN, [count, Input.size]
   END

END
