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
; MODIFICATION HISTORY:   initial version, Mirko Saam, 24.7.97
;                         Ergaenzung der zentralen Struktur um Breite und Hoehe der Source- und Target-Cluster, 25.7.97 
;                         automatischer cast von INIT_WEIGHTS auf DOUBLE, Mirko Saam, 1.8.97
;                         Fehlermeldung, wenn delays zu gross, Mirko, 3.8.97
;                         jeder verzoegerten Verbindung kann ein Lernpotential zugeordnet werden, Mirko, 4.8.97
;                         IDL-bug bei Array-Zuweisung umgangen, Mirko, 4.8.97
;                         Delays werden im nicht-Delay-Fall mit [-1,-1] initialisiert. Das ist ebenfalls wegen des Array/Skalar-Bugs, dem auch Mirko schon begegnet war. Rüdiger, 5.8.1997
;                         Initialisierung der Struktur Matrix nun bei jedem Zeitschritt, damit Gewichte die vorher Null
;                         waren im foldenden auch wirksam sind, Mirko, 5.8.97
;-
FUNCTION DelayWeigh, DelMat, In, INIT_WEIGHTS=init_weights, INIT_DELAYS=init_delays,$
                     SOURCE_CL=source_cl, TARGET_CL=target_cl,$ 
                     SOURCE_W=source_w, SOURCE_H=source_h,$
                     TARGET_W=target_w, TARGET_H=target_h,$
                     TAUP=taup, VP=vp
   
   
   IF N_Elements(init_weights) NE 0 THEN BEGIN
      
      IF N_Elements(source_cl) NE 0 THEN BEGIN
         source_w = source_cl.w
         source_h = source_cl.h
      END
      IF N_Elements(target_cl) NE 0 THEN BEGIN
         target_w = target_cl.w
         target_h = target_cl.h
      END
      
      ; if no delay matrix as parameter than Delay in DelMat equals -1 and Queue is undefined
      IF N_Elements(init_delays) EQ 0 THEN BEGIN
         DelMat = {source_w: source_w,$
                   source_h: source_h,$
                   target_w: target_w,$
                   target_h: target_h,$
                   Weights : DOUBLE(init_weights) ,$
                   Delays  : [-1, -1]          }
      END ELSE BEGIN         
         IF Max(init_delays) GE 15 THEN Message, 'sorry, delays are too big'
         IF (Keyword_Set(taup) AND Set(vp)) THEN BEGIN
            lp = FltArr( (SIZE(init_weights))(1), (SIZE(init_weights))(2) )
         END ELSE BEGIN
            lp = -1
         END
         DelMat = { source_w: source_w,$
                    source_h: source_h,$
                    target_w: target_w,$
                    target_h: target_h,$
                    Weights : DOUBLE(init_weights) ,$
                    Matrix  : BytArr( (SIZE(init_weights))(1), (SIZE(init_weights))(2) ) ,$
                    Delays  : init_delays  ,$
                    Queue   : SpikeQueue( INIT_DELAYS=REFORM(init_delays, N_Elements(init_delays)) ),$
                    VP      : FLOAT(vp),$
                    DP      : exp(-1.0/FLOAT(taup)),$
                    LP      : lp}
      END
      RETURN, DelMat
      
   END
   
   IF N_Elements(init_delays) NE 0                 THEN Message, 'initializing without a weight matrix'
   IF (N_Elements(In) NE (Size(DelMat.Weights))(2))  AND ((Size(DelMat.Weights))(0) EQ 2) THEN Message, 'input incompatible with definition of matrix' 
   
   IF (DelMat.Delays(0) EQ -1) THEN BEGIN
      IF (SIZE(In))(0) EQ 0 THEN In = make_array(1, /BYTE, VALUE=In) 
      RETURN, DelMat.Weights # In 
   END ELSE BEGIN
     IF (count NE 0) THEN BEGIN
         DelMat.Matrix( WHERE (DelMat.Weights NE 0.0) ) =  1
      END ELSE BEGIN
         DelMat.Matrix = 0  ; geht nur, weil Matrix in Struktur steht; sonst waere Matrix keine Matrix mehr
      END
      tmp = DelMat.Matrix AND Transpose(REBIN(In, (SIZE(DelMat.Delays))(2), (SIZE(DelMat.Delays))(1), /SAMPLE))
      tmp = REFORM(tmp, N_Elements(tmp))
      
      ; no direct call of SpikeQueue with DelMat.Queue possible because it's passed by value then !!
      tmpQU = DelMat.Queue
      ; SpikeQueue returns 1dim array but it is automatically reformed to the dimension of DelMat.weights
      spikes = SpikeQueue( tmpQu, tmp )
      res = DelMat.weights * spikes
      DelMat.Queue = tmpQu
      
      ; update the learning potential if needed
      IF (SIZE(DelMat.lp))(0) NE 0 THEN BEGIN
         DelMat.lp =  (DelMat.lp*delmat.dp) + DelMat.vp*spikes
         print, DelMat.lp(5,5)
      END
      RETURN, TOTAL(res, 2)
   END   
END   



