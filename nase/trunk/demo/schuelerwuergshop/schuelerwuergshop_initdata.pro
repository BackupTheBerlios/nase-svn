;+
; NAME: schuelerwuergshop_INITDATA
;
; AIM: Module of <A>schuelerwuergshop</A>  (see also  <A>faceit</A>)
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
; CALLING SEQUENCE: schuelerwuergshop_INITDATA, dataptr
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
;        Revision 1.2  2000/09/28 12:29:37  alshaikh
;              added AIM
;
;        Revision 1.1  2000/02/17 17:41:46  kupper
;        Fuer die lieben Schueler.
;
;        Revision 1.3  1999/09/20 16:36:18  kupper
;        Copy from schuelerwuergshop now okay.
;
;        Revision 1.2  1999/09/20 16:13:55  kupper
;        Kopiert aus schuelerwuergshop.
;
;        Revision 1.1  1999/09/14 15:02:12  kupper
;        Initial revision
;
;-


Pro schuelerwuergshop_ImageSet_a, P
   image_prefix = "../a_"
   sizes = [12, 14, 16, 20, 22, 24, 26, 36, 48]
   Message, /INFO, "Loading Images"
   for i=0, (*P).number_of_images-1 do begin
      Read_X11_BitMap, image_prefix+str(sizes[i])+".xbm", image, height, width, /EXPAND_TO_BYTES
      (*P).images[*, *, i] = transpose(float(image)/255) ;richtig drehen und auf 1 skalieren  
   endfor 
End 
Pro schuelerwuergshop_ImageSet_disc, P
   for i=0, (*P).number_of_images-1 do begin
      (*P).images[*, *, i] = CutTorus(fltarr( (*P).RetinaHeight, (*P).RetinaWidth )+1, i)
   endfor   
End
Pro schuelerwuergshop_ImageSet_gauss, P
   for i=0, (*P).number_of_images-1 do begin
      (*P).images[*, *, i] = gauss_2d( (*P).RetinaHeight, (*P).RetinaWidth, hwb=(i+1)*0.5)
   endfor   
End


