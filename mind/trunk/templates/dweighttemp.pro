;+
; NAME:  dweighttemp.pro
;
;
; PURPOSE: Template for Delays/Weights
;
;
; CATEGORY: Templates
;

; MODIFICATION HISTORY:
;
;
;     $Log$
;     Revision 1.1  2000/01/17 14:58:21  alshaikh
;           initial version... copied from 'dsim.pro'
;
;
;-

DWW = LonArr(1)
   DWW(0) = Handle_Create(!MH, VALUE={INFO    : 'DWW'    ,$
                                      NAME    : 'S->C'   ,$
                                      SYNAPSE : 'FEEDING',$
                                      SOURCE  : 0        ,$
                                      TARGET  : 1        ,$
                                      BOUND   : 'TOROID' ,$
                                      SELF    : 'SELF'   ,$
                                      WINIT   : {INFO : 'DWWINIT' ,$
                                                 TYPE : 'GAUSSIAN',$
                                                 A    :  0.05     ,$
                                                 S    : 10.       ,$
                                                 R    : 11        ,$
                                                 N    :  0.025    ,$
                                                 NORM :  0        },$
                                      DINIT   : {INFO : 'DWDINIT' ,$
                                                 TYPE : 'LINEAR'  ,$
                                                 M    :  1        ,$
                                                 D    : 12        ,$
                                                 R    : 11        },$
                                      T2S     : 0        ,$
                                      FILE    : 's-c'    })
   
