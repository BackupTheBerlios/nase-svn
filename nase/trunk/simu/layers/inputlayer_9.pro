;+
; NAME:
;  InputLayer_9
;
; AIM:
;  Transfer input to Four Compartment Object Neuron synapses of given layer. 
;
; PURPOSE: Ermöglicht den Input von Spikes oder konstanten Strömen
;          in eine Schicht von <A HREF="#INITPARA_8">Typ-8-Neuronen</A>.
;          Zunächst werden die postsynaptischen Potentiale abgeklungen 
;          und danach die neuen Inputs addiert. Sowohl Spikes- als auch 
;          Strominputs müssen in Sparse-Form vorliegen, siehe also
;          <A HREF="#SPASSMACHER">Spassmacher</A>.
;          
; CATEGORY: SIMULATION / LAYERS
;
; CALLING SEQUENCE: InputLayer_8, layer [,SYN1=syn1] [,SYN2=syn2] [,SYN3=syn3] ;                                  [,CURR1=curr1] [,CURR2=curr2] [,CURR3=curr3]
;
; INPUTS: layer : eine mit <A HREF="#INITLAYER_8">InitLayer_8</A> erzeugte Struktur
;
; OPTINAL INPUTS : syn1 .. syn3 : Sparse-Vektoren, die über die Synapse
;                      des jeweiligen Compartments eingespeist werden.
;                  curr1 .. curr3 : Sparse-Vektoren, die direkt ins
;                      entsprechende Compartment injiziert werden.
;                      
; SIDE EFFECTS: wie so oft wird die Layer-Struktur verändert
;
; RESTRICTIONS: keine Überpuefung der Gültigkeit des Inputs (Effizienz!)
;
; EXAMPLE:
;  PRO Type8_Example
;
;   parameter = InitPara_8(deltat=0.01, $ ;ms
;                          th=70., $ ;mV
;                          gsyn=1.E-6, $ ;mS
;                          refperiod=2.0, $ ;ms
;                          soma_l=15.E-4, $ ;cm
;                          soma_d=15.E-4, $ ;cm
;                          den3_d=2.E-4, $ ;cm
;                          den2_d=1.E-4, $ ;cm
;                          den1_d=1.E-4, $;cm
;                          den3_l=200.E-4, $ ;cm
;                          den2_l=75.E-4, $ ;cm
;                          den1_l=75.E-4) ;cm
;
;        
;   testlayer = InitLayer_8(WIDTH=2, HEIGHT=1, TYPE=parameter, INIT_V=[0.316742, -0.0612292, -0.0594528, -0.0579468, -0.0567966])
;                
;   resultarray = fltarr(4000,2,1,5)
;   spikearray = fltarr(4000,2)
;   p = fltarr(2,1,5)
;  
;   inputnonsparse = [0.0005, 0.] 
;   inputsparse = SpassMacher(inputnonsparse)
;
;   links = InitDW(S_LAYER=testlayer,T_LAYER=testlayer, WEIGHT=1.0, /W_NONSELF)
;   
;   FOR n=0,3999 DO BEGIN
;     
;      InputLayer, testlayer, CURR1=inputsparse, SYN3=DelayWeigh(links,LayerOut(testlayer))
;      Proceedlayer, testlayer
; 
;      LayerData, testlayer, POTENTIAL=p
;      
;      resultarray(n,*,*,*) = p
;      spikearray(n,*) = (LayerSpikes(testlayer))
;
;   ENDFOR
;
;   FreeLayer, testlayer
;
;   !p.multi = [0,1,2,0,0]
;
;   plot, resultarray(*,0,0,1)
;   oplot, 10.*spikearray(*,0)
;   oplot, resultarray(*,0,0,2), LINESTYLE=2
;   oplot, resultarray(*,0,0,3), LINESTYLE=3
;   oplot, resultarray(*,0,0,4), LINESTYLE=4
;
;   plot, resultarray(*,1,0,1)
;   oplot, 10.*spikearray(*,1)
;   oplot, resultarray(*,1,0,2), LINESTYLE=2
;   oplot, resultarray(*,1,0,3), LINESTYLE=3
;   oplot, resultarray(*,1,0,4), LINESTYLE=4
;
;  END
;
;
; SEE ALSO: <A HREF="#INITPARA_8">InitPara_8</A>, <A HREF="#INITLAYER_8">InitLayer_8</A>, <A HREF="#PROCEEDLAYER_8">ProceedLayer_8</A>
;
;
; MODIFICATION HISTORY:
;
;      $Log$
;      Revision 2.1  2000/09/28 13:05:26  thiel
;          Added types '9' and 'lif', also added AIMs.
;
;      Revision 1.2  1999/03/11 09:36:33  thiel
;             Keywords vergessen.
;
;      Revision 1.1  1999/03/08 09:50:36  thiel
;             Neu: InputLayer für Typ-8-Neuronen.
;
;-


PRO InputLayer_9, _layer, CURR1=curr1, CURR2=curr2, CURR3=curr3, CURR4=curr4,$
                          SYN1=syn1, SYN2=syn2, SYN3=syn3, SYN4=syn4, $
                          VARTIMESTEP=vartimestep


   Handle_Value, _layer, layer, /NO_COPY


   layer.cells -> ApplyCurrent, SPARSECURRENT1 = curr1, $
                                SPARSECURRENT2 = curr2, $
                                SPARSECURRENT3 = curr3;, $
;                                SPARSECURRENT4 = curr4

   layer.cells -> SpikeInput, SPARSESPIKES1 = syn1, $
                              SPARSESPIKES2 = syn2, $
                              SPARSESPIKES3 = syn3;, $
;                              SPARSESPIKES4 = syn4

   IF Keyword_Set(VARTIMESTEP) THEN BEGIN
      layer.fastcells -> ApplyCurrent, SPARSECURRENT1 = curr1, $
                                       SPARSECURRENT2 = curr2, $
                                       SPARSECURRENT3 = curr3;, $
;                                       SPARSECURRENT4 = curr4

      layer.fastcells -> SpikeInput, SPARSESPIKES1 = syn1, $
                                     SPARSESPIKES2 = syn2, $
                                     SPARSESPIKES3 = syn3;, $
;                                     SPARSESPIKES4 = syn4
   ENDIF



   Handle_Value, _layer, layer, /NO_COPY, /SET


END
  
