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
; CALLING SEQUENCE:   LearnHebbSharp, G, SOURCE_CL=SourceCluste, TARGET_CL=TargetCluster, 
;                                    { (RATE=Rate, ALPHA=Alpha)  |  (LERNRATE=lernrate, ENTLERNRATE=entlernrate) }
;                                    [,/SELF | ,/NONSELF]
;
; INPUTS: G : Die bisherige Gewichtsmatrix (eine mit DelayWeigh oder InitWeights erzeugte Struktur) 
;
; OPTIONAL INPUTS:
;
; KEYWORD PARAMETERS: SOURCE_CL/TARGET_CL : Je ein Cluster bestehend aus beliebigen Neuronen
;
;                     RATE                : die Lernrate
;                     ALPHA               : der Grenzwert, gegen den die
;                                           Gewichte konvergieren.
;        alternativ:  LERNRATE            : die Rate, mit der bei korrelierter Aktivit�t gelernt wird
;                     ENTLERNRATE         :       "   "    "   "  unkorrelierter    "     entlernt  "
;
;                     SELF                : Verbindungen zwischen Neuronen mit gleichen Index 
;                                           werden gelernt. Dies ist die Default-Einstellung,  
;                                           /SELF muss also nicht angegeben werden
;                     NONSELF             : Verbindungen zwischen Neuronen mit gleichem Index
;                                           werden nicht veraendert,
;                                           aber auch nicht Null-gesetzt.
;                                           (Siehe InitDW)
; SIDE EFFECTS: Die Matrix G, die als Parameter G uebergeben wird,
;               wird entsprechend der Lernregel geaendert.
;
; PROCEDURE: LayerSize()
;
; EXAMPLE: LearnHebbSharp, W, Source_CL=Layer, Target_CL=Layer, Rate=0.01, ALPHA=1.0, /Nonself
;          veraendert die Matrix W entsprechend dem Zustand des
;          Clusters 'Layer', dh es werden Intra-Cluster-Verbindungen
;          gelernt, die Verbindungen der Neuronen auf sich selbst
;          bleiben aber unveraendert.
;
; MODIFICATION HISTORY: 
;
;       Sun Sep 7 16:10:55 1997, Ruediger Kupper
;       <kupper@sisko.physik.uni-marburg.de>
;
;		LERNRATE, ENTLERNRATE zugef�gt.
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

PRO LearnHebbSharp, Matrix,SOURCE_CL=Source_CL,TARGET_CL=Target_CL,RATE=Rate,ALPHA=Alpha,SELF=Self,NONSELF=NonSelf, $
                        LERNRATE=lernrate, ENTLERNRATE=entlernrate

   Default, rate, entlernrate
   Default, alpha, lernrate/entlernrate

   spaltenindex = where(Target_CL.O,count)
   If count EQ 0 Then Return, Matrix

   spaltenzahl = Layersize(Target_CL)
   zeilenzahl = Layersize(Source_CL)

   ;-----Matrixmultiplikation ist bei wenigen Spikes langsamer...
   ;opost_diag = bytarr(spaltenzahl,spaltenzahl)
   ;opost_diag(spaltenindex,spaltenindex) = 1
   ;dw = opost_diag # (-Matrix.Weights + Alpha*(Target_CL.O#Source_CL.P))

   dw = fltarr(spaltenzahl,zeilenzahl)
   source_arr = rebin(reform(Source_CL.O,1,zeilenzahl),spaltenzahl,zeilenzahl,/sample)
   dw (spaltenindex,*) = Alpha*Source_Arr(spaltenindex,*) - Matrix.Weights(spaltenindex,*)
   
   If Set(NONSELF) Then dw(Spaltenindex,Spaltenindex)=0

   connections = WHERE(Matrix.Weights NE !NONE, count)
   IF count NE 0 THEN Matrix.Weights(connections) = Matrix.Weights(connections) + Rate*dw(connections)
   
END


