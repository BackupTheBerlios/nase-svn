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
; CATEGORY: GRAPHICS / WIDGETS
;
; CALLING SEQUENCE: FaceIt, name [,/COMPILE]
;
; INPUTS: name: Ein String, der den Namen der auszuführenden Simulation 
;               enthält.
;
;         FaceIt erwartet, daß es die unten aufgeführten Routinen finden kann. 
;         Beim ihrem Aufruf durch FaceIt werden die angeführten Parameter
;         übergeben. Dabei handelt es sich um die beiden Pointer dataptr und 
;         displayptr, das Widget w_userbase und die Struktur event.
;
;          PRO <A HREF="./faceit_demo/#HAUS2_INITDATA">name_INITDATA</A>, dataptr
;             Zum Festlegen der Simulationsparameter und -datenstrukturen,
;             zB Layers und DWs.
;          PRO <A HREF="./faceit_demo/#HAUS2_INITDISPLAY">name_INITDISPLAY</A>, dataptr, displayptr, w_userbase
;             Hierin sollte der Aufbau der benutzereigenen Widget-Hierarchie
;             stattfinden.
;          FUNCTION <A HREF="./faceit_demo/#HAUS2_SIMULATE">name_SIMULATE</A>, dataptr 
;             Sollte den Simulationskern enthalten: Inputbestimmung, Lernen,
;             Berechnen des neuen Netwerkzustands und dergleichen.
;          PRO <A HREF="./faceit_demo/#HAUS2_DISPLAY">name_DISPLAY</A>, dataptr, displayptr
;             Hier soll die Darstellung des Netzwerkzustands während der 
;             Simulation erfolgen.
;          PRO <A HREF="./faceit_demo/#HAUS2_USEREVENT">name_USEREVENT</A>, Event
;             Die Reaktion der benutzerdefinierten Widgets auf äußere 
;             Ereignisse (Mausklicks, Sliderbewegungen) muß hier festgelegt
;             werden.
;          PRO <A HREF="./faceit_demo/#HAUS2_RESET">name_RESET</A>, dataptr, displayptr, w_userbase
;             Falls notwendig, können hier Aktionen bestimmt werden, die bei
;             Betätigung des RESET-Buttons ausgeführt werden sollen.
;          PRO <A HREF="./faceit_demo/#HAUS2_FILEOPEN">name_FileOpen</A>, dataptr, displayptr, group
;             Diese Routine wird vom Menüpunkt 'File.Open' aufgerufen. Hier
;             können zuvor gespeicherte Simulationsdaten eingelesen werden.
;             (Der 'group'-Parameter dient dem Dateiauswahl-Widget als Eltern-
;             teil, ist für den Benutzer uninteressant.)
;          PRO <A HREF="./faceit_demo/#HAUS2_FILESAVE">name_FileSave</A>, dataptr, group
;             Der Menüeintrag 'File.Save' ruft diese Routine auf. Der Benutzer
;             kann damit bei Bedarf Simulationsdaten speichern.
;          FUNCTION <A HREF="./faceit_demo/#HAUS2_KILL_REQUEST">name_KILL_REQUEST</A>, dataptr, displayptr
;             Die hierin enthaltenen Befehle werden vor der Zerstörung des
;             FaceIt-Widgets ausgeführt. ZB können Datenstrukturen freigegeben
;             werden.
;
; OUTPUTS: Eine IDL-Widget-Anwendung mit folgenden Bedienelementen:
;           FILE-Menü: Die bisher enthaltenen Unterpunkte dienen dem Laden
;                      und Speichern und dem Verlassen der Simulation.
;           SIMULATION-Menü: Die Unterpunkte ermöglichen die Wahl einer
;                            begrenzten oder unbegrenzten Simulationsdauer
;                            (DURATION) und die Verzögerung der Darstellung,
;                            um auch schnelle Abläufe nachvollziehen zu können
;                            (DELAY).
;           DISPLAY: Schaltet die Darstellung während der Simulation ein oder 
;                    aus.
;           Step: Zeigt die Zahl der Simulationsschritte an. Der Zähler wird
;                  bei jedem Simulate-Aufruf um 1 erhöht.
;           Last: Zeigt die Dauer des letzten Simulationsschrittes in
;                  Millisekunden.
;           Simulation Progress: Zeigt den Fortschritt der Simulation, falls
;                                eine begrenzte Simulationsdauer gewählt wurde.
;                                (Siehe dazu SIMULATION-Menü.)
;           START / STOP: Startet / stoppt die Simulation. Nach einem Stop wird
;                         der Simulationablauf bei erneutem Start-Drücken 
;                         an der gleichen Stelle fortgesetzt. Ein Zurücksetzen
;                         erfolgt nicht (siehe RESET).
;           RESET: Führt die Prozedur <A HREF="./faceit_demo/#HAUS2_RESET">name_RESET</A> aus, zB, um die 
;                  Simulationsdaten auf ihren ursprünglichen Stand zu setzen
;                  oder die Bildschirmdarstellung zu erneuern. Außerdem wird
;                  der Zähler 'Steps' zurückgesetzt.
;          Desweiteren besitzt die erzeugte Anwendung ein Widget namens 
;          w_userbase, das sich unter den Bedienelementen befindet und zur 
;          Aufnahme der simulationsspezifischen Widgets dient.
;
; KEYWORDS: COMPILE:  Wenn gesetzt, werden alle Teilroutinen der
;                     in "name" angegebenen Simulation vor dem
;                     Start neu kompiliert. Das ist in der
;                     Probephase nützlich, wenn oft Änderungen
;                     in verschiedenen Teilroutinen vorgenommen
;                     werden. Hier geht das Neukompilieren sonst 
;                     oft vergessen.
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
;          dynamischen Schwelle.
;          Zur Definition der Netzwerkarchitektur siehe auch den Programmtext 
;          von <A HREF="./faceit_demo/#HAUS2_INITDATA">haus2_INITDATA</A>. 
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 1.8  1999/09/21 13:15:35  kupper
;        Added Keyword COMPILE.
;
;        Revision 1.7  1999/09/16 12:03:55  thiel
;            Progress display now stays insensitive after display activation.
;
;        Revision 1.6  1999/09/15 15:08:42  thiel
;            Some changes:
;            - RESET and KILL_REQUEST moved into separate routines.
;            - Delay-slider exhanged by progression display.
;            - Now possible to run simulation until maximum duration is reached.
;            - Added new menu-items.
;
;        Revision 1.5  1999/09/03 14:23:55  thiel
;            Changed funcs to procs where possible and improved docu.
;
;        Revision 1.4  1999/09/02 14:56:58  kupper
;        Carrected misspelled hyperling.
;
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



