;+
; NAME:            LayerData
;
; PURPOSE:         Liefert Informationen �ber einen Layer zur�ck
;                  (s.u. OPTIONAL OUTPUTS)
; 
;                   F�r Breite und H�he des Layers stehen au�erdem die Funktionen
;                   <A HREF="#LAYERWIDTH">LayerWidth()</A> und <A HREF="#LAYERHEIGHT">LayerHeight()</A> zur Verf�gung,
;                   die ein klein wenig schneller sein d�rften, weil dort keine Arrays herumkopiert werden.
;
; CATEGORY:         SIMULATION LAYERS
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
; OPTIONAL OUTPUTS: Alle Daten werden in Schl�ssesworten
;                   zur�ckgegeben. 
;                 
;                   Type             : Der Neuronentyp (String)
;                   Width, Height    : Ausma�e des Layers (Integer)
;                   Parameters       : Parameter, wie mit InitPara erzeugt
;                   
;                   Feeding,
;                   Feeding1,
;                   Feeding2 
;                   Linking,
;                   Inhibition       : Stand der entsprechenden
;                                      Leckintegratoren (DoubleArray[HeightxWidth])
;                   Potential        : Membranpotentiale (DoubleArray[HeightxWidth])
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
;        Revision 2.5  1998/11/08 17:33:27  saam
;              + wrong procedure name LAYERDATATEST in last revision
;              + keywords INHIBITION[12], FEEDING[12] renamed to [FS]INHIBITITON,
;                [FS]FEEDING
;              + adapted to new layer definition
;
;        Revision 2.4  1998/11/05 18:07:35  niederha
;               funktioniert jetzt auch f�r Neuronentyp 7
;
;        Revision 2.3  1998/05/27 13:58:15  kupper
;               SCHWELLE2-Keyword aus gruenden eindeutiger Abkuerzung in
;                LSCHWELLE umbenannt.
;
;        Revision 2.2  1998/01/28 15:55:46  kupper
;               Nur Header-Kosmetik.
;
;        Revision 2.1  1998/01/28 15:50:02  kupper
;               Sch�pfung.
;
;-
PRO LayerData, _Layer, $
               TYPE=type, $
               WIDTH=width, HEIGHT=height, $
               PARAMETERS=parameters, $
               FEEDING=feeding, FFEEDING1=ffeeding, SFEEDING=sfeeding, LINKING=linking, INHIBITION=inhibition, $
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
   parameters = Layer.Para
   potential  = REFORM(Layer.M, Layer.H, Layer.W)


   ; handle FEEDING
   CASE Layer.TYPE OF
      '6' : feeding  = REFORM(Layer.para.corrAmpF*(Layer.F2-Layer.F1), Layer.H, Layer.W)
      '7' : BEGIN
               ffeeding = REFORM(Layer.F1, Layer.H, Layer.W)
               sfeeding = REFORM(Layer.F2, Layer.H, Layer.W)   
            END
      ELSE: feeding = REFORM(Layer.F, Layer.H, Layer.W)
   END   

   ; handle LINKING
   CASE Layer.TYPE OF
      '6' : linking = REFORM(Layer.para.corrAmpL*(Layer.L2-Layer.L1), Layer.H, Layer.W)
      ELSE: linking = REFORM(Layer.L, Layer.H, Layer.W)
   END   

   ; handle INHIBITION
   CASE Layer.TYPE OF
      '7' : BEGIN
               finhibition = REFORM(Layer.I1, Layer.H, Layer.W)
               sinhibition = REFORM(Layer.I2, Layer.H, Layer.W)
            END
      ELSE: inhibition = REFORM(Layer.I, Layer.H, Layer.W)
   END   


   ; handle THRESHOLD
   CASE Layer.TYPE OF
      '6' : schwelle = REFORM(Layer.R + Layer.S + Layer.Para.th0, Layer.H, Layer.W)
      ELSE: schwelle = REFORM(Layer.S, Layer.H, Layer.W)
   END

   ; handle SPECIAL TAGS
   IF Layer.Type EQ '2' THEN lschwelle     = Reform(Layer.R, Layer.H, Layer.W)
   IF Layer.Type EQ '3' THEN lernpotential = Reform(Layer.P, Layer.H, Layer.W)


   Handle_Value, _Layer, Layer, /NO_COPY, /SET
   output = LayerSpikes(_Layer, /DIMENSIONS)

;;;   output                                  = Out2Vector(Layer, /DIMENSIONS)
END



