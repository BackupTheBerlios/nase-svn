;+
; NAME: schuelerwuergshop_USEREVENT
;
; PURPOSE: Teilprogramm zur Demonstration der Benutzung von <A HREF="../#FACEIT">FaceIt</A>.
;          Die Reaktion der benutzerdefinierten Widgets auf äußere Ereignisse 
;          (Mausklicks, Sliderbewegungen oä) muß in *_USEREVENT festgelegt 
;          werden.
;
;          Zum Aufbau einer eigenen Simulation empfiehlt es sich, diese Routine
;          zu kopieren, den haus2-Teil des Namens durch den der eigenen
;          Simulation zu ersetzen und die Routine nach den eigenen Wünschen 
;          abzuwandeln.
;
; CATEGORY: GRAPHICS / WIDGETS / FACEIT_DEMO
;
; CALLING SEQUENCE: schuelerwuergshop_USEREVENT, event
;
; INPUTS: event: Eine IDL-Widget-Ereignisstruktur. Siehe dazu auch die IDL-
;                Online-Hilfe.
;
; RESTRICTIONS: Die gesamte FaceIt-Architektur ist erst unter IDL Version 5 
;               lauffähig.
;
; PROCEDURE: 1. Ermittle die WidgetIDs des base-Widgets, des userbase-Widgets
;               und desjenigen Widgets, das das Ereignis erzeugt hat, aus der
;               Event-Struktur.
;            2. Je nach Ursprung des Ereignisses bestimmte Aktionen ausführen.
;               Im Beispiel handelt es sich dabei immer um Slider-Ereignisse.
;               Diese enthalten die neue Einstellung des Sliders in 
;               event.value. Damit werden dann die Simulationsparameter
;               entsprechend geändert.
;            3. Änderungen zum Schluß ins uservalue des base-widgets zurück-
;               schreiben.
;
; EXAMPLE: FaceIt, 'haus2'
;
; SEE ALSO: <A HREF="../#FACEIT">FaceIt</A> und die IDL-Online-Hilfe zum Thema 'Events'. 
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 1.1  2000/02/17 17:41:46  kupper
;        Fuer die lieben Schueler.
;
;        Revision 1.1  1999/09/14 15:02:32  kupper
;        Initial revision
;
;-


PRO schuelerwuergshop_USEREVENT, event


   ; Get WidgetIDs of w_base and w_userbase from event-structure:
   w_userbase = event.handler
   w_base     = event.top

   ; Get uservalue of w_base, which contains all relevant data:
   Widget_Control, w_base, GET_UVALUE=uv, /NO_COPY

   displayptr = uv.displayptr
   dataptr = uv.dataptr

   EventName =  TAG_NAMES(Event, /STRUCTURE_NAME)


   ; Determine which widget generated the event. This widget's ID
   ; is given by event.id. Then take appropriate actions (eg. change
   ; parameters according to new slider setting contained in event.value).
   CASE Event.ID OF

;--- CHANGE THE FOLLOWING PART TO BUILD YOUR OWN SIUMLATION: 

      (*displayptr).W_RFtype        : Begin
                              If (Event.Value eq -1) then (*dataptr).RETINARF = Gabor((*dataptr).GaborSize, WAVELENGTH=(*dataptr).GaborWavelength, HWB=(*dataptr).GaborHWB, /MAXONE) $
                                                     else (*dataptr).RETINARF = Gabor((*dataptr).GaborSize, WAVELENGTH=(*dataptr).GaborWavelength, HWB=(*dataptr).GaborHWB, ORIENTATION=Event.Value, PHASE=0.5*!PI, /MAXONE)
                              opensheet, (*displayptr).layersheet, (*displayptr).RFtv
                              ;SelectNaseTable;, /EXPONENTIAL
                              PlotTvScl, CUBIC=-0.5, /MINUS_ONE, /NASE, SETCOL=0, (*dataptr).RETINARF, TITLE="RETINA-RF", xrange=[-(*dataptr).GaborSize/2, (*dataptr).GaborSize/2], yrange=[-(*dataptr).GaborSize/2, (*dataptr).GaborSize/2], /LEGEND, LEGMARGIN=0.1, PLOTCOL=255
                              closesheet, (*displayptr).layersheet, (*displayptr).RFtv, SAVE_COLORS=0
                              ;SelectNaseTable
                             End
                             
;       (*displayptr).W_DotProb      : Begin
;                              (*(*dataptr).RFScan_p).auto_randomdots = Event.Value/100.0
;                              Widget_Control, (*dataptr).W_DotProbLabel, SET_VALUE=str(Event.Value)+"% dots"
;                             End

