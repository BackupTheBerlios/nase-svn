;+
; NAME:
;  LearnDelays
;
; AIM: Delay adaptation of connections between neurons.
;  
; PURPOSE: 
;  This routine changes the conduction velocity of connections
;  according to the time differences between pre- and postsynaptic
;  spikes of the corresponding neurons. In other words, connection
;  delays are adapted depending on the involved neurons' activity. The
;  exact way of this adaptation must be specified bey a learning
;  function.
;
; CATEGORY:
;  SIMULATION / PLASTICITY
;
; CALLING SEQUENCE:
;  LearnDelays, dw, pc, lw, [,/SHUTUP]
;
; INPUTS: 
;  dw: The old weights/delaymatrix (a structure generated using <A HREF="http://neuro.physik.uni-marburg.de/nase/simu/connections#INITDW">InitDW</A>). 
;  pc: Structure generated by <A HREF="#INITPRECALL">InitPrecall</A>, containing information 
;      about active connections and corresponding time differences. 
;  lw: Learning function. An array with the following contents:
;         lw=[tmaxpre,tmaxpost,deltapre,deltanull,deltapost]
;         tmaxpre=N_Elements(deltapre)
;         tmaxpost=N_Elements(deltapost)
;         deltapre: Array specifying delay changes in case that
;                   postsynaptic spike occured BEFORE presynaptic one.
;         deltanull: Delay change in case pre- and postsynaptic spike
;                    occured simultaneously.
;         deltapost: Array specifying delay changes in case that
;                    postsynaptic spike occured AFTER the
;                    presynaptic one.
;         See also: <A HREF="#INITLEARNBIPOO">InitLearnBiPoo</A>.
;
; KEYWORD PARAMETERS: 
;  SHUTUP: Prevents output of queue reset warning (see below).
;
; (SIDE) EFFECTS: 
;  DW.D and DW.queuehdl are changed. Changes in DW.D are made in steps
;  of arbitrary precision, but the actual delays can only have integer
;  values and are therefore ROUNDED and changed if necessary. Thus, in
;  case of small learning rates, the actual delays change seldom and
;  stepwise from one integer value to the next larger or smaller one.
;  If a delay passes the multiple of 30 (length of a <A HREF="http://neuro.physik.uni-marburg.de/nase/misc/structures#BASICSPIKEQUEUE">basic spikequeue</A>)
;  all spikes currently in the queue are deleted and a new longer
;  or shorter one is generated. This should not happen TOO OFTEN,
;  because otherwise no more spikes are transmitted. To remind the
;  user of those queue resets, a warning is printed if the queues are
;  newly initialized.
;     
; PROCEDURE: 
;  1. 'pc' contains connections that have to be changed and
;     corresponding time differences.
;  2. Delay changes are computed from learning function array 'lw'.
;  3. Change DW.D first.
;  4. Determine current queue delays and compare them to new
;     DW.D-delays.
;  5. If difference is larger than 0.5BIN change corresponding queue
;     delay.
;  6. If any queue delay passes the length of a basicspikequeue, the
;     whole queue is initialized anew.
;
; EXAMPLE: 
;   CON_L1_L1 = InitDW(S_LAYER=L1, T_LAYER=L1, $
;                      WEIGHT=0.3, /W_TRUNCATE, /W_NONSELF, DELAY=13)
;   LearnWindow = InitLearnBiPoo(POSTV=0.2, PREV=0.2)
;
;   PC_L1_L1 = InitPrecall(CON_L1_L1, LearnWindow)
;
;   <simulation loop>
;      I_L1_L = DelayWeigh(CON_L1_L1, LayerOut(L1))
;
;      TotalPrecall, LP_L1_L1, CON_L1_L1, L1
;      LearnDelays, CON_L1_L1, LP_L1_L1, LearnWindow
; 
;
;      InputLayer, L1, FEEDING=I_L1_F, LINKING=I_L1_L
;      ProceedLayer, L1
;   <simulation loop>
;
; SEE ALSO: <A HREF="#INITPRECALL">InitPrecall</A>, <A HREF="#INITLEARNBIPOO">InitLearnBiPoo</A>, <A HREF="#LEARNBIPOO">LearnBiPoo</A>.
;
;
; -
;
; MODIFICATION HISTORY: 
;
;       $Log$
;       Revision 1.9  2000/08/14 14:40:02  thiel
;           Hyperlinks.
;
;       Revision 1.8  2000/08/14 13:37:00  thiel
;           Loop variable is now long. Header translation.
;
;       Revision 1.7  2000/04/12 16:25:22  thiel
;           Variable name 'queue' collided with function of same name.
;
;       Revision 1.6  1999/09/29 12:58:45  thiel
;           Rounding deaktivated.
;
;       Revision 1.5  1999/09/23 14:35:23  thiel
;           More stable by rounding.
;
;       Revision 1.4  1999/08/10 15:12:04  thiel
;           Changed 'Print' to 'Message, /INFO'.
;
;       Revision 1.3  1999/08/09 15:45:32  thiel
;           Now prints warning when spikes are lost due to queue-resets.
;
;       Revision 1.2  1999/08/05 14:15:54  thiel
;           Works correct with multiple changes of the same connection.
;
;       Revision 1.1  1999/07/28 14:49:36  thiel
;           Now possible: Delay Adaptation.
;

