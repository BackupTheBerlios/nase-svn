;+
; NAME:
;  InitLayer_9()
;
; AIM:
;  Initialize layer of Four Compartment Object Neurons.
;
; PURPOSE: Initialisiert eine Neuronenschicht vom Typ 9.
;
; CATEGORY: SIMULATION / LAYERS
;
; CALLING SEQUENCE: layer = InitLayer_9( WIDTH=width, HEIGHT=height, 
;                                        TYPE=type, 
;                                        INIT_V=init_v)
;
; INPUTS: WIDTH, HEIGHT : Breite und Höhe des Layers
;         TYPE          : Struktur, die neuronenspezifische Parameter enthält;
;                          definiert mit <A HREF="#INITPARA_8">InitPara_8</A>.
; 
; OPTIONAL INPUTS : init_v : Die Potentiale aller Neuronen der Layer
;                             werden mit den in init_v angegebenen Werten
;                             vorbelegt. Auf diese Weise lassen sich
;                             seltsame Effekte aufgrund noch nicht
;                             angenommener Gleichgewichtswerte zu Beginn 
;                             der Simulation reduzieren.
;
; OUTPUTS: layer : Handle auf eine Struktur mit folgenden Tags:
;              info : 'LAYER'
;              type : '8'
;                 w : width
;                 h : height
;              para : type
;              decr : 1 ; decides if PSPs are to be decremented or not
;           incurr  : FltArr(width*height,3) ; Gesamter Eingangsstrom in 
;                                            die dendritischen Compartments
;           dualexp : FltArr(3*width*height,2) ; Doppelte e-Funktion zur
;                                                 PSP-Modellierung
;                 V : FltArr(width*height,5) ; Membranpotentiale der vier 
;                                          Compartments plus Zustand der 
;                                          somatischen Recovery-Variablen.  
;                            V(0) = n, V(1) = Vs  (Soma)
;                            V(2) = V3, V(3) = V2, V(4) = V1  (Dendriten)
;                 o : Handle_Create(!MH, VALUE=[0, width*height])
;                ar : BytArr(width*height) ; for the absolute refractory 
;                                             period
;
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
; SEE ALSO: <A HREF="#INITPARA_8">InitPara_8</A>, <A HREF="#INPUTLAYER_8">InputLayer_8</A>, <A HREF="#PROCEEDLAYER_8">ProceedLayer_8</A>
;
; MODIFICATION HISTORY: 
;
;      $Log$
;      Revision 2.1  2000/09/28 13:05:26  thiel
;          Added types '9' and 'lif', also added AIMs.
;
;      Revision 1.1  1999/03/08 09:47:12  thiel
;             Neuer Neuronentyp Nr. 8.
;
;
;-


FUNCTION InitLayer_9, WIDTH=width, HEIGHT=height, TYPE=type, $
                      DELTAT=deltat, $
                      VARTIMESTEP=vartimestep, _EXTRA=_extra


   COMMON Common_Random, seed


   IF (NOT Keyword_Set(width))  THEN Message, 'Keyword WIDTH expected'
   IF (NOT Keyword_Set(height)) THEN Message, 'Keyword HEIGHT expected'
   IF (NOT Keyword_Set(type))   THEN Message, 'Keyword TYPE expected'

   Default, deltat, 0.1

   handle = Handle_Create(!MH, VALUE=[0, width*height])

   IF Set(VARTIMESTEP) THEN $
   layer = { info    : 'LAYER', $
             type    : '9', $
             w       : width, $
             h       : height, $
             para    : type, $
             errbound : vartimestep, $
             o       : handle, $
             cells   : Obj_New(type, WIDTH=width, HEIGHT=height, $
                               DELTAT=deltat, _EXTRA=_extra), $
             fastcells   : Obj_New(type, WIDTH=width, HEIGHT=height, $
                                   DELTAT=2.0*deltat, _EXTRA=_extra) } $
   ELSE $
    layer = { info    : 'LAYER', $
              type    : '9', $
              w       : width, $
              h       : height, $
              para    : type, $
              o       : handle, $
              cells   : Obj_New(type, WIDTH=width, HEIGHT=height, $
                                DELTAT=deltat, _EXTRA=_extra) }

   RETURN, Handle_Create(!MH, VALUE=layer, /NO_COPY)


END 
