;+
; NAME:            LayerData
;
; PURPOSE:         Liefert Informationen über einen Layer zurück
;                  (s.u. OPTIONAL OUTPUTS)
; 
;                   Für Breite und Höhe des Layers stehen außerdem die Funktionen
;                   <A HREF="#LAYERWIDTH">LayerWidth()</A> und <A HREF="#LAYERHEIGHT">LayerHeight()</A> zur Verfügung,
;                   die ein klein wenig schneller sein dürften, weil dort keine Arrays herumkopiert werden.
;
; CATEGORY:         SIMULATION / LAYERS
;
; CALLING SEQUENCE: LayerData, Layer 
;                              [,TYPE=Type]
;                              [,WIDTH=Width] [,HEIGHT=Height]
;                              [,PARAMETERS=Parameters] 
;                              [,FEEDING=Feeding] [,FEEDING1=Feeding1][,FEEDING2=Feeding2] [,LINKING=Linking] [,INHIBITION=Inhibition]
;                              [,POTENTIAL=Potential]
;                              [,SCHWELLE=schnelle_Schwelle] [,LSCHWELLE=langsame_Schwelle]
;                              [,LERNPOTENTIAL=Lernpotential]
;                              [,OUTPUT=Output]
;
; INPUTS:           Layer: Eine mit <A HREF="#INITLAYER>InitLayer</A> initialisierte NASE-Layer-Struktur
;
; OPTIONAL OUTPUTS: Alle Daten werden in Schlüssesworten
;                   zurückgegeben. 
;                 
;                   Type             : Der Neuronentyp (String)
;                   Width, Height    : Ausmaße des Layers (Integer)
;                   Parameters       : Parameter, wie mit InitPara erzeugt
;                   
;                   Feeding,
;                   Feeding1,
;                   Feeding2 
;                   Linking,
;                   Inhibition       : Stand der entsprechenden
;                                      Leckintegratoren (DoubleArray[HeightxWidth])
;                   Potential        : Membranpotentiale (DoubleArray[HeightxWidth])
;                                      für Layer, die aus Typ-8-Neuronen bestehen,
;                                      wird in POTENTIAL ein FltArr(width,height,5)
;                                      zurückgegeben, das die Potentiale aller 
;                                      Compartments und den Zustand der Recovery-
;                                      Variablen enthält:
;                                      Potential(*,*,0) = n  (Recovery) 
;                                      Potential(*,*,1) = Vs  (Soma)
;                                      Potential(*,*,2) = V3  (Dendrit 3) 
;                                      Potential(*,*,3) = V2  (Dendrit 2)
;                                      Potential(*,*,4) = V1  (Dendrit 1)
;
;                   schnelle_Schwelle,
;                   langsame_Schwelle: Stand der entsprechenden
;                                      Leckinteergratoren (DoubleArray[HeightxWidth])
;                   Lernpotential    : Lernpotentiale (DoubleArray[HeightxWidth])
;                   Output           : Output-Spikes (ByteArray[HeightxWidth])
;
;
; EXAMPLE:
;                    LP = InitPara_1()
;                    L = InitLayer(5,5,TYPE=LP)
;                    LayerData, L, FEEDING=MyFeeding, POTENTIAL=MyMembranpotential
;
; SEE ALSO:          <A HREF="#INITPARA_1">InitPara_i</A> (i=1..7), <A HREF="#INITLAYER">InitLayer</A>,  
;                    <A HREF="#INPUTLAYER">InputLayer</A>, <A HREF="#PROCEEDLAYER">ProceedLayer</A>,
;                    <A HREF="#LAYERWIDTH">LayerWidth</A>, <A HREF="#LAYERHEIGHT">LayerHeight</A>,  <A HREF="#LAYERSIZE">LayerSize</A>, 
;                    <A HREF="#OUT2VECTOR">Out2Vector()</A>
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 2.8  2000/06/06 15:02:33  alshaikh
;              new layertype 11
;
;        Revision 2.7  1999/03/08 10:04:51  thiel
;               Typ-8-Behandlung ergänzt.
;
;        Revision 2.6  1999/01/14 14:20:39  saam
;              + works now for one-neuron-layers, too
;
;        Revision 2.5  1998/11/08 17:33:27  saam
;              + wrong procedure name LAYERDATATEST in last revision
;              + keywords INHIBITION[12], FEEDING[12] renamed to [FS]INHIBITITON,
;                [FS]FEEDING
;              + adapted to new layer definition
;
;        Revision 2.4  1998/11/05 18:07:35  niederha
;               funktioniert jetzt auch für Neuronentyp 7
;
;        Revision 2.3  1998/05/27 13:58:15  kupper
;               SCHWELLE2-Keyword aus gruenden eindeutiger Abkuerzung in
;                LSCHWELLE umbenannt.
;
;        Revision 2.2  1998/01/28 15:55:46  kupper
;               Nur Header-Kosmetik.
;
;        Revision 2.1  1998/01/28 15:50:02  kupper
;               Schöpfung.
;
;-
PRO LayerData, _Layer, $
               TYPE=type, $
               WIDTH=width, HEIGHT=height, $
               PARAMETERS=parameters, $
               FEEDING=feeding, FFEEDING1=ffeeding, SFEEDING=sfeeding, LINKING=linking, ILINKING=ilinking, INHIBITION=inhibition, $
               FINHIBITION=finihibition, SINHIBITION=sinhibition,$
               POTENTIAL=potential, $
               SCHWELLE=schwelle, LSCHWELLE=lschwelle, $
               LERNPOTENTIAL=lernpotential, $
               OUTPUT=output

   TestInfo, _Layer, "Layer"
   Handle_Value, _Layer, Layer, /NO_COPY
   

   ; same for ALL TYPES
   type       = Layer.Type
   width      = Layer.W
   height     = Layer.H
   n = width*height
   parameters = Layer.Para


   ;--- handle Potential
   CASE layer.type OF
      '8' : IF n GT 1 THEN potential = Reform(layer.V, layer.h, layer.w, 5) $
                       ELSE potential = layer.V
      ELSE: IF n GT 1 THEN potential  = REFORM(Layer.M, Layer.H, Layer.W) $
                       ELSE potential = Layer.M
   ENDCASE


