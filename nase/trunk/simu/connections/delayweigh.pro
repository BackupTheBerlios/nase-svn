;+
; NAME:                   DelayWeigh
;
; PURPOSE:                realisiert (verzoegerte) Verbindungsmatrix
;                         Matrizen-Indizierung:  G(target_neuron, source_neuron) 
;
; CATEGORY:               SIMULATION
;
; CALLING SEQUENCE:       OutVector = DelayWeigh( Matrix, InVector)
;
; INPUTS:                 Matrix       : eine zuvor initialisierte Struktur 
;                         InVector     : Vector mit n Elementen
;
; OPTIONAL INPUTS:        ---
;
; KEYWORD PARAMETERS:     ---
;
; OUTPUTS:                OutVector: ein Vektor mit m Elementen, der den gewichteten (verzoegerten) Output aus der Verbindungsstruktur darstellt
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
;                         MyDelMat = InitDW(S_WIDTH=2, T_HEIGHT=2, T_WIDTH=6, T_HEIGHT=2, $
;                                           WEIGHT=3.0,$
;                                           D_CONST=[4,2])
;
;                         InVector = [1,1,1,1,1,1,1]
;                         OutVector = DelayWeigh ( MyDelMat, InVector)
;                         print, OutVector
;
;                         FOR z=0,6 DO print, DelayWeigh( MyDelMat, [0,0,0,0,0,0,0] )
;
; MODIFICATION HISTORY:
;
;       Thu Sep 4 17:08:54 1997, Mirko Saam
;       <saam@ax1317.Physik.Uni-Marburg.DE>
;
;		Es gibt nun einen learn-tag, der
;                 a) bei unverzoegerten Verbindungen: die Aktivitaet des praesynaptischen Layers
;                 b) bei verzoegerten Verbindungen: das Ergebis der SpikeQueue
;               enthaelt. Die ist f"ur Update des Lernpotentials notwendig.
;
;       Wed Sep 3 11:35:20 1997, Mirko Saam
;       <saam@ax1317.Physik.Uni-Marburg.DE>
;
;		Header war super-veraltet, muesste jetzt wieder stimmen
;
;
;       Mon Sep 1 13:13:27 1997, Andreas Thiel
;		Geschwindigkeit des Teils ohne Delays wurde erhoeht.
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
;               L�schen der Initialisierung, die nun von InitDW uebernommen wird
;               Einige Optimierungen
;
;                         initial version, Mirko Saam, 24.7.97
;                         Ergaenzung der zentralen Struktur um Breite und Hoehe der Source- und Target-Cluster, 25.7.97 
;                         automatischer cast von INIT_WEIGHTS auf DOUBLE, Mirko Saam, 1.8.97
;                         Fehlermeldung, wenn delays zu gross, Mirko, 3.8.97
;                         jeder verzoegerten Verbindung kann ein Lernpotential zugeordnet werden, Mirko, 4.8.97
;                         IDL-bug bei Array-Zuweisung umgangen, Mirko, 4.8.97
;                         Delays werden im nicht-Delay-Fall mit [-1,-1] initialisiert. Das ist ebenfalls wegen des Array/Skalar-Bugs, dem auch Mirko schon begegnet war. R�diger, 5.8.1997
;                         Initialisierung der Struktur Matrix nun bei jedem Zeitschritt, damit Gewichte die vorher Null
;                         waren im foldenden auch wirksam sind, Mirko, 5.8.97
;
;-
FUNCTION DelayWeigh, DelMat, In
   
   
   IF (N_Elements(In) NE (Size(DelMat.Weights))(2))  AND ((Size(DelMat.Weights))(0) EQ 2) THEN Message, 'input incompatible with definition of matrix' 
   
;----- Der Teil ohne Delays:   
   IF (DelMat.Delays(0) EQ -1) THEN BEGIN

;      ganz alte Variante, ohne nocon !!!!!!!!!!
;      IF (SIZE(In))(0) EQ 0 THEN In = make_array(1, /BYTE, VALUE=In) 
;      RETURN, DelMat.Weights # In 


      DelMat.Learn = In ; Learning with Potentials needs this information

      count = 0
      active = where(In NE 0, count)
      If count EQ 0 Then Return, FltArr(DeLMat.target_w*DelMat.Target_h)
                                ;aus der Funktion rausspringen, wenn
                                ;ohnehin keine Aktivitaet im Input vorliegt:

      new = DelMat.Weights(*,active)
                                ;in new stehen nur noch die Zeilen der
                                ;Gewichtsmatrix, die ueberhaupt
                                ;addiert werden muessen
      count=0
      noneindex = where(new EQ !NONE, count)
      If count NE 0 Then new(noneindex) = 0
                                ; !NONEs werden auf Null gesezt, damit
                                ; sie bei der Addition nicht stoeren

      IF (SIZE(new))(0) EQ 2 THEN RETURN, TOTAL(new, 2) ELSE RETURN, new
                                ;entweder wird ueber die Zeilen
                                ;summiert, oder, falls es nur eine
                                ;Zeile gibt, die zurueckgegeben

  

    
;----- Der Teil mit Delays:      
   END ELSE BEGIN
      
      tmp = Transpose(REBIN([In], (SIZE(DelMat.Delays))(2), (SIZE(DelMat.Delays))(1), /SAMPLE))
                                ; no direct call of SpikeQueue with DelMat.Queue possible because it's passed by value then !!
                                ; SpikeQueue returns 1dim array but it is automatically reformed to the dimension of DelMat.weights
      tmpQU = DelMat.Queue
      DelMat.Learn = SpikeQueue( tmpQu, tmp )
      DelMat.Queue = tmpQu
      
      res = FltArr(DelMat.target_w*DelMat.target_h, DelMat.source_w*DelMat.source_h)
      active = WHERE(DelMat.learn NE 0, count) 
      IF (count NE 0) THEN res(active) = DelMat.weights(active) ;* spikes(active)

      noweights = WHERE(res LE !NONE, count)
      IF count NE 0 THEN res(noweights) = 0

      IF (SIZE(res))(0) EQ 2 THEN RETURN, TOTAL(res, 2) ELSE RETURN, TOTAL(res)

   END   
END   
