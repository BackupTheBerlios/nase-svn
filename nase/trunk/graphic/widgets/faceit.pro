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
;         FaceIt erwartet, daß es die unten aufgeführten Routinen finden kann. 
;         Beim ihrem Aufruf durch FaceIt werden die angeführten Parameter
;         übergeben. Dabei handelt es sich um die beiden Pointer dataptr und 
;         displayptr, das Widget w_userbase und die Struktur event.
;
;          PRO <A HREF="./FACEIT_DEMO/#HAUS2_INITDATA">name_INITDATA</A>, dataptr
;             Zum Festlegen der Simulationsparameter und -datenstrukturen,
;             zB Layers und DWs.
;          PRO <A HREF="./FACEIT_DEMO/#HAUS2_INITDISPLAY">name_INITDISPLAY</A>, dataptr, displayptr, w_userbase
;             Hierin sollte der Aufbau der benutzereigenen Widget-Hierarchie
;             stattfinden.
;          FUNCTION <A HREF="./FACEIT_DEMO/#HAUS2_SIMULATE">name_SIMULATE</A>, dataptr 
;           ---> Return, 1
;             Sollte den Simulationskern enthalten: Inputbestimmung, Lernen,
;             Berechnen des neuen Netwerkzustands und dergleichen.
;          FUNCTION <A HREF="./FACEIT_DEMO/#HAUS2_DISPLAY">name_DISPLAY</A>, dataptr, displayptr
;           ---> Return, 1
;             Hier soll die Darstellung des Netzwerkzustands während der 
;             Simulation erfolgen.
;          FUNCTION <A HREF="./FACEIT_DEMO/#HAUS2_USEREVENT">name_USEREVENT</A>, Event
;           ---> Return, 0
;             Die Reaktion der benutzerdefinierten Widgets auf äußere 
;             Ereignisse (Mausklicks, Sliderbewegungen) muß hier festgelegt
;             werden.
;          PRO <A HREF="./FACEIT_DEMO/#HAUS2_RESET">name_RESET</A>, dataptr, displayptr, w_userbase
;             Falls notwendig, können hier Aktionen bestimmt werden, die bei
;             Betätigung des RESET-Buttons ausgeführt werden sollen.
;          PRO <A HREF="./FACEIT_DEMO/#HAUS2_FILEOPEN">name_FileOpen</A>, dataptr, displayptr, group
;             Diese Routine wird vom Menüpunkt 'File.Open' aufgerufen. Hier
;             können zuvor gespeicherte Simulationsdaten eingelesen werden.
;             (Der 'group'-Parameter dient dem Dateiauswahl-Widget als Eltern-
;             teil, ist für den Benutzer uninteressant.)
;          PRO <A HREF="./FACEIT_DEMO/#HAUS2_FILE_SAVE">name_FileSave</A>, dataptr, group
;             Der Menüeintrag 'File.Save' ruft diese Routine auf. Der Benutzer
;             kann damit bei Bedarf Simulationsdaten speichern.
;          FUNCTION <A HREF="./FACEIT_DEMO/#HAUS2_KILL_REQUEST">name_KILL_REQUEST</A>, dataptr, displayptr
;           ---> Return, 1
;             Die hierin enthaltenen Befehle werden vor der Zerstörung des
;             FaceIt-Widgets ausgeführt. ZB können Datenstrukturen freigegeben
;             werden.
;
; OUTPUTS: Eine IDL-Widget-Anwendung mit folgenden Bedienelementen:
;           FILE-Menü: Die bisher enthaltenen Unterpunkte dienen dem Laden
;                      und Speichern und dem Verlassen der Simulation.
;           DISPLAY: Schaltet die Darstellung während der Simulation ein oder 
;                    aus.
;           Steps: Zeigt die Zahl der Simulationsschritte an. Der Zähler wird
;                  bei jedem Simulate-Aufruf um 1 erhöht.
;           Duration: Zeigt die Dauer des letzten Simulationsschrittes in
;                     Millisekunden.
;           SIMULATION DELAY: Zur Bestimmung der Verzögerung. Soll ja 
;                             Simulationen geben, die so schnell sind, daß man
;                             nicht mehr zugucken kann. Hiermit kann man diese
;                             bremsen.
;           START / STOP: Startet / stoppt die Simulation. Nach einem Stop wird
;                         der Simulationablauf bei erneutem Start-Drücken 
;                         an der gleichen Stelle fortgesetzt. Ein Zurücksetzen
;                         erfolgt nicht (siehe RESET).
;           RESET: Führt die Prozedur <A HREF="./FACEIT_DEMO/#HAUS2_RESET">name_RESET</A> aus, zB, um die 
;                  Simulationsdaten auf ihren ursprünglichen Stand zu setzen
;                  oder die Bildschirmdarstellung zu erneuern. Außerdem wird
;                  der Zähler 'Steps' zurückgesetzt.
;          Desweiteren besitzt die erzeugte Anwendung ein Widget namens 
;          w_userbase, das sich unter den Bedienelementen befindet und zur 
;          Aufnahme der simulationsspezifischen Widgets dient.
;           
; COMMON BLOCKS: WidgetSimulation, MyFont, MySmallFont
;                mit: MyFont = '-adobe-helvetica-bold-r-normal$
;                               --14-140-75-75-p-82-iso8859-1'
;                und: MySmallFont = '-adobe-helvetica-bold-r-normal$
;                                    --12-120-75-75-p-70-iso8859-1'
;
; RESTRICTIONS: Die Benutzung ist erst mit IDL 5 möglich.
;
; PROCEDURE: - Aufbau einer IDL-Widget-Hierarchie mit den Kontrollelementen.
;            - Erzeugen des dataptr und Aufruf der _INITDATA-Routine per 
;              Call_Procedure.
;            - displayptr erzeugen und _INITDISPLAY aufrufen. Diese sollte
;              die Widget-Hierarchie vervollständigen.
;            - Falls die Widgets nicht schon vom Benutzer realisiert wurden,
;              dies mit FaceIt nachholen.
;            - Die Anwendung beim XMANAGER anmelden, und diesen dann immer 
;              wieder die Event-Funktion FACEIT_EVENT abarbeiten lassen.
;            - FaceIt_EVENT ruft regelmäßig _SIMULATE und _DISPLAY auf und
;              reagiert auf Knopfdruck vom Benutzer, wenn nötig.
;
; EXAMPLE: FaceIt, 'haus2'
;
; SEE ALSO: siehe oben
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 1.3  1999/09/02 12:20:42  thiel
;            Hyperlinks corrected.
;
;        Revision 1.2  1999/09/01 16:56:30  thiel
;            Removed 'w_userbase' in call to *_KILL_REQUEST.
;
;        Revision 1.1  1999/09/01 16:43:53  thiel
;            Moved from other directory.
;
;        Revision 1.3  1999/08/30 16:16:39  thiel
;            New File-menu.
;
;        Revision 1.2  1999/08/24 14:28:26  thiel
;            Beta release.
;
;        Revision 1.1  1999/08/19 08:21:36  thiel
;            The Program Formerly Known As NASim.
;
;        Revision 1.3  1999/08/17 13:34:38  thiel
;            Still not complete, but improved once more.
;
;        Revision 1.2  1999/08/13 15:38:13  thiel
;            Alpha release: Now separated basic functions and user definitions.
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
               Widget_Control, UV.W_SimStepCounter, $
                SET_VALUE='Steps: '+str(UV.stepcounter)               
               UV.continue_simulation = $
                Call_FUNCTION(UV.simname+'_SIMULATE', UV.dataptr)
               
               UV.stepcounter = UV.stepcounter+1
               CurrentTime = SysTime(1)
               Widget_Control, UV.W_SimStepTime, SET_VALUE='Duration: '+str(round((CurrentTime-UV.SimAbsTime)*1000))
               UV.SimAbsTime = CurrentTime
               IF (UV.display) THEN BEGIN 
                  UV.display = $
                   Call_FUNCTION(UV.simname+'_DISPLAY', UV.dataptr, UV.displayptr);, UV.W_UserBase) 
               ENDIF
            ENDIF
         END ; WIDGET_TIMER
                                              
         "WIDGET_KILL_REQUEST" : $
          IF Call_FUNCTION(UV.simname+'_KILL_REQUEST', UV.dataptr, UV.displayptr) THEN BEGIN
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
         ENDIF ; SIMULATION_START

         "SIMULATION_STOP" : UV.continue_simulation = 0
                                              
         'SIMULATION_RESET' : BEGIN
            Call_Procedure, UV.simname+'_RESET', $
             UV.dataptr, UV.displayptr;, UV.W_userbase
            UV.stepcounter = 0l
            Widget_Control, UV.W_SimStepCounter, $
             SET_VALUE='Steps: '+str(UV.stepcounter)               
         END

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

      UV.W_SimReset : BEGIN
         Call_Procedure, UV.simname+'_RESET', UV.dataptr, UV.displayptr;, $
          ;UV.W_userbase
         UV.stepcounter = 0l
         Widget_Control, UV.W_SimStepCounter, $
          SET_VALUE='Steps: '+str(UV.stepcounter)               
      END

      UV.W_SimDisplay: BEGIN
         UV.display = Event.Select
         Widget_Control, UV.W_SimDelay, SENSITIVE=UV.display
         Widget_Control, UV.W_userbase, SENSITIVE=UV.display
         IF UV.display THEN BEGIN 
            UV.SimDelay = UV.oldsimdelay
         ENDIF ELSE BEGIN 
            UV.oldsimdelay = UV.SimDelay
            UV.SimDelay = UV.MinSimDelay
         ENDELSE  
      END 

      uv.topmenu: BEGIN
         CASE event.value OF
            'File.Quit' : BEGIN 
               IF Call_FUNCTION(UV.simname+'_KILL_REQUEST', UV.dataptr, UV.displayptr) THEN BEGIN
                  Ptr_Free, UV.dataptr 
                  Ptr_Free, UV.displayptr
                  WIDGET_CONTROL, Event.Top, /DESTROY
                  widget_killed = 1
               ENDIF            ; WIDGET_KILL_REQUEST
            END

            'File.Save' : $
               Call_Procedure, uv.simname+'_FILESAVE', uv.dataptr, uv.topmenu

            'File.Open' : $
               Call_Procedure, uv.simname+'_FILEOPEN', uv.dataptr, $
                               uv.displayptr, uv.topmenu

            ELSE : Message, /INFO, "Caught unhandled menu event!"
         ENDCASE
      END


      ELSE : Message, /INFO, "Caught unhandled event!"
 
   ENDCASE 



   IF NOT(widget_killed) THEN WIDGET_CONTROL, Event.Top, SET_UVALUE=UV, /NO_COPY