PRO FaceIt_Compile, simname

   Resolve_Routine, simname+"_display"
   Resolve_Routine, simname+"_fileopen"
   Resolve_Routine, simname+"_filesave"
   Resolve_Routine, simname+"_freedata"
   Resolve_Routine, simname+"_initdata"
   Resolve_Routine, simname+"_initdisplay"
   Resolve_Routine, simname+"_kill_request", /IS_FUNCTION
   Resolve_Routine, simname+"_reset"
   Resolve_Routine, simname+"_resetsliders"
   Resolve_Routine, simname+"_simulate", /IS_FUNCTION
   Resolve_Routine, simname+"_userevent"

END; FaceIt_Compile

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



PRO  FaceIt_RESET, uv
            
   Call_Procedure, UV.simname+'_RESET', UV.dataptr, UV.displayptr
   UV.stepcounter = 0l
   Widget_Control, UV.W_SimStepCounter, SET_VALUE='Step: '+str(UV.stepcounter)
   Widget_Control, uv.simprogress, SET_VALUE=0

END ; FaceIt_RESET



FUNCTION FaceIt_KILL_REQUEST, name, dataptr, displayptr, base

   IF Call_FUNCTION(name+'_KILL_REQUEST', dataptr, displayptr) THEN BEGIN
      Ptr_Free, dataptr 
      Ptr_Free, displayptr
      WIDGET_CONTROL, base, /DESTROY
      Return, 1
   ENDIF ELSE Return, 0

