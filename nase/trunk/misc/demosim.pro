;+
; NAME:               DEMOSIM
;
; PURPOSE:            dieses Demo soll die Benutzung der Routinen InitPara, InitLayer, LayerProceed, Trainspotting, InitDW
;
; CATEGORY:           DEMO
;
; CALLING SEQUENCE:   .run demosim
;
; EXAMPLE:            .run demosim
;
; MODIFICATION HISTORY:
;
;       $Log$
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
Window, 2, XSIZE=800, YSIZE=400



;-------------> INIT CLUSTERS
   Print, 'Initializing simulation...'

   ; width and height of cluster 
   w = 10
   h = 10


   ; initialize parameters for a cluster of type 1 neurons (first order leaky integrators for feeding, linking, inhibition and threshold, noise amplitude sigma=0.5)
   Layer1 = InitPara_1( TAUF=10.0, TAUL=5.0, TAUI=15.0, VS=30.0, TAUS=10.0, TH0=1.0, SIGMA=0.5)
   ; initialize two dimensional layer (w*h neurons) with parameters defined above
   L1 = InitLayer_1(WIDTH=w, HEIGHT=h, TYPE=Layer1)    

   ; initialize parameters for a cluster of type 1 neurons (first order leaky integrators for feeding, linking, inhibition and threshold, no noise(default) )
   Layer2 = InitPara_1( TAUF=10.0, TAUL=5.0, TAUI=10.0, VS=1.0, TAUS= 5.0, TH0=1.0, SIGMA=0.0)
   ; initialize layer consististing of 1 interneuron
   L2 = InitLayer_1(WIDTH=1, HEIGHT=1, TYPE=Layer2)


   ; will contain cluster outputs
   O_L1    = BytArr(w*h, 500)
   O_L2    = BytArr(1, 500)



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
    
    





;------------->
;-------------> MAIN SIMULATION ROUTINE
;------------->
   Print, 'Starting main simulation loop...'
   FOR t=0l,10000l DO BEGIN

      

;-------------> CREATE INPUT
      ; generate two static squares
      tmp = IntArr(w,h)
      tmp(1:3,1:3) = 1
      tmp(6:8,6:8) = 1

      I_L1_F = Spassmacher(REFORM(tmp, w*h))


;-------------> PROCEED CONNECTIONS
      I_L1_L = DelayWeigh( CON_L1_L1, L1.O)
      I_L2_F = DelayWeigh( CON_L1_L2, L1.O)
      I_L1_I = DelayWeigh( CON_L2_L1, L2.O)

      
;-------------> LEARN SOMETHING
      TotalRecall, LP_L1_L1, CON_L1_L1
      LearnHebbLP, CON_L1_L1, LP_L1_L1, Target_CL=L1, Rate=0.01, ALPHA=0.02

      IF t EQ 3000 THEN ShowNoMercy, CON_L1_L1, LESSTHAN=0.01

;-------------> PROCEED NEURONS
      ; Input -> Layer -> Output
      InputLayer_1, L1, FEEDING=I_L1_F, LINKING=I_L1_L, INHIBITION=I_L1_I
      ProceedLayer_1, L1

      InputLayer_1, L2, FEEDING=I_L2_F
      ProceedLayer_1, L2

      O_L1(*,t MOD 500) = Out2Vector(L1.O)
      O_L2(*,t MOD 500) = Out2Vector(L2.O)
      

;-------------> DISPLAY RESULTS
      IF (t MOD 500 EQ 0 AND t GT 1) THEN BEGIN
         WSet, 2
         !P.Multi = [0,1,2,0,0]
         ; plot output activities as spikeraster
         TrainSpotting, O_L1, TITLE='Output L1', OFFSET=t-500
         TrainSpotting, O_L2, TITLE='Output L2', OFFSET=t-500
         
         ShowWeights, CON_L1_L1,TITEL='Gewichte', /TOS, WINNR=1
      END
      IF (t MOD 100 EQ 0) THEN Print, t, '  max weight: ', MAX(Weights(CON_L1_L1))
   END
   Print, 'Main Simulation Loop done'


   FreeDw, CON_L1_L1
   FreeDw, CON_L1_L2
   FreeDw, CON_L2_L1

   FreeLayer_1, L1
   FreeLayer_1, L2



END
