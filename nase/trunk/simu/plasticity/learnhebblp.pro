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
; CATEGORY: SIMULATION
;
; CALLING SEQUENCE:  G = LearnHebbLP(G, SOURCE_CL=SourceCluste, TARGET_CL=TargetCluster, 
;                                    RATE=Rate, ALPHA=Alpha
;                                    [,/SELF | ,/NONSELF])
;
; INPUTS: G : Die bisherige Gewichtsmatrix (eine mit DelayWeigh oder InitWeights erzeugte Struktur) 
;
; OPTIONAL INPUTS:
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
; OUTPUTS: G : die geaendert Gewichtsmatrix
;
; OPTIONAL OUTPUTS: ---
;
; COMMON BLOCKS: ---
;
; SIDE EFFECTS: Die Matrix G, die als Parameter G uebergeben wird,
;               wird entsprechend der Lernregel geaendert. Zusaetzlich wird die
;               geaenderte Matrix auch als Funktionsergebnis zurueckgeliefert.
;
; RESTRICTIONS: es koennen nur Cluster aus Neuronen verarbeitet
;               werden, die mit Lernpotential ausgestattet sind, dh den Tag .P in
;               der Struktur besitzen.
;
; PROCEDURE: LayerSize()
;
; EXAMPLE: W = LearnHebbLP(W, Source_CL=Layer, Target_CL=Layer, Rate=0.01, ALPHA=1.0, /Nonself)
;          veraendert die Matrix W entsprechend dem Zustand des
;          Clusters 'Layer', dh es werden Intra-Cluster-Verbindungen
;          gelernt, die Verbindungen der Neuronen auf sich selbst
;          bleiben aber unveraendert.
;
; MODIFICATION HISTORY: 
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

FUNCTION LearnHebbLP, Matrix,SOURCE_CL=Source_CL,TARGET_CL=Target_CL,RATE=Rate,ALPHA=Alpha,SELF=Self,NONSELF=NonSelf

   spaltenindex = where(Target_CL.O,count)
   If count EQ 0 Then Return, Matrix

   spaltenzahl = Layersize(Target_CL)
   zeilenzahl = Layersize(Source_CL)

   ;-----Matrixmultiplikation ist bei wenigen Spikes langsamer...
   ;opost_diag = bytarr(spaltenzahl,spaltenzahl)
   ;opost_diag(spaltenindex,spaltenindex) = 1
   ;dw = opost_diag # (-Matrix.Weights + Alpha*(Target_CL.O#Source_CL.P))

   dw = fltarr(spaltenzahl,zeilenzahl)
   source_arr = rebin(reform(Source_CL.P,1,zeilenzahl),spaltenzahl,zeilenzahl,/sample)
   dw (spaltenindex,*) = Alpha*Source_Arr(spaltenindex,*) - Matrix.Weights(spaltenindex,*)
   
   If Set(NONSELF) Then dw(Spaltenindex,Spaltenindex)=0

   connections = WHERE(Matrix.Weights NE !NONE, count)
   IF count NE 0 THEN Matrix.Weights(connections) = Matrix.Weights(connections) + Rate*dw(connections)
   
Return, Matrix
END
