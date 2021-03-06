;+
; NAME:
;  LearnABS
;
; AIM: Learn connection strengths according to ABS rule.
;
; PURPOSE: Aendern einer Gewichtsmatrix in Abhaengigkeit der
;          Aktivitaeten in Source- und Targetcluster
;          genauer gesagt:
;
;                     +1,  falls Aktivitaet(prae)=1 UND Membranpotential(post) >= ThetaPlus     
; deltaW(post,prae)=  -1,  falls Aktivitaet(prae)=1 UND ThetaMinus =< Membranpotentail(post) < ThetaPlus
;                      0,  falls Aktivitaet(prae)=0 ODER falls Aktivitaet(prae)=1 UND Membranpotential(post) < ThetaMinus
;
;   neuW(post,prae)= altW + Rate*deltaW   
;
;          dabei ist Aktivitaet(prae) entweder 0 oder 1 (praesynaptischer Spike oder nicht),
;          ThetaMinus der Wert des postsynaptischem Membranpotentials, ab dem die Verbindungs-
;          staerke vermindert wird, und ThetaPlus der Wert des Membranpotentials, ab dem
;          die Verbindungsstaerke erhoeht wird.   
;          
;          Eine Aenderung des Gewichts der Verbindung von prae nach
;          post erfolgt also nur, wenn das praesynaptische Neuron
;          feuert.
;          Ist dies der Fall, so wird die Verbindung geschwaecht,
;          falls das postsynaptische Membranpotential zwischen ThetaMinus
;          und ThetaPlus liegt. Ist es groesser als ThetaPlus, wird die Verbindung
;          verstaerkt, ansonsten wird sie nicht veraendert.
;
; CATEGORY:
;  Simulation / Plasticity
;
; CALLING SEQUENCE: LearnABS, G, TARGET_CL=TargetCluster, 
;                             RATE=Rate, ALPHA=Alpha,
;                             ENTLERNAPMLITUDE=ThetaMinus, LERNAMPLITUDE=ThetaPlus
;                             [,/SELF | ,/NONSELF]
;
; INPUTS: G                      : Die Gewichtsmatrix 
;                                   (eine mit InitDW erzeugte Struktur) 
;         Source-, TargetCluster : mit InitLayer_? initialisierte Strukturen,
;                                   die die prae- bzw postsynaptischen Neuronen enthalten
;         Rate                   : die Lernrate
;         Alpha                  : der Grenzwert, ueber den hinaus die Gewichte nicht
;                                   erhoeht werden; Gewichte > Alpha werden bei Alpha
;                                   abgeschnitten
;         ThetaMinus, ThetaPlus  : Amplituden des postsyn. Membranpotentials, die
;                                   Entlernen bzw Lernen bestimmen (siehe oben)
;
; KEYWORD PARAMETERS: SELF    : Verbindungen zwischen Neuronen mit gleichen Index 
;                                werden gelernt. Dies ist die Default-Einstellung,  
;                                /SELF muss also nicht angegeben werden
;                     NONSELF : Verbindungen zwischen Neuronen mit gleichem Index
;                               werden nicht veraendert, aber auch nicht Null-gesetzt.
;                               (Siehe InitDW)
;
; RESTRICTIONS: Die DELAY-WEIGHT-Variante wurde nur aufgrund von
;               Analogiebetrachtungen erstellt und NICHT getestet!!!
;
; PROCEDURE: 1. Falls keine praesynaptischen Spikes vorliegen, braucht nichts
;                gelernt zu werden und die Prozedur wird sofort wieder verlassen.
;            2. Zu allen aktiven Source-Neuronen werden die mit ihnen verbundenen
;                Target-Neuronen ermittelt.
;            3. DeltaW dieser Verbindungen wird zunaechst auf -1 gesetzt.
;            4. Ist das Membranpotential der Target-Neuronen (Target_Cl.M(tsn))
;                groesser als die Lernamplitude, so wird DeltaW von -1
;                auf +1 gesetzt, falls es kleiner als die Entlernamplitude
;                ist, wird DeltaW von -1 auf 0 gesetzt.
;            5. Der neue Zustand der Gewichtsmatrix wird aus dem alten
;                plus DeltaW ermittelt.
;
; EXAMPLE: LearnABS, W, TARGET_CL=Layer, RATE=0.01, ALPHA=1.0, $
;                    LERNAPMLITUDE=0.8, ENTLERNAMPLITUDE=0.4, /NONSELF
;          veraendert die Matrix W entsprechend dem Zustand des
;          Clusters 'Layer', dh es werden Intra-Cluster-Verbindungen
;          gelernt, die Verbindungen der Neuronen auf sich selbst
;          bleiben aber unveraendert.
;
; REFERENCES: Artola et al., "Different voltage-dependent thresholds
;             for inducing long-term depression and long-term
;             potentiation in slices of rat visual cortex", Nature
;             347, 1990.
;
;-
;
; MODIFICATION HISTORY: 
;
; $Log$
; Revision 2.7  2000/09/26 15:13:43  thiel
;     AIMS added.
;
; Revision 2.6  1998/08/23 12:59:21  saam
;       + Delayed-Version didn't work at all -> its ok now i guess
;       + syntax change: the specificaion of a source cluster is
;                        unnecessary, because relevant informations
;                        are already available in SDW
;
; Revision 2.5  1998/03/11 11:59:24  thiel
;        Bugfix: C2T allein war undefiniert, DW.C2T tuts,
;        hoffentlich ists auch richtig.
;
; Revision 2.4  1998/02/05 13:17:40  saam
;            + Gewichte und Delays als Listen
;            + keine direkten Zugriffe auf DW-Strukturen
;            + verbesserte Handle-Handling :->
;            + vereinfachte Lernroutinen
;            + einige Tests bestanden
;
; Revision 2.3  1997/12/10 15:56:47  saam
;       Es werden jetzt keine Strukturen mehr uebergeben, sondern
;       nur noch Tags. Das hat den Vorteil, dass man mehrere
;       DelayWeigh-Strukturen in einem Array speichern kann,
;       was sonst nicht moeglich ist, da die Strukturen anonym sind.
;
; Revision 2.2  1997/11/14 16:44:55  thiel
;        Pseudo-HTML-Tags aus dem Header entfernt.
;
; Revision 2.1  1997/11/04 15:32:48  thiel
;        Ab heute fuer alle: eine einfache ABS-Lernregel.
;


