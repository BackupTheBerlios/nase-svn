;+
; NAME: Regler()
;
;      s.a. InitRegler()
;
; PURPOSE: Betreiben eines mit InitRegler() initialisierten Regelkreises.
;          Mit Hilfe eines Regelkreises kann eine Regelgr��e (Zahl)
;          auf einen w�hlbaren Sollwert gebracht bzw. dort gehalten
;          werden (Heizungsthermostat-Prinzip).
;
; CATEGORY: Simulation
;
; CALLING SEQUENCE: Korrektur = Regler ( MeinRegler, Ist, Soll
;                                         [,P=proportionaler_Faktor]
;                                         [,I=integrativer_Faktor]
;                                         [,D=differentieller_Faktor] )
;
; INPUTS: MeinRegler : Eine mit InitRegler() initialisierte Regler-Struktur.
;         Ist        : Ist-Wert der Regelgr��e.
;         Soll       : Soll-Wert der Regelgr��e.
;
; KEYWORD PARAMETERS: proportionaler_Faktor, integrativer_Faktor
;                     und differentieller_Faktor:
;
;                     Die Vorfaktoren f�r die berechnung der Korrektur.
;                     N�heres zu ihrer Bedeutung s.u. unter "PROCEDURE".
;
;                     Defaults sind  P=-0.1 ; I=0 ; D=0 .
;
; OUTPUTS: Korrektur : Ein Korrekturwert, der (nach der bescheidenen
;                      Meinung dieser Routine) zur Regelgr��e ADDIERT
;                      werden sollte, um sie m�glichst effektiv in
;                      Richtung des Sollwertes zu modifizieren.
;
; SIDE EFFECTS: Regler() merkt sich bei jedem Aufruf den aktuellen
;               Wert der Regelgr��e f�r den integrativen Teil der Korrektur.
;
; PROCEDURE: Regler() berechnet die Korrektur aus drei additiven
;            Teilen, welche jeder auf eine bestimmte Weise von der
;            Stellgr��e S abh�ngen.
;
;            S ist f�r jeden Zeitschritt n definiert als
;
;                        S(n) = Ist(n) - Soll(n).
;
;            Daraus berechnet sich in jedem Zeitschritt die
;
;            - proportionale Korrektur
;         
;                        K_p(n) = P * S(n),
;
;              wobei P der im Aufruf �bergebene "proportionale Faktor"
;              ist
;
;            - differentielle Korrektur
;
;                        K_d(n) = D * delta_S(n)    mit delta_S(n) = S(n)-S(n-1),
;
;              wobei delta_S also die �nderung von S seit dem letzen
;              Aufruf ist (die Differenz einer Differenz!) und D der
;              im Aufruf �bergebene "differentielle Faktor"
;                                     
;            - integrative Korrektur
;                                                                            n
;                        K_i(n) = I * S_quer(n)     mit S_quer(n) = 1/GL * SUMME[S(i)],
;                                                                           n-GL
;              wobei GL die in der Initialisierung angegebene
;              Ged�chtnusl�nge und also S_quer(n) der Durchschnitt von
;              S �ber die letzen GL Aufrufe ist.
;              I ist der im Aufruf �bergebene "integrative Faktor".
;
;            Die gesamte Korrektur K berechnet sich dann als
;
;                        K(n) = K_p(n)+K_d(n)+K_i(n).
;
;
; EXAMPLE: Ergebnisse = InitFQueue (100)            ;Eine Simulation mit 100 Zeitschritten
;
;          MeinRegler = InitRegler()
;
;          Groesse = 0.0                            ;Startwert f�r die Regelgr��e
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
;        Revision 2.1  1997/11/13 17:41:06  kupper
;               Sch�pfung.
;
;-

Function Regler, Regler, Ist, Soll, P=p, D=d, I=i

   if not set(Regler) then begin
      message, /INFORM, 'Nicht initialisierte Regler-Struktur. Default-Initialisierung wird verwendet.'
      Regler = InitRegler()
   endif

   Default, D, 0.0
   Default, I, 0.0
   Default, P, -0.1

   ;;------------------> Die folgenden Gr��en beeinflussen die St�rke der Korrektur:
   S = float(Ist)-float(Soll)   ;Stellgr��e
   
   Last_S = Head(Regler)        ;Stellgr��e vom letzten Aufruf
   delta_S = S-Last_S

   Durchschnitt = Total(Queue(Regler))/n_elements(Regler.Q) ;Durchschnitt �ber die gesamte Ged�chtnisl�nge
   ;;--------------------------------
   
   ;;------------------> aktuelle Stellgr��e merken:
   EnQueue, Regler, S
   ;;--------------------------------

   ;;------------------> Korrektur zur�ckgeben:
   Return, P*S + D*delta_S + I*Durchschnitt
   ;;--------------------------------

End
