;+
; NAME: haus2_USEREVENT
;
; AIM:
;  The top level widget event handler for all user interactions.
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
; CALLING SEQUENCE: haus2_USEREVENT, event
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
;        Revision 1.4  2000/10/01 14:52:11  kupper
;        Added AIM: entries in document header. First NASE workshop rules!
;
;        Revision 1.3  1999/09/03 14:24:46  thiel
;            Better docu.
;
;        Revision 1.2  1999/09/02 14:38:18  thiel
;            Improved documentation.
;
;        Revision 1.1  1999/09/01 16:46:31  thiel
;            Moved in repository.
;
;        Revision 1.1  1999/09/01 13:38:10  thiel
;            First version of FaceIt-Demo-Routines. Doku not yet complete.
;
;-


PRO haus2_USEREVENT, event


   ; Get WidgetIDs of w_base and w_userbase from event-structure:
   w_userbase = event.handler
   w_base     = event.top

   ; Get uservalue of w_base, which contains all relevant data:
   Widget_Control, w_base, GET_UVALUE=uv, /NO_COPY

   displayptr = uv.displayptr
   dataptr = uv.dataptr

   ; Determine which widget generated the event. This widget's ID
   ; is given by event.id. Then take appropriate actions (eg. change
   ; parameters according to new slider setting contained in event.value).
   CASE Event.ID OF

;--- CHANGE THE FOLLOWING PART TO BUILD YOUR OWN SIUMLATION: 

      (*displayptr).W_nparvs : BEGIN ; Neuron parameter slider events:
         ; Change parameters in layer-structure to affect neurons immediately:
         Handle_Value, (*dataptr).pre, layer, /NO_COPY
         layer.para.vs = Event.Value
         Handle_Value, (*dataptr).pre, layer, /NO_COPY, /SET
         ; Also change parameters in parameter-structure:
         (*dataptr).prepara.vs = Event.Value
      END

      (*displayptr).W_npartaus : BEGIN
         ; Change parameters in layer-structure to affect neurons immediately:
         Handle_Value, (*dataptr).pre, layer, /NO_COPY
         layer.para.ds = Exp(-1./Event.Value)
         Handle_Value, (*dataptr).pre, layer, /NO_COPY, /SET
         ; Also change parameters in parameter-structure:
         (*dataptr).prepara.taus = Event.Value
      END

      ; External input slider events:
      (*displayptr).W_extinpampl : BEGIN
         (*dataptr).extinpampl = Event.Value
      END

      (*displayptr).W_extinpperiod : BEGIN
         (*dataptr).extinpperiod = Event.Value
      END 
      
      ; Coupling amplitude slider event:
      (*displayptr).W_couplampl : BEGIN
         (*dataptr).couplampl = Event.Value
         wtmp = Weights((*dataptr).CON_pre_pre)
         idx = Where(wtmp NE !NONE, c)
         IF c NE 0 THEN $
          wtmp(idx) = wtmp(idx)-wtmp(idx)+ $
          (*dataptr).couplampl/(*dataptr).prew/(*dataptr).preh $
         ELSE $
          wtmp = wtmp-wtmp+$
          (*dataptr).couplampl/(*dataptr).prew/(*dataptr).preh 
         SetWeights, (*dataptr).CON_pre_pre, wtmp, /NO_INIT
      END

;--- NO CHANGES NECESSARY BELOW THIS LINE.

      ELSE : Message, /INFO, "Caught unhandled User-Event!"

   ENDCASE
      
   ;Write back changes into uservalue of w_base:
   Widget_Control, w_base, SET_UVALUE=uv, /NO_COPY


END ; haus2_USEREVENT 