PRO LearnABS, _DW, $
              TARGET_CL=Target_Cl, $
              RATE=Rate, ALPHA=Alpha, $
              LERNAMPLITUDE=Lernamplitude, ENTLERNAMPLITUDE=Entlernamplitude, $
              SELF=Self,NONSELF=NonSelf
  

   ;-----Die Prozedur muss nichts tun, wenn keine praesynaptischen Spikes vorliegen: 
   Prae = LearnAP(_DW)
   If Prae(0) EQ 0 Then Return

   Handle_Value, _DW, DW, /NO_COPY


   ; si : index to source neuron
   ; sn : to si belonging source neuron
   ; wi : weight indices belonging to neuron

   IF DW.info EQ 'SDW_WEIGHT' THEN BEGIN


      FOR si=2,Prae(0)+1 DO BEGIN
         sn = Prae(si)
         IF DW.S2C(sn) NE -1 THEN BEGIN
            Handle_Value, DW.S2C(sn), wi
            DeltaW = Make_Array(N_Elements(wi),/FLOAT,  VALUE=-1)
            Rauf = Where(Target_Cl.M(DW.C2T(wi)) GE Lernamplitude, c1)
            IF c1 NE 0 THEN DeltaW(Rauf) = 1.0
            Gleich = Where(Target_Cl.M(DW.C2T(wi)) LT Entlernamplitude, c2)
            IF c2 NE 0 THEN DeltaW(Gleich) = 0.0
            IF Set(NONSELF) THEN BEGIN
               self = WHERE(DW.C2T(wi) EQ sn, count)
               IF count NE 0 THEN deltaw(self) = 0.0
            ENDIF
            DW.W(wi) = (DW.W(wi) + Rate*deltaw) > 0.0 < Alpha
         ENDIF
      ENDFOR

   END ELSE BEGIN 
      IF DW.info EQ 'SDW_DELAY_WEIGHT' THEN BEGIN
         
         wi = Prae(2:Prae(0)+1)
         
         DeltaW = Make_Array(N_Elements(wi),/FLOAT,  VALUE=-1)
         Rauf = Where(Target_Cl.M(DW.C2T(wi)) GE Lernamplitude, c1)
         IF c1 NE 0 THEN DeltaW(Rauf) = 1.0
         Gleich = Where(Target_Cl.M(DW.C2T(wi)) LT Entlernamplitude, c2)
         IF c2 NE 0 THEN DeltaW(Gleich) = 0.0
         IF Set(NONSELF) THEN BEGIN
            self = WHERE(DW.C2T(wi) EQ DW.C2S(wi), count)
            IF count NE 0 THEN deltaw(self) = 0.0
         ENDIF
         print, 'LEARN: ',c1,'   EQUAL: ',c2, '    DELEARN: ',N_Elements(wi)-c1-c2
         DW.W(wi) = (DW.W(wi) + Rate*deltaw) >  0.0 < Alpha
      ENDIF ELSE Message, 'illegal first argument'
   END

   Handle_Value, _DW, DW, /NO_COPY, /SET

END
