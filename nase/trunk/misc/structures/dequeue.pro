;+
; NAME: DeQueue()
;
; AIM: dequeues data from queue initialized with <A>InitQueue</A>, <A>InitFQueue</A>
;
;          s.a. EnQueue, DeQueue(), Head(), Tail(), FreeQueue
;
; PURPOSE: Ausreihen eines Datums aus einer Queue. (Der Nächste bitte!)
;
; CATEGORY: Universell
;
; CALLING SEQUENCE: Datum = DeQueue ( MyQueue )
;
; INPUTS: MyQueue: Eine mit InitQueue() oder InitFQueue()
;                  initialisierte Queue-Struktur.
;
; OUTPUTS: Datum  : Das ausgelesene Datum.
;
; SIDE EFFECTS: Bei dynamischen Queues wird der belegte dynamische
;               Speicher wird freigegeben. Bei Fixed Queues wird der
;               freiwerdende Platz mit dem bei der Initialisierung
;               angegebenen Samplewert aufgefüllt.
;
; RESTRICTIONS: Es wird kein Test gemacht, ob die Queue noch Daten
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
;        Revision 1.4  2000/10/11 09:30:41  kupper
;        Added a Temporary().
;
;        Revision 1.3  2000/10/10 14:27:13  kupper
;        Jetzt auch für Fixed Queues!
;
;        Revision 1.2  2000/09/25 09:13:13  saam
;        * added AIM tag
;        * update header for some files
;        * fixed some hyperlinks
;
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
      assert, Queue.valid ge 1, "Fixed queue does not contain any " + $
       "valid values."
      Wert = Queue.Q(Queue.Pointer)
      Queue.Q(Queue.Pointer) = Queue.sample ;; erase value
      Queue.Pointer = cyclic_value(Queue.Pointer-1, [0, Queue.Length])
      Queue.valid = (Queue.valid-1)
      return, Wert
   endif

   If contains(Queue.info, 'DYNAMIC_QUEUE', /IGNORECASE) then begin
      List = Queue.List
      head = Retrieve(List, /first, /NO_COPY); bitte der naechste!
      kill, List, /first
      Queue.List = Temporary(List)
      return, head
   endif
End
