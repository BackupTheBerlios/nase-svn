;+
; NAME:                   DelayWeigh
;
; PURPOSE:                realisiert (verzoegerte) Verbindungsmatrix
;                         Matrizen-Indizierung:  G(target_neuron, source_neuron) 
;
; CATEGORY:               SIMULATION
;
; CALLING SEQUENCE:       Initialisierung ::  Matrix    = DelayWeigh( INIT_WEIGHTS=init_weights [, INIT_DELAYS=init_delays] )
;                         Aufruf          ::  OutVector = DelayWeigh( Matrix, InVector)
;
; INPUTS:                 Matrix       : eine zuvor initialisierte Struktur 
;                         InKector     : Vector mit n Elementen
;
; OPTIONAL INPUTS:        INIT_DELAYS  : Matrix der Dimension (m x n), die verbindungsspezifische Verzoegerungen enthaelt (max.15)
;
; KEYWORD PARAMETERS:     INIT_WEIGHTS : Matrix der Dimension (m x n), die den Source-Layer (n Elemente) mit dem Target-Layer (m Elemente) verbindet
;
;                         SOURCE_CL          : Source-Cluster                           ODER ALTERNATIV
;                         SOURCE_W, SOURCE_H : Breite und Hoehe des Source-Clusters    
;
;                         TARGET_CL          : Target-Cluster                           ODER ALTERNATIV
;                         TARGET_W, TARGET_H : Breite und Hoehe des Target-Clusters    
;
;                         VP, TAUP           : jeder Verbindung wird ein Lernpotential (Leckintegrator 1. Ordnung) mit Verst"arkung VP und
;                                              Zeitkonstante TAUP zugeordnet
;                                              diese Option ist nur zum Lernen verzoegerte Verbindungen SINNVOLL
;                                              wenn, dann muessen immer beide Parameter angegeben werden
;
; OUTPUTS:                wenn INIT_WEIGHTS  angegeben wurde:
;                                 Output:  die initialisierte Matrix-Struktur
;                         wurde INIT_WEIGHTS  NICHT angegeben:
;                                 Output: ein Vektor mit m Elementen, der den gewichteten (verzoegerten) Output aus der Verbindungsstruktur darstellt
;
; OPTIONAL OUTPUTS:       ---
;
; COMMON BLOCKS:          ---
;
; SIDE EFFECTS:           ---
;
; RESTRICTIONS:           Elemente von INIT_DELAYS kleiner 15
;                         InVektor enthaelt nur 0 oder 1
;
; PROCEDURE:              SpikeQueue
;
; EXAMPLE:
;                         weights = IntArr(4,12)
;                         weights(2,5) = 1.0  ; connection from 5 --> 2
;                         weights(0,6) = 2.0  ; connection from 6 --> 0
;                         delays = Make_Array(4,12,/BYTE,VALUE=3) ; each connection has a delay of 3 BINs
;
;                         MyDelMat =  DelayWeigh( INIT_WEIGHTS=weights, INIT_DELAYS=delays, SOURCE_W=4, SOURCE_H=3, TARGET_W=4, TARGET_H=1)
;
;                         InVector = [1,1,1,1,1,1,1]
;                         OutVector = DelayWeigh ( MyDelMat, InVector)
;                         print, OutVector
;
;                         FOR z=0,6 DO print, DelayWeigh( MyDelMat, [0,0,0,0,0,0,0] )
;
; MODIFICATION HISTORY:
;
;       Thu Aug 28 15:59:56 1997, Mirko Saam
;       <saam@ax1317.Physik.Uni-Marburg.DE>
;
;		wenn In kein Array ist, erzeugt rebin einen Fehler, daher nun mit [In]
;
;       Wed Aug 27 16:00:02 1997, Mirko Saam
;       <saam@ax1317.Physik.Uni-Marburg.DE>
;
;		nicht verzoegerte, nicht vorhandene Verbindungen werden jetzt hoffentlich korrekt behandelt
;               keine Matrixmultiplikation mehr, sondern Behandlung wie bei verzoegerten Verbindungen
;
;       Mon Aug 18 16:56:33 1997, Mirko Saam
;       <saam@ax1317.Physik.Uni-Marburg.DE>
;
;		nicht vorhandene Verbindungen werden korrekt bearbeitet 
;
;       Thu Aug 14 15:01:16 1997, Mirko Saam
;       <saam@ax1317.Physik.Uni-Marburg.DE>
;
;               Anpassung an ver"anderten SpikeQueue-Aufruf
;               Löschen der Initialisierung, die nun von InitDW uebernommen wird
;               Einige Optimierungen
;
;                         initial version, Mirko Saam, 24.7.97
;                         Ergaenzung der zentralen Struktur um Breite und Hoehe der Source- und Target-Cluster, 25.7.97 
;                         automatischer cast von INIT_WEIGHTS auf DOUBLE, Mirko Saam, 1.8.97
;                         Fehlermeldung, wenn delays zu gross, Mirko, 3.8.97
;                         jeder verzoegerten Verbindung kann ein Lernpotential zugeordnet werden, Mirko, 4.8.97
;                         IDL-bug bei Array-Zuweisung umgangen, Mirko, 4.8.97
;                         Delays werden im nicht-Delay-Fall mit [-1,-1] initialisiert. Das ist ebenfalls wegen des Array/Skalar-Bugs, dem auch Mirko schon begegnet war. Rüdiger, 5.8.1997
;                         Initialisierung der Struktur Matrix nun bei jedem Zeitschritt, damit Gewichte die vorher Null
;                         waren im foldenden auch wirksam sind, Mirko, 5.8.97
;
;-
FUNCTION DelayWeigh, DelMat, In
   
   
   IF (N_Elements(In) NE (Size(DelMat.Weights))(2))  AND ((Size(DelMat.Weights))(0) EQ 2) THEN Message, 'input incompatible with definition of matrix' 
   
   IF (DelMat.Delays(0) EQ -1) THEN BEGIN

