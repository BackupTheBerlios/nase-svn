;+
; NAME: LearnDelays
;
; PURPOSE: Diese Routine �ndert die Leitungsgeschwindigkeit neuronaler 
;          Verbindungen in Abh�ngigkeit der Zeitdifferenzen zwischen pr�- und
;          postsynaptsicher Aktivit�t der entsprechenden Neuronen, f�hrt also
;          eine "Delay Adaptation" aus. Wie genau diese Adaptation aussehen
;          soll, mu� durch ein Lernfenster vorgegeben werden.
;
; CATEGORY: SIMULATION / PLASTICITY
;
; CALLING SEQUENCE: LearnDelays, dw, pc, lw
;
; INPUTS: dw: Die bisherige Gewichts/Delaymatrix (eine mit <A HREF="../CONNECTIONS/#INITDW">InitDW</A> erzeugte 
;             Struktur). 
;         pc: Eine mit <A HREF="#INITPRECALL">InitPrecall</A> initialisierte Struktur, die die Information
;             �ber die aktiven Verbindungen und die zugeh�rigen Zeitdifferenzen
;             enth�lt.
;         lw: Das Lernfenster. Dieses mu� ein Array mit folgenden Eintr�gen
;             sein: lw=[tmaxpre,tmaxpost,deltapre,deltanull,deltapost]
;             tmaxpre=N_Elements(deltapre)
;             tmaxpost=N_Elements(deltapost)
;             deltapre: Ein Array, das die Delay�nderungen f�r die F�lle angibt,
;                       in denen postsynaptischer VOR pr�synaptischem Spike 
;                       auftritt.
;             deltanull: Die Delay�nderung f�r gleichzeitiges Auftretn von pr�-
;                        und postsynaptischem Spike.
;             deltapost: Ein Array, das die Delay�nderungen f�r die F�lle 
;                        angibt, in denen postsynaptischer NACH pr�synaptischem
;                        Spike auftritt.
;             Siehe dazu auch <A HREF="#INITLEARNBIPOO">InitLearnBiPoo</A>.
;
; (SIDE) EFFECTS: DW.D und DW.queuehdl werden ge�ndert. Die �nderung von DW.D
;                 erfolgt in Schritten von beliebiger Genauigkeit, die 
;                 tats�chlichen Queue-Delays dagegen k�nnen nur ganzzahlige
;                 Werte annehmen und werden deshalb GERUNDET und nur bei Bedarf
;                 ge�ndert. F�r kleine Lernraten �ndern sich die tats�chlichen 
;                 Verz�gerungen also selten und sprunghaft.
;                 Falls ein Delay ein Vielfaches von 30 (L�nge einer 
;                 BasicSpikequeue) �berschreitet, werden alle Spikes in der 
;                 Queue gel�scht und eine gr��ere oder kleinere (aber leere) 
;                 erzeugt. Es sollte darauf geachtet werden, da� dies nicht ZU
;                 H�UFIG passiert, da sonst evtl. keine Spikes mehr �bertragen 
;                 werden.
;     
; PROCEDURE: 1. In 'pc' sind die zu lernende Verbindungen und die zugeh�rigen
;               Zeitdifferenzen enthalten. 
;            2. Die entsprechenden Delay�nderungen werden aus dem 
;               Lernfensterarray 'lw' ermittelt.
;            3. Damit wird zun�chst DW.D aktualisiert.  
;            4. Die aktuellen Queuedelays werden ermittelt und mit den
;               neuen DW.D-Delays verglichen.
;            5. Falls deren Differenz einen halben BIN �bersteigt, wird
;               das entsprechende Queue-Delay ver�ndert.
;            6. Wenn ein Queue-Delay die Grenze einer BasicSpikequeue
;               �berschreitet, wird die gesamte Queue neu initialisiert, was
;               zum Verlust aller darin enthalteten Spikes f�hrt.
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
; SEE ALSO: <A HREF="#INITPRECALL">InitPrecall</A>, <A HREF="#INITLEARNBIPOO">InitLearnBiPoo</A>,  <A HREF="#LEARNBIPOO">InitLearnBiPoo</A>.
;
;
; MODIFICATION HISTORY: 
;
;       $Log$
;       Revision 1.1  1999/07/28 14:49:36  thiel
;           Now possible: Delay Adaptation.
;
;
;-
PRO LearnDelays, _DW, _PC, LW;, SELF=Self, NONSELF=NonSelf;, DELEARN=delearn
  

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
   DW.D(wi) = ((DW.D(wi) + LW(2+ConTiming(*,1)+LW(0)))) > 0.0


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
;         Print, 'Queue-Init!!!'
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
