;+
; NAME: Head()
;
; AIM: returns a queue's head element without removing it
;
;          s.a. EnQueue, DeQueue(), Head(), Tail(), FreeQueue
;
; PURPOSE: Ansehen (ohne Ausreihen) des Datums am Kopf einer
;          Queue, (d.h. des ältesten Datums in der Queue.)     (Wer wäre der nächste?)
;
; CATEGORY: Universell
;
; CALLING SEQUENCE: Datum = Head ( MyQueue [,/VALID] )
;
; INPUTS: MyQueue: Eine mit InitQueue()
;                  initialisierte Queue-Struktur.
;
; OUTPUTS: Datum  : Das ausgelesene Datum.
;
; KEYWORDS: VALID: Ist eine Fixed Queue noch nicht bis zum Rand mit
;                  EnQueue-Aufrufen gefüllt worden, so enthält das
;                  Queue-Array in den ersten Einträgen den
;                  Initialisierungswert (i.d.R. 0).
;                  Wird /VALID angegeben, so wird das erste Datum
;                  zurückgeliefert, das wirklich mit EnQueue eingereiht wurde.
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
;-
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
;        Revision 1.1  1997/11/12 17:11:05  kupper
;               Schöpfung der komplexen Datentypen.
;               Die Liste ist noch nicht vollständig implementiert!
;               (Positions-Parameter fehlen noch.)
;               Stacks & Queues sollten hoffentlich vollständig sein.
;


Function Head, Queue, VALID=valid

   If not contains(Queue.info, 'QUEUE', /IGNORECASE) then message, 'Not a Queue!'

   If contains(Queue.info, 'FIXED_QUEUE', /IGNORECASE) then begin
      If Keyword_Set(VALID) then if Queue.valid lt Queue.length then return, Queue.Q(0)
      return, Queue.Q((Queue.Pointer+1) mod Queue.Length)
   endif

   If contains(Queue.info, 'DYNAMIC_QUEUE', /IGNORECASE) then begin
      return, Retrieve(Queue.List, /first) ;bitte der naechste!
   endif

End
