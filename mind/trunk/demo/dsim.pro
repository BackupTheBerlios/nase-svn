;+
; NAME: 
;  DSim
;
; VERSION:
;   $Id$
;
; AIM:
;  Demonstrates how to create simulations with MIND.
; 
; PURPOSE:
;  DSim is an example of how to describe the simulation of a neural
;  network by MIND commands. It may also be used as a skeleton to
;  build ones own MIND files. The network described in DSim consists
;  of two interconnected neural layers named 'simple-' and 'complex
;  cells'. During simulation, 'simple cells' are first fed with input
;  pulses and later with a stationary input. This is repeated two
;  times. 'Complex cells' receive spikes generated by 'simple cells'.
;  Coupling strength between the two cell types is varied in two
;  seperate simulation runs to demonstrate the use of <A>ForEach</A>. 
;   
; CATEGORY:
;  Demonstration
;  Graphic
;  MIND
;  Simulation
;
; CALLING SEQUENCE:
;  DSim & Sim
; 
; OUTPUTS
;  Different windows displaying behavior of neurons and connections
;  structures during the simulation. Results are written into
;  different files.
;
; SEE ALSO: <A>Sim</A>, <A>ForEach</A>, <A>DForEach</A>.
;
;-



PRO DSim
  
   COMMON SH_Q, Qwins, Q_1
   COMMON COMMON_Random, seed

   ;; AP and P in ATTENTION save all simulation parameters and data
   ;; structures
   COMMON ATTENTION, AP, P, _TIME


   Freeeachhandle
   UClose,/ALL


   ;; Specify global parameters
   SIMULATION = {VER: '.', $    ; use current directory as working directory
                 SKEL: 'dsim', $ ; add dsim to all filenames
                 TIME: 500l, $  ; overall simulation duration: 100 ms
                 SAMPLE: 0.001} ; one sim step corresponds to 0.001s


   ;; Specify layers and their parameters 
   LW = LonArr(2)               ; two layers are defined

   ;; first layer:
   LW(0) = Handle_Create(!MH, $
                         VALUE={INFO: 'LAYER', $
                                w: 11, $
                                h: 11, $
                                name: 'Simple Cells', $
                                ;; file is used to create filename for
                                ;; saving results
                                file: 's', $
                                 ;; parameters are submitted to InitPara_6
                                NPW: {INFO: 'INITPARA_6', $
                                      TAUF: [0.2789d, 9.0d], $
                                      TAUL: [0.3866d, 4.0d], $
                                      TAUI:  10.0d, $
                                      VS: 2.0d, $
                                      TAUS: 10.0d, $
                                      VR: 0.0d, $
                                      TAUR: 5.0d, $
                                      TH0: 0.3d, $
                                      FADE: 0, $
                                      SIGMA: 0.0d, $
                                      NOISYSTART: 0.0d, $
                                      SPIKENOISE: 0.0d}, $
                                 ;; extra commands for saving results
                                LEX: {INFO: 'LAYEREXTRA',$
                                 ;; record the output during
                                 ;; whole simulation 
                                REC_O: [0l, SIMULATION.TIME],$
                                 ;; dont record membrane potentials
                                REC_M: [0l,0l], $
                                 ;; save MUA
                                REC_MUA: 1, $
                                ANALYZE: 0, $
                                 ;; display spiketrains
                                SPIKERASTER: 1}})
                                      
   ;; second layer:                  
   LW(1) = Handle_Create(!MH, $
                         VALUE={INFO: 'LAYER', $
                                w: 11, $
                                h: 11, $
                                name: 'Complex Cells', $
                                file: 'c', $
                                NPW: {INFO: 'INITPARA_6', $
                                      TAUF: [0.2789d, 9.0d], $
                                      TAUL: [0.3866d, 4.0d], $
                                      TAUI: 10.0d, $
                                      VS: 2.0d, $
                                      TAUS: 10.0d, $
                                      VR: 0.0d, $
                                      TAUR: 5.0d, $
                                      TH0:   0.3d, $
                                      FADE: 0, $
                                      SIGMA: 0.0d, $
                                      NOISYSTART: 0.0d, $
                                      SPIKENOISE: 0.0d}, $
                                LEX: {INFO: 'LAYEREXTRA', $
                                      REC_O: [0l, SIMULATION.TIME], $
                                      REC_M: [0l,0l], $
                                      REC_MUA: 1, $
                                      ANALYZE: 0, $
                                      SPIKERASTER: 1}})

   ;; create Plotcilloscopes for single neurons (5,5) in both layers
   NWatch = LonArr(2)
   NWatch(0) = Handle_Create(!MH, VALUE={L : 0,$
                                         w : 5,$
                                         h : 5})
   NWatch(1) = Handle_Create(!MH, VALUE={L : 1,$
                                         w : 5,$
                                         h : 5})


   
   ;; Connections
   DWW = LonArr(1)              ; one connection structure will be defined
   DWW(0) = Handle_Create(!MH, $
                          VALUE={INFO: 'DWW', $
                                 NAME: 'S->C', $
                                 FILE: 's-c', $
                                 SYNAPSE: 'FEEDING', $
                                 ;; numbers of source and target layers
                                 SOURCE: 0, $
                                 TARGET: 1, $
                                 BOUND: 'TOROID', $
                                 SELF: 'SELF', $
                                  ;; specify parameters for weight and
                                  ;; delay initialization 
                                 WINIT: {INFO: 'DWWINIT', $
                                         TYPE: 'GAUSSIAN', $
                                         A: 0., $
                                         S: 5., $
                                         R: 10, $
                                         NORM: 0}, $
                                  DINIT: {INFO: 'DWDINIT', $
                                          TYPE: 'LINEAR', $
                                          M: 1, $
                                          D: 12, $
                                          R: 10},$
                                  T2S: 0})
   



   ;; Learning
   LEARNW = LonArr(1)
   LEARNW(0) = Handle_Create(!MH, $
                             VALUE={INFO: 'LEARN', $
                                    INDEX: 0, $
                                    ;; learn connections in DW structure 0
                                    DW: 0, $
                                    ;; learning rule name and
                                    ;; parameters        
                                    RULE: 'LHLP2', $
                                    ALPHA: 0.25, $
                                    GAMMA: 0.001, $
                                    WIN:  'ALPHA', $
                                    TAU_INC: 0.3866, $
                                    TAU_DEC: 4., $
                                     ;; save and display weight
                                     ;; convergence every 5 BINs 
                                    RECCON: 5, $ 
                                     ;; show weights every 50 BINs
                                    SHOWW: 50, $
                                     ;; ZOOM factor of
                                     ;; ShowWeights procedure 
                                    ZOOM: 3, $ 
                                     ;; terminate if a weight exceeds 10.
                                    TERM: 10., $ 
                                    NOMERCY: 0})



   ;;-------> INPUT
   ;; three external input filters will be used
   MFILTER = LonArr(3)
   
   ;; first filter creates spike pulses
   MFILTER(0) = Handle_Create(!MH, $
                              VALUE={NAME: 'sifpoissonc', $
                               ;; filter is active between 0ms and 99ms  
                              start: 0, $
                              stop: 99})
   ;; second filter jitters spikes created by the first
   MFILTER(1) = Handle_Create(!MH, $
                              VALUE={NAME: 'sifnjitter', $
                                     start: 0, $
                                     stop: 99, $
                                     ;; parameters sent to the
                                     ;; external filter 
                                     params: {jitter: 2}})
   ;; third filter generates stationary input
   MFILTER(2) = Handle_Create(!MH, $
                              VALUE={NAME: 'ifconst', $
                               ;; filter is active between 150ms and 249ms  
                                     start: 125, $
                                     stop: 224, $
                                     params: {value: 0.4}})


   ;; now compose input by putting filters together
   MINPUT = LonArr(2)
   MINPUT(0) = Handle_Create(!MH, $
                             VALUE={INFO: 'INPUT', $
                                    ;; input 0 is delivered to layer 0
                                    ;; via the feeding synapse
                                    INDEX: 0, $
                                    LAYER: 0, $
                                    SYNAPSE: 'FEEDING', $
                                    TYPE: 'EXTERN', $
                                    ;; active during complete simulation
                                    start: 0, $
                                    stop: simulation.time-1, $
                                    ;; input is repeated after 250 ms
                                    PERIOD: 250, $
                                    TIME_STEP: -1, $
                                    ;; input is shown in separate window
                                    VISIBLE: 1, $
                                    ;; composed of filters 0 and 1 
                                    FILTERS: MFILTER(0:1)})

   MINPUT(1) = Handle_Create(!MH, $
                             VALUE={INFO: 'INPUT', $
                                    ;; input 1 is delivered to layer 0
                                    ;; via the direct synapse
                                    INDEX: 1, $
                                    LAYER: 0, $
                                    SYNAPSE: 'DIRECT', $
                                    TYPE: 'EXTERN', $
                                    ;; active during complete simulation
                                    start: 0, $
                                    stop: simulation.time-1, $
                                    ;; input is repeated after 250 ms
                                    PERIOD: 250, $
                                    TIME_STEP: -1, $
                                    VISIBLE: 1, $
                                    ;; composed of filter 2
                                    FILTERS: MFILTER(2)})



   ;; finally put all previously defined data structures inside AP
   AP = {file: '', $            ; file and ofile must be present,
         ofile: '', $           ; they are overwritten later
         CON: InitConsole(MODE='win'), $ ; init console to print outputs
         SIMULATION: SIMULATION, $ ; global parameters
         DWW: DWW, $            ; connection-informations
         LW: LW, $              ; layer-informations
         LEARNW: LEARNW, $      ; learning-informations
         NWATCH: NWATCH, $      ; neurons to be watched in plotcillosscopes
         INPUT: MINPUT, $       ; input
         ;; run the simulation 2 times and vary the coupling strength 
         __TNcoupling: 'WINIT.A/DWW(0)', $
         __TVcoupling: [0.005, 0.01]}


   ;; call FakeEach to prepare P structure and set directories correctly
   FakeEach


END
