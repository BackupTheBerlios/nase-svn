;+
; NAME: FaceIt 
;       (Frame for Application Control by Event-driven Interactive Technology)
;
; AIM:
;  A universal graphical user interface for NASE simulations.
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
; CATEGORY: GRAPHIC / WIDGETS
;
; CALLING SEQUENCE: FaceIt, name [,/COMPILE]
;
; INPUTS PARAMETERS: 
;         name: Ein String, der den Namen der auszuführenden Simulation 
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
; KEYWORD PARAMETERS: 
;           COMPILE:  Wenn gesetzt, werden alle Teilroutinen der
;                     in "name" angegebenen Simulation vor dem
;                     Start neu kompiliert. Das ist in der
;                     Probephase nützlich, wenn oft Änderungen
;                     in verschiedenen Teilroutinen vorgenommen
;                     werden. Hier geht das Neukompilieren sonst 
;                     oft vergessen.
;           
; COMMON BLOCKS: 
;                WidgetSimulation, MyFont, MySmallFont
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
;-
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 1.22  2003/02/06 15:42:20  kupper
;        produced .png-Version of naselogo2_small.gif and incativated Basim's
;        NOGIF-switch.
;        (Switch remains for compatibility, but has no effect.)
;
;        Revision 1.21  2003/01/21 16:54:05  alshaikh
;        added nogif tag
;
;        Revision 1.20  2000/10/03 12:39:43  kupper
;        Added INVISIBLE and GETBASE keywords.
;
;        Revision 1.19  2000/10/01 14:51:58  kupper
;        Added AIM: entries in document header. First NASE workshop rules!
;
;        Revision 1.18  2000/09/27 15:59:17  saam
;        service commit fixing several doc header violations
;
;        Revision 1.17  2000/09/01 19:46:12  kupper
;        Stepcounter is now an unsigned LONG64.
;
;        Revision 1.16  2000/03/31 17:14:50  kupper
;        Fixed small bug in comparison.
;
;        Revision 1.15  2000/03/31 12:15:36  kupper
;        FaceIt_NewUserBase()es are now realized automatically.
;        Fixed passing of /FLOATING keyword to FaceIt_NewUserBase().
;
;        Invented batch-mode.
;        No documentation yet. Suggest a "real" document describing FaceIt. Header is
;        just to small. (TO BE DONE!)
;
;        Revision 1.14  2000/03/22 16:55:46  kupper
;        Fixed overflow-bug when computing averaged steptime.
;
;        Revision 1.13  2000/03/20 17:43:17  kupper
;        Oho, forgoto to adjust Quit-Menu-code to new parameters of Faceit_Kill_Request.
;        Fixed.
;
;        Revision 1.12  2000/03/17 11:40:41  kupper
;        Now displays also average steptime over last 100 steps.
;
;        Revision 1.11  1999/11/29 16:07:02  kupper
;        Implemented service function "FACEIT_NewUserbase".
;
;        Revision 1.10  1999/11/16 18:03:23  kupper
;        Now sets black/white linear colortable after initialization is
;        finished. Thus, ShowIts with PRIVATE_COLORS not set don't look
;        so strange...
;
;        Revision 1.9  1999/10/27 12:01:11  kupper
;        Added no_block-keyword.
;
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




