;+
; NAME: Head()
;
; AIM: returns a queue's head element without removing it
;
;          s.a. EnQueue, DeQueue(), Head(), Tail(), FreeQueue
;
; PURPOSE: Ansehen (ohne Ausreihen) des Datums am Kopf einer
;          Queue, (d.h. des �ltesten Datums in der Queue.)     (Wer w�re der n�chste?)
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
;                  EnQueue-Aufrufen gef�llt worden, so enth�lt das
;                  Queue-Array in den ersten Eintr�gen den
;                  Initialisierungswert (i.d.R. 0).
;                  Wird /VALID angegeben, so wird das erste Datum
;                  zur�ckgeliefert, das wirklich mit EnQueue eingereiht wurde.
;
; PROCEDURE: Die Queue ist �ber eine Liste implementiert. Alle
;            Vorg�nge werden auf die entsprechenden Listen-Routinen
;            (initlist, insert, retrieve(), kill, freelist) abgew�lzt!
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
;        Revision 1.4  2000/10/11 09:54:24  kupper
;        Changed to work with new double ended fixed queues.
;
;        Revision 1.3  2000/09/25 09:13:13  saam
;        * added AIM tag
;        * update header for some files
;        * fixed some hyperlinks
;
;        Revision 1.2  1998/05/19 19:03:33  kupper
;               VALID f�r Fixed-Queues implementiert.
;
;        Revision 1.1  1997/11/12 17:11:05  kupper
;               Sch�pfung der komplexen Datentypen.
;               Die Liste ist noch nicht vollst�ndig implementiert!
;               (Positions-Parameter fehlen noch.)
;               Stacks & Queues sollten hoffentlich vollst�ndig sein.
;


Function Head, Queue, VALID=valid

   If not contains(Queue.info, 'QUEUE', /IGNORECASE) then message, 'Not a Queue!'

   If contains(Queue.info, 'FIXED_QUEUE', /IGNORECASE) then begin
      If Keyword_Set(VALID) then begin
         if Queue.valid lt Queue.length then return, Queue.Q(cyclic_value(Queue.Pointer-1, [0, Queue.Length]))
      endif
      return, Queue.Q((Queue.Pointer+1) mod Queue.Length)
   endif

   If contains(Queue.info, 'DYNAMIC_QUEUE', /IGNORECASE) then begin
      return, Retrieve(Queue.List, /first) ;bitte der naechste!
   endif

End
