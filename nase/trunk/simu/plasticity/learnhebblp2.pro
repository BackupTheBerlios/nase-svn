;+
; NAME:               LearnHebbLP2
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
;                                    ALPHA=alpha, GAMMA=gamma
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
;                     GAMM      : Parameter, der den Grenzwert
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
;       Revision 2.1  1998/01/21 21:54:52  saam
;             Aus LearnHebbLP hervorgegangen.
;
;
;-
PRO LearnHebbLP2, _DW, LP, TARGET_CL=Target_CL,SELF=Self,NONSELF=NonSelf, $
                ALPHA=alpha, GAMMA=gamma
  
   Handle_Value, _DW, DW, /NO_COPY
 

   Handle_Value, Target_Cl.O, Post
   If Post(0) EQ 0 Then BEGIN
      Handle_Value, _DW, DW, /NO_COPY, /SET
      RETURN
   END

   ; st : total number of source neurons
   ; ti : index to target neuron
   ; tn : to ti belonging target neuron
   ; tsn: the list of source neurons connected to tn

   IF DW.info EQ 'DW_WEIGHT' THEN BEGIN

      FOR ti=2,Post(0)+1 DO BEGIN
         tn = Post(ti)
         IF DW.SSource(tn) NE -1 THEN BEGIN
            Handle_Value, DW.SSource(tn), tsn
            deltaw = (GetRecall(LP))(tsn) - alpha
            IF Set(NONSELF) THEN BEGIN
               self = WHERE(tsn EQ tn, count)
               IF count NE 0 THEN deltaw(self) = 0.0
            ENDIF
            DW.Weights(tn, tsn) = (DW.Weights(tn, tsn) + gamma*deltaw) > 0.0
         ENDIF
      ENDFOR

   END ELSE BEGIN 
      IF DW.info EQ 'DW_DELAY_WEIGHT' THEN BEGIN
         
         FOR ti=2,Post(0)+1 DO BEGIN
            tn = Post(ti)
            IF DW.SSource(tn) NE -1 THEN BEGIN
               Handle_Value, DW.SSource(tn), tsn
               deltaw = (GetRecall(LP))(tn, tsn) - alpha
               IF Set(NONSELF) THEN BEGIN
                  self = WHERE(tsn EQ tn, count)
                  IF count NE 0 THEN deltaw(self) = 0.0
               ENDIF
               DW.Weights(tn, tsn) = (DW.Weights(tn, tsn) + gamma*deltaw) > 0.0
               Handle_Value, DW.SSource(tn), tsn, /SET
            ENDIF
         ENDFOR
         
      END ELSE Message, 'illegal first argument'
   END

   Handle_Value, _DW, DW, /NO_COPY, /SET
      
END
