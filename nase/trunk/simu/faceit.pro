;+
; NAME: FaceIt 
;       (Frame for Application Control by Event-driven Interactive Technology)
;
; PURPOSE: Stellt Grundfunktionen einer graphischen Simulationsoberfläche zur 
;          Verfügung. FaceIt erzeugt eine IDL-Widget-Anwendung, die ein Fenster
;          zur Darstellung des Simulationsablaufs und Buttons zur Steuerung 
;          dieser Simulation besitzt. Der Simulationskern und die Darstellung
;          der Ergebnisse (Spiketrains, DW-Matrizen usw) müssen vom Benutzer 
;          in separaten Routinen festgelegt werden. FaceIt ruft diese Routinen 
;          dann regelmäßig und entsprechend den auftretenden Ereignisse (zB 
;          Mausklicks auf die Buttons) auf.
;
; CATEGORY: SIMULATION
;
; CALLING SEQUENCE: FaceIt, name
;
; INPUTS: name: Ein String, der den Namen der auszuführenden Simulation 
;               enthält.
;
;         Desweiteren erwartet FaceIt, daß es die unten aufgeführten Routinen 
;         finden kann. Beim Aufruf werden die angeführten Parameter übergeben.
;         Dabei handelt es sich um die beiden Pointer dataptr und displayptr
;         und das Widget W_userbase.
;
;          PRO name_INITDATA, dataptr
;          PRO name_INITDISPLAY, dataptr, displayptr, W_UserBase
;          FUNCTION name_SIMULATE, dataptr 
;           ---> Return, 1
;          FUNCTION name_DISPLAY, dataptr, , displayptr, W_UserBase
;           ---> Return, 1
;          FUNCTION name_USEREVENT, Event
;           ---> Return, 0
;          PRO name_RESET, dataptr, displayptr, W_UserBase
;          FUNCTION name_KILL_REQUEST, dataptr, displayptr, W_UserBase
;           ---> Return, 1
;
; OUTPUTS: Eine IDL-Widget-Anwendung mit folgenden Bedienelementen:
;           DISPLAY: Schaltet die Darstellung während der Simulation ein oder 
;                    aus.
;           SIMULATION DELAY: Zur Bestimmung der Verzögerung. Soll ja 
;                             Simulationen geben, die so schnell sind, daß man
;                             nicht mehr zugucken kann. Hiermit kann man diese
;                             bremsen.
;           START / STOP: Startet / stoppt die Simulation. Nach einem Stop wird
;                         der Simulationablauf bei erneutem Start-Drücken 
;                         fortgesetzt.
;           RESET: Führt die Prozedur name_RESET aus, zB, um die 
;                  Simulationsdaten auf ihren ursprünglichen Stand zu setzen
;                  oder die Bildschirmdarstellung zu erneuern.
;          Desweiteren besitzt die erzeugte Anwendung ein Widget namens 
;          W_userbase, das sich unter den Bedienelementen befindet und zur 
;          Aufnahme simulationsspezifischen Widgets dient.
;           
; COMMON BLOCKS: WidgetSimulation, MyFont, MySmallFont
;                mit: MyFont = '-adobe-helvetica-bold-r-normal$
;                               --14-140-75-75-p-82-iso8859-1'
;                und: MySmallFont = '-adobe-helvetica-bold-r-normal$
;                                    --12-120-75-75-p-70-iso8859-1'
;
; RESTRICTIONS: Die Benutzung ist erst mit IDL 5 möglich.
;
;               WARNUNG: Dies ist erst der Alpha-Release, also ist mit
;               Umstellungen der Syntax und Bugs zu rechnen.
;
; PROCEDURE: (schreib ich mal irgendwann)
;
; EXAMPLE: FaceIt, 'haus2'
;
; SEE ALSO: ---
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 1.1  1999/08/19 08:21:36  thiel
;            The Program Formerly Known As NASim.
;
;        Revision 1.3  1999/08/17 13:34:38  thiel
;            Still not complete, but improved once more.
;
;        Revision 1.2  1999/08/13 15:38:13  thiel
;            Alphe release: Now separated basic functions and user definitions.
;
;        Revision 1.1  1999/08/09 16:43:23  kupper
;        Ein Sub-Alpha-Realease der neuen graphischen
;        Simulationsoberflaeche.
;        Fuer Andreas.
;
;-



FUNCTION FaceIt_CreateData, simname

   dataptr = PTR_NEW({info : simname+'_data'})

   Call_Procedure, simname+'_INITDATA', dataptr

   Return, dataptr

END ; FaceIt_CreateData


