;+
; NAME: Regler()
;
; AIM: operates a control loop initialized with <A>InitRegler</A> 
;
;      s.a. InitRegler()
;
; PURPOSE: Betreiben eines mit InitRegler() initialisierten Regelkreises.
;          Mit Hilfe eines Regelkreises kann eine Regelgröße (Zahl)
;          auf einen wählbaren Sollwert gebracht bzw. dort gehalten
;          werden (Heizungsthermostat-Prinzip).
;
; CATEGORY: Simulation
;
; CALLING SEQUENCE: Korrektur = Regler ( MeinRegler, Ist, Soll
;                                         [,P=proportionaler_Faktor]
;                                         [,I=integrativer_Faktor]
;                                         [,D=differentieller_Faktor] )
;
; INPUTS: MeinRegler : Eine mit InitRegler() initialisierte
;                      Regler-Struktur, oder eine undefinierte
;                      Variable (dann wird sie automatisch initialisiert.)
;         Ist        : Ist-Wert der Regelgröße.
;         Soll       : Soll-Wert der Regelgröße.
;
;                      Die Regelgröße ist dabei eine beliebige, nicht
;                      notwendigerweise bekannte Funktion einer direkt
;                      beeinflußbaren Variablen.
;
;                      Beispiel: Regelgröße = Raumtemperatur
;                                Variable   = Winkel des Thermostat-Drehknopfes
;
; KEYWORD PARAMETERS: proportionaler_Faktor, integrativer_Faktor
;                     und differentieller_Faktor:
;
;                     Die Vorfaktoren für die berechnung der Korrektur.
;                     Näheres zu ihrer Bedeutung s.u. unter "PROCEDURE".
;
;                     Defaults sind  P=-0.1 ; I=0 ; D=0 .
;
; OUTPUTS: Korrektur : Ein Korrekturwert, der (nach der bescheidenen
;                      Meinung dieser Routine) zu der beeinflußbaren Variablen
;                      addiert werden sollte, um sie möglichst effektiv in
;                      Richtung des Sollwertes zu modifizieren.
;
;                      Beispiel: Korrektur = Winkel, um den der Thermostat-Drehknopf
;                                            bewegt werden soll.
;
; SIDE EFFECTS: Regler() merkt sich bei jedem Aufruf den aktuellen
;               Wert der Regelgröße für den integrativen Teil der
;               Korrektur.
;
;               Wird Regler() mit einer nicht initialisierten
;               Reglerstruktur aufgerufen, so wird InitRegler() mit
;               den Defaulteinstellungen aufgerufen. Daher ist eine
;               explizierte Initialisierung nicht unbedingt nötig.
;
; PROCEDURE: Regler() berechnet die Korrektur aus drei additiven
;            Teilen, welche jeder auf eine bestimmte Weise von der
;            Stellgröße S abhängen.
;
;            S ist für jeden Zeitschritt n definiert als
;
;                        S(n) = Ist(n) - Soll(n).
;
;            Daraus berechnet sich in jedem Zeitschritt die
;
;            - proportionale Korrektur
;         
;                        K_p(n) = P * S(n),
;
;              wobei P der im Aufruf übergebene "proportionale Faktor"
;              ist
;
;            - differentielle Korrektur
;
;                        K_d(n) = D * delta_S(n)    mit delta_S(n) = S(n)-S(n-1),
;
;              wobei delta_S also die Änderung von S seit dem letzen
;              Aufruf ist (die Differenz einer Differenz!) und D der
;              im Aufruf übergebene "differentielle Faktor"
;                                     
;            - integrative Korrektur
;                                                                            n
;                        K_i(n) = I * S_quer(n)     mit S_quer(n) = 1/GL * SUMME[S(i)],
;                                                                           n-GL
;              wobei GL die in der Initialisierung angegebene
;              Gedächtnuslänge und also S_quer(n) der Durchschnitt von
;              S über die letzen GL Aufrufe ist.
;              I ist der im Aufruf übergebene "integrative Faktor".
;
;            Die gesamte Korrektur K berechnet sich dann als
;
;                        K(n) = K_p(n)+K_d(n)+K_i(n).
;
;            P sollte stets ungleich 0 sein, da ein Regler nur mit
;            einem Integal- oder Differentialteil nicht
;            zufriedenstellend arbeitet.            
;            Der Intergalteil realisiert ein gewisse Trägheit des
;            Reglers. Er ist zu empfehlen, wenn in der Regelgröße
;            schnellere Fluktuationen (Ausreißer)
;            auftreten. Andererseits treten aufgrund der trägen
;            Reaktion wahrscheinlich Oszillationen auf (s. Beispiel).
;            Größere Gedächtnislängen bzw. größere I machen den Regler
;            träger.
;            Wofür der Differentialteil gut sein kann, ist mir nicht
;            ganz klar. Er scheint mir meist zu einer Verschlechterung
;            des Ergebnisses und zu Aufschaukelungseffekten zu
;            führen. Es mag jedoch durchaus sinnvolle Anwendungen
;            dafür geben, die mir bisher nicht untergekommen
;            sind. Wenn jemand eine findet, kann er mir bitte
;            bescheidsagen...
;
;            
;
; RESTRICTIONS: Man beachte, daß die Regelgröße -zumindest lokal-
;               monoton von der beeinflußbaren Variablen abhängen muß,
;               wenn eine Regelung (negative Rückkopplung) erfolgreich
;               funktionieren soll.
;
;               Man beachte weiterhin das Vorzeichen der Faktoren P,D
;               und I: Steigt die Regelgröße R (z.B. Raumtemperatur) mit
;                      steigender Variablengröße V
;                      (z.B. Thermostatstellung), so müssen P,D und I
;                      negatives Vorzeichen haben, damit bei
;                      entsprechender Abweichung von R vom Sollwert
;                      V auch in die richtige Richtung korrigiert
;                      wird!
;
;               P sollte stets ungleich 0 sein, da ein Regler nur mit
;               einem Integal- oder Differentialteil nicht
;               zufriedenstellend arbeitet.            
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
;        Revision 2.5  2000/12/14 15:15:19  kupper
;        Broke on first call, as Queue(/Valid) now issues error, when no valid elements are in queue.
;
;        Revision 2.4  2000/09/25 09:13:10  saam
;        * added AIM tag
;        * update header for some files
;        * fixed some hyperlinks
;
;        Revision 2.3  1998/05/19 19:05:03  kupper
;               Ein /VALID für den I-Teil...
;
;        Revision 2.2  1997/11/13 18:42:21  kupper
;               Ergänzungen zum Header.
;
;        Revision 2.1  1997/11/13 17:41:06  kupper
;               Schöpfung.
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

   ;;------------------> Die folgenden Größen beeinflussen die Stärke der Korrektur:
   S = float(Ist)-float(Soll)   ;Stellgröße
   
   Last_S = Head(Regler)        ;Stellgröße vom letzten Aufruf
   delta_S = S-Last_S

   If ContainedElements(Queue, /Valid) eq 0 then Durchschnitt = 0 else $
    Durchschnitt = Total(Queue(Regler, /VALID))/n_elements(Regler.Q) ;Durchschnitt über die gesamte Gedächtnislänge
   ;;--------------------------------
   
   ;;------------------> aktuelle Stellgröße merken:
   EnQueue, Regler, S
   ;;--------------------------------

   ;;------------------> Korrektur zurückgeben:
   Return, P*S + D*delta_S + I*Durchschnitt
   ;;--------------------------------

End
