;+
; NAME: DEMOSIM
;
; AIM: demo simulation demonstrating the basic usage of important NASE routines
;
; PURPOSE: Dieses Demonstrationsprogramm soll anhand eines Beispiel-
;          netzwerks die Benutzung einiger wichtiger N.A.S.E.-Routinen 
;          verdeutlichen. Im einzelnen sind dies Routinen
;          
;          -zur Behandlung von Neuronenschichten: 
;            <A>InitPara_1</A>, <A>InitLayer</A>, <A>InputLayer</A>, <A>ProceedLayer</A>,
;            <A>FreeLayer</A>
;
;          -zur Behandlung von Verbindungen zwischen Neuronenschichten:
;            <A>InitDW</A>, <A>DelayWeigh</A>, <A>FreeDW</A>
;
;          -zum Lernen von Verbindungsstaerken:
;            <A>InitRecall</A>, <A>TotalRecall</A>, <A>LearnHebbLP</A>, <A>FreeRecall</A>
;
;          -zur graphischen Darstellung:
;            <A>ShowWeights</A>, <A>Trainspotting</A>
;
;          Das Beispielnetzwerk besteht aus einer Schicht von 10x10
;          Neuronen (im Programm L1 genannt) und einem Inhibitionsneuron 
;          (L2 im Programm).
;          Die Neuronen in der Schicht erhalten als Feeding-Input ein
;          Muster, das zwei Quadrate zeigt (I_L1_F), Linking-Input von 
;          allen anderen Neuronen ihrer Schicht (CON_L1_L1) und inhibito-
;          rischen Input vom Inhibitionsneuron (CON_L2_L1). Die Gewichte 
;          der Linking-Verbindungen werden waehrend der Simulation ge-
;          maess einer Hebb-Lernregel veraendert.
;          Das Inhibitionsneuron erhaelt Feeding-Input von allen 
;          Neuronen in der Schicht (CON_L1_L2).
;          Waehrend der Simulation werden die Spikeaktivitaet in der 
;          Neuronenschicht und die des Inhibitionsneurons dargestellt.
;          Ausserdem gezeigt wird die Staerke der Verbindungen innerhalb
;          der Schicht.
;          
; CATEGORY: MISCELLANEOUS
; 
; CALLING SEQUENCE:   .run demosim
;
; MODIFICATION HISTORY:
;
;       $Log$
;       Revision 1.1  2000/10/06 13:57:21  thiel
;           Moved from nase/misc and used new hyperlink syntax.
;
;       Revision 1.17  2000/09/25 09:10:32  saam
;       * appended AIM tag
;       * some routines got a documentation update
;       * fixed some hyperlinks
;
;       Revision 1.16  1999/07/16 09:40:44  thiel
;           Endlich das "stop" am Ende entfernt.
;
;       Revision 1.15  1998/11/08 19:33:47  saam
;             TrainspottingScope and new Layer types included
;
;       Revision 1.14  1998/11/06 13:59:45  thiel
;              Jetzt wieder auf dem aktuellen Stand.
;
;       Revision 1.13  1998/02/19 13:36:06  thiel
;              Hoffentlich stimmen die Hyperlinks jetzt.
;
;       Revision 1.12  1998/02/19 13:14:00  thiel
;              Bessere Hyperlinks.
;
;       Revision 1.11  1998/02/11 16:16:43  saam
;             alles weg
;
;       Revision 1.10  1998/02/11 15:47:16  saam
;             kein Showweights in Schleife
;
;       Revision 1.9  1998/02/11 15:09:40  saam
;             Zeit wird ohne Initialiseirung gemessen
;
;       Revision 1.8  1998/02/11 14:58:20  saam
;             Zeitmessung hinzugefuegt
;
;       Revision 1.7  1998/02/09 15:32:59  thiel
;              Der Header ist etwas ausfuehrlicher geworden.
;
;       Revision 1.6  1998/02/05 13:24:29  saam
;             + FreeDW's ergaenzt
;             + Bug im Aufruf von InitRecall der letzten Revision korrigiert
;
;       Revision 1.5  1998/02/03 16:10:27  thiel
;              Mal wieder auf den neuesten Stand gebracht.
;
;       Revision 1.4  1997/10/13 16:46:02  saam
;       zeitliche Abfolge des Zeitschrittes korrigiert
;
;       Revision 1.3  1997/09/20 17:44:25  thiel
;              TOTALRECALL muss jetzt in der Simulation
;       	   vor der Lernregel aufgerufen werden
;
;       Revision 1.2  1997/09/18 08:09:14  saam
;            Anpassung an veraenderte Syntax&Semantik
;
;
;       Thu Aug 28 17:55:32 1997, Mirko Saam
;       <saam@ax1317.Physik.Uni-Marburg.DE>
;	     Urversion erstellt
;
;
;-
 
Window, 1, TITLE='weights', XSIZE=320, YSIZE=320
SH2 = DefineSheet(/WINDOW, XSIZE=800, YSIZE=250, MULTI=[3,1,3], TITLE='Diverses')



