;+
; NAME: LearnHebbSharp
;
; PURPOSE: Aendern einer Gewichtsmatrix in Abhaengigkeit der
;          Aktivitaeten in Source- und Targetcluster
;          genauer gesagt:
; deltaW(post,prae)=( -altW(post,prae)+alpha*Aktivitaet(post)*Aktivitaet(prae)) * Aktivitaet(post) 
;   neuW(post,prae)=altW + Rate*deltaW   
;
;          dabei ist Aktivitaet(post) bzw Aktivitaet(prae) entweder 0
;          oder 1 (postsynaptischer Spike oder nicht)
;          und alpha der Grenzwert der Gewichte.
;          
;          Eine Aenderung des Gewichts der Verbindung von prae nach
;          post erfolgt also nur, wenn das postsynaptische Neuron
;          feuert (hintere Multiplikation mit Aktivitaet(post))
;          Ist dies der Fall, so wird die Verbindung geschwaecht
;          (Subtraktion des alten Gewichts),falls kein praesynaptischer Spike vorliegt.
;
; CATEGORY: SIMULATION
;
; CALLING SEQUENCE:   LearnHebbSharp, G, TARGET_CL=TargetCluster, 
;                                    { (RATE=Rate, ALPHA=Alpha)  |  (LERNRATE=lernrate, ENTLERNRATE=entlernrate) }
;                                    [,/SELF | ,/NONSELF]
;
; INPUTS: G : Die bisherige Gewichtsmatrix (eine mit DelayWeigh oder InitWeights erzeugte Struktur) 
;
; KEYWORD PARAMETERS: SOURCE_CL, 
;                     TARGET_CL     : jeweils eine mit InitLayer_? initialisierter Layer
;
;                     RATE          : die Lernrate
;                     ALPHA         : der Grenzwert, gegen den die
;                                     Gewichte konvergieren.
;        alternativ:  LERNRATE      : die Rate, mit der bei korrelierter Aktivität gelernt wird
;                     ENTLERNRATE   :       "   "    "   "  unkorrelierter    "     entlernt  "
;
;                     SELF          : Verbindungen zwischen Neuronen mit gleichen Index 
;                                     werden gelernt. Dies ist die Default-Einstellung,  
;                                     /SELF muss also nicht angegeben werden
;                     NONSELF       : Verbindungen zwischen Neuronen mit gleichem Index
;                                     werden nicht veraendert,
;                                     aber auch nicht Null-gesetzt.
;                                     (Siehe InitDW)
;
; SIDE EFFECTS: Die Matrix G, die als Parameter G uebergeben wird,
;               wird entsprechend der Lernregel geaendert.
;
; PROCEDURE: LayerSize()
;
; EXAMPLE: LearnHebbSharp, W, Target_CL=Layer, Rate=0.01, ALPHA=1.0, /Nonself
;          veraendert die Matrix W entsprechend dem Zustand des
;          Clusters 'Layer', dh es werden Intra-Cluster-Verbindungen
;          gelernt, die Verbindungen der Neuronen auf sich selbst
;          bleiben aber unveraendert.
;
; MODIFICATION HISTORY: 
;
;       $Log$
;       Revision 1.5  1997/09/17 10:25:53  saam
;       Listen&Listen in den Trunk gemerged
;
;       Revision 1.3.2.2  1997/09/15 08:39:52  saam
;       Anpassung an Listenstruktur der anderen Routinen
;
;       Sun Sep 7 16:10:55 1997, Ruediger Kupper
;       <kupper@sisko.physik.uni-marburg.de>
;
;		LERNRATE, ENTLERNRATE zugefügt.
;
;       Wed Sep 3 15:52:19 1997, Ruediger Kupper
;       <kupper@sisko.physik.uni-marburg.de>
;
;		Ist jetzt eine Prozedur und keine Funktion mehr. (Ab
;		Rev. 1.3)
;
;       Mon Aug 18 16:45:46 1997, Mirko Saam
;       <saam@ax1317.Physik.Uni-Marburg.DE>
;
;             Behandlung von nicht vorhandenen Verbindungen
;
;
; erste Version vom 5. August '97. Andreas.
;
;-
PRO LearnHebbSharp, DW, SOURCE_CL=Source_Cl, TARGET_CL=Target_CL,RATE=Rate,ALPHA=Alpha,SELF=Self,NONSELF=NonSelf

   Default, rate, entlernrate
   Default, alpha, lernrate/entlernrate


   Handle_Value, Target_Cl.O, Post
   If Post(0) EQ 0 Then Return

   ; st : total number of source neurons
   ; ti : index to target neuron
   ; tn : to ti belonging target neuron
   ; tsn: the list of source neurons connected to tn
   st = LayerSize(Source_Cl)

   IF DW.info EQ 'DW_WEIGHT' THEN BEGIN

      FOR ti=2,Post(0)+1 DO BEGIN
         tn = Post(ti)
         IF DW.SSource(tn) NE -1 THEN BEGIN
            Handle_Value, DW.SSource(tn), tsn
            deltaw = Alpha*Post(tsn) - DW.Weights(tn, tsn)
            IF Set(NONSELF) THEN BEGIN
               self = WHERE(tsn EQ tn, count)
               IF count NE 0 THEN deltaw(self) = 0.0
            ENDIF
            DW.Weights(tn, tsn) = DW.Weights(tn, tsn) + Rate*deltaw
         ENDIF
      ENDFOR

   END ELSE BEGIN 
      IF DW.info EQ 'DW_DELAY_WEIGHT' THEN BEGIN
         
         FOR ti=2,Post(0)+1 DO BEGIN
            tn = Post(ti)
            IF DW.SSource(tn) NE -1 THEN BEGIN
               Handle_Value, DW.SSource(tn), tsn
               deltaw = Alpha*Post(tsn) - DW.Weights(tn, tsn)
               IF Set(NONSELF) THEN BEGIN
                  self = WHERE(tsn EQ tn, count)
                  IF count NE 0 THEN deltaw(self) = 0.0
               ENDIF
               DW.Weights(tn, tsn) = DW.Weights(tn, tsn) + Rate*deltaw
            ENDIF
         ENDFOR
         
      END ELSE Message, 'illegal first argument'
   END
   
END


