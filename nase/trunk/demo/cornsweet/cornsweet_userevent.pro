;+
; NAME:  cornsweet_userevent
;
; AIM : Module of cornsweet.pro  (see also  <A>faceit</A>)
;
; PURPOSE:
;
;
; CATEGORY:
;
;
; CALLING SEQUENCE:
;
; 
; INPUTS:
;
;
; OPTIONAL INPUTS:
;
;	
; KEYWORD PARAMETERS:
;
;
; OUTPUTS:
;
;
; OPTIONAL OUTPUTS:
;
;
; COMMON BLOCKS:
;
;
; SIDE EFFECTS:
;
;
; RESTRICTIONS:
;
; PROCEDURE:
;
;
; EXAMPLE:
;
;
;-
; MODIFICATION HISTORY:
;
;
;     $Log$
;     Revision 1.3  2000/09/28 12:06:30  alshaikh
;           AIM bugfixes
;
;     Revision 1.2  2000/09/27 15:08:05  alshaikh
;           AIM-tag added
;
;     Revision 1.1  2000/02/16 10:20:37  alshaikh
;           initial version
;
;
;

PRO cornsweet_USEREVENT, event


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

      (*displayptr).W_linkparrange : BEGIN 
         (*dataptr).linkparrange = Event.Value
         
         temp =  InitDW(S_LAYER=(*dataptr).pre, T_LAYER=(*dataptr).pre, $
                W_CONST=[(*dataptr).linkparampl,(*dataptr).linkparrange], $
                         /W_NONSELF, /D_NONSELF)
         SetWeights, (*dataptr).CON_pre_pre, weights(temp), /NO_INIT
         FreeDw,temp
         (*dataptr).outpattern=0
         (*dataptr).passedtime = 0
      END

 (*displayptr).W_linkparampl : BEGIN 
         (*dataptr).linkparampl = Event.Value
         
         temp =  InitDW(S_LAYER=(*dataptr).pre, T_LAYER=(*dataptr).pre, $
                W_CONST=[(*dataptr).linkparampl,(*dataptr).linkparrange], $
                         /W_NONSELF, /D_NONSELF)
         SetWeights, (*dataptr).CON_pre_pre, weights(temp), /NO_INIT
         FreeDw,temp
         (*dataptr).outpattern=0
         (*dataptr).passedtime = 0
      END


     



      ; External input slider events:
      (*displayptr).W_extinpampl : BEGIN
         (*dataptr).extinpampl = Event.Value
         (*dataptr).outpattern=0      
         (*dataptr).passedtime = 0
      END

      (*displayptr).W_extinpleft : BEGIN
         (*dataptr).extinpleft = Event.Value
         (*dataptr).outpattern=0
         (*dataptr).passedtime = 0
      END 

      (*displayptr).W_extinptau : BEGIN
         (*dataptr).extinptau = Event.Value
         (*dataptr).outpattern=0
         (*dataptr).passedtime = 0
      END 
       (*displayptr).W_extinpoffset : BEGIN
         (*dataptr).extinpoffset = Event.Value
         (*dataptr).outpattern=0
         (*dataptr).passedtime = 0
      END 



;--- NO CHANGES NECESSARY BELOW THIS LINE.

      ELSE : Message, /INFO, "Caught unhandled User-Event!"

   ENDCASE
      
   ;Write back changes into uservalue of w_base:
   Widget_Control, w_base, SET_UVALUE=uv, /NO_COPY


END ; cornsweet_USEREVENT 