;---  handle FEEDING
   CASE Layer.TYPE OF
      '6' : IF n GT 1 THEN feeding  = REFORM(Layer.para.corrAmpF*(Layer.F2-Layer.F1), Layer.H, Layer.W) ELSE  feeding  = Layer.para.corrAmpF*(Layer.F2-Layer.F1)
      '7' : BEGIN
         IF n GT 1 THEN BEGIN
            ffeeding = REFORM(Layer.F1, Layer.H, Layer.W)
            sfeeding = REFORM(Layer.F2, Layer.H, Layer.W)   
         END ELSE BEGIN
            ffeeding = Layer.F1
            sfeeding = Layer.F2
         END
      END
      '8' : feeding = !NONE
      ELSE: IF n GT 1 THEN feeding = REFORM(Layer.F, Layer.H, Layer.W) ELSE feeding = Layer.F
   ENDCASE


;--- handle LINKING
   CASE Layer.TYPE OF
      '11': BEGIN 
         IF n GT 1 THEN linking = REFORM(Layer.L1, Layer.H, Layer.W) ELSE linking = Layer.Layer.L1
         IF n GT 1 THEN ilinking = REFORM(Layer.L2, Layer.H, Layer.W) ELSE ilinking = Layer.Layer.L2
      END 


      '6' : IF n GT 1 THEN linking = REFORM(Layer.para.corrAmpL*(Layer.L2-Layer.L1), Layer.H, Layer.W) ELSE linking = Layer.para.corrAmpL*(Layer.L2-Layer.L1)
      '8' : linking = !NONE
      ELSE: IF n GT 1 THEN linking = REFORM(Layer.L, Layer.H, Layer.W) ELSE linking = Layer.L
   ENDCASE
   

;--- handle INHIBITION
   CASE Layer.TYPE OF
      '7' : BEGIN
         IF n GT 1 THEN BEGIN 
            finhibition = REFORM(Layer.I1, Layer.H, Layer.W) 
            sinhibition = REFORM(Layer.I2, Layer.H, Layer.W)
         END ELSE BEGIN
            finhibition = Layer.I1 
            sinhibition = Layer.I2
         END
      END
      '8' : inhibition = !NONE
      ELSE: IF n GT 1 THEN inhibition = REFORM(Layer.I, Layer.H, Layer.W) ELSE inhibition = Layer.I
   ENDCASE
   

;--- handle THRESHOLD
   CASE Layer.TYPE OF
      '6' : IF n GT 1 THEN schwelle = REFORM(Layer.R + Layer.S + Layer.Para.th0, Layer.H, Layer.W) ELSE schwelle = Layer.R + Layer.S + Layer.Para.th0
      '8' : schwelle = !NONE
      ELSE: IF n GT 1 THEN schwelle = REFORM(Layer.S, Layer.H, Layer.W) ELSE schwelle = Layer.S
   ENDCASE


   ; handle SPECIAL TAGS
   IF Layer.Type EQ '2' THEN BEGIN
      IF n GT 1 THEN lschwelle = Reform(Layer.R, Layer.H, Layer.W) ELSE lschwelle = Layer.R
   END
   IF Layer.Type EQ '3' THEN BEGIN
      IF n GT 1 THEN lernpotential = Reform(Layer.P, Layer.H, Layer.W) ELSE lernpotential = Layer.P
   END

   Handle_Value, _Layer, Layer, /NO_COPY, /SET
   output = LayerSpikes(_Layer, /DIMENSIONS)

END



