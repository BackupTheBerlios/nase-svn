;+
; NAME: Record
;
; PURPOSE: Aufzeichnen von Zustandsgroessen der Neuronen aus einer Layer.
;
; CATEGORY: SIMULATION
;
; CALLING SEQUENCE: Kontrolle = Record (TAPE=Aufnahmeband, VALUE=Zustandsgroesse)
;
; INPUTS: Aufnahmeband: Eine mit InitTape erzeugte Struktur.
;         Zustandsgroesse: Eine beliebige Zustandsgroesse
;                          der Layer, zum Beispiel Output (Spikes) oder
;                          Feedingpotential oder...
;
; OPTIONAL INPUTS: ---
;
; KEYWORD PARAMETERS: siehe Inputs 
;
; OUTPUTS: Kontrolle: Das zuletzt gespeicherte Zustands-Array wird zurueckgegeben.
;
; OPTIONAL OUTPUTS: ---
;
; COMMON BLOCKS: ---
;
; SIDE EFFECTS: ---
;
; RESTRICTIONS: ---
;
; PROCEDURE: Set()
;
; EXAMPLE: MittlereSpalteOben=LayerIndex(Layer90, Row=0, Col=Layer90.w/2-1)
;          MittlereSpalte=mittlerespalteoben+IndGen(Layer90.h)
;
;          Raster90 = InitTape(LAYER=Layer90, INDEX=MittlereSpalte, DURATION=3*Praesentationszeit*Dauer)
;
;          Layer90_out = ProceedLayer_3(Layer90, Vf*muster90, Vl*Linking/(inp_quad), Inhibition90)
;
;          Aktuell = Record(TAPE=Raster90, VALUE=Layer90.O)
;          Print, Aktuell
;
;          Trainspotting, Raster90.nt
;
;          Das Beispiel erzeugt zunaechst ein Index-Array, das die
;          mittlere Spalte der Schicht beschreibt. Dieses wird dann an
;          die InitTape-Funktion uebergeben, damit die weiss, welche
;          Neuronen ueberhaupt untersucht werden sollen.
;          Nach einem Simulationsschritt speichert die Record-Funktion
;          den Output von Layer90 (also ein Spikeraster) auf das vorher initialisierte Tape
;          mit Namen Raster90. Zur Kontrolle werden die gespeicherten
;          Werte auch noch einmal mit Aktuell ausgegeben.
;          Am Ende der Aufzeichnung koennte das gespeicherte
;          Spikeraster mit der Trainspotting-Routine dargestellt werden. 
;
; MODIFICATION HISTORY:
;
;       Thu Aug 21 11:41:24 1997, Andreas Thiel
;;		Erste Version erstellt und ein wenig getestet.
;
;-


FUNCTION Record, TAPE=Tape, VALUE=Value

If Not Set(TAPE) Then Message, 'Aufnahmetape mit TAPE=... angeben!'
If Not Set(VALUE) Then Message, 'Wert, der aufgzeichnet werden soll, mit VALUE=... angeben!' 


RecordVector = Value(Tape.i)

Tape.nt(*,Tape.t) = RecordVector

Tape.t = Tape.t+1


RETURN, RecordVector

END
