;+
; NAME: inputtemp.pro
;
;
; PURPOSE:  Template -> 'Input'  
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

MINPUT = LonArr(1)
MFILTER = lonarr(1)
MFILTER(0) = Handle_Create(!MH, VALUE={ NAME : 'ifname' ,$
                                        start: 0 ,$
                                        stop : 100 ,$
                                        params : $
                                        {$
                                        }$
                                      })

MINPUT(0) = Handle_Create(!MH, VALUE={INFO    : 'INPUT'  ,$
                                      INDEX   :    0     ,$
                                      LAYER   :    0     ,$
                                      SYNAPSE : 'FEEDING',$
                                      TYPE    : 'EXTERN' ,$
                                      PERIOD  : 100.0      ,$
                                      time_step : 1.0, $
                                      visible : 1,$
                                      filters : MFILTER, $
                                      corr     : 0.0 })