;      alte Variante, ohne nocon !!!!!!!!!!
;      IF (SIZE(In))(0) EQ 0 THEN In = make_array(1, /BYTE, VALUE=In) 
;      RETURN, DelMat.Weights # In 
      
      
      spikes = Transpose(REBIN([In], (SIZE(DelMat.Weights))(2), (SIZE(DelMat.Weights))(1), /SAMPLE))
                                ; no direct call of SpikeQueue with DelMat.Queue possible because it's passed by value then !!
                                ; SpikeQueue returns 1dim array but it is automatically reformed to the dimension of DelMat.weights
      
      res = FltArr(DelMat.target_w*DelMat.target_h, DelMat.source_w*DelMat.source_h)
      active = WHERE(spikes NE 0, count) 
      IF (count NE 0) THEN res(active) = DelMat.weights(active) ;* spikes(active)
      
      noweights = WHERE(res LE !NONE, count)
      IF count NE 0 THEN res(noweights) = 0
      
      IF (SIZE(res))(0) EQ 2 THEN RETURN, TOTAL(res, 2) ELSE RETURN, TOTAL(res)
      
      
   END ELSE BEGIN
      
      tmp = Transpose(REBIN([In], (SIZE(DelMat.Delays))(2), (SIZE(DelMat.Delays))(1), /SAMPLE))
                                ; no direct call of SpikeQueue with DelMat.Queue possible because it's passed by value then !!
                                ; SpikeQueue returns 1dim array but it is automatically reformed to the dimension of DelMat.weights
      tmpQU = DelMat.Queue
      spikes = SpikeQueue( tmpQu, tmp )
      DelMat.Queue = tmpQu
      
      res = FltArr(DelMat.target_w*DelMat.target_h, DelMat.source_w*DelMat.source_h)
      active = WHERE(spikes NE 0, count) 
      IF (count NE 0) THEN res(active) = DelMat.weights(active) ;* spikes(active)

      noweights = WHERE(res LE !NONE, count)
      IF count NE 0 THEN res(noweights) = 0

      
                                ; update the learning potential if needed
      IF (SIZE(DelMat.lp))(0) NE 0 THEN BEGIN
         DelMat.lp =  ((DelMat.lp - delmat.dp) > 0) + DelMat.vp*spikes
      END

      IF (SIZE(res))(0) EQ 2 THEN RETURN, TOTAL(res, 2) ELSE RETURN, TOTAL(res)

   END   
END   
