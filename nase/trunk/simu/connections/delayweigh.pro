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
;       Revision 1.35  1998/02/12 10:31:56  thiel
;              Da war doch glatt noch ein S2T uebriggeblieben...
;
;       Revision 1.34  1998/02/11 17:49:55  thiel
;              Jetzt wieder ohne Benutzung der S2T-Liste, weils
;              keinen Unterschied macht.
;
;       Revision 1.33  1998/02/11 17:39:01  saam
;             bloede (!!) Optimierungen
;
;       Revision 1.32  1998/02/11 16:17:14  saam
;             HandleOperationen mit NO_COPY
;
;       Revision 1.31  1998/02/11 15:43:10  saam
;             Geschwindigkeitsoptimierung durch eine neue Liste
;             die source- auf target-Neuronen abbildet
;
;       Revision 1.30  1998/02/11 14:11:05  saam
;             Geschwindigkeitsoptimierung
;
;       Revision 1.29  1998/02/05 14:18:50  saam
;             loop variables now long
;
;       Revision 1.28  1998/02/05 13:16:00  saam
;             + Gewichte und Delays als Listen
;             + keine direkten Zugriffe auf DW-Strukturen
;             + verbesserte Handle-Handling :->
;             + vereinfachte Lernroutinen
;             + einige Tests bestanden
;
;       Revision 1.27  1997/12/10 15:53:37  saam
;             Es werden jetzt keine Strukturen mehr uebergeben, sondern
;             nur noch Tags. Das hat den Vorteil, dass man mehrere
;             DelayWeigh-Strukturen in einem Array speichern kann,
;             was sonst nicht moeglich ist, da die Strukturen anonym sind.
;
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
FUNCTION DelayWeigh, _DW, InHandle
   

   Handle_Value, _DW, DW, /NO_COPY 
   Handle_Value, InHandle, In

 
;----- Der Teil ohne Delays:   
   IF (DW.Info EQ 'SDW_WEIGHT') THEN BEGIN


      IF Handle_Info(DW.Learn) THEN Handle_Value, DW.Learn, In, /SET $
      ELSE  DW.Learn = Handle_Create(_DW, VALUE=In)

      IF In(0) EQ 0 THEN BEGIN
         result = FltArr(2,1)
         result(1,0) = DW.target_w*DW.target_h
         Handle_Value, _DW, DW, /NO_COPY, /SET 
         RETURN, result
                                ;aus der Funktion rausspringen, wenn
                                ;ohnehin keine Aktivitaet im Input vorliegt:
      END

      
      ; asi : active source index
      ; asn : active source neuron
      ; wi  : weight indices
      vector = FltArr(DW.target_w*DW.target_h)
      
      FOR asi=2l,In(0)+1 DO BEGIN
         asn = In(asi)
         IF DW.S2C(asn) NE -1 THEN BEGIN
            Handle_Value, DW.S2C(asn), wi, /NO_COPY
            ; C2T(wi) has each target neuron only once,
            ; because there is only one connection between
            ; source and target; therefore next assignment is ok
            tN = DW.C2T(wi) 
            vector(tN) = vector(tn) + DW.W(wi)
            Handle_Value, DW.S2C(asn), wi, /NO_COPY, /SET
         END
      END

      Handle_Value, _DW, DW, /NO_COPY, /SET 
      RETURN, Spassmacher(vector)
      
      
      
      
;----- Der Teil mit Delays:      
   END ELSE IF (DW.Info EQ 'SDW_DELAY_WEIGHT') THEN BEGIN
      
      ; acili: active connection index list IN
      ; acilo: active connection index list OUT
      ; asi  : active source index
      ; asn  : active source neuron
      ; atn  : active target neurons

      acili_empty = 1 ;TRUE


      ; compute the weight indices receiving input from IN in a list named ACILI
      FOR asi= 2l, In(0)+1 DO BEGIN
         asn = In(asi)
         IF DW.S2C(asn) NE -1 THEN BEGIN
            Handle_Value, DW.S2C(asn), wi            
            IF NOT acili_empty THEN BEGIN
               acili = [acili, wi] 
            END ELSE BEGIN
               acili = wi
               acili_empty = 0
            END
         END
      END

      ; convert ACILI into an SSpass list 
      IF NOT acili_empty THEN BEGIN
         acili = [n_elements(acili), N_Elements(DW.W), acili]
      END ELSE BEGIN
         acili = [0, N_Elements(DW.W)]
      END

      ; enQueue it and deQueue results in ACILO
      tmpQU = DW.Queue
      acilo = SpikeQueue( tmpQu, acili ) 
      DW.Queue = tmpQu

      IF Handle_Info(DW.Learn) THEN Handle_Value, DW.Learn, acilo, /SET $
      ELSE DW.Learn = Handle_Create(_DW, VALUE=acilo)

      vector = FltArr(DW.target_w*DW.target_h)

      ; create a Spass vector with the output activity
      IF acilo(0) GT 0 THEN BEGIN
         counter = 0
         acilo = acilo(2:acilo(0)+1)
         
         ; wi: weight index
         FOR i=0l,N_Elements(acilo)-1 DO BEGIN
            wi = acilo(i)
            ; get corresponding target index
            Handle_Value, DW.S2T(asn), tN            
            vector(tN) = vector(tN) + DW.W(wi)
         END


         Handle_Value, _DW, DW, /NO_COPY, /SET 
         RETURN, Spassmacher(vector)
      END ELSE BEGIN
         Handle_Value, _DW, DW, /NO_COPY, /SET 
         RETURN, [0, DW.target_w*DW.target_h]
      END
              
      
   END ELSE Message, 'SDW[_DELAY]_WEIGHT structure expected, but got '+Info(DW)



END   