END ; faceit_EVENT



PRO FaceIt, simname

   COMMON WidgetSimulation, MyFont, MySmallFont


   DEBUGMODE = 1; XMANAGER will terminate on error, if DEBUGMODE is set
   

   minSimDelay = 1e-30; secs


   MyFont = '-adobe-helvetica-bold-r-normal--14-140-75-75-p-82-iso8859-1'
   MySmallFont = '-adobe-helvetica-bold-r-normal--12-120-75-75-p-70-iso8859-1'

   Widget_Control, DEFAULT_FONT=MySmallFont ;Let it be default.




   ;--- Base:
   W_Base = Widget_Base (TITLE='FaceIt! '+simname, $
                         /BASE_ALIGN_LEFT, /COLUMN, $
                         /TLB_KILL_REQUEST_EVENTS $ ;test: IF TAG_NAMES(event, /STRUCTURE_NAME) EQ 'WIDGET_KILL_REQUEST' THEN ...
                         $      ;Note that widgets that have this keyword set are responsible for killing themselves
                         $      ; after receiving a WIDGET_KILL_REQUEST event. They cannot be destroyed using the usual window system controls.
                        )


   ;--- Menu:
   desc = ['3\File', $
           '0\Open', $
           '0\Save', $
           '2\Quit']

   topmenu = CW_PDMenu(w_base, desc, /RETURN_FULL_NAME, FONT=myfont) 


   ;--- Control buttons:
   W_SimControl = Widget_Base(W_Base, FRAME=3, $
                              /BASE_ALIGN_CENTER, /ROW)

   W_simlogo  = Widget_ShowIt(W_simcontrol, XSIZE=75, YSIZE=50, $
                              /PRIVATE_COLORS)

   W_SimDisplay = CW_BGroup(W_SimControl, "Display", /NONEXCLUSIVE, $
                            SET_VALUE=1, FONT=MyFont)

   W_simtimes = Widget_Base(W_simcontrol, /BASE_ALIGN_LEFT, /COL)

   W_SimStepCounter = Widget_Label(W_simtimes, FONT=MySmallFont, $
                                   VALUE='Steps: ----')

   W_SimStepTime = Widget_Label(W_simtimes, FONT=MySmallFont, $
                                VALUE='Duration: ----')

   W_SimDelay = Widget_Slider(W_SimControl, MINIMUM=0, MAXIMUM=1000, $
                              XSIZE=238, TITLE="Simulation Delay / ms", $
                              FONT=MySmallFont)

   W_SimStart = Widget_Button(W_SimControl, VALUE="Start", FONT=MyFont)

   W_SimStop  = Widget_Button(W_SimControl, VALUE="Stop", FONT=MyFont)
   
   W_SimReset  = Widget_Button(W_SimControl, VALUE="Reset", FONT=MyFont)


   ;--- User base:
   W_UserBase = Widget_Base(W_Base, $
                            FRAME=3, $
                            /ALIGN_CENTER, $
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
      'topmenu', topmenu, $                        
      'W_simlogo', w_simlogo, $
      'W_SimDisplay', W_SimDisplay, $
      'W_SimStepCounter', W_SimStepCounter, $
      'stepcounter', 0l, $
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
   

   Widget_Control, W_Base, SET_UVALUE=userstruct
            

   Message, /INFO, ""
   Message, /INFO, "   ********************************"
   Message, /INFO, "   *** Registering Main Widget  ***"
   Message, /INFO, "   ********************************"

   Widget_Control, W_Base, /REALIZE  


   ;--- display nase-logo:
   ShowIt_Open, userstruct.w_simlogo
   Read_GIF, GETENV("NASEPATH")+"/graphic/naselogo2_small.gif", logo, r, g, b
   Utvlct, r, g, b
   Utv, logo
   ShowIt_Close, userstruct.w_simlogo


   XMANAGER, CATCH=1-DEBUGMODE

   XMANAGER, "Simulation: "+SimName, W_Base, $
    EVENT_HANDLER="FaceIt_EVENT", /NO_BLOCK


END ; FaceIt

