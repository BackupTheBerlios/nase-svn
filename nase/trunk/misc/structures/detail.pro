;+
; NAME: DeTail()
;
; AIM: dequeues data from the tail of queue initialized with <A>InitQueue</A>, <A>InitFQueue</A>
;
;          s.a. EnQueue, DeQueue(), Head(), Tail(), FreeQueue
;
; PURPOSE: Ausreihen eines Datums aus einer Queue von hinten. (Der LETZTE bitte!)
;
; CATEGORY: Universell
;
; CALLING SEQUENCE: Datum = DeTail ( MyQueue )
;
; INPUTS: MyQueue: Eine mit InitQueue() oder InitFQueue()
;                  initialisierte Queue-Struktur.
;
; OUTPUTS: Datum  : Das ausgelesene Datum.
;
; SIDE EFFECTS: Bei dynamischen Queues wird der belegte dynamische
;               Speicher wird freigegeben. Bei Fixed Queues wird der
;               freiwerdende Platz mit dem bei der Initialisierung
;               angegebenen Samplewert aufgef�llt.
;
; RESTRICTIONS: Es wird kein Test gemacht, ob die Queue noch Daten
;               enth�lt. Ein aufruf von DeQueue() mit einer leeren
;               Queue f�hrt zu einer Fehlermeldung.
;
; PROCEDURE: Die dynamic Queue ist �ber eine Liste implementiert. Alle
;            Vorg�nge werden auf die entsprechenden Listen-Routinen
;            (initlist, insert, retrieve(), kill, freelist) abgew�lzt!
;            Der Vorgang f�r die fixed Queue ist straightforward.
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
;          print, DeTail( MyQueue )        -> Ausgabe: "letzter"
;          print, DeTail( MyQueue )        -> Ausgabe: "zweiter"
;
;          FreeQueue, MyQueue 
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 1.1  2000/10/11 16:50:39  kupper
;        Re-implemented fixed queues to allow for using them as bounded queues
;        also. (HOPE it works...) Implemented dequeue for these queues and
;        implemented detail.
;
;        Revision 1.4  2000/10/11 09:30:41  kupper
;        Added a Temporary().
;
;        Revision 1.3  2000/10/10 14:27:13  kupper
;        Jetzt auch f�r Fixed Queues!
;
;        Revision 1.2  2000/09/25 09:13:13  saam
;        * added AIM tag
;        * update header for some files
;        * fixed some hyperlinks
;
;        Revision 1.1  1997/11/12 17:11:03  kupper
;               Sch�pfung der komplexen Datentypen.
;               Die Liste ist noch nicht vollst�ndig implementiert!
;               (Positions-Parameter fehlen noch.)
;               Stacks & Queues sollten hoffentlich vollst�ndig sein.
;
;-

Function DeTail, Queue

   If not contains(Queue.info, 'QUEUE', /IGNORECASE) then message, 'Not a Queue!'

   If contains(Queue.info, 'FIXED_QUEUE', /IGNORECASE) then begin
      assert, Queue.valid ge 1, "Fixed queue does not contain any " + $
       "valid values."
      Wert = Queue.Q(Queue.tail)
      Queue.Q(Queue.tail) = Queue.sample ;; erase value
      Queue.tail = cyclic_value(Queue.tail-1, [0, Queue.Length])
      Queue.valid = (Queue.valid-1)
      return, Wert
   endif

   If contains(Queue.info, 'DYNAMIC_QUEUE', /IGNORECASE) then begin
      List = Queue.List
      tail = Retrieve(List, /last, /NO_COPY); bitte der naechste!
      kill, List, /last
      Queue.List = Temporary(List)
      return, tail
   endif
End
