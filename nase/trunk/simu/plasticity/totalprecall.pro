;+
; NAME: TotalPrecall
;
; PURPOSE: Diese Prozedur wird zur Aktualisierung einer Liste von 
;          Zeitdifferenzen zwischen prä- und postsynaptischen Spikes verwendet.
;          Diese Liste wird mit <A HREF="#INITPRECALL">InitPrecall</A> erzeugt und kann später von 
;          Lernregeln ausgewertet werden, die die Zeitdifferenz als Grundlage 
;          der Gewichts- oder Delayänderung benutzen. 
;          Die Zeitdifferenz wird durch t_post - t-pre berechnet, ist also 
;          positiv, falls der postsynaptische Spike NACH dem präsynaptsichen 
;          auftritt. 
;
; CATEGORY: SIMULATION / PLASTICITY
;
; CALLING SEQUENCE: TotalPrecall, PC, DW, postL
;
; INPUTS: PC: Eine mit <A HREF="#INITPRECALL">InitPrecall</A> erzeugte Struktur.
;         DW: Die zugehörige DW-Struktur. Diese liefert NACH dem Aufruf von
;              <A HREF="../CONNECTIONS/'DELAYWEIGH">DelayWeigh</A> die präsynaptischen Aktionspotentiale.
;         postL: Die postsynaptische Neuronenschicht.
;
; SIDE EFFECTS: PC wird beim Aufruf verändert.
;
; EXAMPLE:            
;   Layer1 = InitPara_1()
;   L1 = InitLayer(WIDTH=2, HEIGHT=1, TYPE=Layer1)    
;
;   CON_L1_L1 = InitDW(S_LAYER=L1, T_LAYER=L1, $
;                      WEIGHT=0.1, /W_TRUNCATE, /W_NONSELF, DELAY=1)
;
;   LearnWindow = InitLearnBiPoo(POSTV=0.01, PREV=0.01)
;   PC_L1_L1 = InitPrecall(CON_L1_L1, LearnWindow)
;
;   <Simulationloop START>
;      InputForMyLayer = DelayWeigh(CON_L1_L1, LayerOut(L1))
;      TotalPrecall, PC_L1_L1, CON_L1_L1, L1
;      <Learn connections within L1 eg with 'LearnBiPoo'>
;      InputLayer, L1, FEEDING=InputForMyLayer
;      ProceedLayer, L1
;   <Simulationloop STOP>
;
; SEE ALSO: <A HREF="#INITPRECALL">InitPrecall</A>, <A HREF="#INITLEARNBIPOO">InitLearnBiPoo</A>, <A HREF="#LEARNBIPOO">LearnBiPoo</A> 
;
;
; MODIFICATION HISTORY:
;
;       $Log$
;       Revision 1.10  1999/08/05 16:00:26  thiel
;           Tried to speed it up.
;
;       Revision 1.9  1999/08/05 12:20:51  thiel
;           Hyperlink...
;
;       Revision 1.8  1999/08/05 11:58:23  thiel
;           Hyperlkinkcorrection.
;
;       Revision 1.7  1999/08/05 11:49:39  thiel
;           Now computes time differences between ALL spikes until they are
;           too old. No more resetting of learned connections.
;
;       Revision 1.6  1999/07/27 10:19:12  thiel
;           Changed 'transpose' to 'reform' and wrote header.
;
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
      ; save presynaptic neurons'/connections' activation time:
      PC.pre(preAP,pc.spikesinpre) = PC.time
      pc.spikesinpre = (pc.spikesinpre+1) MOD pc.deltamin


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
         targettimes = PC.Post(DW.C2T(preCON),*)
         atn = WHERE(targettimes NE !NONEl, c)
         IF c NE 0 THEN BEGIN
            learnpre = precon(atn MOD N_Elements(precon))
            IF delay THEN $
             list1 = [learnPre, targettimes(atn)-pc.time] $
            ELSE $
             list1 = [learnPre, targettimes(atn)-pc.time]
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
      ; save time of postsynaptic spikes:
      PC.post(PostAP,pc.spikesinpost) = PC.time
      pc.spikesinpost = (pc.spikesinpost+1) MOD pc.deltamax

      ; we have to find corresponding active connections
      ; to the active postsynaptic neurons stored in PostAP
      FOR ati=0, N_Elements(PostAP)-1 DO BEGIN
         atn = PostAP(ati)
         IF DW.T2C(atn) NE -1 THEN BEGIN
            Handle_Value, DW.T2C(atn), wi
            ; Reform to make 'wi' really 1-dimensional:
            wi = Reform(wi, N_Elements(wi), /OVERWRITE) 
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
            sourcetimes = PC.pre(DW.C2S(postCON),*)
            aci = WHERE(sourcetimes NE !NONEl, c)
            IF c NE 0 THEN BEGIN
               learnPost = postCon(aci MOD N_Elements(postcon))
;               PostNeurons = DW.C2T(learnPost)
               list2 = [learnPost, PC.time-sourcetimes(aci)]
               list2 = REFORM(list2, N_Elements(list2)/2 ,2, /OVERWRITE)
            ENDIF ; c NE 0
         ENDIF ELSE BEGIN
            ; Delay=1
            sourcetimes = PC.pre(postCON,*)
            idx = WHERE(sourcetimes NE !NONEl, c)
            IF c NE 0 THEN BEGIN
               learnPost = postCon(idx MOD N_Elements(postcon))
                                ; complicated...
               list2 = [learnPost, PC.time-sourcetimes(idx)]
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
   
   
   ; resetting of learned connections is no longer necessary:
;   IF Set(learnPre)    THEN BEGIN
;      PC.Pre(learnPre) = !NONEl
;      PC.Post(PN) = !NONEl
;   ENDIF

;   IF Set(learnPost)   THEN BEGIN
;      PC.Pre(learnPost)    = !NONEl
;      PC.Post(PostNeurons)    = !NONEl
;   ENDIF



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
