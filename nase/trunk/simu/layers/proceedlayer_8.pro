;+
; NAME: ProceedLayer_8
;
; AIM:
;  Compute output of Four Compartment Neurons in current timestep.
;
; PURPOSE: Führt einen Simulationsschritt für eine Schicht aus Neuronen 
;          des Typs 8 (<A HREF="#INITPARA_8">4-Compartment-Neuron</A>) durch. Dazu werden die 
;          entsprechenden DGLn für die Compartments mit der IDL-
;          Runge-Kutta-Integrationsmethode gelöst. Input in die Neuronen
;          muß vor dem ProceedLayer_8-Aufruf mit <A HREF="#INPUTLAYER_8">InputLayer_8</A> 
;          festgelegt werden.
;
; CATEGORY: SIMULATION / LAYERS
;
; CALLING SEQUENCE: ProceedLayer_8, layer
;
; INPUTS: layer: eine durch <A HREF="#INITLAYER_8">InitLayer_8</A> erzeugte Layer
;
; COMMON BLOCKS: common_random
;                proceedlayer_8_cb (für die Übergabe der Parameter an die
;                                    Runge-Kutta-Funktion)
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
; SEE ALSO: <A HREF="#INITPARA_8">InitPara_8</A>, <A HREF="#INITLAYER_8">InitLayer_8</A>, <A HREF="#INPUTLAYER_8">InputLayer_8</A>
;
;-
; MODIFICATION HISTORY: 
;
;      $Log$
;      Revision 1.6  2000/09/28 13:05:26  thiel
;          Added types '9' and 'lif', also added AIMs.
;
;      Revision 1.5  2000/09/27 15:59:41  saam
;      service commit fixing several doc header violations
;
;      Revision 1.4  1999/05/07 12:47:07  thiel
;          Weiß nich mehr, was da geändert wurde.
;
;      Revision 1.3  1999/03/08 09:54:59  thiel
;             Hyperlink-Korrektur.
;
;      Revision 1.2  1999/03/05 14:32:53  thiel
;             Header-Ergänzung.
;
;      Revision 1.1  1999/03/05 13:10:19  thiel
;             Neuer Neuronentyp 8, ein Vier-Compartment-Modellneuron.
;
; 


FUNCTION ProceedLayer_8_DGLS, t, V

   COMMON ProceedLayer_8_cb, layer, index

   alpham = 0.1*(25.-V(1))/(EXP(2.5-0.1*V(1))-1.)

   Return, [ 0.01*(10.-V(1))/(EXP(1.-0.1*V(1))-1.)*(1.-V(0)) - 0.125*EXP(-0.0125*V(1))*V(0), $
             (-layer.para.gk*V(0)^4*(V(1)-layer.para.Vk) - layer.para.gna*(alpham/(alpham+(4.*EXP(-0.0555556*V(1)))))^3*(0.85-V(0))*(V(1)-layer.para.Vna) - layer.para.gms*(V(1)-layer.para.Vl) + layer.para.gc3s*(V(2)-V(1)))/layer.para.Cms, $
             (-layer.para.gm3*V(2) + layer.para.gc23*(V(3)-V(2)) + layer.para.gc3s*(V(1)-V(2)) + layer.incurr(index,0))/layer.para.Cm3, $
             (-layer.para.gm2*V(3) + layer.para.gc23*(V(2)-V(3)) + layer.para.gc12*(V(4)-V(3)) + layer.incurr(index,1))/layer.para.Cm2, $
             (-layer.para.gm1*V(4) + layer.para.gc12*(V(3)-V(4)) + layer.incurr(index,2))/layer.para.Cm1 ]

END



PRO ProceedLayer_8, _layer, _EXTRA=_extra

   COMMON common_random, seed

   COMMON ProceedLayer_8_cb

   
   Handle_Value, _layer, layer, /NO_COPY

   
   IF layer.decr THEN BEGIN
      layer.dualexp(*,0) = layer.dualexp(*,0) * layer.para.dsyn(0)
      layer.dualexp(*,1) = layer.dualexp(*,1) * layer.para.dsyn(1)
      Layer.decr = 0
   END

;--- neurons with abs refractory period gone   
   firedLast = WHERE(layer.ar EQ 1, count)
   IF count NE 0 THEN layer.ar(firedLast) = 0

   
   FOR index = 0, layer.w*layer.h-1 DO BEGIN
      dVnachdt = ProceedLayer_8_DGLS(0., layer.V(index,*))
      layer.V(index,*) = NR_RK4(layer.V(index,*), dVnachdt, 0., layer.para.deltat, 'ProceedLayer_8_DGLS')
   ENDFOR

   
;--- absolute refractory period if needed
   refN = WHERE(layer.ar GT 0, count)
   IF count NE 0 THEN layer.ar(refN) = layer.ar(refN)-1


   result = WHERE(layer.V(*,1) GE (layer.para.th + 100.*layer.ar), count) 


   newout = [count, layer.w * layer.h]
   IF count NE 0 THEN BEGIN
      newout = [newout, result]
      layer.ar(result) = layer.para.rp ; mark neurons as refractory
   END

   Handle_Value, layer.o, newout, /SET

   Layer.decr = 1
   

   Handle_Value, _layer, layer, /NO_COPY, /SET


END
