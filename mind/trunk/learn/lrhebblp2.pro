;+
; NAME:               LRHebbLP2
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
; CATEGORY: MIND LEARN
;
; CALLING SEQUENCE:     LrHebbLP2, G, LP, TARGET_CL=TargetCluster, 
;                                    ALPHA=alpha, GAMMA=gamma, DELEARN=delearn
;                                    [,MAXIMUM=maximum]
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
;                     MAXIMUM   : Maximale Verbindungsstaerke 
;
; PROCEDURE:          LayerSize(), TotalRecall()
;
; MODIFICATION HISTORY:
;
;
;     $Log$
;     Revision 1.1  2000/01/26 10:40:27  alshaikh
;           +initial version
;           +doesn't work with delays
;           +no fancy header
;
;
;-
PRO _LearnHebbLP2, _DW, LP, TARGET_CL=Target_CL,SELF=Self,NONSELF=NonSelf, $
                ALPHA=alpha, GAMMA=gamma, DELEARN=delearn,MAXIMUM=max
  

   Post = Handle_Val(LayerOut(Target_CL))
   If Post(0) EQ 0 Then RETURN
   Handle_Value, _DW, DW, /NO_COPY
   

   ; ti : index to target neuron
   ; tn : to ti belonging target neuron
   ; wi : weight indices belonging to neuron

   IF Set(DELEARN) THEN BEGIN
      DW.W = (DW.W - DELEARN) > 0.0
   END

   IF DW.Info EQ 'SDW_WEIGHT' THEN BEGIN

      FOR ti=2,Post(0)+1 DO BEGIN
         tn = Post(ti)
         IF DW.T2C(tn) NE -1 THEN BEGIN
            Handle_Value, DW.T2C(tn), wi
            deltaw = (GetRecall(LP))(DW.C2S(wi)) - alpha
            IF Set(NONSELF) THEN BEGIN
               self = WHERE(DW.C2S(wi) EQ tn, count)
               IF count NE 0 THEN deltaw(self) = 0.0
            ENDIF
            DW.W(wi) = ((DW.W(wi) + gamma*deltaw) > 0.0) < max;0.003
         ENDIF
      ENDFOR

   END ELSE BEGIN 
      IF DW.info EQ 'SDW_DELAY_WEIGHT' THEN BEGIN
         
         FOR ti=2,Post(0)+1 DO BEGIN
            tn = Post(ti)
            IF DW.T2C(tn) NE -1 THEN BEGIN
               Handle_Value, DW.T2C(tn), wi
               deltaw = (GetRecall(LP))(wi) - alpha
               IF Set(NONSELF) THEN BEGIN
                  self = WHERE(DW.C2S(wi) EQ tn, count)
                  IF count NE 0 THEN deltaw(self) = 0.0
               ENDIF
               DW.W(wi) = (DW.W(wi) + gamma*deltaw) > 0.0
            ENDIF
         ENDFOR
         
      END ELSE Message, 'illegal first argument'
   END

   Handle_Value, _DW, DW, /NO_COPY, /SET
      
END





PRO lrhebblp2,con=CON,win=WIN,ALPHA=alpha, TARGET_CL=target_cl,GAMMA=gamma,MAXIMUM=max

Default, MAXIMUM,1000.0

_LearnHebbLP2,CON,WIN,target_cl=target_cl, alpha=alpha,gamma=gamma,MAXIMUM=max

END 
