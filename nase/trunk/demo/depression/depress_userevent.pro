;+
; NAME: depress_userevent
;
;
; PURPOSE: siehe depress.pro
;
;
; MODIFICATION HISTORY:
;
;
;     $Log$
;     Revision 1.1  1999/10/14 12:31:15  alshaikh
;           initial version
;
;
;-

PRO depress_USEREVENT, event


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

  (*displayptr).W_nparth0 : BEGIN ; Neuron parameter slider events:
 ; Change parameters in layer-structure to affect neurons immediately:
         Handle_Value, (*dataptr).pre, layer, /NO_COPY
         layer.para.th0 = Event.Value
         Handle_Value, (*dataptr).pre, layer, /NO_COPY, /SET
         ; Also change parameters in parameter-structure:
         (*dataptr).prepara.th0 = Event.Value
      END


      (*displayptr).w_next_frq1 : BEGIN
         (*dataptr).frequency1 = Event.Value
      END


      (*displayptr).w_next_frq2 : BEGIN
         (*dataptr).frequency2 = Event.Value
      END


    (*displayptr).w_nmode_mode : BEGIN
       (*dataptr).mode = Event.Value
    END

 (*displayptr).W_ndepress_tau_rec : BEGIN 
    FreeDW, (*dataptr).Con_in_pre
     (*dataptr).tau_rec = event.value
     (*dataptr).CON_in_pre =  $
      initDW(S_LAYER=(*dataptr).in_layer, T_LAYER=(*dataptr).pre, $
             W_CONST=[1, 2],  NOCON=2, /depress, tau_rec=(*dataptr).tau_rec, $
             U_se=(*dataptr).U_se)      
  END


  (*displayptr).W_ndepress_u_se : BEGIN
     FreeDW, (*dataptr).Con_in_pre
     (*dataptr).U_se = event.value
     (*dataptr).CON_in_pre =  $
      initDW(S_LAYER=(*dataptr).in_layer, T_LAYER=(*dataptr).pre, $
             W_CONST=[1, 2],  NOCON=2, /depress, tau_rec=(*dataptr).tau_rec, $
             U_se=(*dataptr).U_se)      
  end



  (*displayptr).W_nnoise_sigma : BEGIN 
     Handle_Value, (*dataptr).pre, layer, /NO_COPY
     layer.para.sigma = Event.Value
     Handle_Value, (*dataptr).pre, layer, /NO_COPY, /SET
     ; Also change parameters in parameter-structure:
     (*dataptr).prepara.sigma = Event.Value 
end



;--- NO CHANGES NECESSARY BELOW THIS LINE.

      ELSE : Message, /INFO, "Caught unhandled User-Event!"

   ENDCASE
      
   ;Write back changes into uservalue of w_base:
   Widget_Control, w_base, SET_UVALUE=uv, /NO_COPY


END ; depress_USEREVENT 
