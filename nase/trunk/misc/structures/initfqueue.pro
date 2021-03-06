;+
; NAME: InitFQueue()
;
; AIM: initializes a general queue with fixed length
;
;          s.a. EnQueue, Head(), Tail(), Queue(), FreeQueue
;
; PURPOSE: Initialisierung einer Fixed Queue (Queue mit vorgegebener,
;          fester L�nge.)
;
; CATEGORY: Universell, Simulation
;
; CALLING SEQUENCE: MyFQueue = InitFQueue ( length [,sample] )
;
; INPUTS: length: Die (feste) L�nge der Queue.
;
; OPTIONAL INPUTS: sample: Ein Beispielwert von dem Typ, den die Queue
;                          sp�ter enthalten soll. Erlaubt sind alle
;                          IDL-Typen, von denen sich Arrays bilden
;                          lassen (weil die Queue �ber ein Array
;                          implentiert ist).
;                          Dies ist auch der Initialisierungswert f�r
;                          die gesamte Queue, d.h. die frisch
;                          initialisierte Queue enth�lt an jeder
;                          Stelle diesen Wert.
;                          Default ist 0.0, also Typ <FLOAT>.
;
; OUTPUTS: Eine initialisierte FQueue-Struktur.
;          Diese Struktur enth�lt einen Info-Tag mit Inhalt 'FIXED_QUEUE'.
;
; RESTRICTIONS: Keine. Diese Art von Queue benutzt auch keinen
;               dynamischen Speicher, daher ist ein Aufruf von
;               FreeQueue nicht unbedingt notwendig. Er ist jedoch zu
;               empfehlen, um den Speicher des internen Queue-Arrays
;               freizugeben, wenn die Queue sehr gro� war und nicht
;               mehr gebraucht wird.
;
;               Mit EnQueue wird das Queue-Array der Reihe nach
;               aufgef�llt. Ist die Queue voll, so fallen die Elemente
;               am Kopf ohne Warnung der Reihe nach wieder heraus,
;               wenn hinten etwas reingesteckt wird. (Dies ist in der
;               Regel ein gew�nschter Effekt - auf diese Weise l��t
;               sich leicht ein "Ged�chtnis" implementieren, das sich
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
; EXAMPLE: 1. MyFQueue = InitFQueue ( 3, 0d )    ; Queue der L�nge 3, die Doubles enth�lt.
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
;             print, Head( MyFQueue )             -> Ausgabe: 2.0, da die Queue nur die L�nge 3 hat,
;                                                                  und damit der erste Wert wieder
;                                                                  herausgefallen ist.
;             FreeQueue, MyFQueue
;
;
;          2. ;Ich habe eine Simulation �ber 100 Zeitschritte, die in
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
;        Revision 1.5  2000/10/11 16:50:39  kupper
;        Re-implemented fixed queues to allow for using them as bounded queues
;        also. (HOPE it works...) Implemented dequeue for these queues and
;        implemented detail.
;
;        Revision 1.4  2000/10/10 14:28:33  kupper
;        Now queue struct contains the sample value, for DeQueue() needs
;        something to fill in!
;
;        Revision 1.3  2000/09/25 09:13:13  saam
;        * added AIM tag
;        * update header for some files
;        * fixed some hyperlinks
;
;        Revision 1.2  1998/05/19 19:03:33  kupper
;               VALID f�r Fixed-Queues implementiert.
;
;        Revision 1.1  1997/11/12 17:11:06  kupper
;               Sch�pfung der komplexen Datentypen.
;               Die Liste ist noch nicht vollst�ndig implementiert!
;               (Positions-Parameter fehlen noch.)
;               Stacks & Queues sollten hoffentlich vollst�ndig sein.
;
;-

Function InitFQueue, length, sample

   if not set (length) then message, 'Missing Length Parameter!'

   Default, sample, 0.0

   ;;The order of elements in the internal array is:
   ;;increasing index in direction of tail
   return, {info   : 'FIXED_QUEUE', $
            Q      : make_array(length, VALUE=sample), $
            sample : sample, $ ;; for later filling in by DeQueue()
            tail   : length-1, $       ;the tail of the queue (last that was
                                ;enqueued, last to go out)
            valid  : 0, $; the number of valid elements in the queue.
            $            ;;head = cyclic_value(tail-valid+1, [0,length])
            abshead: 0, $; the start (absolute head) of the fixed queue.
            length : length}
End
