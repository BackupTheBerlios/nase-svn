;+
; NAME: FreeStack          ( Gegenstück zu InitStack(). )
;
;          s.a. Push, Pop(), Top(), FreeStack
;
; PURPOSE: Löschen eines gesamten Stacks und freigeben des (dynamischen) Speichers.
;
; CATEGORY: Universell.
;
; CALLING SEQUENCE: FreeStack, MyStack
;
; INPUTS: MyStack  : Eine mit InitStack() initialisierte
;                    Stackstruktur, die auch noch Daten enthalten
;                    darf.
;        
; RESTRICTIONS:
;     FreeStack erledigt alle!
;     Pop() braucht -NICHT- für alle Elemente aufgerufen zu werden,
;        wenn der Stack gelöscht werden soll. 
;
; PROCEDURE: Der Stack ist über eine Liste implementiert. Alle
;            Vorgänge werden auf die entsprechenden Listen-Routinen
;            (initlist, insert, retrieve(), kill, freelist) abgewälzt!
;
; EXAMPLE: MyStack = InitStack()
;
;          Push, MyStack, "erster"       ; immer
;          Push, MyStack, "zweiter"      ; oben
;          Push, MyStack, "letzter"      ; drauf!
;
;          print, Top( MyStack )          -> Ausgabe: "letzter"
;
;          print, Pop( MyStack )          -> Ausgabe: "letzter"
;          print, Pop( MyStack )          -> Ausgabe: "zweiter"
;          print, Pop( MyStack )          -> Ausgabe: "erster"
;
;          FreeStack, MyStack
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

Pro FreeStack, Stack

   If not contains(Stack.info, 'STACK', /IGNORECASE) then message, 'Not a Stack!'

   FreeList, Stack.List

End
