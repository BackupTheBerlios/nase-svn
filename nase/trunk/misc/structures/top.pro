;+
; NAME: Top()
;
;          s.a. Push, Pop(), Top(), FreeStack
;
; PURPOSE: Das obere Datum eines Stacks ansehen. (Was liegt oben?)
;
; CATEGORY: Universell
;
; CALLING SEQUENCE: Datum = Top ( MyStack )
;
; INPUTS: MyStack: Eine mit InitStack()
;                  initialisierte Stack-Struktur.
;
; OUTPUTS: Datum  : Das ausgelesene Datum.
;
; SIDE EFFECTS: Das Element wird -NICHT- vom Stack entfernt.
;
; PROCEDURE: Der Stack ist �ber eine Liste implementiert. Alle
;            Vorg�nge werden auf die entsprechenden Listen-Routinen
;            (initlist, insert, retrieve(), kill, freelist) abgew�lzt!
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
;        Revision 1.1  1997/11/12 17:11:11  kupper
;               Sch�pfung der komplexen Datentypen.
;               Die Liste ist noch nicht vollst�ndig implementiert!
;               (Positions-Parameter fehlen noch.)
;               Stacks & Queues sollten hoffentlich vollst�ndig sein.
;
;-

Function Top, Stack

   If not contains(Stack.info, 'STACK', /IGNORECASE) then message, 'Not a Stack!'

   return, Retrieve(Stack.List, /first) ;immer von oben runter!

End
