;+
; NAME:               DEMOSIM
;
; PURPOSE:            dieses Demo soll die Benutzung der Routinen InitPara, InitLayer, LayerProceed, Trainspotting, InitDW
;
; CATEGORY:           DEMO
;
; CALLING SEQUENCE:   .run demosim
;
; INPUTS:             ---
;
; OPTIONAL INPUTS:    ---
;
; KEYWORD PARAMETERS: ---
;
; OUTPUTS:            ---
;
; OPTIONAL OUTPUTS:   ---
;
; COMMON BLOCKS:      ---
;
; SIDE EFFECTS:       ---
;
; RESTRICTIONS:       ---
;
; PROCEDURE:          ---
;
; EXAMPLE:            .run demosim
;
; MODIFICATION HISTORY:
;
;       Thu Aug 28 17:55:32 1997, Mirko Saam
;       <saam@ax1317.Physik.Uni-Marburg.DE>
;
;		Urversion erstellt
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


   ; initialize parameters for a cluster of type 1 neurons (first order leaky integrators for feeding, linking, inhibition and threshold; learning potential)
   Layer1 = InitPara_3( TAUF=10.0, TAUL=5.0, TAUI=15.0, VS=30.0, TAUS=10.0, TH0=1.0, SIGMA=0.5)
   ; initialize two dimensional layer (w*h neurons) with parameters defined above
   L1 = InitLayer_3(WIDTH=w, HEIGHT=h, TYPE=Layer1)    

   ; initialize parameters for a cluster of type 2 neurons (first order leaky integrators for feeding, linking, inhibition and threshold)
   Layer2 = InitPara_1( TAUF=10.0, TAUL=5.0, TAUI=10.0, VS=1.0, TAUS= 5.0, TH0=1.0, SIGMA=0.0)
   ; initialize layer consististing of 1 interneuron
   L2 = InitLayer_1(WIDTH=1, HEIGHT=1, TYPE=Layer2)

   ; will contain feeding/linking/inhibition-inputs
   I_L1_F = DblArr(w*h)
   I_L1_L = DblArr(w*h)
   I_L1_I = DblArr(w*h)

   I_L2_F = DblArr(1)
   I_L2_L = DblArr(1)
   I_L2_I = DblArr(1)

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
                      W_CONST=[0.001, 4], /W_TRUNCATE, /W_NONSELF, W_NOCON=4)

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
      tmp(1:3,1:3) = 1.0
      tmp(6:8,6:8) = 1.0

      I_L1_F = REFORM(tmp, w*h)


;-------------> PROCEED CONNECTIONS
      I_L1_L = DelayWeigh( CON_L1_L1, L1.O)
      I_L2_F = DelayWeigh( CON_L1_L2, L1.O)
      I_L1_I = DelayWeigh( CON_L2_L1, L2.O)

      


;-------------> PROCEED NEURONS
      ; Input -> Layer -> Output
      O_L1(*,t MOD 500)    = ProceedLayer_3(L1, I_L1_F, I_L1_L, I_L1_I)
      O_L2(*,t MOD 500)    = ProceedLayer_1(L2, I_L2_F, I_L2_L, I_L2_I)
      

;-------------> LEARN SOMETHING
      CON_L1_L1 = LearnHebbLP(CON_L1_L1, Source_CL=L1, Target_CL=L1, Rate=0.02, ALPHA=0.02)


;-------------> DISPLAY RESULTS
      IF (t MOD 500 EQ 0 AND t GT 1) THEN BEGIN
         WSet, 2
         !P.Multi = [0,1,2,0,0]
         ; plot output activities as spikeraster
         TrainSpotting, O_L1, TITLE='Output L1', OFFSET=t-500
         TrainSpotting, O_L2, TITLE='Output L2', OFFSET=t-500
         
         ShowWeights, CON_L1_L1,TITEL='Gewichte', /TOS, WINNR=1
      END
      IF (t MOD 100 EQ 0) THEN Print, t, '  max weight: ', MAX(CON_L1_L1.weights)
   END
   Print, 'Main Simulation Loop done'



END
