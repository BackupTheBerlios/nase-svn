;+
; NAME: LearnDelays
;
; PURPOSE: Diese Routine ändert die Leitungsgeschwindigkeit neuronaler 
;          Verbindungen in Abhängigkeit der Zeitdifferenzen zwischen prä- und
;          postsynaptsicher Aktivität der entsprechenden Neuronen, führt also
;          eine "Delay Adaptation" aus. Wie genau diese Adaptation aussehen
;          soll, muß durch ein Lernfenster vorgegeben werden.
;
; CATEGORY: SIMULATION / PLASTICITY
;
; CALLING SEQUENCE: LearnDelays, dw, pc, lw, [,/SHUTUP]
;
; INPUTS: dw: Die bisherige Gewichts/Delaymatrix (eine mit <A HREF="../CONNECTIONS/#INITDW">InitDW</A> erzeugte 
;             Struktur). 
;         pc: Eine mit <A HREF="#INITPRECALL">InitPrecall</A> initialisierte Struktur, die die Information
;             über die aktiven Verbindungen und die zugehörigen Zeitdifferenzen
;             enthält.
;         lw: Das Lernfenster. Dieses muß ein Array mit folgenden Einträgen
;             sein: lw=[tmaxpre,tmaxpost,deltapre,deltanull,deltapost]
;             tmaxpre=N_Elements(deltapre)
;             tmaxpost=N_Elements(deltapost)
;             deltapre: Ein Array, das die Delayänderungen für die Fälle angibt,
;                       in denen postsynaptischer VOR präsynaptischem Spike 
;                       auftritt.
;             deltanull: Die Delayänderung für gleichzeitiges Auftretn von prä-
;                        und postsynaptischem Spike.
;             deltapost: Ein Array, das die Delayänderungen für die Fälle 
;                        angibt, in denen postsynaptischer NACH präsynaptischem
;                        Spike auftritt.
;             Siehe dazu auch <A HREF="#INITLEARNBIPOO">InitLearnBiPoo</A>.
;
; KEYWORD PARAMETERS: SHUTUP: Verhindert die Ausgabe der Queue Reset-Warnung.
;                             (Siehe dazu ein paar Zeilen weiter unten.)
;
; (SIDE) EFFECTS: DW.D und DW.queuehdl werden geändert. Die Änderung von DW.D
;                 erfolgt in Schritten von beliebiger Genauigkeit, die 
;                 tatsächlichen Queue-Delays dagegen können nur ganzzahlige
;                 Werte annehmen und werden deshalb GERUNDET und nur bei Bedarf
;                 geändert. Für kleine Lernraten ändern sich die tatsächlichen 
;                 Verzögerungen also selten und sprunghaft.
;                 Falls ein Delay ein Vielfaches von 30 (Länge einer 
;                 BasicSpikequeue) überschreitet, werden alle Spikes in der 
;                 Queue gelöscht und eine größere oder kleinere (aber leere) 
;                 erzeugt. Es sollte darauf geachtet werden, daß dies nicht ZU
;                 HÄUFIG passiert, da sonst evtl. keine Spikes mehr übertragen 
;                 werden. Damit man das nicht vergißt, wird eine Warnung 
;                 ausgegeben, wenn die Queues neu initialisiert werden.
;     
; PROCEDURE: 1. In 'pc' sind die zu lernende Verbindungen und die zugehörigen
;               Zeitdifferenzen enthalten. 
;            2. Die entsprechenden Delayänderungen werden aus dem 
;               Lernfensterarray 'lw' ermittelt.
;            3. Damit wird zunächst DW.D aktualisiert.  
;            4. Die aktuellen Queuedelays werden ermittelt und mit den
;               neuen DW.D-Delays verglichen.
;            5. Falls deren Differenz einen halben BIN übersteigt, wird
;               das entsprechende Queue-Delay verändert.
;            6. Wenn ein Queue-Delay die Grenze einer BasicSpikequeue
;               überschreitet, wird die gesamte Queue neu initialisiert, was
;               zum Verlust aller darin enthalteten Spikes führt.
; 
; EXAMPLE: 
;   CON_L1_L1 = InitDW(S_LAYER=L1, T_LAYER=L1, $
;                      WEIGHT=0.3, /W_TRUNCATE, /W_NONSELF, DELAY=13)
;   LearnWindow = InitLearnBiPoo(POSTV=0.2, PREV=0.2)
;
;   PC_L1_L1 = InitPrecall(CON_L1_L1, LearnWindow)
;
;   <Simulationsschleife>
;      I_L1_L = DelayWeigh(CON_L1_L1, LayerOut(L1))
;
;      TotalPrecall, LP_L1_L1, CON_L1_L1, L1
;      LearnDelays, CON_L1_L1, LP_L1_L1, LearnWindow
; 
;
;      InputLayer, L1, FEEDING=I_L1_F, LINKING=I_L1_L
;      ProceedLayer, L1
;   <Simulationsschleife>
;
; SEE ALSO: <A HREF="#INITPRECALL">InitPrecall</A>, <A HREF="#INITLEARNBIPOO">InitLearnBiPoo</A>,  <A HREF="#LEARNBIPOO">LearnBiPoo</A>.
;
;
; MODIFICATION HISTORY: 
;
;       $Log$
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
;
;-
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
   

   FOR i=0, N_Elements(wi)-1 DO BEGIN
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
   Handle_Value, DW.queuehdl, queue, /NO_COPY
   
   ; Read last Basicspikequeue into 'tmpqu'
   Handle_Value, queue(queue(0)), tmpqu


   ; Determine current delays form spikequeue-array:
   queuedelays = (queue(queue(0)+1:N_Elements(queue)-1))(wi)

;   Print, 'DW.D(wi): ',DW.D(wi)
;   Print, 'queuedelays: ',queuedelays

   ; What are the actual delays of the queues?
   ; Determine current delays from 'starts' in Basicspikequeues:
   ; (This is only for testing!)
;   realqueuedelays = FltArr(N_Elements(wi))
;   FOR handlei=1,queue(0) DO BEGIN
;      Handle_Value, queue(handlei), tmpqu
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
         FreeSpikeQueue, queue
         queue = InitSpikeQueue(INIT_DELAYS=DW.D)
      ENDIF ELSE BEGIN
         ; change STARTS in BasicSpikeQueue:
         tmpqu.starts(wi(diffidx)) = newstarts
         ; change Delays in S
         queue(queue(0)+1+wi(diffidx)) = $
          queuedelays(diffidx)+Round(diff(diffidx))
         Handle_Value, queue(queue(0)), tmpqu, /NO_COPY, /SET
      ENDELSE
   ENDIF

   
   Handle_Value, DW.queuehdl, queue, /NO_COPY, /SET
   Handle_Value, PC.postpre, ConTiming, /NO_COPY, /SET
   Handle_Value, _PC, PC, /NO_COPY, /SET
   Handle_Value, _DW, DW, /NO_COPY, /SET


END
