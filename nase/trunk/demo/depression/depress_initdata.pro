;+
; NAME: depress_initdata
;
; AIM: Module of depress.pro  (see also  <A>faceit</A>)
;
; PURPOSE: siehe depress.pro
;
;
; MODIFICATION HISTORY:
;
;
;     $Log$
;     Revision 1.2  2000/09/28 12:16:12  alshaikh
;           added AIM
;
;     Revision 1.1  1999/10/14 12:31:13  alshaikh
;           initial version
;
;
;-

PRO depress_INITDATA, dataptr

   Message, /INFO, "Initializing simulation data."


   ; Fill the structure with variables that are to be used by all routines:
   *dataptr = Create_Struct(TEMPORARY(*dataptr), $


      'prew' , 100, $, ; width and height of neuron layer
      'preh' , 20, $
      'extinpampl' , 1.0, $ ; amplitude of external input
      'tau_rec', 200.0, $   ; depression parameters tau_rec and U_se
      'u_se', 0.6, $
      'frequency1', 50.0, $  ; external excitation 1 
      'frequency2', 5.0, $    ; external excitation 2
      'counter' , 0l, $ ; counter for determining elapsed time
       'mode',1 $ ; excitation mode
       )
 

   Message, /INFO, "... neurons."

   ; Put NASE-objects inside the structure as well:

   ; parameters:
   
   ; Typ der ersten Neuronenschicht  
   *dataptr = Create_Struct( TEMPORARY(*dataptr), $
                       'in_type', InitPara_1(tauf=1., taul=1.0, taui=1.0,Vs=1.0, th0=1.0,taus=1.) $
                     )
   
   ; Typ der zweiten Neuronenschicht
   *dataptr = Create_Struct( TEMPORARY(*dataptr), $
                       'prepara', InitPara_1(tauf=1., Vs=1.0, th0=1.0,taus=10.0,sigma=0.0) $
  
                     )
  


; layers
 
   *dataptr = Create_Struct( *dataptr, $
      'in_layer', InitLayer(WIDTH=(*dataptr).prew, HEIGHT=(*dataptr).preh, $
                       TYPE=(*dataptr).in_type))

   *dataptr = Create_Struct( *dataptr, $
      'pre', InitLayer(WIDTH=2, HEIGHT=2, $
                       TYPE=(*dataptr).prepara), $

   ; the output of the layer in the previous timestep:
      'lastout', LonArr((*dataptr).preh,(*dataptr).prew) $               
                     )


   Message, /INFO, "... coupling: input layer with output layer"

   
   ; and a DW-structure for intra-layer coupling:
   ; Schicht 1 ist mit Schicht 2 vollstaendig verbunden 

   *dataptr = Create_Struct( *dataptr, $
      'CON_in_pre', $
         InitDW(S_LAYER=(*dataptr).in_layer, T_LAYER=(*dataptr).pre, $
           W_CONST=[1, 2],   NOCON=2, /depress, tau_rec=(*dataptr).tau_rec, $ 
                U_se=(*dataptr).U_se) $     
   )


END ; depress_INITDATA
