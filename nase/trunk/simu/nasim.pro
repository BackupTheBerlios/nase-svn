;+
; NAME:
;
; PURPOSE:
;
; CATEGORY:
;
; CALLING SEQUENCE:
;
; INPUTS:
;
; OPTIONAL INPUTS:
;
; KEYWORD PARAMETERS:
;
; OUTPUTS:
;
; OPTIONAL OUTPUTS:
;
; COMMON BLOCKS:
;
; SIDE EFFECTS:
;
; RESTRICTIONS:
;
; PROCEDURE:
;
; EXAMPLE:
;
; SEE ALSO:
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 1.1  1999/08/09 16:43:23  kupper
;        Ein Sub-Alpha-Realease der neuen graphischen
;        Simulationsoberflaeche.
;        Fuer Andreas.
;
;-

;vvvvvvvvvvvvvvvvvvvvvvvv User defined actions vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
Function NASim_Init, W_Base, W_UserBase
   Common WidgetSimulation, MyFont, MySmallFont

   
   P = PTR_NEW( {info                    : "NASim_Parameters" $
               } )
 
   Return, P
End

Function NASim_Kill_Request, W_Base, W_UserBase, P
   ;;------------------> Cleanup
   Message, /INFO, "cleaning up"
   ;;--------------------------------
   print, "ouch!"
   Return, (1 eq 1)             ;TRUE
End

Function NASim_Simulate, W_Base, W_UserBase, P, display
   Return, 1                    ;TRUE
End


Function NASim_UserEvent, Event
   W_UserBase = Event.Handler
   W_Base     = Event.Top
   EventName =  TAG_NAMES(Event, /STRUCTURE_NAME)
   WIDGET_CONTROL, W_Base, GET_UVALUE=UV, /NO_COPY
   P = UV.P

   Case Event.ID of

;      (*P).THIS_IS_AN_EXAMPLE: Begin
;                              If (Event.Value eq -1) then (*P).RETINARF = Gabor((*P).GaborSize, WAVELENGTH=(*P).GaborWavelength, HWB=(*P).GaborHWB, /MAXONE) $
;                                                     else (*P).RETINARF = Gabor((*P).GaborSize, WAVELENGTH=(*P).GaborWavelength, HWB=(*P).GaborHWB, ORIENTATION=Event.Value, PHASE=0.5*!PI, /MAXONE)
;                              opensheet, (*P).layersheet, (*P).RFtv
;                              SelectNaseTable, /EXPONENTIAL
;                              PlotTvScl, /NASE, SETCOL=0, (*P).RETINARF, TITLE="RETINA-RF", xrange=[-(*P).GaborSize/2, (*P).GaborSize/2], yrange=[-(*P).GaborSize/2, (*P).GaborSize/2], /LEGEND, LEGMARGIN=0.1, PLOTCOL=255
;                              closesheet, (*P).layersheet, (*P).RFtv, SAVE_COLORS=0
;                              SelectNaseTable
;                             End
                             
      else                 : Message, /INFO, "Caught unhandled User-Event!"

   EndCase
      
   WIDGET_CONTROL, W_Base, SET_UVALUE=UV, /NO_COPY
   Return, 0                 ;We handled it, so swallow event
End
;^^^^^^^^^^^^^^^^^^^^^ End: User defined actions ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^




