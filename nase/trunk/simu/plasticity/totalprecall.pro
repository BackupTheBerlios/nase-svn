;+
; NAME:               TotalPrecall
;
; PURPOSE:            Die Prozedur erhaelt als Input die 
;                     (verzoegerten oder unverzoegerten) praesynaptischen 
;                     Aktionspotentiale (VORSICHT: das passiert
;                     bereits in DelayWeigh!) und aktualisiert alle 
;                     Lernpotentiale, die in der mit <A HREF="#INITRECALL">InitRecall</A>
;                     erzeugten Struktur enthalten sind. Wird kein 
;                     In-Handle uebergeben, so werden die Potentiale 
;                     nur abgeklungen.
;
; CATEGORY:           SIMULATION / PLASTICITY
;
; CALLING SEQUENCE:   TotalRecall, LP [, DW]
;
; INPUTS:             LP: Eine mit InitRecall erzeugte Struktur
;                     DW: die zugehoerige DW-Struktur
;
; SIDE EFFECTS:       LP wird beim Aufruf veraendert
;
; EXAMPLE:            
;                  My_Neuronentyp = InitPara_1()
;                  My_Layer       = InitLayer_1(Type=My_Neuronentyp, WIDTH=21, HEIGHT=21)   
;                  My_DWS         = InitDW (S_Layer=My_Layer, T_Layer=My_Layer, $
;                                           D_LINEAR=[1,2,10], /D_TRUNCATE, $
;                                            D_NRANDOM=[0,0.1], /D_NONSELF, $
;                                           W_GAUSS=[1,5], /W_TRUNCATE, $
;                                            W_RANDOM=[0,0.3], /W_NONSELF)
;
;                  LP = InitRecall( My_DWS, EXPO=[1.0, 10.0])
;
;                  <Simulationsschleife START>
;                  InputForMyLayer = DelayWeigh( My_DWS, My_Layer.O)
;                  TotalRecall, LP, My_DWS
;                  <Learn Something between My_Layer and My_layer>
;                  ProceedLayer_1(My_Layer, ....)
;                  <Simulationsschleife STOP>
;
; SEE ALSO: <A HREF="#INITRECALL">InitRecall</A>, <A HREF="#LEARNHEBBLP">LearnHebbLP</A>
;
;
; MODIFICATION HISTORY:
;
;       $Log$
;       Revision 1.5  1999/07/26 13:04:36  thiel
;           Print-Statements removed.
;
;       Revision 1.4  1999/07/26 12:49:44  thiel
;           Non-Delay version improved.
;
;       Revision 1.3  1999/07/26 09:10:52  thiel
;           New version with even better learned connection reset.
;
;       Revision 1.2  1999/07/23 13:13:45  thiel
;           Corrected two bugs: Dimension of 'wi' and
;                               reset of learned connections.
;
;       Revision 1.1  1999/07/21 15:03:42  saam
;             + no docu yet
;
;
;-