PRO schuelerwuergshop_INITDATA, dataptr

   Message, /INFO, "Initializing simulation data."


   GaborWavelength = 4          ;multiples of 2!!
   RETINASize      = 24
   DotProb         = 0.001


   ; Fill the structure with variables that are to be used by all routines:
   *dataptr = Create_Struct(TEMPORARY(*dataptr), $

;--- CHANGE THE FOLLOWING PART TO BUILD YOUR OWN SIUMLATION: 

                 $              ;Sizes
                 "InputWidth"              , RETINASize, $;*(GaborWavelength/2), $;Sampling-Theorem!
                 "InputHeight"             , RETINASize, $;*(GaborWavelength/2), $;Sampling-Theorem!
                 "CurrentInput"            , fltarr(RETINASize, RETINASize), $;fltarr(RETINASize*(GaborWavelength/2), RETINASize*(GaborWavelength/2)), $
                 $
                 "RetinaWidth"             , RETINASize, $
                 "RetinaHeight"            , RETINASize, $
                 "CurrentRetinaIn"         , fltarr(RETINASize, RETINASize), $ 
                 "CurrentRetinaIn_spass"   , PTR_NEW(0), $
                 $
                 "ControlWidth"            , 1, $
                 "ControlHeight"           , 1, $
                 $
;$                 "CORTEXWidth"             , 1, $
;$                 "CORTEXHeight"            , 1, $
                 $              ;Parameters of RETINA-Cells RF
                 "GaborWavelength"         , GaborWavelength, $
                 "GaborSize"               , GaborWavelength*2-1, $ ; Size of the Array
                 "GaborHWB"                , GaborWavelength/5.0, $ ; HWB
                 "GaborAmplitude"          , 3.0, $
                 $              ;Parameters of CORTEX-Cell(s) RF
;$                 "CORTEXStrength"          , 1.0, $
                 $              ;Parameters of CONTROL-PF
                 "CouplingAmplitude"       , 0.2, $
                 "CouplingRange"           , 5, $
                 "coupling_enabled"        , 1, $
                 "Counter"                 , 0l $
    )
 


   Message, /INFO, "initializing Neurons&Coupling" 
   ; Put NASE-objects inside the structure as well:

   ;;Neurons&Coupling
   *dataptr = Create_Struct( Temporary(*dataptr), $
                      "RetinaNeuron", InitPara_1(sigma=0.1), $ ;0.4
                      "CORTEXNeuron", InitPara_2(TAUR=50, VR=7, TAUS=1) $
                    )
   *dataptr = Create_Struct( *dataptr, $
                      "RETINA", initlayer(WIDTH=(*dataptr).RetinaWidth, HEIGHT=(*dataptr).RetinaHeight, TYPE=(*dataptr).RetinaNeuron) $;, $
;$                      "CORTEX", initlayer(WIDTH=(*dataptr).CORTEXWidth, HEIGHT=(*dataptr).CORTEXHeight, TYPE=(*dataptr).CORTEXNeuron) $
                    )

   Message, /INFO, "initializing RETINARF"
   ;INPUTtoRETINA = InitDW (S_WIDTH=(*dataptr).InputWidth, S_HEIGHT=(*dataptr).InputHeight $
   ;                                             , T_LAYER=(*dataptr).RETINA $
   ;                                            )
   ;SetWeight, INPUTtoRETINA, cuttorus((*dataptr).GaborAmplitude*Gabor((*dataptr).INPUTWidth, WAVELENGTH=(*dataptr).GaborWavelength, HWB=(*dataptr).GaborHWB), (*dataptr).GABORWAVELENGTH, CUT_VALUE=!NONE), $
   ; T_ROW=(*dataptr).RETINAHeight/2, T_COL=(*dataptr).RETINAWidth/2, $ 
   ; /ALL
   ;tomwaits, INPUTtoRETINA, NO_BLOCK=0

   *dataptr = Create_Struct( *dataptr, $
                       "RETINARF",       Gabor((*dataptr).GaborSize, WAVELENGTH=(*dataptr).GaborWavelength, HWB=(*dataptr).GaborHWB, /MAXONE) $
                       ;GaborAmplitude wird online dranmultipliziert!
                       ;"INPUTtoRETINA", INPUTtoRETINA $
                     )
   

;   Message, /INFO, "initializing RETINAtoCORTEX"
;   *dataptr = Create_Struct( *dataptr, $
;                      "RETINAtoCORTEX", InitDW(S_LAYER=(*dataptr).RETINA, T_LAYER=(*dataptr).CORTEX $
;                                               , WEIGHT=(*dataptr).CORTEXStrength $
;                                              ) $
;                    )
   

   Message, /INFO, "initializing intra-RETINA-coupling: RETINAtoRETINA"
   *dataptr = Create_Struct( *dataptr, $
                       "RETINAtoRETINA", InitDW(S_LAYER=(*dataptr).RETINA , T_LAYER=(*dataptr).RETINA $
                                                , /SOURCE_TO_TARGET $
                                                , W_LINEAR=[(*dataptr).CouplingAmplitude, (*dataptr).CouplingRange] $
                                                , /W_NONSELF $
                                               ) $
                    )
;   *dataptr = Create_Struct( *dataptr, $
;                       "CONTROLPF", (*dataptr).ControlAmplitude*Gauss_2d((*dataptr).RETINAHeight, (*dataptr).RETINAwidth, HWB=(*dataptr).ControlHWB) $
;                     )
;   *dataptr = Create_Struct( *dataptr, $
;                       "CONTROLPF_spass", Spassmacher((*dataptr).CONTROLPF) $
;                     )

   number_of_images = 9
   *dataptr =  Create_Struct (*dataptr, $
                        "images", fltarr((*dataptr).RetinaHeight, (*dataptr).RetinaWidth, number_of_images), $
                        "number_of_images", number_of_images, $
                        "current_image", 5, $
                        "image_brightness", 1.0, $
                        "image_set", "schuelerwuergshop_ImageSet_a" $
                       )
   Call_Procedure, (*dataptr).image_set, dataptr



;--- NO CHANGES NECESSARY BELOW THIS LINE.


END ; schuelerwuergshop_INITDATA