PRO LearnDelays, _DW, _PC, LW, SHUTUP=shutup;, SELF=Self, NONSELF=NonSelf;, DELEARN=delearn
  

   Handle_Value, _PC, PC, /NO_COPY
   Handle_Value, PC.postpre, ConTiming, /NO_COPY

   IF ConTiming(0) EQ !NONEl THEN BEGIN
      Handle_Value, PC.postpre, ConTiming, /NO_COPY, /SET
      Handle_Value, _PC, PC, /NO_COPY, /SET
      RETURN
   END

   Handle_Value, _DW, DW, /NO_COPY

;   IF Set(DELEARN) THEN BEGIN
;      DW.W = (DW.W - DELEARN) > 0.0
;   END
   
;   self = WHERE(DW.C2S(wi) EQ tn, count)
;   IF count NE 0 THEN deltaw(self) = 0.0
   

   wi = ConTiming(*,0) ; = indices of connections to be learned

;   Print
;   Print, 'ConTim:', Contiming

;--- First change DW.D according to deltat contained in ConTiming
;    according to learnwindow:
   

   FOR i=0l, N_Elements(wi)-1 DO BEGIN
      DW.D(wi(i)) = ((DW.D(wi(i)) + LW(2+ConTiming(i,1)+LW(0)))) > 0.0
      ; If no delayshift is necessary set delays back to their integer value
      ; to avoid delay-drifting:
      ;      IF  ConTiming(i,1) EQ 1 THEN $
      ;       DW.D(wi(i))=Float(Round(DW.D(wi(i))))

;      print, 'i ',i,' DW.D(wi(',i,') ',dw.D(wi(i))
;      print, 'cont:', ConTiming(i,0), ConTiming(i,1)
   ENDFOR

   wi = wi(UNIQ(wi, SORT(wi)))
   

;--- Now the queue-delays have to be changed also:

   ; Read spikequeue-structure into 'queue':
   Handle_Value, DW.queuehdl, qu, /NO_COPY
   
   ; Read last Basicspikequeue into 'tmpqu'
   Handle_Value, qu(qu(0)), tmpqu


   ; Determine current delays form spikequeue-array:
   queuedelays = (qu(qu(0)+1:N_Elements(qu)-1))(wi)

;   Print, 'DW.D(wi): ',DW.D(wi)
;   Print, 'queuedelays: ',queuedelays

   ; What are the actual delays of the queues?
   ; Determine current delays from 'starts' in Basicspikequeues:
   ; (This is only for testing!)
;   realqueuedelays = FltArr(N_Elements(wi))
;   FOR handlei=1,qu(0) DO BEGIN
;      Handle_Value, qu(handlei), tmpqu
;      realqueuedelays = realqueuedelays+alog(tmpqu.starts(wi))/alog(2.)
;   ENDFOR
;   Print, 'real queuedelays: ',realqueuedelays


   ; Differnce between DW-delay and Queue-delay
   diff = DW.D(wi)-queuedelays

   ; Is the difference larger than 1/2 BIN?
   ; If yes, queue-delays have to be changed.
   diffidx = Where(Abs(diff) GE 0.5, c)
   IF c NE 0 THEN BEGIN
;      Print
;      Print, 'Change queues!'
      newstarts = IShft(tmpqu.starts(wi(diffidx)),Round(diff(diffidx)))
      overunderflow = Where(newstarts LE 0, c)
      IF c NE 0 THEN BEGIN
         IF NOT Keyword_Set(SHUTUP) THEN $
          Message, /INFO, 'Warning! Queue-reset. Possible loss of spikes.'
         FreeSpikeQueue, qu
         qu = InitSpikeQueue(INIT_DELAYS=DW.D)
      ENDIF ELSE BEGIN
         ; change STARTS in BasicSpikeQueue:
         tmpqu.starts(wi(diffidx)) = newstarts
         ; change Delays in S
         qu(qu(0)+1+wi(diffidx)) = $
          queuedelays(diffidx)+Round(diff(diffidx))
         Handle_Value, qu(qu(0)), tmpqu, /NO_COPY, /SET
      ENDELSE
   ENDIF

   
   Handle_Value, DW.queuehdl, qu, /NO_COPY, /SET
   Handle_Value, PC.postpre, ConTiming, /NO_COPY, /SET
   Handle_Value, _PC, PC, /NO_COPY, /SET
   Handle_Value, _DW, DW, /NO_COPY, /SET


END
