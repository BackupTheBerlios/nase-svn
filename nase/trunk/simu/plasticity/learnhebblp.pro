;+
; NAME:
;  LearnHebbLP
;
; AIM: Learn coupling strengths according to Hebb rule with learning potential.
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
; CATEGORY:
;  Simulation / Plasticity
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
;-
;
; MODIFICATION HISTORY: 
;
;       $Log$
;       Revision 1.22  2000/09/26 15:13:43  thiel
;           AIMS added.
;
;       Revision 1.21  1998/11/09 10:58:53  saam
;             adapted to new layer type
;
;       Revision 1.20  1998/11/08 17:52:41  saam
;             changed to new layer type
;
;       Revision 1.19  1998/05/12 10:25:33  thiel
;              Bugfix im Delay-Teil, da fehlte ein DW.
;
;       Revision 1.18  1998/02/11 17:57:10  thiel
;              Benutzt nicht mehr die Info()-Funktion, sondern
;              den .info-Tag, geht schneller.
;
;       Revision 1.17  1998/02/05 13:17:41  saam
;                  + Gewichte und Delays als Listen
;                  + keine direkten Zugriffe auf DW-Strukturen
;                  + verbesserte Handle-Handling :->
;                  + vereinfachte Lernroutinen
;                  + einige Tests bestanden
;
;       Revision 1.16  1997/12/11 14:07:57  saam
;             Bug bei Handles korrigiert
;
;       Revision 1.15  1997/12/10 15:56:48  saam
;             Es werden jetzt keine Strukturen mehr uebergeben, sondern
;             nur noch Tags. Das hat den Vorteil, dass man mehrere
;             DelayWeigh-Strukturen in einem Array speichern kann,
;             was sonst nicht moeglich ist, da die Strukturen anonym sind.
;
;       Revision 1.14  1997/11/03 17:33:46  saam
;             Variable st war etwas sinnentleert -> rausgeworfen
;
;       Revision 1.13  1997/10/03 14:09:03  kupper
;       Schreibfehler in "Lerrate" korrigiert!
;
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
;       erste Version vom 30 Juli '97. Andreas.  
;       neue Keyword-Abfrage und
;       Geschwindigkeitsoptimierung. 5. August '97. Andreas.

PRO LearnHebbLP, _DW, LP, TARGET_CL=Target_CL,RATE=Rate,ALPHA=Alpha,SELF=Self,NONSELF=NonSelf, $
                    LERNRATE=lernrate, ENTLERNRATE=entlernrate
  

   If Not Set(RATE) Then Rate = Entlernrate
   If Not Set(ALPHA) Then Alpha = Lernrate/Entlernrate
 
   Handle_Value, LayerOut(Target_CL), Post
   If Post(0) EQ 0 Then Return

   Handle_Value, _DW, DW, /NO_COPY

   ; ti : index to target neuron
   ; tn : to ti belonging target neuron
   ; wi : weight indices belonging to neuron
   IF DW.info EQ 'SDW_WEIGHT' THEN BEGIN

      FOR ti=2,Post(0)+1 DO BEGIN
         tn = Post(ti)
         IF DW.T2C(tn) NE -1 THEN BEGIN
            Handle_Value, DW.T2C(tn), wi
            deltaw = Alpha*(GetRecall(LP))(DW.C2S(wi)) - DW.W(wi)
            IF Set(NONSELF) THEN BEGIN
               self = WHERE(DW.C2S(wi) EQ tn, count)
               IF count NE 0 THEN deltaw(self) = 0.0
            ENDIF
            DW.W(wi) = DW.W(wi) + Rate*deltaw
         ENDIF
      ENDFOR

   END ELSE BEGIN 
      IF DW.Info EQ 'SDW_DELAY_WEIGHT' THEN BEGIN
         
         FOR ti=2,Post(0)+1 DO BEGIN
            tn = Post(ti)
            IF DW.T2C(tn) NE -1 THEN BEGIN
               Handle_Value, DW.T2C(tn), wi
               deltaw = Alpha*(GetRecall(LP))(wi) - DW.W(wi)
               IF Set(NONSELF) THEN BEGIN
                  self = WHERE(DW.C2S(wi) EQ tn, count)
                  IF count NE 0 THEN deltaw(self) = 0.0
               ENDIF
               DW.W(wi) = DW.W(wi) + Rate*deltaw
            ENDIF
         ENDFOR
         
      END ELSE Message, 'illegal first argument'
   END

   Handle_Value, _DW, DW, /NO_COPY, /SET

END
