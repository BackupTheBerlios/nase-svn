;+
; NAME:               LearnBiPoo
;
; PURPOSE:            Aendern einer Gewichtsmatrix in Abhaengigkeit der
;                     Aktivitaeten in Source- und Targetcluster
;                     genauer gesagt:
;                       deltaW(post,prae)=( Lernpotential(prae) - ALPHA  ) * Aktivitaet(post) 
;                       neuW(post,prae)=altW + GAMMA*deltaW   
;
;                     dabei ist Aktivitaet(post) entweder 0 oder 1 (postsynaptischer Spike oder nicht).
;                     Das Lernpotential sollte maximal 1 werden, denn dann 
;                     ist der sinnvolle Wertebereich von ALPHA: [0,1]
;          
;                     Eine Aenderung des Gewichts der Verbindung von prae nach
;                     post erfolgt also nur, wenn das postsynaptische Neuron
;                     feuert (Multiplikation mit Aktivitaet(post))
;                     Ist dies der Fall, so wird die Verbindung geschwaecht
;                     (Subtraktion des alten Gewichts),falls der letzte praesynaptische Spike schon zu lange
;                     zurueckliegt (das resultiert dann naemlich in kleinem Wert des Lernpotentials) 
;
; CATEGORY: SIMULATION PLASTICITY
;
; CALLING SEQUENCE:     LearnHebbLP, G, LP, TARGET_CL=TargetCluster, 
;                                    ALPHA=alpha, GAMMA=gamma, DELEARN=delearn
;                                    [,/SELF | ,/NONSELF]
;
; INPUTS:             G  : Die bisherige Gewichtsmatrix (eine mit DelayWeigh oder 
;                              InitWeights erzeugte Struktur) 
;                     LP : Eine mit InitDW initialisierte Lernpotential-Struktur
;
; KEYWORD PARAMETERS: TARGET_CL : ein mit InitLayer_? initialisierter Layer
;
;                     ALPHA     : Ist das Lernpotential max. 1, dann bedeutet
;                                 ALPHA=0: kein Entlernen
;                                 ALPHA=1: kein Lernen 
;                     DELEARN   : Gewichte werden jeden Zeitschritt um
;                                 DELEARN verringert, es findet aber keine Umwandlung
;                                 von exc. in inh. Synapsentypen statt, d.h. MIN(wij)=0;
;                                 default is 0.0
;                     GAMMA     : Parameter, der den Grenzwert
;                                 beeinflusst, gegen den die
;                                 Gewichte konvergieren.
;                     SELF      : Verbindungen zwischen Neuronen mit gleichen Index 
;                                 werden gelernt. Dies ist die Default-Einstellung,  
;                                 /SELF muss also nicht angegeben werden
;                     NONSELF   : Verbindungen zwischen Neuronen mit gleichem Index
;                                 werden nicht veraendert,
;                                 aber auch nicht Null-gesetzt.
;                                 (Siehe InitDW)
;
; PROCEDURE:          LayerSize(), TotalRecall()
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
;       Revision 1.2  1999/07/26 13:19:58  thiel
;           Changed according to new InitLearnBiPoo-array contents.
;
;       Revision 1.1  1999/07/21 07:17:29  saam
;             + this is learnbipoo version1
;             + no header yet, no time yet....
;
;
;-
PRO LearnBiPoo, _DW, _PC, LW, SELF=Self, NONSELF=NonSelf, DELEARN=delearn
  

   Handle_Value, _PC, PC, /NO_COPY
   Handle_Value, PC.postpre, ConTiming, /NO_COPY

   IF ConTiming(0) EQ !NONEl THEN BEGIN
      Handle_Value, PC.postpre, ConTiming, /NO_COPY, /SET
      Handle_Value, _PC, PC, /NO_COPY, /SET
      RETURN
   END

   Handle_Value, _DW, DW, /NO_COPY

   IF Set(DELEARN) THEN BEGIN
      DW.W = (DW.W - DELEARN) > 0.0
   END

;   self = WHERE(DW.C2S(wi) EQ tn, count)
;   IF count NE 0 THEN deltaw(self) = 0.0
   
   wi = ConTiming(*,0)
   DW.W(wi) = (DW.W(wi) + LW(2+ConTiming(*,1)+LW(0))); > 0.0


   Handle_Value, PC.postpre, ConTiming, /NO_COPY, /SET
   Handle_Value, _PC, PC, /NO_COPY, /SET
   Handle_Value, _DW, DW, /NO_COPY, /SET
END