Function Faceit_NewUserbase, W_userbase, FLOATING=floating,_EXTRA=_extra
   ;; W_userbase is the highest widget in hierarchy that the
   ;; user ever gets his hands on. So he can only give us that
   ;; information. We now need to get out W_Base from it. We
   ;; know that W_userbase has a shell-base, which only purpose
   ;; it is to store W_Base as it's User Value:
   shell = Widget_Info(/PARENT, W_userbase)
   Widget_Control, shell, GET_UVALUE=W_Base 
   ;; now we will build a new top-level-base, which has W_Base
   ;; as Group-Leader. It will also store W_Base as it's User
   ;; Value. Moreover, it serves as a shell for the new
   ;; userbase, which is returned to the user.
   ;; The shell will have simname_USEREVENT as event handler,
   ;; just like the shell of the standard W_userbase.
   Widget_Control, W_Base, GET_UVALUE=uval
   new_shell = Widget_Base(GROUP_LEADER=W_Base, $
                           UVALUE=W_Base, $
                           FLOATING=floating, $
                           _EXTRA=_extra) ;event_pro see XMANAGER call below.
   ;; now register this new top level base at the xmanager to
   ;; have it's events processed:
   XMANAGER, "FaceIt! "+uval.simname, new_shell, /NO_BLOCK, EVENT_HANDLER=uval.simname+'_USEREVENT'
   ;; XMANAGER replaces the TLB's EVENT_PRO by this event-handler!

   ;; create the new user base:
   new_base = Widget_Base(new_shell, $
                       _EXTRA=_extra)

   ;; store the new user base in the array of user-bases:
   *uval.UserBases =  [*uval.UserBases, new_base]

   ;; finally, return the new user-base to the user:
   return, new_base
   ;; by the way: is it okay to use the same _EXTRAs for
   ;; new_shell (a top level base) and the base contained
   ;; therein, or do we have to sort keywords???
   ;; Well, I had to sort out FLOATING... we`ll see.
End


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

Pro FaceIt_Set_Display, uv, display ;pass only 1 or 0!!
   UV.display = display
   Widget_Control, uv.W_SimDisplay, Set_Value=display
   
   ;; toggle sensitivity of userbase. Any widgets that were explicitely frozen
   ;; in batch mode will not be affected.
   Widget_Control, UV.W_userbase, SENSITIVE=UV.display

   IF UV.display THEN BEGIN 
      UV.SimDelay = UV.oldsimdelay
   ENDIF ELSE BEGIN 
      UV.oldsimdelay = UV.SimDelay
      UV.SimDelay = UV.MinSimDelay
   ENDELSE  
End

Pro FaceIt_update_percentage, uv; update the percentage display
   if uv.duration eq 0 then begin
      Widget_Control, uv.w_percentage, Set_Value=""
   endif else begin
      Widget_Control, uv.w_percentage, Set_Value=string(float(uv.stepcounter)/uv.duration*100 $
                                                      ,format="(I3,'%')")
   endelse
End
Pro FaceIt_Set_Duration, uv, duration ;Sets simulation duration
   uv.duration = Long(duration)
   if duration eq 0 then begin
      Widget_Control, uv.w_duration, Set_Value="Duration: unlimited"
   endif else begin
      Widget_Control, uv.w_duration, Set_Value="Duration: "+str(duration)
   endelse
   Widget_Control, uv.simprogress, SET_SLIDER_MAX=uv.duration
   FaceIt_update_percentage, uv
End ;; FaceIt_Set_Duration

Pro FaceIt_Reset_Counter, uv    ;Resets the simulation time counter.  
   UV.stepcounter = 0l
   Widget_Control, UV.W_SimStepCounter, SET_VALUE='Step: '+str(0)
   Widget_Control, uv.simprogress, SET_VALUE=0
   FaceIt_update_percentage, uv ;just to update the percentage display!
End ; FaceIt_Reset_Counter

Pro FaceIt_Start_Simulation, uv
   IF NOT UV.continue_simulation THEN BEGIN
      UV.continue_simulation = 1
      UV.SimAbsTime = SysTime(1)
      WIDGET_CONTROL, UV.W_Base, TIMER=0 ;Initiate next simulation cycle
   ENDIF
End


PRO  FaceIt_RESET, uv
            
   Call_Procedure, UV.simname+'_RESET', UV.dataptr, UV.displayptr
   FaceIt_Reset_Counter, uv

END ; FaceIt_RESET



FUNCTION FaceIt_KILL_REQUEST, UV
   
   IF Call_FUNCTION(UV.simname+'_KILL_REQUEST', UV.dataptr, UV.displayptr) THEN $
    BEGIN
      Ptr_Free, UV.SimStepTimeQ
      Ptr_Free, UV.dataptr 
      Ptr_Free, UV.displayptr
      Ptr_Free, UV.batchptr
      Ptr_Free, UV.UserBases
      ;; This will destroy all user-bases, cause they all have w_base as parent
      ;; or group leader:
      WIDGET_CONTROL, UV.w_base, /DESTROY
      Return, 1
   ENDIF ELSE Return, 0

END ; FaceIt_KILL_REQUEST



;--- This handles the basic events
PRO FaceIt_EVENT, Event



   WIDGET_CONTROL, Event.Top, GET_UVALUE=UV, /NO_COPY
   widget_killed = 0
   batch_next = 0
  
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
               FaceIt_update_percentage, uv
               IF (uv.duration GT 0) THEN $
                Widget_Control, uv.simprogress, SET_VALUE=uv.stepcounter

               ;; call _simulate and stop if it returns false:
               UV.continue_simulation = $
                Call_FUNCTION(UV.simname+'_SIMULATE', UV.dataptr)
               
               ;; in batch mode, call monitor and return if it returns false:
               If UV.batch ne "" then begin
                  If not Call_Function(UV.batch+"_MONITOR", UV.dataptr, $
                                       UV.displayptr, UV.batchptr) then begin
                     Message, /Informational, "Batch exit condition met at step "+str(UV.stepcounter)+"."
                     batch_next = 1 ;Next batch condition, if batch mode.
                  endif
               endif
               
               ;; increase stepcounter
               UV.stepcounter = UV.stepcounter+1

               ; if counter has reached duration: stop or call next batch cycle
               IF (uv.duration GT 0) AND (uv.stepcounter GT uv.duration) THEN begin
                  If UV.batch eq "" then $
                   UV.continue_simulation = 0 $
                  else $
                   batch_next = 1 ;Next batch condition
               EndIf

               ; Display duration of last cycle(s):
               CurrentTime = SysTime(1)
               LastDuration = round((CurrentTime-UV.SimAbsTime)*1000)
               EnQueue, *UV.SimStepTimeQ, LastDuration
               Widget_Control, UV.W_SimStepTime, SET_VALUE='Last : '+ $
                str(LastDuration)
               Q = Queue(*UV.SimStepTimeQ, /Valid)
               Widget_Control, UV.W_SimStepTimeInt, SET_VALUE='L.100: '+ $
                str(fix(Total(Q)/n_elements(Q)))
               UV.SimAbsTime = CurrentTime

               ; If display-flag is set call DISPLAY-Routine to show results:
               IF (UV.display) THEN $ 
                  Call_Procedure, UV.simname+'_DISPLAY', $
                                  UV.dataptr, UV.displayptr               
            ENDIF
         END ; WIDGET_TIMER
                                              
         "WIDGET_KILL_REQUEST" : $
             widget_killed = FaceIt_KILL_REQUEST(UV)
  
         "SIMULATION_START" : FaceIt_Start_Simulation, UV

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

      UV.W_SimNext : batch_next = 1

      UV.W_SimDisplay: FaceIt_Set_Display, uv, Event.Select 

      uv.topmenu: BEGIN
         CASE event.value OF

            'File.Quit' : $
             widget_killed = $
             FaceIt_KILL_REQUEST(UV)

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
                  FaceIt_Set_Duration, uv, 0
               ENDIF ELSE BEGIN 
                  FaceIt_Set_Duration, uv, result.duration > 1
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

   ;; In batch mode, call next batch cycle if batch_next is set:
   If batch_next and (UV.batch ne "") then begin
      ;; init next batch cycle. If result is -1, exit FaceIt.
      Message, /Informational, "Calling next batch cycle."
      new_duration = Call_Function(UV.batch+"_NEXT", UV.dataptr, UV.displayptr, UV.batchptr)
      If new_duration eq -1 then begin
         widget_killed = FaceIt_KILL_REQUEST(UV) ;Exit
      endif else begin
         FaceIt_Reset_Counter, uv
         FaceIt_Set_Duration, uv, new_duration
      endelse
   End


   IF NOT(widget_killed) THEN $
    WIDGET_CONTROL, Event.Top, SET_UVALUE=UV, /NO_COPY


END ; faceit_EVENT



PRO FaceIt, simname, COMPILE=compile, NO_BLOCK=no_block, BATCH=batch, $
            INVISIBLE=invisible, GET_BASE=get_base,NOGIF=NOGIF

   COMMON WidgetSimulation, MyFont, MySmallFont

   Default, NO_BLOCK, 1
   DEBUGMODE = 1; XMANAGER will terminate on error, if DEBUGMODE is set
   
   Default, BATCH, ""

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
                              /PRIVATE_COLORS, FRAME=2)

   W_SimDisplay = CW_BGroup(W_SimControl, "Display", /NONEXCLUSIVE, $
                            SET_VALUE=1, FONT=MyFont)

   W_simtimes = Widget_Base(W_simcontrol, /BASE_ALIGN_LEFT, /COL)

   W_SimStepCounter = Widget_Label(W_simtimes, FONT=MySmallFont, $
                                   VALUE='Step: -----')

   W_SimStepTime = Widget_Label(W_simtimes, FONT=MySmallFont, $
                                VALUE='Last : ----')
   W_SimStepTimeInt = Widget_Label(W_simtimes, FONT=MySmallFont, $
                                VALUE='L.100: ----')

   W_SimProgress = Widget_Base(W_simcontrol, /Base_Align_Left, /Column)
   W_duration = Widget_Label(W_SimProgress, FONT=MySmallFont, $
                             VALUE='Duration: -------')
   W_SimProgPer = Widget_Base(W_SimProgress, /Row, /Base_Align_Top)
   simprogress = Widget_Slider(W_SimProgPer, MINIMUM=0, MAXIMUM=1, $
                              XSIZE=125, TITLE="Simulation Progress", $
                              FONT=MySmallFont, /SUPPRESS_VALUE, Sensitive=0)
   W_percentage = Widget_Label(W_SimProgPer, FONT=MySmallFont, $
                             VALUE='---%')

   W_SimStart = Widget_Button(W_SimControl, VALUE="Start", FONT=MyFont)

   W_SimStop  = Widget_Button(W_SimControl, VALUE="Stop", FONT=MyFont)
   
   W_SimReset  = Widget_Button(W_SimControl, VALUE="Reset", FONT=MyFont)


   ;--- User base:
   W_UserBaseShell = Widget_Base(W_Base, UVALUE=W_Base, $
                                EVENT_PRO=simname+'_USEREVENT' )
   ;; the only puropse of W_UserBaseShell is to supply the event 
   ;; handler with the ID of W_Base. As now there is the
   ;; function FaceIt_NewUserBase, W_Base may not simply be the 
   ;; parent of W_UserBase!
   W_UserBase = Widget_Base(W_UserBaseShell, $
                            FRAME=3, $
                            /ALIGN_CENTER, $
                            /BASE_ALIGN_CENTER, $
                            /COLUMN )
   
   
   Message, /INFO, ""
   Message, /INFO, "   ******************************"
   Message, /INFO, "   *** Calling Initialization ***"
   Message, /INFO, "   ******************************"


   userstruct = Create_Struct( $
      'simname', simname, $
      'dataptr', FaceIt_CreateData(simname), $
      'W_Base', W_Base, $
      'topmenu', topmenu, $                        
      'W_simlogo', w_simlogo, $
      'W_SimDisplay', W_SimDisplay, $
      'W_SimStepCounter', W_SimStepCounter, $
      'stepcounter', 0ull, $
      'simprogress', simprogress, $
      'W_percentage', W_percentage, $
      'W_duration', W_duration, $
      'W_SimStepTime', W_SimStepTime, $
      'W_SimStepTimeInt', W_SimStepTimeInt, $
      'SimStepTimeQ', Ptr_New(InitFQueue(100, 0)), $
      'SimAbsTime', SysTime(1), $
      'W_SimStart', W_SimStart, $
      'W_SimStop', W_SimStop, $
      'W_SimReset', W_SimReset, $
      'W_SimNext', 0l, $
      'W_UserBase', W_UserBase, $
      'UserBases', Ptr_New([W_UserBase]), $ ;An array of all user-bases.
      'duration', 0l, $ ; duration of simulation in bin, 0 = eternal
      'minSimDelay', minSimDelay, $
      'oldSimDelay', minSimDelay, $
      'SimDelay', minSimDelay, $ ;SimulationDelay/ms
      'batch', BATCH, $ ; Name of batch control, or ""
      'batchptr', Ptr_New({freeze:0l}), $; a place for the user to store batch data
      ;;; Flags:
      'continue_simulation', 0, $
      'display', 1 $
   )

   ;; we have to put these informations into W_Base's User
   ;; Value, for it may be required when creating the display
   ;; (currently, FaceIt_NewUserbase() is the only function that 
   ;; uses it.)
   Widget_Control, W_Base, SET_UVALUE=userstruct

   userstruct = Create_Struct(userstruct, $
      'displayptr', FaceIt_CreateDisplay(simname, $
                       userstruct.dataptr, W_UserBase) $
   )
   
   ;; If batch mode, init, add NEXT button and freeze user base:
   If BATCH ne "" then begin
      Message, /Informational, "Initializing batch mode"
      duration = Call_Function(BATCH, userstruct.dataptr, $
                               userstruct.displayptr, userstruct.batchptr)
      ;; Add the NEXT button:
      userstruct.W_SimNext  = Widget_Button(W_SimControl, VALUE="Next", FONT=MyFont)
      ;; turn off display
      FaceIt_Set_Display, userstruct, 0
      ;; permanently freeze some widgets if requested:
      If (*userstruct.batchptr).freeze[0] ne 0 then $
         for i=1, n_elements((*userstruct.batchptr).freeze) do $
          Widget_Control, (*userstruct.batchptr).freeze[i-1], Sensitive=0
   Endif else begin
      duration = 0
   EndElse
  



   Message, /INFO, ""
   Message, /INFO, "   ********************************"
   Message, /INFO, "   *** Registering Main Widget  ***"
   Message, /INFO, "   ********************************"

   If Keyword_Set(INVISIBLE) then begin
      For i=1, n_elements(*userstruct.UserBases) do $
       Widget_Control, (*userstruct.UserBases)[i-1], MAP=0
      Widget_Control, w_base, MAP=0
   endif
   ;; Realize all user-bases:
   ;; This will also realize W_Base.
   For i=1, n_elements(*userstruct.UserBases) do $
    Widget_Control, (*userstruct.UserBases)[i-1], /REALIZE

   ;; display and set duration:
   FaceIt_Set_Duration, userstruct, duration

   ;--- display nase-logo:
;;   if (nogif eq 0) then begin
       ShowIt_Open, userstruct.w_simlogo
       Read_PNG, GETENV("NASEPATH")+"/graphic/naselogo2_small.png", logo, r, g, b
       Utvlct, r, g, b
       Utv, logo
       ShowIt_Close, userstruct.w_simlogo
;;   end
   loadct, 0                    ;don't leave that ugly logo-colortable...



   ;;When in batch-mode, autostart the simulation:
   If BATCH ne "" then FaceIt_Start_Simulation, userstruct

   
   ;; Now update user value:
   Widget_Control, W_Base, SET_UVALUE=userstruct
 

   XMANAGER, CATCH=1-DEBUGMODE

   XMANAGER, "FaceIt! "+SimName, W_Base, $
    EVENT_HANDLER="FaceIt_EVENT", NO_BLOCK=no_block

   GET_BASE = w_base

END ; FaceIt

