;+
; NAME: InitFQueue()
;
; AIM: initializes a general queue with fixed length
;
;          s.a. EnQueue, Head(), Tail(), Queue(), FreeQueue
;
; PURPOSE: Initialisierung einer Fixed Queue (Queue mit vorgegebener,
;          fester Länge.)
;
; CATEGORY: Universell, Simulation
;
; CALLING SEQUENCE: MyFQueue = InitFQueue ( length [,sample] )
;
; INPUTS: length: Die (feste) Länge der Queue.
;
; OPTIONAL INPUTS: sample: Ein Beispielwert von dem Typ, den die Queue
;                          später enthalten soll. Erlaubt sind alle
;                          IDL-Typen, von denen sich Arrays bilden
;                          lassen (weil die Queue über ein Array
;                          implentiert ist).
;                          Dies ist auch der Initialisierungswert für
;                          die gesamte Queue, d.h. die frisch
;                          initialisierte Queue enthält an jeder
;                          Stelle diesen Wert.
;                          Default ist 0.0, also Typ <FLOAT>.
;
; OUTPUTS: Eine initialisierte FQueue-Struktur.
;          Diese Struktur enthält einen Info-Tag mit Inhalt 'FIXED_QUEUE'.
;
; RESTRICTIONS: Keine. Diese Art von Queue benutzt auch keinen
;               dynamischen Speicher, daher ist ein Aufruf von
;               FreeQueue nicht unbedingt notwendig. Er ist jedoch zu
;               empfehlen, um den Speicher des internen Queue-Arrays
;               freizugeben, wenn die Queue sehr groß war und nicht
;               mehr gebraucht wird.
;
;               Mit EnQueue wird das Queue-Array der Reihe nach
;               aufgefüllt. Ist die Queue voll, so fallen die Elemente
;               am Kopf ohne Warnung der Reihe nach wieder heraus,
;               wenn hinten etwas reingesteckt wird. (Dies ist in der
;               Regel ein gewünschter Effekt - auf diese Weise läßt
;               sich leicht ein "Gedächtnis" implementieren, das sich
;               automatisch die letzten soundsoviel Werte eines
;               Parameters "merkt". Ich selbst benutzt die FQueue
;               inzwischen dauernd in dieser Eigenschaft, um mir
;               sequentiell anfallende Daten schnell und einfach zu
;               merken. Vgl. dazu insbesondere auch die
;               Queue()-Funktion und das Beispiel Nr. 2.
;
; PROCEDURE: wie's Sommer einen lehrt...
;            (Array von samples erstellen, Struktur bauen...)
;
; EXAMPLE: 1. MyFQueue = InitFQueue ( 3, 0d )    ; Queue der Länge 3, die Doubles enthält.
;          
;             EnQueue, MyFQueue, 1.0
;             EnQueue, MyFQueue, 2.0
;
;             print, Tail( MyFQueue )             -> Ausgabe: 2.0
;             print, Head( MyFQueue )             -> Ausgabe: 0.0, da hier noch der
;                                                                  Initialisierungswert 0d steht.
;             EnQueue, MyFQueue, 3.0
;             EnQueue, MyFQueue, 4.0
;
;             print, Tail( MyFQueue )             -> Ausgabe: 4.0
;             print, Head( MyFQueue )             -> Ausgabe: 2.0, da die Queue nur die Länge 3 hat,
;                                                                  und damit der erste Wert wieder
;                                                                  herausgefallen ist.
;             FreeQueue, MyFQueue
;
;
;          2. ;Ich habe eine Simulation über 100 Zeitschritte, die in
;             ;jedem Schritt ein Float als Ergebnis liefert.
;            
;             Ergebnisse = InitFQueue (100)
;
;             For n=1,100 do begin
;                 < SIMULTION >
;                 EnQueue, Ergebnisse, Ergebnis_dieses_Zeitschritts
;             End
;
;             Plot, Queue( Ergebnisse ) ;Mal mir alle Ergebnisse auf!
;
;             FreeQueue, Ergebnisse    
;                                         
;   
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 1.3  2000/09/25 09:13:13  saam
;        * added AIM tag
;        * update header for some files
;        * fixed some hyperlinks
;
;        Revision 1.2  1998/05/19 19:03:33  kupper
;               VALID für Fixed-Queues implementiert.
;
;        Revision 1.1  1997/11/12 17:11:06  kupper
;               Schöpfung der komplexen Datentypen.
;               Die Liste ist noch nicht vollständig implementiert!
;               (Positions-Parameter fehlen noch.)
;               Stacks & Queues sollten hoffentlich vollständig sein.
;
;-

Function InitFQueue, length, sample

   if not set (length) then message, 'Missing Length Parameter!'

   Default, sample, 0.0

   return, {info   : 'FIXED_QUEUE', $
            Q      : make_array(length, VALUE=sample), $
            Pointer: length-1, $ ;Dieser Zeiger weist stets auf das zuletzt
                                ;beschriebene Element, also auf den
                                ;Schwanz der Queue.
            Length : length, $
            valid  : 0l}        ;Hier steht am Anfang die Anzahl der bereits eingereihten Elemente, 
                                ;solange bis mehr als length Elemente
                                ;eingereiht wurden. (Falls die
                                ;Initwerte nicht beachtet werden sollen....)
End
