;+
; NAME: LayerData
;
; PURPOSE: Liefert Informationen über einen Layer zurück
;          (s.u. OPTIONAL OUTPUTS)
; 
;          Für Breite und Höhe des Layers stehen außerdem die Funktionen
;          <A HREF="#LAYERWIDTH">LayerWidth()</A> und <A HREF="#LAYERHEIGHT">LayerHeight()</A> zur Verfügung,
;          die ein klein wenig schneller sein dürften, weil dort keine Arrays herumkopiert werden.
;
; CATEGORY: Simulation
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
; INPUTS: Layer: Eine initialisierte NASE-Layer-Struktur
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
;                   schnelle_Schwelle,
;                   langsame_Schwelle: Stand der entsprechenden
;                                      Leckinteergratoren (DoubleArray[HeightxWidth])
;                   Lernpotential    : Lernpotentiale (DoubleArray[HeightxWidth])
;                   Output           : Output-Spikes (ByteArray[HeightxWidth])
;
;
; EXAMPLE: LayerData ( FEEDING=MyFeeding, POTENTIAL=MyMembranpotential )
;
; SEE ALSO: <A HREF="#INITLAYER_1">InitLayer_1()</A>,  <A HREF="#INITLAYER_2">InitLayer_2()</A>,  <A HREF="#INITLAYER_3">InitLayer_3()</A>, 
;           <A HREF="#INITPARA_1">InitPara_1()</A>,   <A HREF="#INITPARA_2">InitPara_2()</A>,   <A HREF="#INITPARA_3">InitPara_3()</A>,  
;           <A HREF="#LAYERWIDTH">LayerWidth()</A>,   <A HREF="#LAYERHEIGHT">LayerHeight()</A>,  <A HREF="#LAYERSIZE">LayerSize()</A>, 
;           <A HREF="#INPUTLAYER_1">InputLayer_1</A>,   <A HREF="#INPUTLAYER_2">InputLayer_2</A>, 
;           <A HREF="#PROCEEDLAYER_1">ProceedLayer_1</A>, <A HREF="#PROCEEDLAYER_2">ProceedLayer_2</A>, <A HREF="#PROCEEDLAYER_3">ProceedLayer_3</A>, 
;           <A HREF="#OUT2VECTOR">Out2Vector()</A>
;
; MODIFICATION HISTORY:
;
;        $Log$
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

Pro LayerDataTest, Layer, $
               TYPE=type, $
               WIDTH=width, HEIGHT=height, $
               PARAMETERS=parameters, $
               FEEDING=feeding, FEEDING1=feeding1, FEEDING2=feeding2, LINKING=linking, INHIBITION=inhibition, $
               POTENTIAL=potential, $
               SCHWELLE=schwelle, LSCHWELLE=lschwelle, $
               LERNPOTENTIAL=lernpotential, $
               OUTPUT=output

   TestInfo, Layer, "Layer"
   
   type       = Layer.Type
   width      = Layer.W
   height     = Layer.H
   parameters = Layer.Para


   linking                                 = Reform(Layer.L, Layer.H, Layer.W)
   potential                               = Reform(Layer.M, Layer.H, Layer.W)
   schwelle                                = Reform(Layer.S, Layer.H, Layer.W)
   if Layer.Type eq '2' then lschwelle     = Reform(Layer.R, Layer.H, Layer.W)
   if Layer.Type eq '3' then lernpotential = Reform(Layer.P, Layer.H, Layer.W)
   output                                  = Out2Vector(Layer, /DIMENSIONS)
   if Layer.Type eq '7' then begin 
                             feeding1      = Reform(Layer.F1, Layer.H, Layer.W)
                             feeding2      = Reform(Layer.F2, Layer.H, Layer.W)   
                             inhibition1   = Reform(Layer.I1, Layer.H, Layer.W)
                             inhibition2   = Reform(Layer.I2, Layer.H, Layer.W)
                        end else begin
                             feeding       = Reform(Layer.F, Layer.H, Layer.W)
                             inhibition    = Reform(Layer.I, Layer.H, Layer.W)   
                        end

End



