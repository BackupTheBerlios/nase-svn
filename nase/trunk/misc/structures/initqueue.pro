;+
; NAME: InitQueue()
;
;          s.a. EnQueue, DeQueue(), Head(), Tail(), FreeQueue
;
; PURPOSE: Initialisierung einer Queue
;
; CATEGORY: Universell
;
; CALLING SEQUENCE: MyQueue = InitQueue()
;
; OUTPUTS: MyQueue: Eine initialisierte Queue-Struktur, die den
;                   Info-Tag 'DYNAMIC_QUEUE' enthält.
;
; SIDE EFFECTS: Es wird dynamischer Speicher belegt. Daher nach
;               beendigung ein FreeQueue nicht vergessen!
;
; RESTRICTIONS: Keine. Die Queue darf später sogar verschiedene
;               Datentypen incl. Structures, Arrays, Listen, Queues,
;               Stacks oder <UNDEFINED> enthalten.
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
;        Revision 1.1  1997/11/12 17:11:07  kupper
;               Schöpfung der komplexen Datentypen.
;               Die Liste ist noch nicht vollständig implementiert!
;               (Positions-Parameter fehlen noch.)
;               Stacks & Queues sollten hoffentlich vollständig sein.
;
;-

Function InitQueue

   return, {info   : 'DYNAMIC_QUEUE', $
            List   : InitList()}
End
