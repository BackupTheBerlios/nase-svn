;+
; NAME: DeQueue()
;
;          s.a. EnQueue, DeQueue(), Head(), Tail(), FreeQueue
;
; PURPOSE: Ausreihen eines Datums aus einer Queue. (Der Nächste bitte!)
;
; CATEGORY: Universell
;
; CALLING SEQUENCE: Datum = DeQueue ( MyQueue )
;
; INPUTS: MyQueue: Eine mit InitQueue()
;                  initialisierte Queue-Struktur.
;
; OUTPUTS: Datum  : Das ausgelesene Datum.
;
; SIDE EFFECTS: Der belegte dynamische Speicher wird freigegeben.
;
; RESTRICTIONS: DeQueue ist für Fixed Queues ( InitFQueue() ) nicht
;               definiert, da diese ja eine feste Länge haben. (Head()
;               benutzen!)
;               Es wird kein Test gemacht, ob die Queue noch Daten
;               enthält. Ein aufruf von DeQueue() mit einer leeren
;               Queue führt zu einer Fehlermeldung.
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
;        Revision 1.1  1997/11/12 17:11:03  kupper
;               Schöpfung der komplexen Datentypen.
;               Die Liste ist noch nicht vollständig implementiert!
;               (Positions-Parameter fehlen noch.)
;               Stacks & Queues sollten hoffentlich vollständig sein.
;
;-

Function DeQueue, Queue

   If not contains(Queue.info, 'QUEUE', /IGNORECASE) then message, 'Not a Queue!'

   If contains(Queue.info, 'FIXED_QUEUE', /IGNORECASE) then begin
      message, 'DeQueue not defined for Fixed Queues. Use "Head()" instead!'  
   endif

   If contains(Queue.info, 'DYNAMIC_QUEUE', /IGNORECASE) then begin
      List = Queue.List
      head = Retrieve(List, /first, /NO_COPY); bitte der naechste!
      kill, List, /first
      Queue.List = List
      return, head
   endif
End
