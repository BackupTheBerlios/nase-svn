;+
; NAME: LearnHebbLP
;
; PURPOSE: Aendern einer Gewichtsmatrix in Abhaengigkeit der
;          Aktivitaeten in Source- und Targetcluster
;          genauer gesagt:
; deltaW(post,prae)=( -altW(post,prae)+alpha*Aktivitaet(post)*Lernpotential(prae)) * Aktivitaet(post) 
;   neuW(post,prae)=altW + Rate*deltaW   
;
;          dabei ist Aktivitaet(post) entweder 0 oder 1 (postsynaptischer Spike oder nicht)
;          und alpha ein Parameter, der den Grenzwert der Gewichte beeinflusst
;          
;          Eine Aenderung des Gewichts der Verbindung von prae nach
;          post erfolgt also nur, wenn das postsynaptische Neuron
;          feuert (hintere Multiplikation mit Aktivitaet(post))
;          Ist dies der Fall, so wird die Verbindung geschwaecht
;          (Subtraktion des alten Gewichts),falls der letzte praesynaptische Spike schon zu lange
;          zurueckliegt (das resultiert dann naemlich in kleinem Wert des Lernpotentials) 
;
;    Eine andere Sicht der oben angegebenen Lernregel lautet:
;        neuW(post,prae)= altW
;                          - ENTLERNRATE*Aktivität(post)*altW(post,prae)
;                          + LERNRATE   *Aktivität(post)*Lernpotential(prae) 
;       
;             mit: ENTLERNRATE=Rate,  LERNRATE=Rate*alpha
;          
;
; CATEGORY: SIMULATION
;
; CALLING SEQUENCE:     LearnHebbLP, G, LP, TARGET_CL=TargetCluster, 
;                                    { (RATE=Rate, ALPHA=Alpha)  |  (LERNRATE=lernrate, ENTLERNRATE=entlernrate) }
;                                    [,/SELF | ,/NONSELF]
;
; INPUTS: G  : Die bisherige Gewichtsmatrix (eine mit DelayWeigh oder InitWeights erzeugte Struktur) 
;         LP : Eine mit InitDW initialisierte Lernpotential-Struktur
;
; KEYWORD PARAMETERS: TARGET_CL : ein mit InitLayer_? initialisierter Layer
;
;                     RATE                : die Lernrate
;                     ALPHA               : Parameter, der den Grenzwert
;                                           beeinflusst, gegen den die
;                                           Gewichte konvergieren.
;
;                                           Die tatsächliche obere
;                                           Grenze für die Gewichte                  V_lern
;                                           berechnet sich zu:           alpha * -----------------
;                                                                                      -1/tau_lern
;                                                                                 1 - e
;
;        alternativ:  LERNRATE            : die Rate, mit der bei korrelierter Aktivität gelernt wird
;                     ENTLERNRATE         :       "   "    "   "  unkorrelierter    "     entlernt  "
;
;                     SELF                : Verbindungen zwischen Neuronen mit gleichen Index 
;                                           werden gelernt. Dies ist die Default-Einstellung,  
;                                           /SELF muss also nicht angegeben werden
;                     NONSELF             : Verbindungen zwischen Neuronen mit gleichem Index
;                                           werden nicht veraendert,
;                                           aber auch nicht Null-gesetzt.
;                                           (Siehe InitDW)
;
; PROCEDURE: LayerSize(), TotalRecall()
;
; EXAMPLE: LearnHebbLP, W, LP, Target_CL=Layer, Rate=0.01, ALPHA=1.0, /Nonself
;          veraendert die Matrix W entsprechend dem Zustand des
;          Clusters 'Layer', dh es werden Intra-Cluster-Verbindungen
;          gelernt, die Verbindungen der Neuronen auf sich selbst
;          bleiben aber unveraendert.
;
; MODIFICATION HISTORY: 
;
;       $Log$
;       Revision 1.12  1997/09/20 17:29:29  thiel
;              TOTALRECALL wird NICHT MEHR von der Lernregel aufgerufen.
;              Das muss man jetzt selbst erledigen.
;
;       Revision 1.11  1997/09/17 10:35:04  saam
;            kleine Bugs korrigiert
;
;       Revision 1.10  1997/09/17 10:25:52  saam
;               Listen&Listen in den Trunk gemerged
;
;
;       Fri Sep 12 12:09:30 1997, Mirko Saam
;       <saam@ax1317.Physik.Uni-Marburg.DE>
;       Revision: 1.7.2.5 
;               Umstellung auf die neue DelayWeigh-Struktur
;               Angabe des Source_Cl ist obsolet, da alle notwendigen
;               Informationen auch in LP stehen
;
;       Wed Sep 10 19:55:04 1997, Andreas Thiel
;		DEFAULT funktioniert nicht, wenn ENTLERNRATE nicht
;		gesetzt ist. Besser mit IF SET() usw.
;
;       Sun Sep 7 16:14:37 1997, Ruediger Kupper
;       <kupper@sisko.physik.uni-marburg.de>
;
;		LERNRATE,ENTLERNRATE zugefügt.
;
;       Thu Sep 4 17:03:51 1997, Mirko Saam
;       <saam@ax1317.Physik.Uni-Marburg.DE>
;
;		Funktioniert nun auch mit verzoegerten Verbindungen
;               Lernpotentiale nun nicht mehr in den Neuronen sondern in separater
;               Struktur
;
;       Wed Sep 3 15:50:04 1997, Ruediger Kupper
;       <kupper@sisko.physik.uni-marburg.de>
;
;		Ist jetzt eine Prozedur und keine Funktion mehr. (Ab
;		Rev. 1.5)
;
;       Mon Aug 18 16:44:07 1997, Mirko Saam
;       <saam@ax1317.Physik.Uni-Marburg.DE>
;
;             Behandlung von nicht vorhandenen Verbindungen
;
;
;
;		 erste Version vom 30 Juli
;                '97. Andreas.  neue Keyword-Abfrage und
;                Geschwindigkeitsoptimierung. 5. August '97. Andreas.  -
;-
PRO LearnHebbLP, DW, LP, TARGET_CL=Target_CL,RATE=Rate,ALPHA=Alpha,SELF=Self,NONSELF=NonSelf, $
                    LERNRATE=lernrate, ENTLERNRATE=entlernrate
  

   If Not Set(RATE) Then Rate = Entlernrate
   If Not Set(ALPHA) Then Alpha = Lerrate/Entlernrate

   ; update learning potentials
   ; TotalRecall, LP, DW.Learn

   ; TOTALRECALL sollte vor der Lernregel in der eigentlichen Simulation
   ; aufgerufen werden, da sonst eventuell zu oft geupdated wird.
 
   Handle_Value, Target_Cl.O, Post
   If Post(0) EQ 0 Then Return

   ; st : total number of source neurons
   ; ti : index to target neuron
   ; tn : to ti belonging target neuron
   ; tsn: the list of source neurons connected to tn
   st = LP.source_s

   IF DW.info EQ 'DW_WEIGHT' THEN BEGIN

      FOR ti=2,Post(0)+1 DO BEGIN
         tn = Post(ti)
         IF DW.SSource(tn) NE -1 THEN BEGIN
            Handle_Value, DW.SSource(tn), tsn
            deltaw = Alpha*LP.values(tsn) - DW.Weights(tn, tsn)
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
               deltaw = Alpha*LP.values(tn, tsn) - DW.Weights(tn, tsn)
               IF Set(NONSELF) THEN BEGIN
                  self = WHERE(tsn EQ tn, count)
                  IF count NE 0 THEN deltaw(self) = 0.0
               ENDIF
               DW.Weights(tn, tsn) = DW.Weights(tn, tsn) + Rate*deltaw
               Handle_Value, DW.SSource(tn), tsn, /SET
            ENDIF
         ENDFOR
         
      END ELSE Message, 'illegal first argument'
   END

END
