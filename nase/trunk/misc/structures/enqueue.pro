;+
; NAME: EnQueue
;
;          s.a. EnQueue, DeQueue(), Head(), Tail(), FreeQueue
;
; PURPOSE: Einreihen eines Datums in eine Queue. (Hinten anstellen!)
;
; CATEGORY: Universell
;
; CALLING SEQUENCE: EnQueue, MyQueue, Datum  [,/NO_COPY]
;
; INPUTS: MyQueue: Eine mit InitQueue() oder InitFQueue() 
;                  initialisierte Queue-Struktur.
;         Datum  : Das einzureihende Datum. Dieses kann bei
;                  Dynamischen Queues ( InitQueue() ) von beliebigem
;                  Typ sein (alle IDL-Typen incl. Strukturen, Arrays,
;                  Listen, Queues, Stacks oder <UNDEFINED>).
;                  Bei Fixed Queues ( InitFQueue() ) muß es dem bei
;                  der Initialisierung angegebenen Typ entsprechen.
;
;
; KEYWORD PARAMETERS: NO_COPY : Wie bei den meisten IDL-Routinen, die
;                                Daten übertragen, bewirkt die Angabe
;                                dieses Schlüsselwortes, daß der
;                                Inhalt von "Datum" nicht kopiert,
;                                sondern direkt teil der Queue
;                                wird. Dies hat nur Effekt, wenn in
;                                "Datum" eine Variable übergeben
;                                wird. In diesem Fall ist der Datentyp
;                                der Variable nach dem Aufruf <Undefined>.
;
; SIDE EFFECTS: Es wird dynamischer Speicher belegt. Daher nach
;               beendigung ein FreeQueue nicht vergessen!
;
; RESTRICTIONS: Keine. Die Queue darf sogar verschiedene
;               Datentypen incl. Structures, Arrays, Listen, Queues,
;               Stacks oder <UNDEFINED> gleichzeitig enthalten.
;
; PROCEDURE: Die Queue ist über eine Liste implementiert. Alle
;            Vorgänge werden auf die entsprechenden Listen-Routinen
;            (initlist, insert, retrieve(), kill, freelist) abgewälzt!
;
; EXAMPLE: MyQueue = InitQueue()
;
;          EnQueue, MyQueue, "erster"       ; immer
;          EnQueue, MyQueue, "zweiter"      ; hinten
;          EnQueue, MyQueue, "letzter"       ; anstellen!
;
;          print, Head( MyQueue )           -> Ausgabe: "erster"
;          print, Tail( MyQueue )           -> Ausgabe: "letzter"
;
;          print, DeQueue( MyQueue )        -> Ausgabe: "erster"
;          print, DeQueue( MyQueue )        -> Ausgabe: "zweiter"
;
;          FreeQueue, MyQueue 
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 1.1  1997/11/12 17:11:04  kupper
;               Schöpfung der komplexen Datentypen.
;               Die Liste ist noch nicht vollständig implementiert!
;               (Positions-Parameter fehlen noch.)
;               Stacks & Queues sollten hoffentlich vollständig sein.
;
;-

Pro EnQueue, Queue, Wert, NO_COPY=no_copy

   If not contains(Queue.info, 'QUEUE', /IGNORECASE) then message, 'Not a Queue!'

   If contains(Queue.info, 'FIXED_QUEUE', /IGNORECASE) then begin
      Queue.Pointer = (Queue.Pointer+1) mod Queue.Length
      Queue.Q(Queue.Pointer) = Wert
   endif

   If contains(Queue.info, 'DYNAMIC_QUEUE', /IGNORECASE) then begin
      List = Queue.List
      Insert, List, Wert, /last, NO_COPY=no_copy ;bitte hinten anstellen!
      Queue.List = List
   endif
End
