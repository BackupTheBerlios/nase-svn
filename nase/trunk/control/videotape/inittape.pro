;+
; NAME: IniTape
;
;
; PURPOSE: Erzeugen einer Tape-Struktur
;
; CATEGORY: SIMULATION
;
; CALLING SEQUENCE: MyTape = InitTape(LAYER=Schicht [,INDEX=IndexArray]
;                                     ,DURATION=Aufnahmedauer [,STARTTIME=Startzeit])
;
;
; 
; INPUTS: Schicht:       Eine mit InitLayer erzeugte Struktur.
;         Aufnahmedauer: Laenge des zu erzeugenden Arrays, das die
;                        gewuenschten Werte speichern soll.
;
; OPTIONAL INPUTS: IndexArray: Gibt die Indizes derjenigen Neuronen in
;                              der Schicht an, die betrachtet werden sollen. Hier ist es also
;                              moeglich, Reihen oder Spalten von Neuronen festzulegen, oder
;                              kreisfoermig angeordnete, oder... 
;                              Wird kein IndexArry angegeben, werden alle Neuronen der Schicht betrachtet. 
;                  Startzeit:  Default ist 0.
;
; KEYWORD PARAMETERS: siehe INPUTS
;
; OUTPUTS: Eine Tape-Struktur:
;             Tape = { t  : Time                    ,$
;                      i  : index                   ,$
;                      nt : FltArr(Length,Duration) } 
;          Jede Tape-Struktur entahelt also einen eigenen Zaehler .t,
;          ein Array mit Indizes .i
;          und ein Array, in das die entsprechende Werte gespeichert
;          werden. (Abszisse: Zeit, Ordinate: Neuronennummer)
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
;            Default
;
; EXAMPLE: MittlereSpalteOben=LayerIndex(Layer90, Row=0, Col=Layer90.w/2-1)
;          MittlereSpalte=mittlerespalteoben+IndGen(Layer90.h)
;
;          Raster90 = InitTape(LAYER=Layer90, INDEX=MittlereSpalte, DURATION=3*Praesentationszeit*Dauer)
;
;          Das Beispiel erzeugt zunaechst ein Index-Array, das die
;          mittlere Spalte der Schicht beschreibt. Dieses wird dann an
;          die InitTape-Funktion uebergeben, damit die weiss, welche
;          Neuronen der Schicht Layer90 ueberhaupt untersucht werden sollen. 
;
;
; MODIFICATION HISTORY:
;
;       Thu Aug 21 12:01:29 1997, Andreas Thiel
;		Erste Version erstellt und getestet.
;
;-


FUNCTION InitTape, LAYER=Layer, INDEX=Index, DURATION=Duration, STARTTIME=StartTime


If Not Set(DURATION) Then Message, 'Dauer der Aufnahme mit DURATION=... angeben!'
If Not Set(LAYER) Then Message, 'Schicht, aus der aufgenommen werden soll, mit LAYER=... angeben!'

If Not Set(INDEX) Then Index=IndGen(LayerSize(Layer))

Default, StartTime,0

Info = size(Index)
Length = Info(1)

Tape = { t  : StartTime               ,$
         i  : index                   ,$
         nt : FltArr(Length,Duration) } 
           

RETURN, Tape

END