PRO TotalPrecall, _PC, _DW, postL

   PreAP = LearnAP(_DW) ; returns only active neurons for SDW_WEIGHT

   Handle_Value, _PC, PC, /NO_COPY
   Handle_Value, _DW, DW, /NO_COPY

   
   IF DW.Info EQ 'SDW_WEIGHT' THEN delay = 0 ELSE delay = 1


   ;
   ; handle PREsynaptic firing neurons
   ;
   IF PreAP(0) NE 0 THEN BEGIN ; is at least one presynaptic connection/neuron active?
      PreAP = PreAP(2:PreAP(0)+1)
      
      ; set neurons/connections active
      PC.pre(preAP) = PC.time

      IF NOT delay THEN BEGIN
         ; Delay=0: We have to find corresponding active connections
         ; to the active presynaptic neurons stored in PreAP.
         FOR asi=0, N_Elements(PreAP)-1 DO BEGIN
            asn = PreAP(asi)
            IF DW.S2C(asn) NE -1 THEN BEGIN
               Handle_Value, DW.S2C(asn), wi, /NO_COPY
               IF Set(preCON) THEN preCON = [preCON, wi] $
               ELSE preCON = wi 
                  ; preCON : list of active presynaptic weight indidices
               Handle_Value, DW.S2C(asn), wi, /NO_COPY, /SET
            ENDIF
         ENDFOR
      ENDIF ELSE preCON = PreAP; Delay=1: Active connections are already
                               ; given in PreAP 


      IF Set(preCON) THEN BEGIN ; there may be neurons not connected to any neuron
         ; look if the corresponding postsynaptic neuron was already active
         ; if yes, remember connection to be learned
         atn = WHERE(PC.Post(DW.C2T(preCON)) NE !NONEl, c)
         IF c NE 0 THEN BEGIN
            learnPre = preCON(atn)
            PN = DW.C2T(learnPre)
            IF delay THEN list1 = [learnPre, PC.Post(PN)-PC.Pre(learnPre)] $
            ELSE list1 = [learnPre, PC.Post(PN)-PC.Pre(DW.C2S(learnPre))]
            list1 = REFORM(list1, N_Elements(list1)/2 ,2, /OVERWRITE)
         ENDIF
      ENDIF 

   ENDIF 




   ;
   ; handle POSTsynaptic firing neurons
   ;
   Handle_Value, LayerOut(postL), postAP ; get POSTsynaptic action potentials
   IF PostAP(0) NE 0 THEN BEGIN
      PostAP = PostAP(2:PostAP(0)+1)
      PC.post(PostAP) = PC.time

      ; we have to find corresponding active connections
      ; to the active postsynaptic neurons stored in PostAP
      FOR ati=0, N_Elements(PostAP)-1 DO BEGIN
         atn = PostAP(ati)
         IF DW.T2C(atn) NE -1 THEN BEGIN
            Handle_Value, DW.T2C(atn), wi
            wi = Transpose(wi)  ; added this line
            IF Set(postCON) THEN postCON = [postCON, wi] $
            ELSE postCON = wi   
               ; postCON : list of active postsynaptic weight indidices
         ENDIF
      ENDFOR

      
      IF Set(postCON) THEN BEGIN ; there may be neurons not connected to any neuron
       ; look if the corresponding presynaptic connection was already active
       ; if yes, remember connection to be learned
         IF NOT delay THEN BEGIN
            ; Delay=0
            aci = WHERE(PC.Pre(DW.C2S(postCON)) NE !NONEl, c)
            IF c NE 0 THEN BEGIN
               learnPost = postCon(aci)
               PostNeurons = DW.C2T(learnPost)
               list2 = [learnPost, PC.Post(PostNeurons)-PC.Pre(DW.C2S(learnPost))]
               list2 = REFORM(list2, N_Elements(list2)/2 ,2, /OVERWRITE)
            ENDIF ; c NE 0
         ENDIF ELSE BEGIN
            ; Delay=1
            idx = WHERE(PC.pre(postCON) NE !NONEl, c)
            IF c NE 0 THEN BEGIN
               learnPost = postCon(idx)
                                ; complicated...
               PostNeurons = DW.C2T(learnPost)
               list2 = [learnPost, PC.Post(PostNeurons)-PC.Pre(learnPost)]
               list2 = REFORM(list2, N_Elements(list2)/2 ,2, /OVERWRITE)
            ENDIF ; c NE 0
         ENDELSE ; Delay=1
         
      ENDIF ; Set(postCON)

   ENDIF ; PostAP(0) NE 0   


   ; merge the two results
   IF Set(list1) THEN BEGIN
      IF Set(list2) THEN list = [list1,list2] ELSE list = list1
   END ELSE BEGIN
      IF Set(list2) THEN list = list2
   END

   IF NOT Set(list) THEN list = Make_Array(/long, 1, 2, VALUE=!NONEl)

   IF Handle_Info(PC.postpre) THEN Handle_Value, PC.postpre, list, /SET ELSE PC.postpre = Handle_Create(!MH, VALUE = list)
   
   
   ; reset learned connections
   IF Set(learnPre)    THEN BEGIN
      PC.Pre(learnPre) = !NONEl
      PC.Post(PN) = !NONEl
   ENDIF

   IF Set(learnPost)   THEN BEGIN
      PC.Pre(learnPost)    = !NONEl
      PC.Post(PostNeurons)    = !NONEl
   ENDIF



   ; reset neuron's last spike if its too old
   ; in correspondence with the learning window's width
   oldSpikes = WHERE(PC.post LE PC.time-PC.deltaMin,c)
   IF c NE 0 THEN PC.post(oldSpikes) = !NONEl
   
   oldSpikes = WHERE(PC.pre LE PC.time-PC.deltaMax,c)
   IF c NE 0 THEN PC.pre(oldSpikes) = !NONEl
   

   PC.time = PC.time + 1

   Handle_Value, _DW, DW, /NO_COPY, /SET
   Handle_Value, _PC, PC, /NO_COPY, /SET

END
