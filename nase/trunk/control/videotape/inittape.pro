;+
; NAME: InitTape
;
; AIM: Initializes a Tape-Structure.
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
;                              Wird kein IndexArry angegeben, werden alle Neuronen der Schicht 
;                              betrachtet.
;                              VORSICHT: Das Indexarray muss eindimensional sein, sonst gehts
;                                        nicht. Also gegebenenfalls REFORMen. 
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
; PROCEDURE: Kleiner Syntaxtest, Defaults festlegen und dann die Struktur erzeugen.
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
; SEE ALSO: <A HREF="#RECORD">Record</A>
;
; MODIFICATION HISTORY:
;
;       $Log$
;       Revision 2.6  2000/09/28 13:23:27  alshaikh
;             added AIM
;
;       Revision 2.5  1998/06/24 14:45:15  thiel
;              Kein .Log im Header!
;
;
;       Thu Aug 21 18:02:12 1997, Andreas Thiel
;		.t ist jetzt ein Long-Integer
;
;       Thu Aug 21 12:01:29 1997, Andreas Thiel
;		Erste Version erstellt und getestet.
;
;-


FUNCTION InitTape, LAYER=Layer, INDEX=Index, DURATION=Duration, STARTTIME=StartTime


If Not Set(DURATION) Then Message, 'Dauer der Aufnahme mit DURATION=... angeben!'
If Not Set(LAYER) Then Message, 'Schicht, aus der aufgenommen werden soll, mit LAYER=... angeben!'

If Not Set(INDEX) Then Index=IndGen(LayerSize(Layer))

Default, StartTime, 0
StartTime = Long(StartTime)

ArrayInfo = size(Index)
Length = ArrayInfo(1)

Tape = { t  : StartTime               ,$
         i  : index                   ,$
         nt : FltArr(Length,Duration) } 
           

RETURN, Tape

END
