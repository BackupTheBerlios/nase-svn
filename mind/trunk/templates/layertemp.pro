;+
; NAME:   layertemp.pro
;
;
; PURPOSE: Template -> Layers
;
;
; CATEGORY: Templates

; MODIFICATION HISTORY:
;
;
;     $Log$
;     Revision 1.1  2000/01/17 14:58:22  alshaikh
;           initial version... copied from 'dsim.pro'
;
;
;-


LW = LonArr(1)
LW(0) = Handle_Create(!MH, VALUE={INFO   : 'LAYER'           ,$
                                  w      :     21            ,$
                                  h      :     21            ,$
                                  name   : 'Simple Cells'    ,$
                                  file   : 's'               ,$
                                  NPW    : {  INFO : 'NEURONPARA6' ,$
                                              tf1  :   0.2789d      ,$
                                              tf2  :   9.0d         ,$
                                              tl1  :   0.3866       ,$
                                              tl2  :   4.0d         ,$
                                              ti   :  10.0d         ,$
                                              vs   :   2.0d         ,$
                                              ts   :  10.0d         ,$
                                              vr   :   0.0d         ,$
                                              tr   :   5.0d         ,$
                                              t0   :   0.3d         ,$
                                              fade : 200            ,$
                                              n    :   0.0d         ,$
                                              ns   :   0.0d         ,$
                                              sn   :   0.0d         },$
                                  LEX    : { INFO       : 'LAYEREXTRA',$
                                             REC_O      : [0l, SIMULATION.TIME],$
                                             REC_M      : [0l,0l]              ,$
                                             REC_MUA    : 1                    ,$
                                             ANALYZE    : 0                    ,$
                                             SPIKERASTER: 1                    }})
