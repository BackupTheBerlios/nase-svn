;+
; NAME:  learntemp.pro
;
;
; PURPOSE: Template -> Learning 
;
;
; CATEGORY: Templates
;
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


   LEARNW = LonArr(1)
   LEARNW(0) = Handle_Create(!MH, VALUE={INFO    :  'LEARN' ,$
                                         INDEX   :   0      ,$
                                         DW      :   0      ,$
;
                                         RULE    :  'LHLP2' ,$
                                         ALPHA   :   0.25   ,$
                                         GAMMA   :   0.001  ,$
                                         WIN     :  'ALPHA' ,$
                                         TAU_INC :   0.3866 ,$
                                         TAU_DEC :   4.     ,$
;
                                         RECCON  : 100      ,$ 
                                         SHOWW   : 500      ,$ 
                                         ZOOM    :   1      ,$ 
                                         TERM    :  10.     ,$ 
                                         NOMERCY :   0      })