END ; FaceIt_KILL_REQUEST



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
               ; Initiate next simulation cycle:
               WIDGET_CONTROL, UV.W_Base, TIMER=UV.SimDelay

               ; Print stepcounter and display progress:
               Widget_Control, UV.W_SimStepCounter, $
                SET_VALUE='Step: '+str(UV.stepcounter)               
               IF (uv.duration GT 0) THEN $
                Widget_Control, uv.simprogress, SET_VALUE=uv.stepcounter

               UV.continue_simulation = $
                Call_FUNCTION(UV.simname+'_SIMULATE', UV.dataptr)
               
               UV.stepcounter = UV.stepcounter+1

               ; Stop if counter has reached duration:
               IF (uv.duration GT 0) AND uv.stepcounter GT uv.duration THEN $
                UV.continue_simulation = 0
               
               ; Display duration of last cycle:
               CurrentTime = SysTime(1)
               Widget_Control, UV.W_SimStepTime, SET_VALUE='Last: '+ $
                str(round((CurrentTime-UV.SimAbsTime)*1000))
               UV.SimAbsTime = CurrentTime

               ; If display-flag is set call DISPLAY-Routine to show results:
               IF (UV.display) THEN $ 
                  Call_Procedure, UV.simname+'_DISPLAY', $
                                  UV.dataptr, UV.displayptr               
            ENDIF
         END ; WIDGET_TIMER
                                              
         "WIDGET_KILL_REQUEST" : $
             widget_killed = $
             FaceIt_KILL_REQUEST(UV.simname, UV.dataptr, UV.displayptr, $
                                 UV.w_base)
  
         "SIMULATION_START" : $
          IF NOT UV.continue_simulation THEN BEGIN
            UV.continue_simulation = 1
            UV.SimAbsTime = SysTime(1)
            WIDGET_CONTROL, UV.W_Base, TIMER=0 ;Initiate next simulation cycle
         ENDIF ; SIMULATION_START

         "SIMULATION_STOP" : UV.continue_simulation = 0
                                              
         'SIMULATION_RESET' : FaceIt_RESET, uv

         ELSE : Message, "Unexpected event caught from W_Base: "+ EventName
              
      ENDCASE 
  
      


      ;--- Internal basic events, button presses and such:

      UV.W_SimStart: $ ; "Pressed" is the only event that this will generate
       IF NOT UV.continue_simulation THEN BEGIN  
         UV.continue_simulation = 1
         UV.SimAbsTime = SysTime(1)
         WIDGET_CONTROL, UV.W_Base, TIMER=0 ;Initiate next simulation cycle
      ENDIF 

      UV.W_SimStop : UV.continue_simulation = 0 
         ; "Pressed" is the only event that this will generate

      UV.W_SimReset : FaceIt_RESET, uv

      UV.W_SimDisplay: BEGIN
         UV.display = Event.Select
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

            'File.Quit' : $
             widget_killed = $
             FaceIt_KILL_REQUEST(UV.simname, UV.dataptr, UV.displayptr, $
                                 UV.w_base)

            'File.Save' : $
               Call_Procedure, uv.simname+'_FILESAVE', uv.dataptr, uv.topmenu

            'File.Open' : $
               Call_Procedure, uv.simname+'_FILEOPEN', uv.dataptr, $
                               uv.displayptr, uv.topmenu

            'Simulation.Duration' : BEGIN
               simulation_duration_desc = [ $
                  '0, BUTTON, Eternal|Limited, TAG=eternal, EXCLUSIVE' , $
                  '0, INTEGER, '+String(uv.duration, FORMAT="(I7)") + $
                     ', LABEL_LEFT=Duration / bin:, WIDTH=7' + $ 
                     ', TAG=duration', $
                  '1, BASE,, ROW', $
                  '0, BUTTON, OK, QUIT, TAG=ok', $
                  '2, BUTTON, Cancel, QUIT, TAG=cancel']
               result = CW_FORM2(simulation_duration_desc, /COLUMN, $
                                TITLE='Simulation.Duration')  
               help, result, /STRUC
               IF result.ok THEN $
                IF result.eternal EQ 0 THEN BEGIN
                  uv.duration = 0l
                  Widget_Control, uv.simprogress, SET_VALUE=0
               ENDIF ELSE BEGIN 
                  uv.duration = Long(result.duration) > 1l
                  Widget_Control, uv.simprogress, SET_SLIDER_MAX=uv.duration
               ENDELSE

            END

            'Simulation.Delay' : BEGIN
               simulation_delay_desc = [ $
                  '0, INTEGER, '+String(1000.*uv.simdelay, FORMAT="(I4)") + $
                     ', LABEL_LEFT=Simulation Delay / ms:, WIDTH=4' + $ 
                     ', TAG=delay', $
                  '1, BASE,, ROW', $
                  '0, BUTTON, OK, QUIT, TAG=ok', $
                  '2, BUTTON, Cancel, QUIT, TAG=cancel']
               result = CW_FORM2(simulation_delay_desc, /COLUMN, $
                                TITLE='Simulation.Delay')  
               IF result.ok THEN $
                uv.simdelay = (result.delay/1000.0) > UV.minSimDelay
             
            END


            ELSE : Message, /INFO, "Caught unhandled menu event!"
         ENDCASE
      END


      ELSE : Message, /INFO, "Caught unhandled event!"
 
   ENDCASE 


   IF NOT(widget_killed) THEN $
    WIDGET_CONTROL, Event.Top, SET_UVALUE=UV, /NO_COPY