;-------------> INIT CLUSTERS
   Print, 'Initializing simulation...'

   ; width and height of cluster 
   w = 10
   h = 10


   ; initialize parameters for a cluster of type 1 neurons (first order leaky integrators for feeding, linking, inhibition and threshold, noise amplitude sigma=0.5)
   Layer1 = InitPara_1( TAUF=10.0, TAUL=5.0, TAUI=15.0, VS=30.0, TAUS=10.0, TH0=1.0, SIGMA=0.5)
   ; initialize two dimensional layer (w*h neurons) with parameters defined above
   L1 = InitLayer(WIDTH=w, HEIGHT=h, TYPE=Layer1)    

   ; initialize parameters for a cluster of type 1 neurons (first order leaky integrators for feeding, linking, inhibition and threshold, no noise(default) )
   Layer2 = InitPara_1( TAUF=10.0, TAUL=5.0, TAUI=10.0, VS=1.0, TAUS= 5.0, TH0=1.0, SIGMA=0.0)
   ; initialize layer consististing of 1 interneuron
   L2 = InitLayer(WIDTH=1, HEIGHT=1, TYPE=Layer2)




;-------------> INIT WEIGHTS

   ; this creates connections from L1 to L1 with following properties:
   ;   ++ one neuron is connected to all neurons having a distance less equal 4  (W_CONST)
   ;   ++ a neuron is NOT connected to the corresponding neuron in the other layer (W_NONSELF)
   ;   ++ connections with a distance greater then 4 are not drawn and therefore can't be learned (W_NOCON)
   ;   ++ connections exceeding the layer-dimensions are truncated and not cyclically continued (W_TRUNCATE)
   CON_L1_L1 = InitDW(S_LAYER=L1, T_LAYER=L1, $
                      W_CONST=[0.001, 4], /W_TRUNCATE, /W_NONSELF, NOCON=4)
   LP_L1_L1 = InitRecall(L1, EXPO=[5.0,10.0])

;   with delays
;   CON_L1_L1 = InitDW(S_LAYER=L1, T_LAYER=L1, $
;                      W_CONST=[0.001, 4], /W_TRUNCATE, /W_NONSELF, DELAY=3, NOCON=4)
;   LP_L1_L1 = InitRecall(CON_L1_L1, EXPO=[5.0,10.0])

   ; show the connections in a window
   ShowWeights, CON_L1_L1, /TOS, WINNR=1

    ; Layer1 -> Interneuron (completely connected)
    CON_L1_L2 = InitDW( S_LAYER=L1, T_LAYER=L2, WEIGHT=0.1)

   ; Interneuron -> Layer1 (completely connected)
    CON_L2_L1 = InitDW( S_LAYER=L2, T_LAYER=L1, WEIGHT=1.0)
    
    

    OpenSheet, SH2, 0
    TSS1 = InitTrainspottingScope(NEURONS=w*h, TIME=500)
    CloseSheet, SH2, 0
    OpenSheet, SH2, 1
    TSS2 = InitTrainspottingScope(NEURONS=1, TIME=500)
    CloseSheet, SH2, 1
    OpenSheet, SH2, 2
    PS = InitPlotcilloscope(RAYS=3, TIME=500)
    CloseSheet, SH2, 2
      





;------------->
;-------------> MAIN SIMULATION ROUTINE
;------------->
   Print, 'Starting main simulation loop...'
   SimTimeInit      
   FOR t=0l,9700l DO BEGIN

;-------------> CREATE INPUT
      ; generate two static squares
      tmp = IntArr(w,h)
      tmp(1:3,1:3) = 1
      tmp(6:8,6:8) = 1

      I_L1_F = Spassmacher(REFORM(tmp, w*h))


;-------------> PROCEED CONNECTIONS
      I_L1_L = DelayWeigh( CON_L1_L1, LayerOut(L1))
      I_L2_F = DelayWeigh( CON_L1_L2, LayerOut(L1))
      I_L1_I = DelayWeigh( CON_L2_L1, LayerOut(L2))

      
;-------------> LEARN SOMETHING
      TotalRecall, LP_L1_L1, CON_L1_L1
      LearnHebbLP, CON_L1_L1, LP_L1_L1, Target_CL=L1, Rate=0.01, ALPHA=0.02
 
      IF t EQ 3000 THEN ShowNoMercy, CON_L1_L1, LESSTHAN=0.01

;-------------> PROCEED NEURONS
      ; Input -> Layer -> Output
      InputLayer, L1, FEEDING=I_L1_F, LINKING=I_L1_L, INHIBITION=I_L1_I
      ProceedLayer, L1

      InputLayer, L2, FEEDING=I_L2_F
      ProceedLayer, L2


      OpenSheet, SH2, 2
      LayerData, L1, INHIBITION=i, POTENTIAL=m, SCHWELLE=theta
      Plotcilloscope, PS, [i(12),m(12),theta(12)]
      CloseSheet, SH2, 2
      
      


;-------------> DISPLAY RESULTS

    OpenSheet, SH2, 0
    TrainSpottingScope, TSS1, LayerOut(L1)
    CloseSheet, SH2, 0
    OpenSheet, SH2, 1
    TrainSpottingScope, TSS2, LayerOut(L2)
    CloseSheet, SH2, 1

      IF (t MOD 500 EQ 0 AND t GT 1) THEN BEGIN
         ShowWeights, CON_L1_L1,TITEL='Gewichte', /TOS, WINNR=1
      END
      IF (t MOD 100 EQ 0) THEN Print, t, '  max weight: ', MaxWeight(CON_L1_L1)
   END
   SimTimeStep
   SimTimeStop

   Print, 'Main Simulation Loop done'

   FreeDw, CON_L1_L1
   FreeDw, CON_L1_L2
   FreeDw, CON_L2_L1

   FreeLayer, L1
   FreeLayer, L2

   FreeRecall, LP_L1_l1

END
