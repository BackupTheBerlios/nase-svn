;+
; NAME: InitRegler()
;
; AIM:  initializes a control loop
;
;      s.a. Regler()
;
; PURPOSE: Initialisierung eines Regelkreises.
;          Mit Hilfe eines Regelkreises kann eine Regelgröße (Zahl)
;          auf einen wählbaren Sollwert gebracht bzw. dort gehalten
;          werden (Heizungsthermostat-Prinzip).
;
; CATEGORY: Simulation
;
; CALLING SEQUENCE: MeinRegler = InitRegler ( [Gedächtnislänge] )
;
; OPTIONAL INPUTS: Gedächtnislänge: Ein Integer, der angibt, wieviel
;                                   "Geschichte" in der Reglerstruktur
;                                   gespeichert ist. Regler() wird
;                                   sich bei jedem Aufruf den
;                                   aktuellen Wert der Regelgröße in
;                                   einer internen Fixed Queue
;                                   merken. Dieser Wert gibt an, wie
;                                   lang diese Queue ist.
;                                   Dieser Wert wird ausschließlich
;                                   für den integrativen Teil der
;                                   Regelung benutzt. (s. Regler() )
;                                   Eine größere Gedächtnislänge macht
;                                   den Regler träger.
;                                   Default ist 10, d.h. die jeweils
;                                   10 letzen Aufrufe gehen in die
;                                   Berechnung des integrativen Teils ein.
;
; OUTPUTS: Eine initialisierte Reglerstruktur, deren info-Tag den
;          String 'REGLER' enthält.
;
; SIDE EFFECTS:
;
; PROCEDURE: InitFQueue()
;
; EXAMPLE: Ergebnisse = InitFQueue (100)            ;Eine Simulation mit 100 Zeitschritten
;
;          MeinRegler = InitRegler()
;
;          Groesse = 0.0                            ;Startwert für die Regelgröße
;
;          for i = 1,100 do begin
;              EnQueue, Ergebnisse, Groesse         ;Merk dir den Verlauf der Groesse
;              Korrektur = Regler ( MeinRegler, Groesse, 23.0, I=-0.2 ) ;Istwert: Groesse, Sollwert: 23.0
;              Groesse = Groesse + Korrektur
;          endfor
;
;          Plot, Queue(Ergebnisse)                  ;Zeig's mir
;
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 2.2  2000/09/25 09:13:09  saam
;        * added AIM tag
;        * update header for some files
;        * fixed some hyperlinks
;
;        Revision 2.1  1997/11/13 17:41:07  kupper
;               Schöpfung.
;
;-

Function InitRegler, GL

   Default, GL, 10

   r = InitFQueue(GL, 0.0)           ;Eine fixed Queue als Gedächtnis!
   r.info = r.info+' REGLER'

   return, r

End

