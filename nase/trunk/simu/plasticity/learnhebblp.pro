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
;          
;
; CATEGORY: SIMULATION
;
; CALLING SEQUENCE:     LearnHebbLP, G, LP, SOURCE_CL=SourceCluste, TARGET_CL=TargetCluster, 
;                                    RATE=Rate, ALPHA=Alpha
;                                    [,/SELF | ,/NONSELF]
;
; INPUTS: G  : Die bisherige Gewichtsmatrix (eine mit DelayWeigh oder InitWeights erzeugte Struktur) 
;         LP : Eine mit InitDW initialisierte Lernpotential-Struktur
;
; KEYWORD PARAMETERS: SOURCE_CL/TARGET_CL : Je ein Cluster bestehend aus
;                                           Neuronen, die ein Lernpotential besitzen. (z.B. Typ 3)
;                     RATE                : die Lernrate
;                     ALPHA               : Parameter, der den Grenzwert
;                                           beeinflusst, gegen den die
;                                           Gewichte konvergieren.
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
; EXAMPLE: LearnHebbLP, W, LP, Source_CL=Layer, Target_CL=Layer, Rate=0.01, ALPHA=1.0, /Nonself
;          veraendert die Matrix W entsprechend dem Zustand des
;          Clusters 'Layer', dh es werden Intra-Cluster-Verbindungen
;          gelernt, die Verbindungen der Neuronen auf sich selbst
;          bleiben aber unveraendert.
;
; MODIFICATION HISTORY: 
;
;       Thu Sep 4 17:03:51 1997, Mirko Saam
;       <saam@ax1317.Physik.Uni-Marburg.DE>
;
;		Fktioniert nun auch mit verzoegerten Verbindungen
;               Lernpotentiale nun nicht mehr in den Neuronen sondern in separater
;                  Struktur
;
;       Wed Sep 3 15:50:04 1997, Ruediger Kupper
;       <kupper@sisko.physik.uni-marburg.de>
;
;		Ist jetzt eine Prozedur und keine Funktion mehr. (Ab
;		Rev. 1.5)
;
;       Mon Aug 18 16:44:07 1997, Mirko Saam
;<saam@ax1317.Physik.Uni-Marburg.DE>
;
;             Behandlung von nicht vorhandenen Verbindungen
;
;
;
;		 erste Version vom 30 Juli
;                '97. Andreas.  neue Keyword-Abfrage und
;                Geschwindigkeitsoptimierung. 5. August '97. Andreas.  -
;-

PRO LearnHebbLP, Matrix, LP, SOURCE_CL=Source_CL,TARGET_CL=Target_CL,RATE=Rate,ALPHA=Alpha,SELF=Self,NONSELF=NonSelf


   ; update learning potentials
   TotalRecall, LP, Matrix.Learn

   spaltenindex = where(Target_CL.O,count)
   If count EQ 0 Then Return

   spaltenzahl = Layersize(Target_CL)
   zeilenzahl = Layersize(Source_CL)

   ;-----Matrixmultiplikation ist bei wenigen Spikes langsamer...
   ;opost_diag = bytarr(spaltenzahl,spaltenzahl)
   ;opost_diag(spaltenindex,spaltenindex) = 1
   ;dw = opost_diag # (-Matrix.Weights + Alpha*(Target_CL.O#Source_CL.P))

   dw = fltarr(spaltenzahl,zeilenzahl)

   IF Matrix.info EQ 'DW_WEIGHT' THEN BEGIN
      source_arr = rebin(reform(LP.values,1,zeilenzahl),spaltenzahl,zeilenzahl,/sample)
      dw (spaltenindex,*) = Alpha*Source_Arr(spaltenindex,*) - Matrix.Weights(spaltenindex,*)
   END ELSE BEGIN 
      IF Matrix.info EQ 'DW_DELAY_WEIGHT' THEN BEGIN
         dw (spaltenindex,*) = Alpha*LP.values(spaltenindex,*) - Matrix.Weights(spaltenindex,*)
      END ELSE Message, 'illegal first argument'
   END

   If Set(NONSELF) Then dw(Spaltenindex,Spaltenindex)=0

   connections = WHERE(Matrix.Weights NE !NONE, count)
   IF count NE 0 THEN Matrix.Weights(connections) = Matrix.Weights(connections) + Rate*dw(connections)
   
END
