;+
; NAME: haus2_INITDATA
;
; AIM:
;  Initialize the data and structures used by the simulation application.
;
; PURPOSE: Teilprogramm zur Demonstration der Benutzung von <A HREF="../#FACEIT">FaceIt</A>. 
;          *_INITDATA dient der Festlegung der Simulationsstrukturen 
;          (Layer, DWs usw) und der globalen Parameter zu Beginn der 
;          Simulation.
;          
;          Zum Aufbau einer eigenen Simulation empfiehlt es sich, diese Routine
;          zu kopieren, den haus2-Teil des Namens durch den der eigenen
;          Simulation zu ersetzen und die Routine nach den eigenen Wünschen 
;          abzuwandeln.
;
; CATEGORY: GRAPHICS / WIDGETS / FACEIT_DEMO
;
; CALLING SEQUENCE: haus2_INITDATA, dataptr
;
; INPUTS: dataptr : Ein Pointer auf eine Struktur, die alle notwendigen
;                   Simulationsdaten (Parameter, NASE-Strukturen wie Layer und
;                   DWs) enthält. Der Pointer wird von <A HREF="../#FACEIT">FaceIt</A> zur Verfügung 
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
; EXAMPLE: FaceIt, 'haus2'
;          Die Beispielsimulation definiert eine Schicht aus 7x7 Neuronen,
;          die vollständig verbunden sind (allerdings keine direkte Verbindung
;          eines Neurons mit sich selbst). Die Verbindungstärken sind alle 
;          gleich, ihre Stärke kann mit einem Schieberegler während der 
;          Simulation variiert werden. Alle Verbindungen sind verzögert, die 
;          Initialisierung der Delays ist zufällig gleichverteilt im Intervall
;          [10ms, 20ms]. 
;          Die Neuronen erhalten außerdem äußeren Input in Form von Pulsen, 
;          die alle Neuronen gleichzeitig erregen. Stärke und Periode dieser 
;          Pulse kann ebenfalls mit Slidern reguliert werden.
;          Weitere Schieberegler dienen dem Anpassen der Parameter der
;          dynamischen Schwelle
;
; SEE ALSO: <A HREF="../#FACEIT">FaceIt</A> und IDL-Online-Hilfe zu 'Create_Struct'
;           
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 1.4  2000/10/01 14:52:11  kupper
;        Added AIM: entries in document header. First NASE workshop rules!
;
;        Revision 1.3  1999/09/15 15:00:16  kupper
;        Added a TEMPORARY() here and there to conserve memory...
;
;        Revision 1.2  1999/09/03 14:24:46  thiel
;            Better docu.
;
;        Revision 1.1  1999/09/01 16:46:31  thiel
;            Moved in repository.
;
;        Revision 1.1  1999/09/01 13:38:10  thiel
;            First version of FaceIt-Demo-Routines. Doku not yet complete.
;
;-


PRO haus2_INITDATA, dataptr

   Message, /INFO, "Initializing simulation data."


   ; Fill the structure with variables that are to be used by all routines:
   *dataptr = Create_Struct(TEMPORARY(*dataptr), $

;--- CHANGE THE FOLLOWING PART TO BUILD YOUR OWN SIUMLATION: 

      'prew' , 7, $, ; width and height of neuron layer
      'preh' , 7, $
      'extinpampl' , 1.1, $ ; amplitude of external input
      'extinpperiod' , 50, $ ; period of external input
      'couplampl' , 10., $ ; amplitude of intra-layer coupling
      'maxdelay' , 20, $ ; upper and lower boundary of delays
      'mindelay' , 10, $ 
      'counter' , 0l $ ; counter for determining elapsed time
   )
 


   Message, /INFO, "... neurons."

   ; Put NASE-objects inside the structure as well:

   ; parameters:
   *dataptr = Create_Struct( TEMPORARY(*dataptr), $
                       'prepara', InitPara_1(tauf=1., Vs=10., taus=5.) $
                     )
   ; a layer:
   *dataptr = Create_Struct( *dataptr, $
      'pre', InitLayer(WIDTH=(*dataptr).prew, HEIGHT=(*dataptr).preh, $
                       TYPE=(*dataptr).prepara), $
   ; the output of the layer in the previous timestep:
      'lastout', LonArr((*dataptr).preh,(*dataptr).prew) $               
                     )


   Message, /INFO, "... coupling: CON_pre_pre."
   
   ; and a DW-structure for intra-layer coupling:
   *dataptr = Create_Struct( *dataptr, $
      'CON_pre_pre', $
         InitDW(S_LAYER=(*dataptr).pre, T_LAYER=(*dataptr).pre, $
                WEIGHT=(*dataptr).couplampl/(*dataptr).prew/(*dataptr).preh, $
                D_RANDOM=[(*dataptr).mindelay,(*dataptr).maxdelay], $
                /W_NONSELF, /D_NONSELF) $
   )

;--- NO CHANGES NECESSARY BELOW THIS LINE.


END ; haus2_INITDATA