Pro NASim_Event, Event
   WIDGET_CONTROL, Event.Top, GET_UVALUE=UV, /NO_COPY
   widget_killed = 0
   continue_simulation = 0
   
   EventName =  TAG_NAMES(Event, /STRUCTURE_NAME)

   Case Event.ID of
      
     UV.W_Base    : Case EventName of
                      "WIDGET_TIMER"        : Begin
                                              If (*UV.continue_simulation_p) then begin
                                               WIDGET_CONTROL, UV.W_Base, TIMER=UV.SimDelay ;Initiate next simulation cycle
                                               *UV.continue_simulation_p = NASim_Simulate(UV.W_Base, UV.W_UserBase, UV.P, UV.display)
                                               CurrentTime = SysTime(1)
                                               Widget_Control, UV.W_SimStepTime, SET_VALUE=str(round((CurrentTime-UV.SimAbsTime)*1000))
                                               UV.SimAbsTime = CurrentTime
                                              EndIf
                                             End
                                              
                      "WIDGET_KILL_REQUEST" : If NASim_Kill_Request(UV.W_Base, UV.W_UserBase, UV.P) then begin
                                              PTR_FREE, UV.P
                                              PTR_FREE, UV.continue_simulation_p
                                              WIDGET_CONTROL, Event.Top, /DESTROY
                                              widget_killed = 1
                                             EndIf
  
                      "SIMULATION_START"    : $
                                             If not(*UV.continue_simulation_p) then Begin
                                              *UV.continue_simulation_p = 1
                                              UV.SimAbsTime = SysTime(1)
                                              WIDGET_CONTROL, UV.W_Base, TIMER=0 ;Initiate next simulation cycle
                                             EndIf

                      "SIMULATION_STOP"     : *UV.continue_simulation_p = 0
                                              
                      else                 : Message, "Unexpected event caught from W_Base: "+ EventName
                   Endcase
  
     UV.W_SimDelay: Case EventName of
                     "WIDGET_SLIDER"       : Begin
                                             WIDGET_CONTROL, UV.W_SimDelay, GET_VALUE=NewDelay
                                             UV.SimDelay = (NewDelay/1000.0) > UV.minSimDelay
                                            End
     
                     else                 : Message, "Unexpected event caught from W_SimDelay: "+ EventName
                  Endcase
 
     UV.W_SimStart: $ ;"Pressed" is the only event that this will generate
                    If not(*UV.continue_simulation_p) then begin
                     *UV.continue_simulation_p = 1
                     UV.SimAbsTime = SysTime(1)
                     WIDGET_CONTROL, UV.W_Base, TIMER=0 ;Initiate next simulation cycle
                    EndIf

     UV.W_SimStop : *UV.continue_simulation_p = 0 ;"Pressed" is the only event that this will generate

     UV.W_SimDisplay: Begin
                       UV.display = Event.Select
                       Widget_Control, UV.W_SimDelay, SENSITIVE=UV.display
                       If UV.display then begin
                          UV.SimDelay = UV.oldsimdelay
                       endif else begin
                          UV.oldsimdelay = UV.SimDelay
                          UV.SimDelay = UV.MinSimDelay
                       EndElse 
                      End

     else         : begin
                     message, /INFO, "Caught unhandled event!"
                    end
 
   EndCase

   If not(widget_killed) then WIDGET_CONTROL, Event.Top, SET_UVALUE=UV, /NO_COPY
End


Pro NASim
   Common WidgetSimulation

   SimulationName = "NASim"
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
   
   W_UserBase = Widget_Base(W_Base, $
                            FRAME=3, $
                            /BASE_ALIGN_CENTER, $
                            /COLUMN, $
                            EVENT_FUNC="NASim_UserEvent" $
                           )
   
   
   Message, /INFO, ""
   Message, /INFO, "          ******************************"
   Message, /INFO, "          *** Calling Initialization ***"
   Message, /INFO, "          ******************************"
   Widget_Control, W_Base, /NO_COPY, SET_UVALUE={P             : NASim_Init(W_Base, W_UserBase), $
                                                 W_Base        : W_Base, $
                                                 W_SimDisplay  : W_SimDisplay, $
                                                 W_SimDelay    : W_SimDelay, $
                                                 W_SimStepTime : W_SimStepTime, $
                                                 SimAbsTime    : SysTime(1), $
                                                 W_SimStart    : W_SimStart, $
                                                 W_SimStop     : W_SimStop, $
                                                 W_UserBase    : W_UserBase, $
                                                 minSimDelay   : minSimDelay, $
                                                 oldSimDelay   : minSimDelay, $
                                                 SimDelay      : minSimDelay, $ ;SimulationDelay/ms
                                          continue_simulation_p: PTR_NEW(0), $
                                                 display       : 1 $
                                                }
 
   Message, /INFO, ""
   Message, /INFO, "          ********************************"
   Message, /INFO, "          *** Registering Main Widget  ***"
   Message, /INFO, "          ********************************"
   Widget_Control, W_Base, /REALIZE  
   ;;Widget_Control, W_Base, TIMER=0 ;Initiate Simulation loop
   XMANAGER, CATCH=1-DEBUGMODE
   XMANAGER, "Simulation: "+SimulationName, W_Base, EVENT_HANDLER=SimulationName+"_Event", /NO_BLOCK
end