END ; faceit_EVENT



PRO FaceIt, simname, COMPILE=compile

   COMMON WidgetSimulation, MyFont, MySmallFont


   DEBUGMODE = 1; XMANAGER will terminate on error, if DEBUGMODE is set
   

   minSimDelay = 1e-30; secs


   MyFont = '-adobe-helvetica-bold-r-normal--14-140-75-75-p-82-iso8859-1'
   MySmallFont = '-adobe-helvetica-bold-r-normal--12-120-75-75-p-70-iso8859-1'

   Widget_Control, DEFAULT_FONT=MySmallFont ;Let it be default.


   ;--- Recompile all Simulation-Routines, if requested:
   If Keyword_Set(COMPILE) then FaceIt_Compile, simname

   ;--- Base:
   W_Base = Widget_Base (TITLE='FaceIt! '+simname, $
                         /BASE_ALIGN_LEFT, /COLUMN, $
                         MBAR=menubar, $
                         /TLB_KILL_REQUEST_EVENTS $ ;test: IF TAG_NAMES(event, /STRUCTURE_NAME) EQ 'WIDGET_KILL_REQUEST' THEN ...
                         $      ;Note that widgets that have this keyword set are responsible for killing themselves
                         $      ; after receiving a WIDGET_KILL_REQUEST event. They cannot be destroyed using the usual window system controls.
                        )


   ;--- Menu:
   desc = ['1\File', $
           '0\Open', $
           '0\Save', $
           '2\Quit', $
           '3\Simulation', $
           '0\Duration', $
           '2\Delay' ]

   topmenu = CW_PDMenu(menubar, desc, /RETURN_FULL_NAME, FONT=myfont, /MBAR) 


   ;--- Control buttons:
   W_SimControl = Widget_Base(W_Base, FRAME=3, $
                              /BASE_ALIGN_CENTER, /ROW)

   W_simlogo  = Widget_ShowIt(W_simcontrol, XSIZE=75, YSIZE=50, $
                              /PRIVATE_COLORS)

   W_SimDisplay = CW_BGroup(W_SimControl, "Display", /NONEXCLUSIVE, $
                            SET_VALUE=1, FONT=MyFont)

   W_simtimes = Widget_Base(W_simcontrol, /BASE_ALIGN_LEFT, /COL)

   W_SimStepCounter = Widget_Label(W_simtimes, FONT=MySmallFont, $
                                   VALUE='Step: -----')

   W_SimStepTime = Widget_Label(W_simtimes, FONT=MySmallFont, $
                                VALUE='Last: ----')

   simprogress = Widget_Slider(W_SimControl, MINIMUM=0, MAXIMUM=1, $
                              XSIZE=125, TITLE="Simulation Progress", $
                              FONT=MySmallFont, /SUPPRESS_VALUE)

   W_SimStart = Widget_Button(W_SimControl, VALUE="Start", FONT=MyFont)

   W_SimStop  = Widget_Button(W_SimControl, VALUE="Stop", FONT=MyFont)
   
   W_SimReset  = Widget_Button(W_SimControl, VALUE="Reset", FONT=MyFont)


   ;--- User base:
   W_UserBase = Widget_Base(W_Base, $
                            FRAME=3, $
                            /ALIGN_CENTER, $
                            /BASE_ALIGN_CENTER, $
                            /COLUMN, $
                            EVENT_PRO=simname+'_USEREVENT' $
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
      'simprogress', simprogress, $
      'W_SimStepTime', W_SimStepTime, $
      'SimAbsTime', SysTime(1), $
      'W_SimStart', W_SimStart, $
      'W_SimStop', W_SimStop, $
      'W_SimReset', W_SimReset, $
      'W_UserBase', W_UserBase, $
      'duration', 0l, $ ; duration of simulation in bin, 0 = eternal
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

   Widget_Control, userstruct.simprogress, SENSITIVE=0


   ;--- display nase-logo:
   ShowIt_Open, userstruct.w_simlogo
   Read_GIF, GETENV("NASEPATH")+"/graphic/naselogo2_small.gif", logo, r, g, b
   Utvlct, r, g, b
   Utv, logo
   ShowIt_Close, userstruct.w_simlogo


   XMANAGER, CATCH=1-DEBUGMODE

   XMANAGER, "FaceIt! "+SimName, W_Base, $
    EVENT_HANDLER="FaceIt_EVENT", /NO_BLOCK


END ; FaceIt

