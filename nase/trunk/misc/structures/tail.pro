;+
; NAME:
;   Tail()
;
; VERSION:
;   $Id$
;
; AIM:
;   returns a queue's trailing element without removing it.
;
; PURPOSE:
;   <A>Tail()</A> returns the element that is last in a
;   queue, without removing it. That is, (for dynamic queues and
;   fixed queues that are used as bounded queues), <A>Tail()</A>
;   yields the same result as <A>DeTail()</A>, but it does not change
;   the contents of the queue. (Who was last?)
;   For fixed queues, the contents of the last element space is returned,
;   which may contain the sample element (see description of the VALID
;   keyword).
;
; CATEGORY:
;*  DataStructure
;
; CALLING SEQUENCE:
;*  datum = Tail ( MyQueue [,/VALID] )
;
; INPUTS:
;   MyQueue:: A queue structure that was initialized using
;             <A>InitQueue()</A> or <A>InitFQueue()</A>.
;
; INPUT KEYWORDS:
;   VALID:: This keyword applies to fixed queues only. It makes fixed
;           queues behave like bounded queues. 
;
;           If a fixed queue is not yet filled completely with
;           elements, some element spaces  of the queue still contain the
;           sample element that was specified togeteher with the
;           <A>InitFQueue()</A> command.  In addition, if elements are
;           removed by the <A>DeQueue()</A> or <A>DeTail()</A>
;           command, the freed spaces are set to the sample element.
;           With the VALID keyword not set, <A>Tail()</A> always
;           returns the contents of the last space in the queue,
;           which may be one of these free places containing the
;           sample element.
;           With VALID set, the last valid (non-empty) queue entry
;           is returned. I.e. the queue behaves like a bounded queue
;           which my contain fewer elements than the queue's capacity. 
;
; OUTPUTS: 
;   datum:: The queue's trailing element
;
; PROCEDURE: 
;   Dynamic queues are implemented via lists. Hence, the operation is
;   mapped to adequate list oerations.
;   For fixed and bounded queues, internal pointers are adequately
;   interpreted as pointers into the buffer.
;
; EXAMPLE:
;*   MyQueue = InitQueue()
;*
;*   EnQueue, MyQueue, "erster"       ; immer
;*   EnQueue, MyQueue, "zweiter"      ; hinten
;*   EnQueue, MyQueue, "letzter"      ; anstellen!
;*   
;*   print, Head( MyQueue )           
;*   > erster
;*   print, Tail( MyQueue )           
;*   > letzter
;*   
;*   print, DeQueue( MyQueue )        
;*   > erster
;*   print, DeQueue( MyQueue )        
;*   > zweiter
;*   
;*   FreeQueue, MyQueue 
;
; SEE ALSO:
;   <A>EnQueue</A>, <A>DeQueue()</A>, <A>DeTail</A>, <A>Head()</A>,
;   <A>Tail()</A>, <A>FreeQueue</A>, <A>InitQueue()</A>, <A>InitFQueue()</A>
;
;-
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 1.4  2000/10/16 14:13:08  kupper
;        Header polishing.
;
;        Revision 1.3  2000/10/11 16:50:39  kupper
;        Re-implemented fixed queues to allow for using them as bounded queues
;        also. (HOPE it works...) Implemented dequeue for these queues and
;        implemented detail.
;
;        Revision 1.2  2000/09/25 09:13:14  saam
;        * added AIM tag
;        * update header for some files
;        * fixed some hyperlinks
;
;        Revision 1.1  1997/11/12 17:11:10  kupper
;               Schöpfung der komplexen Datentypen.
;               Die Liste ist noch nicht vollständig implementiert!
;               (Positions-Parameter fehlen noch.)
;               Stacks & Queues sollten hoffentlich vollständig sein.
;
;

Function Tail, Queue, VALID=valid

   If contains(Queue.info, 'FIXED_QUEUE', /IGNORECASE) then begin
      If Keyword_Set(Valid) then begin
         return, Queue.Q(Queue.tail)
      endif else begin
         return, Queue.Q( (Queue.abshead+Queue.length-1) mod $
                          Queue.length )
      endelse
   endif

   If contains(Queue.info, 'DYNAMIC_QUEUE', /IGNORECASE) then begin
      return, Retrieve(Queue.List, /last) ;der letzte in der Reihe!
   endif

End
