;+
; NAME: InitPara_8
;
;
; PURPOSE: Festlegen der Parameter für eine Schicht aus Typ8-Neuronen
;           (Vier-Compartment-Neuron)
;          Das hier verwendete Modellneuron besteht aus drei dendritischen
;          und einem somatischen Compartment. Die dendritischen Compartments
;          sind passiv, d.h. sie enthalten keine spannungsabhängigen
;          Ionenkanäle und können deshalb auch keine Aktionspotentiale
;          erzeugen. Das somatische Compartment dagegen ist mit
;          spannungsabhängigen Na- und K-Kanälen ausgestattet, kann also
;          feuern. Es verhält sich im wesentlichen wie das Tintenfisch-
;          Axon von Hodgkin und Huxley, allerdings sind deren vier Gleichungen
;          nach FitzHugh auf zwei reduziert worden. 
;          Die Compartments sind hintereinander angeordnet:
;          Das Soma ist mit dem 3. Dendriten verbunden, dieser mit dem 2.
;          und dieser wiederum mit dem 1., ungefähr so:
;             ___   ____   _____     __ 
;           ()___)-()___)-()____)---()_)
;             De1    De2     De3    Soma
;
;          Die dendritischen Compartments können sowohl Spike-Input
;          über ihre Synapsen erhalten als auch direkt mit einem
;          konstanten Strom gereizt werden (siehe <A HREF="#INPUTLAYER_8">InputLayer_8</A>).
;          Die Ausgabe des Neurons sind Spikes, die genau wie die
;          des Typ-6-Neurons unabhängig von der gewählten Zeitauflösung
;          einen Simulationsschritt dauern. Sie werden erzeugt, wenn das
;          Membranpotential des somatischen Compartments einen Schwell-
;          wert übersteigt, der vom Benutzer angegeben werden muß, da
;          die Höhe der Aktionspotentiale je nach Parameterwahl 
;          unterschiedlich ist. Es empfiehlt sich, zunächst den Verlauf
;          des somatischen Mebranpotentials zu beobachten (das ist mit 
;          <A HREF="#LAYERDATA">LayerData</A> möglich) und danach
;          die Schwelle für die Spikeauslösung subjektiv festzulegen. 
;
; CATEGORY: SIMULATION / LAYERS
;
; CALLING SEQUENCE: 
;    parameter = InputPara_8(DELTAT=deltat, TH=th, REFPERIOD=refperiod, $
;                            TAUSYN=tausyn, $
;                            VNA=vna, VK=vk, VL=vl, VSYN=vsyn, $
;                            GNA=gna, GK=gk, GM=gm, GC=gc, GSYN=gsyn, CM=cm, $
;                            SOMA_D=soma_d, SOMA_L=soma_l, $
;                            DEN1_D=den1_d, DEN1_L=den1_l, $
;                            DEN2_D=den2_d, DEN2_L=den2_l, $
;                            DEN3_D=den3_d, DEN3_L=den3_l)
;
;    Alle Parameter haben Default-Werte (unter INPUTS nach der jeweiligen
;    Beschreibung aufgeführt) und müssen somit nicht explizit
;    angegeben werden. Ich hab aber jetzt keine Lust, um jeden einzelnen
;    sone eckige Klammer zu malen. OK?
;
; INPUTS: General
;            deltat : Duration of simulation timestep, 0.01 ms
;                      (Deltat must not be too large!)
;                th : Threshold for spike-generation.
;                      (If Vsoma GE th Then Output = 1)
;            tausyn : FltArr(2), time constants of dual exponential 
;                      function for synaptic conductance, [2,3] ms  
;
;        Potentials
;           All potentials adjusted relative to resting potential Veq = -70mV
;           Vsim := Vreal - Veq 
;               Vna : Na equilibrium potential, 115 mV
;                Vk : K equilibrium potential, -12 mV
;                Vl : Leakage potential, 10.6 mV
;              Vsyn : Potential of 'synaptic battery', 115 mV
;
;        Membrane properties
;               gna : specific conductance with all Na-channels open, 120 mS/cm²
;                gk : specific conductance with all K-channels open, 36 mS/cm²
;                gm : specific membrane leakage conductance, 0.3 mS/cm²
;                      ( Rl = 1/3 ohm m² )
;              gsyn : peak value of synaptic conductance, 5.E-7 mS
;                gc : specific cytoplasmic axial conductance, 33+1/3 mS/cm
;                      ( Ra = 0.3 ohm m)
;                Cm : specific membrane capacity, 1uF/cm²
;
;        Compartment dimensions
;            soma_l : soma length, 30 um
;            soma_d : soma diameter, 30 um 
;                      (length = diam => same surface as spherical soma)
;            den1_l : 1st dendrite length, 100 um
;            den1_d : 1st dendrite diameter, 2 um
;            den2_l : 2nd dendrite length, 100 um
;            den2_d : 2nd dendrite diameter, 2 um
;            den3_l : 3rd dendrite length, 100 um
;            den3_d : 3rd dendrite diameter, 2 um
;
; OUTPUTS: Eine Struktur mit folgenden Tags:
;             info : 'PARA'
;	      type : '8'
;
;          deltat
;              th
;              rp : refractory period/bin
;            dsyn : factors for exponential decay
;                    of synaptic conductance
;      corrampsyn : factor for normalizing maximum 
;                    synaptic conductance to gsyn
;      
;             Vna
;              Vk
;              Vl
;            Vsyn 
;     
;             gm1 : membrane conductance of 1st dendritic compartment
;             Cm1 : membrane capacity of 1st dendritic compartment
;
;            gc12 : axial conductance between 1st and 2nd
;                    dendritic compartment
;   
;             gm2 : membrane conductance of 2nd dendritic compartment
;             Cm2 : membrane capacity of 2nd dendritic compartment
;
;
;            gc23 : axial conductance between 2nd and 3rd
;                    dendritic compartment
;
;             gm3 : membrane conductance of 1st dendritic compartment
;             Cm3 : membrane capacity of 1st dendritic compartment
;
;            gc3s : axial conductance between 3rd dendritic and
;                    soma compartment
;
;             gna : overall Na-conductance of soma compartment
;              gk : overall K-conductance of soma compartment
;             gms : leakage conductance of soma membrane
;            gsyn
;             Cms : capacity of soma membrane
;
;
; PROCEDURE: 1. Variablen mit Default-Werten belegen.
;            2. Aus den spezifischen Größen und den Compartment-
;                Asumaßen die Paramter pro Compartment bestimmen.
;            3. Struktur definieren
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
; SEE ALSO: <A HREF="#INITLAYER_8">InitLayer_8</A>, <A HREF="#INPUTLAYER_8">InputLayer_8</A>, <A HREF="#PROCEEDLAYER_8">ProceedLayer_8</A>
;
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 1.2  1999/03/08 09:44:26  thiel
;               Hyperlinks kaputt, wie immer.
;
;        Revision 1.1  1999/03/05 14:30:19  thiel
;               Der Parameterteil des Typ-8-Neurons.
;
;-


