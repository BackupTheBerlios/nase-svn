;+
; NAME: cornsweet_initdata
;
; AIM : Module of cornsweet.pro  (see also  <A>faceit</A>)
;
; PURPOSE:
;
;
; CATEGORY:
;
;
; CALLING SEQUENCE:
;
; 
; INPUTS:
;
;
; OPTIONAL INPUTS:
;
;	
; KEYWORD PARAMETERS:
;
;
; OUTPUTS:
;
;
; OPTIONAL OUTPUTS:
;
;
; COMMON BLOCKS:
;
;
; SIDE EFFECTS:
;
;
; RESTRICTIONS:
;
; PROCEDURE:
;
;
; EXAMPLE:
;
;-
;
; MODIFICATION HISTORY:
;
;
;     $Log$
;     Revision 1.3  2000/09/28 12:06:29  alshaikh
;           AIM bugfixes
;
;     Revision 1.2  2000/09/27 15:08:04  alshaikh
;           AIM-tag added
;
;     Revision 1.1  2000/02/16 10:20:35  alshaikh
;           initial version
;
;
;

PRO cornsweet_INITDATA, dataptr
   Message, /INFO, "Initializing simulation data."


   ; Fill the structure with variables that are to be used by all routines:
   *dataptr = Create_Struct(TEMPORARY(*dataptr), $

;--- CHANGE THE FOLLOWING PART TO BUILD YOUR OWN SIUMLATION: 

      'length' , 200, $, ; height of neuron layer
      'linkparrange',11, $   ; linking range
      'linkparampl' , 0.1, $ ; amplitude of linking input
      'extinpampl' , 0.1, $ ; period of external input
      'extinpoffset' , 0.2, $ 
      'extinpleft' , 65, $ 
      'extinptau' , 6.5, $ 
      'inpattern', fltarr(200), $
      'outpattern', fltarr(200), $
       'passedtime',0,$
       'extinpperiod',100000l,$

      'mindelay' , 10, $ 
      'counter' , 0l $ ; counter for determining elapsed time
   )
 


   Message, /INFO, "... neurons."

   ; Put NASE-objects inside the structure as well:

   ; parameters:
   *dataptr = Create_Struct( TEMPORARY(*dataptr), $
                       'prepara', InitPara_1(tauf=10.0,taul=1.0,taui=15.0,Vs=5., taus=20.0,th0=1.0,sigma=0.1) $
                     )
   ; a layer:
   *dataptr = Create_Struct( *dataptr, $
      'pre', InitLayer(WIDTH=(*dataptr).length, HEIGHT=1, $
                       TYPE=(*dataptr).prepara) $
   ; the output of the layer in the previous timestep:
   ;  'lastout', LonArr((*dataptr).length,1) $               
                     )


   Message, /INFO, "... coupling: CON_pre_pre."
   
   ; and a DW-structure for intra-layer coupling:
   *dataptr = Create_Struct( *dataptr, $
      'CON_pre_pre', $
         InitDW(S_LAYER=(*dataptr).pre, T_LAYER=(*dataptr).pre, $
                W_CONST=[(*dataptr).linkparampl,(*dataptr).linkparrange], $
                         /W_NONSELF, /D_NONSELF) $
   )

;--- NO CHANGES NECESSARY BELOW THIS LINE.


END ; cornsweet_INITDATA
