;+
; NAME: haus2_INITDATA
;
; PURPOSE: Teilprogramm zur Demonstration der Beutzung von <A HREF="#FACEIT">FaceIt</A>. 
;          *_INITDATA dient der Festlegung der Simulationsstrukturen 
;          (Layer, DWs usw) und der globalen Parameter zu Beginn der 
;          Simulation.
;          
;          Zum Aufbau einer eigenen Simulation empfiehlt es sich, diese Routine
;          zu kopieren, den haus2-Teil des Namens durch den der eigenen
;          Simulation zu ersetzen und die Routine nach den eigenen Wünschen 
;          abzuwandeln.
;
; CATEGORY: SIMULATION / FACEIT
;
; CALLING SEQUENCE: haus2_INITDATA, dataptr
;
; INPUTS: dataptr : Ein Pointer auf eine Struktur, die alle notwendigen
;                   Simulationsdaten (Parameter, NASE-Strukturen wie Layer und
;                   DWs) enthält. Der Pointer wird von FaceIt zur Verfügung 
;                   gestellt, der Aufbau der Struktur ist vom Benutzer 
;                   auszuführen.  Das macht man so:
;                    *dataptr = Create_Struct(*dataptr, 'lernrate' , 0.23)
;                   oder so:
;                    *dataptr = Create_Struct( *dataptr, $
;                         'layer', InitLayer(WIDTH=(*dataptr).width, $
;                                            HEIGHT=(*dataptr).height, $
;                                            TYPE=(*dataptr).paratype))
;
; (SIDE) EFFECTS: *dataptr sollte nach dem Durchlauf von *_INITDATA alle
;                 relevanten Daten enthalten.
;
; RESTRICTIONS: Die Benutzung der gesamten FaceIt-Architektur ist erst ab 
;               IDL 5 möglich. 
;
; EXAMPLE: Siehe Programmtext.
;
; SEE ALSO: FaceIt, 
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 1.1  1999/09/01 16:46:31  thiel
;            Moved in repository.
;
;        Revision 1.1  1999/09/01 13:38:10  thiel
;            First version of FaceIt-Demo-Routines. Doku not yet complete.
;
;-


PRO haus2_INITDATA, dataptr

   Message, /INFO, "Initializing simulation data."

   *dataptr = Create_Struct(*dataptr, $
      'prew' , 7, $, ; width and height of neuron layer
      'preh' , 7, $
      'extinpampl' , 1.1, $ ; amplitude of external input
      'extinpperiod' , 50, $ ; period of external input
      'couplampl' , 10., $ ; amplitude of intra-layer coupling
      'maxdelay' , 20, $ ; upper and lower boundary of delays
      'mindelay' , 10, $ 
      'counter' , 0l $ ; counter for determining elapsed time
   )
 

   ;--- init neurons:
   Message, /INFO, "... neurons."

   *dataptr = Create_Struct( *dataptr, $
                       'prepara', InitPara_1(tauf=1., Vs=10., taus=5.) $
                     )
   *dataptr = Create_Struct( *dataptr, $
      'pre', InitLayer(WIDTH=(*dataptr).prew, HEIGHT=(*dataptr).preh, $
                       TYPE=(*dataptr).prepara), $
      'lastout', LonArr((*dataptr).preh,(*dataptr).prew) $               
                     )



   ;--- init coupling:
   Message, /INFO, "... coupling: CON_pre_pre."
   
   *dataptr = Create_Struct( *dataptr, $
      'CON_pre_pre', $
         InitDW(S_LAYER=(*dataptr).pre, T_LAYER=(*dataptr).pre, $
                WEIGHT=(*dataptr).couplampl/(*dataptr).prew/(*dataptr).preh, $
                D_RANDOM=[(*dataptr).mindelay,(*dataptr).maxdelay], $
                /W_NONSELF, /D_NONSELF) $
   )


END ; haus2_INITDATA