FUNCTION InitPara_8, DELTAT=deltat, TH=th, REFPERIOD=refperiod, $
                 TAUSYN=tausyn, $
                 VNA=vna, VK=vk, VL=vl, VSYN=vsyn, $
                 GNA=gna, GK=gk, GM=gm, GC=gc, GSYN=gsyn, CM=cm, $
                 SOMA_D=soma_d, SOMA_L=soma_l, $
                 DEN1_D=den1_d, DEN1_L=den1_l, $
                 DEN2_D=den2_d, DEN2_L=den2_l, $
                 DEN3_D=den3_d, DEN3_L=den3_l

 
   Default, deltat, 0.01 ;ms
   Default, th, 60. ;mV
   Default, refPeriod, 1. ;ms
   Default, tausyn, [2.,3.] ;ms

   Default, Vna, 115. ;mV
   Default, Vk, -12. ;mV
   Default, Vl, 10.6 ;mV
   Default, Vsyn, 115. ;mV

   Default, gna, 120. ;mS/cm²
   Default, gk, 36. ;mS/cm²
   Default, gsyn, 5.E-7 ;mS
   Default, gm, 0.3 ;mS/cm²
   default, gc, 100./3. ;mS/cm
   Default, Cm, 1.;uF/cm²

   Default, soma_d, 30.E-4 ;cm
   Default, soma_l, 30.E-4 ;cm
   Default, den1_l, 100.E-4 ;cm
   Default, den1_d, 2.E-4 ;cm
   Default, den2_l, 100.E-4 ;cm
   Default, den2_d, 2.E-4 ;cm
   Default, den3_l, 100.E-4 ;cm
   Default, den3_d, 2.E-4 ;cm

;--- calculate parameters per compartment from specific values and 
;     compartment dimensions:
   gm1 = gm*!pi*den1_l*den1_d
   Cm1 = Cm*!pi*den1_l*den1_d

   gc12 = !pi*gc/2./(den1_l/den1_d^2+den2_l/den2_d^2)
   
   gm2 = gm*!pi*den2_l*den2_d
   Cm2 = Cm*!pi*den2_l*den2_d

   gc23 = !pi*gc/2./(den2_l/den2_d^2+den3_l/den3_d^2)

   gm3 = gm*!pi*den3_l*den3_d
   Cm3 = Cm*!pi*den3_l*den3_d

   gc3s = !pi*gc/2./(den3_l/den3_d^2+soma_l/soma_d^2)

   gna = gna*!pi*soma_l*soma_d
   gk = gk*!pi*soma_l*soma_d
   gms = gm*!pi*soma_l*soma_d
   Cms = Cm*!pi*soma_l*soma_d

;--- this is the correction factor to norm the maximal amplitude of 
;    EPSP to 1 (or wij respectively)
   corrampsyn = 1./(exp(-alog(tausyn(1)/tausyn(0))*tausyn(0)/(tausyn(1)-tausyn(0)))-exp(-alog(tausyn(1)/tausyn(0))*tausyn(1)/(tausyn(1)-tausyn(0))))


;--- define parameter structure
   Para = { info : 'PARA', $
	    type : '8', $

          deltat : deltat, $
              th : th, $
              rp : FIX(refPeriod/deltat), $
            dsyn : exp(-deltat/tausyn) ,$
      corrampsyn : corrampsyn, $
      
             Vna : Vna, $
              Vk : Vk, $
              Vl : Vl, $
            Vsyn : Vsyn, $
     
             gm1 : gm1, $
             Cm1 : Cm1, $

            gc12 : gc12, $
   
             gm2 : gm2, $
             Cm2 : Cm2, $

            gc23 : gc23, $

             gm3 : gm3, $
             Cm3 : Cm3, $

            gc3s : gc3s, $

             gna : gna, $
              gk : gk, $
             gms : gms, $
            gsyn : gsyn, $
             Cms : Cms }

   RETURN, Para

END 
