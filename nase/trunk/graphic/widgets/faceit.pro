;+
; NAME:
;  FaceIt
;
; VERSION:
;  $Id$
;
; AIM:
;  A universal graphical user interface for NASE simulations.
;
; PURPOSE:
;  <C>FaceIt</C> is an acronym for <B>F</B>rame for <B>A</B>pplication <B>C</B>ontrol by
; <B>E</B>vent-driven <B>I</B>nteractive <B>T</B>echnology. The
; routine generates an IDL widget 
;  application that supplies basic components of a graphical
;  simulation environment. The widget application consists of a window
;  diplaying the progress of the simulation and a number of buttons
;  to control its execution. The simulation kernel and routines to
;  display results, like spike trains or connection matrices, have to be
;  supplied by the user in separate routines, which <C>FaceIt</C>
;  then calls regularly during the simulation, while at the same time
;  reacting to 
;  events like mouse clicks on the control buttons.   
;
; CATEGORY:
;  Graphic
;  NASE
;  Simulation
;  Widgets
;
; CALLING SEQUENCE:
;* FaceIt, name [,/COMPILE]
;
; INPUTS:
;  name:: A string specifying the name of the simulation intended to
;         execute.<BR>
;  <C>FaceIt</C> is supposed to be able to find the subroutines
;  described below, click on the routines' names to see their own
;  header with more information. When called by <C>FaceIt</C>, the pointers
;  <*>dataptr</*> and <*>displayptr</*>, the widget <*>w_userbase</*>
;  and the structure <*>event</*> are passed to the subroutines as
;  required.<BR> 
;  <*>PRO</*> <A NREF=HAUS2_INITDATA>name_INITDATA</A><*>,
;  dataptr</*>: Contains specification of simulation parameters and
;                necessary data structures, eg layers and connections.<BR>
;  <*>PRO</*> <A NREF=HAUS2_INITDISPLAY>name_INITDISPLAY</A><*>,
;  dataptr, displayptr, w_userbase</*>: Construction of the user
;                                       defined widget hierarchy.<BR>
;  <*>FUNCTION</*> <A NREF=HAUS2_SIMULATE>name_SIMULATE</A><*>,
;  dataptr</*>: Contains the simulation kernel, input calculation,
;               computation of the new network state and the like.<BR>
;  <*>PRO</*> <A NREF=HAUS2_DISPLAY>name_DISPLAY</A><*>, dataptr,
;  displayptr</*>: Used to display the network's state during simulation.<BR>
;  <*>PRO</*> <A NREF=HAUS2_USEREVENT>name_USEREVENT</A><*>,
;  event</*>: The reaction of user defined widgets to externel events
;             like mouse clicks or slider movements has to be defined here.<BR>
;  <*>PRO</*> <A NREF=HAUS2_RESET>name_RESET</A><*>, dataptr,
;  displayptr, w_userbase</*>: Actions that should be executed when the
;                             Reset button is pressed may be described
;                             here.<BR>
;  <*>PRO</*> <A NREF=HAUS2_FILEOPEN>name_FILEOPEN</A><*>, dataptr,
;  displayptr, group</*>: This routine is called by the menu entry
;                         'File.Open'. It may be used to read
;                         previously saved simulation data. (The
;                         parameter <*>group</*> serves as the file
;                         choose widget's parent, it is of no
;                         importance for the user.)<BR>
;  <*>PRO</*> <A NREF=HAUS2_FILESAVE>name_FILESAVE</A><*>, dataptr,
;  group</*>: Menu entry 'File.Save' calls this routine. It may be
;             used to save simulation data for later retrieval.<BR>
;  <*>FUNCTION</*> <A NREF=HAUS2_KILL_REQUEST>name_KILL_REQUEST</A><*>,
;  dataptr, displayptr</*>: Instructions herein are executed prior to
;                           destruction of the FaceIt widget. Eg, data
;                           structures may be correctly destroyed
;                           here.
;
; INPUT KEYWORDS:
;  /COMPILE:: If set, all subroutines of the simulation specified by
;             <*>name</*> are compiled prior to the start. This is
;             useful during testing phase, when numerous changes are
;             made in different subroutines. <*>/COMPILE</*> avoids
;             forgetting to compile some of the routines that were
;             changed.
;
; OUTPUTS:
;  An IDL widget application with the following elements:<BR>
;  File menu:: For loading and saving simulation data.
;  Simulation menu:: Its entries let the user choose between bounded
;                    or unbounded simulation (<*>duration</*>) and
;                    allow the slowing down of display refresh to
;                    observe fast processes (<*>delay</*>).
;  Display button:: Toggles plotting of results during the simulation.
;  Step:: Indicates the number of simulation steps. The counter is
;         increased each time <C>name_SIMULATE</C> is called.
;  Last::  Duration of previous simulation step in milliseconds.
;  Simulation Progress:: If a bounded duration (see <*>Simulation</*>
;                        menu is chosen, the progress
;                        is displayed here.
;  Start/Stop buttons:: These buttons start and stop the simulation
;                       run. After stopping, pressing <*>START</*>
;                       again continues the calculations at the
;                       stopping point. 
;  Reset button:: Execute the subroutine 
;                 <C>name_RESET</C>, to set the
;                 simulation parameters to their original value or to
;                 refresh the screen. The <*>steps</*> counter is also
;                 reset.
;  w_userbase:: A widget that is located beneath the control
;               elements. It is intended to carry the simulation
;               specific display elements supplied by the user.
;
; COMMON BLOCKS:
;  WidgetSimulation, MyFont, MySmallFont, with <BR>
;   <*>MyFont = !NASEWIDGETFONT</*> and <BR>
;   <*>MySmallFont = !NASEWIDGETFONTSMALL</*>. (See <A>DefGlobVars</A>.) 
;
; RESTRICTIONS:
;  Usage is only possible with IDL version 5.0 or higher.<BR>
;
; PROCEDURE:
;  - Create an IDL widget hierarchy with the control elements.<BR>
;  - Introduce <*>dataptr</*> and call <C>name_INITDATA</C> via
;  <*>Call_Procedure</*>.<BR>
;  - Create <*>displayptr</*> and call <C>name_INITDISPLAY</C>. At
;  this point, the widget hierarchy should be completely defined.<BR>
;  - Let <C>FaceIt</C> realize the widgets if this has not yet been
;  done by the user.<BR>
;  - Register the application in IDL's XManager and make XManager repeatedly
;  process the event function <C>FACEIT_EVENT</C>.<BR>
;  - <C>FACEIT_EVENT</C> in turn calls <C>name_SIMULATE</C> and
;  <C>name_DISPLAY</C> and reacts to the user's button presses when
;  needed.
;
; EXAMPLE:
;* FaceIt, 'haus2'
; This example defines a layer of 7x7 neurons that are completely
; coupled. Coupling strength is uniform, the amplitude can be varied
; during the simulation using one of the sliders. All connections are
; delayed, with time lags randomly distributed in the interval
; [10ms,20ms].<BR>
; Neurons simultaneuosly receive pulsed external input. Amplitude
; and period of these pulses may also be controlled via sliders. More
; sliders are intended to adjust the threshold's parameters.<BR>
; For more information on the networks architecture and its definition,
; see the source code of <A NREF=HAUS2_INITDATA>haus2_INITDATA</A>.
;
; SEE ALSO:
;  <A>FaceIt_Rename</A>
;-



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


   MyFont = !NASEWidgetFont
   MySmallFont = !NASEWidgetFontSmall

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