FUNCTION FaceIt_CreateDisplay, simname, dataptr, W_userbase

   displayptr = PTR_NEW({info : simname+'_display'})

   Call_Procedure, simname+'_INITDISPLAY', $
    dataptr, displayptr, W_userbase

   Return, displayptr

END ; FaceIt_CreateDisplay


;--- This handles the basic events
PRO FaceIt_EVENT, Event

   WIDGET_CONTROL, Event.Top, GET_UVALUE=UV, /NO_COPY
   widget_killed = 0
  
   EventName =  TAG_NAMES(Event, /STRUCTURE_NAME)

   CASE Event.ID OF


      ;--- Basic events from outside, possibly sent to the simulation:
      UV.W_Base : CASE EventName OF 
         "WIDGET_TIMER" : $
          BEGIN
            IF UV.continue_simulation THEN BEGIN 
               ;Initiate next simulation cycle
               WIDGET_CONTROL, UV.W_Base, TIMER=UV.SimDelay
               UV.continue_simulation = $
                Call_FUNCTION(UV.simname+'_SIMULATE', UV.dataptr)
               CurrentTime = SysTime(1)
               Widget_Control, UV.W_SimStepTime, SET_VALUE=str(round((CurrentTime-UV.SimAbsTime)*1000))
               UV.SimAbsTime = CurrentTime
               IF (UV.display) THEN BEGIN 
                  UV.display = $
                   Call_FUNCTION(UV.simname+'_DISPLAY', UV.dataptr, UV.displayptr, UV.W_UserBase) 
               ENDIF
            ENDIF
         END ; WIDGET_TIMER
                                              
         "WIDGET_KILL_REQUEST" : $
          IF Call_FUNCTION(UV.simname+'_KILL_REQUEST', UV.dataptr, UV.displayptr, UV.W_UserBase) THEN BEGIN
            Ptr_Free, UV.dataptr 
            Ptr_Free, UV.displayptr
            WIDGET_CONTROL, Event.Top, /DESTROY
            widget_killed = 1
         ENDIF ; WIDGET_KILL_REQUEST
  
         "SIMULATION_START" : $
          IF NOT UV.continue_simulation THEN BEGIN
            UV.continue_simulation = 1
            UV.SimAbsTime = SysTime(1)
            WIDGET_CONTROL, UV.W_Base, TIMER=0 ;Initiate next simulation cycle
         ENDIF

         "SIMULATION_STOP" : UV.continue_simulation = 0
                                              
         'SIMULATION_RESET' : Call_Procedure, UV.simname+'_RESET', $
                                 UV.dataptr, UV.displayptr, UV.W_userbase

         ELSE : Message, "Unexpected event caught from W_Base: "+ EventName
              
      ENDCASE 
  
      


      ;--- Internal basic events, button presses and such:
      UV.W_SimDelay: CASE EventName OF  
         "WIDGET_SLIDER" : BEGIN
            WIDGET_CONTROL, UV.W_SimDelay, GET_VALUE=NewDelay
            UV.SimDelay = (NewDelay/1000.0) > UV.minSimDelay
         END 
     
         ELSE : Message, "Unexpected event caught from W_SimDelay: "+ EventName
      ENDCASE 
 
     
      UV.W_SimStart: $ ; "Pressed" is the only event that this will generate
       IF NOT UV.continue_simulation THEN BEGIN  
         UV.continue_simulation = 1
         UV.SimAbsTime = SysTime(1)
         WIDGET_CONTROL, UV.W_Base, TIMER=0 ;Initiate next simulation cycle
      ENDIF 

      UV.W_SimStop : UV.continue_simulation = 0 ; "Pressed" is the only event that this will generate

      UV.W_SimReset : $
       Call_Procedure, UV.simname+'_RESET', UV.dataptr, UV.displayptr, $
          UV.W_userbase

      UV.W_SimDisplay: BEGIN
         UV.display = Event.Select
         Widget_Control, UV.W_SimDelay, SENSITIVE=UV.display
         IF UV.display THEN BEGIN 
            UV.SimDelay = UV.oldsimdelay
         ENDIF ELSE BEGIN 
            UV.oldsimdelay = UV.SimDelay
            UV.SimDelay = UV.MinSimDelay
         ENDELSE  
      END 

      ELSE : Message, /INFO, "Caught unhandled event!"
 
   ENDCASE 



   IF NOT(widget_killed) THEN WIDGET_CONTROL, Event.Top, SET_UVALUE=UV, /NO_COPY
END ; all2all_EVENT



