;+
; NAME:                   DelayWeigh
;
; PURPOSE:                realisiert (verzoegerte) Verbindungsmatrix
;                         Matrizen-Indizierung:  G(target_neuron, source_neuron) 
;
; CATEGORY:               SIMULATION
;
; CALLING SEQUENCE:       OutVector = DelayWeigh( Matrix, InHandle)
;
; INPUTS:                 Matrix       : eine zuvor mit InitDW initialisierte Struktur 
;                         InHandle     : Handle auf eine SSparse-Liste, i.a Layer.O
;
; OUTPUTS:                OutVector: Sparse-Vektor, der den gewichteten (verzoegerten) Output aus der Verbindungsstruktur darstellt
;
; RESTRICTIONS:           Elemente von INIT_DELAYS kleiner 15
;                         InVektor enthaelt nur 0 oder 1
;
; PROCEDURE:              SpikeQueue
;
; EXAMPLE:
;                         MyDelMat = InitDW(S_WIDTH=2, T_HEIGHT=2, T_WIDTH=6, T_HEIGHT=2, $
;                                           WEIGHT=3.0,$
;                                           D_CONST=[4,2])
;
;                         InHandle = Handle_Create(SSpassmacher([1,1,1,1,1,1,1]))
;                         OutVector = DelayWeigh ( MyDelMat, InHandle)
;                         print, SpassBeiseite(OutVector)
;
;                         FOR z=0,6 DO print, SpassBeiseite(DelayWeigh( MyDelMat, Create_Handle(Spassmacher([0,0,0,0,0,0,0])) ))
;
; MODIFICATION HISTORY:
;
;       $Log$
;       Revision 1.26  1997/11/12 09:46:11  saam
;             Inkompatibilitaet mit IDL5 korrigiert
;
;       Revision 1.25  1997/09/20 09:52:43  thiel
;              Da war noch ein 'Norm2Spass'-Aufruf von ganz frueher
;              uebrig, am Ende des Delay-Teils.
;              Wurde in 'Spassmacher' umbenannt.
;
;       Revision 1.24  1997/09/19 16:35:20  thiel
;              Umfangreiche Umbenennung: von spass2vector nach SpassBeiseite
;                                        von vector2spass nach Spassmacher
;
;       Revision 1.23  1997/09/17 10:25:47  saam
;       Listen&Listen in den Trunk gemerged
;
;       Revision 1.22.2.9  1997/09/12 11:17:55  saam
;            noch mehr Spass angepasst
;
;       Revision 1.22.2.8  1997/09/12 11:15:10  saam
;            Anpassung an neubenannte Spass-Routinen
;
;
;       Thu Sep 11 18:58:58 1997, Mirko Saam
;       <saam@ax1317.Physik.Uni-Marburg.DE>
;       Revision: 1.22.2.7 
;
;		Verzoegerter Teil funktioniert auch
;               Input ist nun ein Handle auf einer SSparse-Liste               
;
;       Mon Sep 8 11:50:06 1997, Mirko Saam
;       <saam@ax1317.Physik.Uni-Marburg.DE>
;
;		Unverzoegerter Teil funktioniert
;
;       Fri Sep 6 16:49:22 1997, Mirko Saam
;       <saam@ax1317.Physik.Uni-Marburg.DE>
;
;		Beginn der Umstellung auf Sparse-Matrixzen und Vektoren
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
FUNCTION DelayWeigh, DelMat, InHandle
   
   
Handle_Value, InHandle, In

;----- Der Teil ohne Delays:   
   IF (DelMat.info EQ 'DW_WEIGHT') THEN BEGIN


      IF Handle_Info(DelMat.Learn) THEN Handle_Value, DelMat.Learn, In, /SET $
      ELSE  DelMat.Learn = Handle_Create(VALUE=In)

      IF In(0) EQ 0 THEN BEGIN
         result = FltArr(2,1)
         result(1,0) = DeLMat.target_w*DelMat.Target_h
         Return, result
                                ;aus der Funktion rausspringen, wenn
                                ;ohnehin keine Aktivitaet im Input vorliegt:
      END

      
      ; asi : active source index
      ; asn : active source neuron
      ; tn  : target neurons
      vector = FltArr(DeLMat.target_w*DelMat.Target_h)

      FOR asi=2,In(0)+1 DO BEGIN
         asn = In(asi)
         IF DelMat.STarget(asn) NE -1 THEN BEGIN
            Handle_Value, DelMat.STarget(asn), tn
            vector(tn) = vector(tn) + DelMat.Weights( tn, asn )
         END
      END
      
      RETURN, Spassmacher(vector)
      
      
      
      
;----- Der Teil mit Delays:      
   END ELSE BEGIN
      
      ; acili: active connection index list IN
      ; acilo: active connection index list OUT
      ; asi  : active source index
      ; asn  : active source neuron
      ; atn  : active target neurons
      ; snc  : total number of source neurons 
      ; tnc  : total number of target neurons 
      snc = LONG(DelMat.source_w*DelMat.target_h)
      tnc = LONG(DelMat.target_w*DelMat.target_h)

      acili_empty = 1 ;TRUE

      FOR asi= 2, In(0)+1 DO BEGIN
         asn = In(asi)
         IF DelMat.STarget(asn) NE -1 THEN BEGIN
            Handle_Value, DelMat.STarget(In(asi)), atn            
            aci = asn*tnc + atn
            IF NOT acili_empty THEN BEGIN
               acili = [acili, aci] 
            END ELSE BEGIN
               acili = aci
               acili_empty = 0
            END
         END
      END

      
      IF NOT acili_empty THEN BEGIN
         acili = [n_elements(acili), snc*tnc, acili]
      END ELSE BEGIN
         acili = [0, snc*tnc]
      END

      tmpQU = DelMat.Queue
      acilo = SpikeQueue( tmpQu, acili ) 
      DelMat.Queue = tmpQu

      IF Handle_Info(DelMat.Learn) THEN Handle_Value, DelMat.Learn, acilo, /SET $
      ELSE DelMat.Learn = Handle_Create(VALUE=acilo)

      vector = FltArr(tnc)

      IF acilo(0) GT 0 THEN BEGIN
         counter = 0
         acilo = acilo(2:acilo(0)+1)
         
         FOR source = 0l, snc-1 DO BEGIN
            cutoff = MAX(WHERE( acilo LT (source+1)*tnc))
            IF cutoff NE -1 THEN BEGIN
               tn = acilo(0:cutoff) MOD tnc
               
               vector(tn) = vector(tn) + DelMat.Weights(acilo(0:cutoff))
               
               nel = N_Elements(acilo)-1
               IF nel GT cutoff THEN acilo = acilo(cutoff+1:nel) ELSE source = snc
            END
         END
         
         RETURN, Spassmacher(vector)
      END ELSE BEGIN
         RETURN, [0, tnc]
      END
              

   END   
END   
