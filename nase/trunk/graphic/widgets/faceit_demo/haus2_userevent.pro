;+
; NAME: haus2_USEREVENT
;
; PURPOSE: Teilprogramm zur Demonstration der Beutzung von <A HREF="#FACEIT">FaceIt</A>.
;          Die Reaktion der benutzerdefinierten Widgets auf äußere Ereignisse 
;          (Mausklicks, Sliderbewegungen) muß in *_USEREVENT festgelegt werden.
;
;          Zum Aufbau einer eigenen Simulation empfiehlt es sich, diese Routine
;          zu kopieren, den haus2-Teil des Namens durch den der eigenen
;          Simulation zu ersetzen und die Routine nach den eigenen Wünschen 
;          abzuwandeln.
;
; CATEGORY: SIMULATION / FACEIT
;
; CALLING SEQUENCE: haus2_USEREVENT, event
;
; INPUTS: event
;
; OUTPUTS: 0, falls das Ereignis bearbeitet wurde.
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
;        Revision 1.1  1999/09/01 16:46:31  thiel
;            Moved in repository.
;
;        Revision 1.1  1999/09/01 13:38:10  thiel
;            First version of FaceIt-Demo-Routines. Doku not yet complete.
;
;-



FUNCTION haus2_USEREVENT, Event

   W_UserBase = Event.Handler
   W_Base     = Event.Top
   EventName =  TAG_NAMES(Event, /STRUCTURE_NAME)
   WIDGET_CONTROL, W_Base, GET_UVALUE=UV, /NO_COPY

   displayptr = UV.displayptr
   dataptr = UV.dataptr

   CASE Event.ID OF

      ; Neuron parameter slider events:
      (*displayptr).W_nparvs : BEGIN
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
          wtmp(idx) = wtmp(idx)-wtmp(idx)+(*dataptr).couplampl/(*dataptr).prew/(*dataptr).preh $
          ELSE $
          wtmp = wtmp-wtmp+(*dataptr).couplampl/(*dataptr).prew/(*dataptr).preh 
         SetWeights, (*dataptr).CON_pre_pre, wtmp, /NO_INIT
      END


      ELSE : Message, /INFO, "Caught unhandled User-Event!"

   ENDCASE
      
   WIDGET_CONTROL, W_Base, SET_UVALUE=UV, /NO_COPY
   Return, 0                 ;We handled it, so swallow event

END ; haus2_USEREVENT 