;       (*displayptr).W_RFFeed       : Begin
;                              (*dataptr).GaborAmplitude = Event.Value;/100.0
;                              ;Widget_Control, (*dataptr).W_RFFeedLabel, SET_VALUE="RF Feed: "+string((*dataptr).GaborAmplitude, FORMAT="(F4.2)")
;                             End

       (*displayptr).W_ImageSet      : Begin
                              (*dataptr).Image_Set = Event.Value
                              Call_Procedure, (*dataptr).Image_Set, dataptr
                              opensheet, (*displayptr).layersheet, (*displayptr).INPUTtv
                              PlotTv, /NASE, SETCOL=0, 255*(*dataptr).image_brightness*(*dataptr).images[*, *, (*dataptr).current_image], $
                               Title="Input Pattern", xrange=[-(*dataptr).RETINAWidth/2, (*dataptr).RETINAWidth/2], yrange=[-(*dataptr).RETINAHeight/2, (*dataptr).RETINAHeight/2], $
                               PLOTCOL=255, /LEGEND, LEGMARGIN=0.1, LEG_MIN=0, LEG_MAX=1
                              closesheet, (*displayptr).layersheet, (*displayptr).INPUTtv, SAVE_COLORS=0
                             End
       (*displayptr).W_Brightness    : Begin
                              (*dataptr).Image_Brightness = Event.Value
                              opensheet, (*displayptr).layersheet, (*displayptr).INPUTtv
                              PlotTv, /NASE, SETCOL=0, 255*(*dataptr).image_brightness*(*dataptr).images[*, *, (*dataptr).current_image], $
                               Title="Input Pattern", xrange=[-(*dataptr).RETINAWidth/2, (*dataptr).RETINAWidth/2], yrange=[-(*dataptr).RETINAHeight/2, (*dataptr).RETINAHeight/2], $
                               PLOTCOL=255, /LEGEND, LEGMARGIN=0.1, LEG_MIN=0, LEG_MAX=1
                              closesheet, (*displayptr).layersheet, (*displayptr).INPUTtv, SAVE_COLORS=0
                             End

       (*displayptr).W_image        : Begin
                              If Event.Value-1 ne (*dataptr).current_image then begin
                                 (*dataptr).current_image = Event.Value-1
                                 opensheet, (*displayptr).layersheet, (*displayptr).INPUTtv
                                 PlotTv, /NASE, SETCOL=0, 255*(*dataptr).image_brightness*(*dataptr).images[*, *, (*dataptr).current_image], $
                                  Title="Input Pattern", xrange=[-(*dataptr).RETINAWidth/2, (*dataptr).RETINAWidth/2], yrange=[-(*dataptr).RETINAHeight/2, (*dataptr).RETINAHeight/2], $
                                  PLOTCOL=255, /LEGEND, LEGMARGIN=0.1, LEG_MIN=0, LEG_MAX=1
                                 closesheet, (*displayptr).layersheet, (*displayptr).INPUTtv, SAVE_COLORS=0
                              EndIf
                             End

       (*displayptr).W_coupling     : Begin
                              (*dataptr).coupling_enabled = Event.Select
                             End


;--- NO CHANGES NECESSARY BELOW THIS LINE.

      ELSE : Message, /INFO, "Caught unhandled User-Event!"

   ENDCASE

   
   (*dataptr).CurrentInput = (*dataptr).Image_brightness*(*dataptr).images[*, *, (*dataptr).current_image]
   (*dataptr).CurrentRETINAin = CONVOL((*dataptr).CurrentInput, (*dataptr).GaborAmplitude*(*dataptr).RETINARF, /EDGE_WRAP)

   opensheet, (*displayptr).layersheet, (*displayptr).INPUTtv
   PlotTV, /NASE, SETCOL=0, 255*(*dataptr).CurrentInput, TITLE="Input Pattern", /LEGEND, LEGMARGIN=0.1, LEG_MIN=0, LEG_MAX=1, PLOTCOL=255
   closesheet, (*displayptr).layersheet, (*displayptr).INPUTtv, SAVE_COLORS=0
   
   opensheet, (*displayptr).layersheet, (*displayptr).RETINAintv
   PlotTVScl, /NASE, SETCOL=0, (*dataptr).CurrentRETINAin, TITLE="RETINA In", /LEGEND, LEGMARGIN=0.1, PLOTCOL=255
   closesheet, (*displayptr).layersheet, (*displayptr).RETINAintv, SAVE_COLORS=0


      
   ;Write back changes into uservalue of w_base:
   Widget_Control, w_base, SET_UVALUE=uv, /NO_COPY


END ; schuelerwuergshop_USEREVENT 
