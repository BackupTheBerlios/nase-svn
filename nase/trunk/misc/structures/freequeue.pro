;+
; NAME: FreeQueue          ( Gegenstück zu Init(F)Queue(). )
;
;             s.a. Init(F)Queue(), EnQueue, DeQueue(), Head(), Tail()
;
; PURPOSE: Löschen einer gesamten Queue und freigeben des (dynamischen) Speichers.
;
; CATEGORY: Universell.
;
; CALLING SEQUENCE: FreeQueue, MyQueue
;
; INPUTS: MyQueue  : Eine mit InitQueue() oder InitFQueeu() initialisierte
;                    Queuestruktur, die auch noch Daten enthalten
;                    darf.
;        
; RESTRICTIONS:
;     FreeQueue erledigt alle!
;     DeQueue() braucht -NICHT- für alle Elemente aufgerufen zu werden,
;        wenn die Queue gelöscht werden soll. 
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
;        Revision 1.1  1997/11/12 17:11:05  kupper
;               Schöpfung der komplexen Datentypen.
;               Die Liste ist noch nicht vollständig implementiert!
;               (Positions-Parameter fehlen noch.)
;               Stacks & Queues sollten hoffentlich vollständig sein.
;
;-

Pro FreeQueue, Queue

   If not contains(Queue.info, 'QUEUE', /IGNORECASE) then message, 'Not a Queue!'

   If contains(Queue.info, 'FIXED_QUEUE', /IGNORECASE) then begin
      Queue = -1
      return
   end
   
   If contains(Queue.info, 'DYNAMIC_QUEUE', /IGNORECASE) then begin
      FreeList, Queue.List
      return
   end

End
