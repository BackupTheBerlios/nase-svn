;+
; NAME:
;  DWeightTemp
;
; VERSION:
;  $Id$
; 
; AIM:
;  Template for defining a DelayWeight data structure
;
; PURPOSE:
;  Template for defining a DelayWeight data structure
;
; CATEGORY: 
;  Connections
;  MIND
;  Simulation
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
   
   ; if FILE is omitted or set to NULL, nothing is saved
