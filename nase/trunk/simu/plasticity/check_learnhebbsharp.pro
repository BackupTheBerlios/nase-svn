;+
; NAME: Check_LearnHebbSharp
;
; PURPOSE: Routine zum Testen des LearnHebbSharp-Funktionsaufrufs mit
;          ausfuehrlicher Fehlerbehandlung 
;
; CATEGORY: SIMULATION
;
; CALLING SEQUENCE:  Check_LearnHebbSharp(G, SOURCE_CL=SourceCluste, TARGET_CL=TargetCluster, 
;                                    RATE=Rate, ALPHA=Alpha
;                                    [,/SELF | ,/NONSELF]
;
; INPUTS: G : Die bisherige Gewichtsmatrix (eine mit DelayWeigh oder InitWeights erzeugte Struktur) 
;
; OPTIONAL INPUTS:
;
; KEYWORD PARAMETERS: SOURCE_CL/TARGET_CL : Je ein Cluster bestehend aus
;                                           Neuronen, die ein Lernpotential besitzen. (z.B. Typ 3)
;                     RATE                : die Lernrate
;                     ALPHA               : der Grenzwert, gegen den die
;                                           Gewichte konvergieren.
;                     SELF                : Verbindungen zwischen Neuronen mit gleichen Index 
;                                           werden gelernt. Dies ist die Default-Einstellung,  
;                                           /SELF muss also nicht angegeben werden
;                     NONSELF             : Verbindungen zwischen Neuronen mit gleichem Index
;                                           werden nicht veraendert,
;                                           aber auch nicht Null-gesetzt.
;                                           (Siehe InitDW)
; OUTPUTS: Eine kurze Beschreibung der Wirkungsweise der Funktion bei
;          den angegebenen Parametern
;
; OPTIONAL OUTPUTS: ---
;
; COMMON BLOCKS: ---
;
; SIDE EFFECTS: Die Matrix G, die als Parameter G uebergeben wird,
;               wird entsprechend der Lernregel geaendert. Zusaetzlich wird die
;               geaenderte Matrix auch als Funktionsergebnis zurueckgeliefert.
;
; RESTRICTIONS: ---
;
; PROCEDURE: LayerSize()
;
; EXAMPLE: Check_LearnHebbSharp, W, Source_CL=Layer, Target_CL=Layer, Rate=0.01, ALPHA=1.0, /Nonself
;          veraendert die Matrix W entsprechend dem Zustand des
;          Clusters 'Layer', dh es werden Intra-Cluster-Verbindungen
;          gelernt, die Verbindungen der Neuronen auf sich selbst
;          bleiben aber unveraendert.
;
; MODIFICATION HISTORY: 
;
;       Wed Sep 3 16:15:37 1997, Ruediger Kupper
;       <kupper@sisko.physik.uni-marburg.de>
;
;		Ab Rev. 1.3 ist diese Funktion eine Prozedur.
;
;       Mon Aug 18 16:44:07 1997, Mirko Saam
;<saam@ax1317.Physik.Uni-Marburg.DE>
;
;             Behandlung von nicht vorhandenen Verbindungen
;
;
;
;        erste Version vom 5. August '97. Andreas.
;
;-

Pro Check_LearnHebbSharp, Matrix,SOURCE_CL=Source_CL,TARGET_CL=Target_CL,RATE=Rate,ALPHA=Alpha,SELF=Self,NONSELF=NonSelf

   spaltenzahl = Layersize(Target_CL)
   zeilenzahl = Layersize(Source_CL)

   If Set(SELF) AND Set(NONSELF) Then Message, 'Die Schluesselworte SELF und NONSELF duerfen nicht beide gleichzeitig angegeben werden.'
   If Set(NONSELF) AND (spaltenzahl NE Zeilenzahl) Then Message, 'Ist NONSELF angegeben, muessen Source- und Target-Cluster gleich gross sein.'

   Print
   Print, 'Soweit scheint alles in Ordnung.'
   Print, 'Lernregel: strikter Hebb mit Decay-Term.'
   Print, 'Es werden Verbindungen zwischen einem Source-Cluster der Groesse ',Zeilenzahl
   Print, 'und einem Target-Cluster der Groesse ',Spaltenzahl, ' gelernt.'
   Print, 'Lernrate: ',Rate
   Print, 'Grenzwertparameter: ',Alpha
   If Set(NONSELF) Then Print, 'Verbindungen zwischen Neuronen mit gleichem Index werden NICHT veraendert. (Keine Rueckkopplung)' $
      Else Print, 'Verbindungen zwischen Neuronen mit gleichem Index werden mitgelernt. (Rueckkopplung bei identischem Source- und Target-Cluster)'

   Print
   Print, 'Drueck ne Taste!'
   Taste = Get_KBRD (1)


   spaltenindex = where(Target_CL.O,count)
   If count EQ 0 Then Return, Matrix


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

END


