;+
; NAME: asso_userevent
;
;
; PURPOSE: siehe assoziativ.pro
;
;
; MODIFICATION HISTORY:
;
;
;     $Log$
;     Revision 1.1  1999/10/14 12:37:45  alshaikh
;           initial version
;
;
;-
PRO asso_USEREVENT, event


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

; hier kommen alle moeglichen Reaktionen :
      
      (*displayptr).W_nparvs : BEGIN 
         Handle_Value, (*dataptr).l2,layer, /NO_COPY
         layer.para.vs = Event.Value
         Handle_Value, (*dataptr).l2, layer, /NO_COPY, /SET
         (*dataptr).prepara2.vs = Event.Value
      END



      (*displayptr).W_npartaus : BEGIN
         Handle_Value, (*dataptr).l2, layer, /NO_COPY
          layer.para.ds = Exp(-1./Event.Value)
         Handle_Value, (*dataptr).l2, layer, /NO_COPY, /SET
         (*dataptr).prepara2.taus = Event.Value
      END

 
      (*displayptr).W_nparth0 : BEGIN
         Handle_Value, (*dataptr).l2, layer, /NO_COPY
         layer.para.th0 = Event.Value
         Handle_Value, (*dataptr).l2, layer, /NO_COPY, /SET
         (*dataptr).prepara2.th0 = Event.Value
      END


      (*displayptr).W_patternnr : BEGIN
         (*dataptr).pattern_number = Event.Value
      END

      
      (*displayptr).W_nkopplfeed : BEGIN
         (*dataptr).kfeed = Event.Value
         wtmp = Weights((*dataptr).CON_asso_asso_feed)
         maximum = max (wtmp)
         wtmp = wtmp / maximum * (*dataptr).kfeed
         SetWeights, (*dataptr).CON_asso_asso_feed, wtmp, /NO_INIT
      END



      (*displayptr).W_nkopplinhib : BEGIN
         (*dataptr).kinhib = Event.Value
         wtmp = Weights((*dataptr).CON_asso_asso_inhib)
         maximum = max (wtmp)
         wtmp = wtmp / maximum * (*dataptr).kinhib
         SetWeights, (*dataptr).CON_asso_asso_inhib, wtmp, /NO_INIT
      END

      ELSE : Message, /INFO, "Caught unhandled User-Event!"
   ENDCASE

   Widget_Control, w_base, SET_UVALUE=uv, /NO_COPY

END ; asso_USEREVENT 
