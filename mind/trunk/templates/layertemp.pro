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
;     Revision 1.2  2000/01/25 15:23:16  alshaikh
;           new layer-structure!
;
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
                                             REC_MUA    : 1                    ,$
                                             ANALYZE    : 0                    ,$
                                             SPIKERASTER: 1                    }})
