;+
; NAME:
;   LayerTemp
;
; AIM:
;   Demonstrates the syntax and options of a MIND layer
;
; PURPOSE:
;   Demonstrates the syntax and options of a MIND layer
;
; CATEGORY:
;  Help
;  MIND
;
;-


LW = LonArr(1)
LW(0) = Handle_Create(!MH, VALUE={INFO   : 'LAYER'           ,$
                                  w      :     21            ,$
                                  h      :     21            ,$
                                  name   : 'Simple Cells'    ,$
                                  file   : 's'               ,$
                                  wrap   : 0                 ,$ ; toroidal boundary conditions for input generation if set to 1
                                                              $ ; (only if IFfilter cares for this option)
                                                              $ ; for compatibility this tag may bo omitted; it is assumed to be zero.
                                  NPW    : {  INFO : 'INITPARA_1' ,$  ; the following values are
                                              tauf  :   10.0      ,$  ; directly passed to 
                                              taul  :   5.0       ,$  ; 'initpara_1'
                                              taui   :  10.0d     ,$  ;     
                                              vs   :   2.0d       ,$  ;
                                              taus   :  4.0d      ,$  ;
                                              th0   :   1.0d      ,$  ;
                                              sigma    :   0.05d  },$ ;
                                  LEX    : { INFO       : 'LAYEREXTRA',$
                                             REC_O      : [0l, SIMULATION.TIME],$
                                             REC_M      : [0l,0l]              ,$
                                             REC_MUA    : 1                    ,$ ; [bool] records sum of actions potentials
                                             REC_LFP    : 1                    ,$ ; [bool] records sum of all neurons' membrane potentials 
                                             ANALYZE    : 0                    ,$
                                             SPIKERASTER: 1                    }})
