;+
; NAME:
;   Head()
;
; VERSION:
;   $Id$
;
; AIM:
;   returns a queue's leading element without removing it.
;
; PURPOSE:
;   <A>Head()</A> returns the element that is first in a
;   queue, without removing it. That is, (for dynamic queues and
;   fixed queues that are used as bounded queues), <A>Head()</A>
;   yields the same result as <A>DeQueue()</A>, but it does not change
;   the contents of the queue. (Who would be next?)
;   For fixed queues, the contents of the frontmost element space is returned,
;   which may contain the sample element (see description of the VALID
;   keyword).
;
; CATEGORY:
;*  DataStructure
;
; CALLING SEQUENCE:
;*  datum = Head ( MyQueue [,/VALID] )
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
;           With the VALID keyword not set, <A>Head()</A> always
;           returns the contents of the frontmost space in the queue,
;           which may be one of these free places containing the
;           sample element.
;           With VALID set, the leading valid (non-empty) queue entry
;           is returned. I.e. the queue behaves like a bounded queue
;           which my contain fewer elements than the queue's capacity. 
;
; OUTPUTS: 
;   datum:: The queue's leading element
;
; PROCEDURE: 
;   Dynamic queues are implemented via lists. Hence, the operation is
;   mapped to adequate list oerations.
;   For fixed and bounded queues, internal pointers are adequately
;   interpreted as pointers into the buffer.
;
; EXAMPLE:
;*   IDL> MyQueue = InitQueue()
;*
;*   IDL> EnQueue, MyQueue, "erster"       ; immer
;*   IDL> EnQueue, MyQueue, "zweiter"      ; hinten
;*   IDL> EnQueue, MyQueue, "letzter"      ; anstellen!
;*   
;*   IDL> print, Head( MyQueue )           
;*   > erster
;*   IDL> print, Tail( MyQueue )           
;*   > letzter
;*   
;*   IDL> print, DeQueue( MyQueue )        
;*   > erster
;*   IDL> print, DeQueue( MyQueue )        
;*   > zweiter
;*   
;*   IDL> FreeQueue, MyQueue 
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
;        Revision 1.5  2000/10/11 16:50:39  kupper
;        Re-implemented fixed queues to allow for using them as bounded queues
;        also. (HOPE it works...) Implemented dequeue for these queues and
;        implemented detail.
;
;        Revision 1.4  2000/10/11 09:54:24  kupper
;        Changed to work with new double ended fixed queues.
;
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
      If Keyword_Set(VALID) then begin
         return, Queue.Q(cyclic_value(Queue.tail-Queue.valid+1, [0, Queue.Length]))
      endif
      return, Queue.Q(Queue.abshead)
   endif

   If contains(Queue.info, 'DYNAMIC_QUEUE', /IGNORECASE) then begin
      return, Retrieve(Queue.List, /first) ;bitte der naechste!
   endif

End
