;+
; NAME: Push
;
;          s.a. Push, Pop(), Top(), FreeStack
;
; PURPOSE: Ein Datum auf einen Stack legen. (Immer oben drauf!)
;
; CATEGORY: Universell
;
; CALLING SEQUENCE: Push, MyStack, Datum  [,/NO_COPY]
;
; INPUTS: MyStack: Eine mit InitStack() 
;                  initialisierte Stack-Struktur.
;         Datum  : Das aufzulegende Datum. Dieses kann
;                  von beliebigem
;                  Typ sein (alle IDL-Typen incl. Strukturen, Arrays,
;                  Listen, Stacks, Stacks oder <UNDEFINED>).
;
; KEYWORD PARAMETERS: NO_COPY : Wie bei den meisten IDL-Routinen, die
;                                Daten übertragen, bewirkt die Angabe
;                                dieses Schlüsselwortes, daß der
;                                Inhalt von "Datum" nicht kopiert,
;                                sondern direkt teil des Stacks
;                                wird. Dies hat nur Effekt, wenn in
;                                "Datum" eine Variable übergeben
;                                wird. In diesem Fall ist der Datentyp
;                                der Variable nach dem Aufruf <Undefined>.
;
; SIDE EFFECTS: Es wird dynamischer Speicher belegt. Daher nach
;               beendigung ein FreeStack nicht vergessen!
;
; RESTRICTIONS: Keine. Der Stack darf sogar verschiedene
;               Datentypen incl. Structures, Arrays, Listen, Stacks,
;               Stacks oder <UNDEFINED> gleichzeitig enthalten.
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
;        Revision 1.1  1997/11/12 17:11:09  kupper
;               Schöpfung der komplexen Datentypen.
;               Die Liste ist noch nicht vollständig implementiert!
;               (Positions-Parameter fehlen noch.)
;               Stacks & Queues sollten hoffentlich vollständig sein.
;
;-

Pro Push, Stack, Wert

   If not contains(Stack.info, 'STACK', /IGNORECASE) then message, 'Not a Stack!'

   List = Stack.List

   Insert, List, Wert, /first ;immer oben drauf!

   Stack.List = List
End