PRO FaceIt, simname

   COMMON WidgetSimulation, MyFont, MySmallFont


   DEBUGMODE = 1; XMANAGER will terminate on error, if DEBUGMODE is set
   

   minSimDelay = 1e-30; secs
   MyFont = '-adobe-helvetica-bold-r-normal--14-140-75-75-p-82-iso8859-1'
   MySmallFont = '-adobe-helvetica-bold-r-normal--12-120-75-75-p-70-iso8859-1'

   Widget_Control, DEFAULT_FONT=MySmallFont ;Let it be default.

   W_Base = Widget_Base (TITLE=SimulationName, $
                         /BASE_ALIGN_CENTER, $
                         /COLUMN, $
                         /TLB_KILL_REQUEST_EVENTS $ ;test: IF TAG_NAMES(event, /STRUCTURE_NAME) EQ 'WIDGET_KILL_REQUEST' THEN ...
                         $      ;Note that widgets that have this keyword set are responsible for killing themselves
                         $      ; after receiving a WIDGET_KILL_REQUEST event. They cannot be destroyed using the usual window system controls.
                        )
   
   W_SimControl = Widget_Base(W_Base, $
                              FRAME=3, $
                              /BASE_ALIGN_CENTER, $
                              /ALIGN_TOP, /ROW $
                             )
   W_simlogo  = DefineSheet(W_simcontrol, /WINDOW, XSIZE=75, YSIZE=50, $
                                /PRIVATE_COLORS)

   W_SimDisplay = CW_BGroup(W_SimControl, "Display", $
                            /NONEXCLUSIVE, $
                            SET_VALUE=1, $
                            FONT=MyFont $
                           )
   W_SimDelay = Widget_Slider(W_SimControl, $
                              MINIMUM=0, MAXIMUM=1000, XSIZE=238, $
                              TITLE="Simulation Delay / ms", FONT=MySmallFont $
                             )
   W_SimStepTime = Widget_Label(W_SimControl, $
                                FONT=MySmallFont, $
                                FRAME=0, $
                                VALUE="----" $
                               )
   W_SimStart = Widget_Button(W_SimControl, $
                              VALUE="Start", FONT=MyFont $
                             )
   W_SimStop  = Widget_Button(W_SimControl, $
                              VALUE="Stop", FONT=MyFont $
                             )
   
   
   W_SimReset  = Widget_Button(W_SimControl, $
                              VALUE="Reset", FONT=MyFont $
                             )
   
   W_UserBase = Widget_Base(W_Base, $
                            FRAME=3, $
                            /BASE_ALIGN_CENTER, $
                            /COLUMN, $
                            EVENT_FUNC=simname+'_USEREVENT' $
                           )
   
   
   Message, /INFO, ""
   Message, /INFO, "   ******************************"
   Message, /INFO, "   *** Calling Initialization ***"
   Message, /INFO, "   ******************************"


   userstruct = Create_Struct( $
      'simname', simname, $
      'dataptr', FaceIt_CreateData(simname) $
   )

   userstruct = Create_Struct(userstruct, $
      'displayptr', FaceIt_CreateDisplay(simname, $
                       userstruct.dataptr, W_UserBase), $
      'W_Base', W_Base, $
      'W_simlogo', w_simlogo, $
      'W_SimDisplay', W_SimDisplay, $
      'W_SimDelay', W_SimDelay, $
      'W_SimStepTime', W_SimStepTime, $
      'SimAbsTime', SysTime(1), $
      'W_SimStart', W_SimStart, $
      'W_SimStop', W_SimStop, $
      'W_SimReset', W_SimReset, $
      'W_UserBase', W_UserBase, $
      'minSimDelay', minSimDelay, $
      'oldSimDelay', minSimDelay, $
      'SimDelay', minSimDelay, $ ;SimulationDelay/ms
      'continue_simulation', 0, $ ; Flags
      'display', 1 $
   )
   
   Widget_Control, W_Base, /NO_COPY, SET_UVALUE=userstruct
            
   ;--- display nase-logo:
   WIDGET_CONTROL, W_Base, GET_UVALUE=UV
   OpenSheet, UV.w_simlogo
   Read_GIF, GETENV("NASEPATH")+"/graphic/naselogo2_small.gif", logo, r, g, b
   Utvlct, r, g, b
   Utv, logo
   CloseSheet, UV.w_simlogo


   Message, /INFO, ""
   Message, /INFO, "   ********************************"
   Message, /INFO, "   *** Registering Main Widget  ***"
   Message, /INFO, "   ********************************"
   Widget_Control, W_Base, /REALIZE  
   XMANAGER, CATCH=1-DEBUGMODE
   XMANAGER, "Simulation: "+SimName, W_Base, EVENT_HANDLER="FaceIt_EVENT", /NO_BLOCK


END ; FaceIt

