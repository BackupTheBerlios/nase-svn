;+
; NAME: Pop()
;
; AIM: pops data from a stack initialized with <A>InitStack</A>
;
;          s.a. Push, Pop(), Top(), FreeStack
;
; PURPOSE: Ein Datum von einem Stack herunternehmen. (Von oben wegnehmen.)
;
; CATEGORY: Universell
;
; CALLING SEQUENCE: Datum = Pop ( MyStack )
;
; INPUTS: MyStack: Eine mit InitStack()
;                  initialisierte Stack-Struktur.
;
; OUTPUTS: Datum  : Das ausgelesene Datum.
;
; SIDE EFFECTS: Das Element wird vom Stack entfernt.
;               Der belegte dynamische Speicher wird freigegeben.
;
; RESTRICTIONS: Es wird kein Test gemacht, ob der Stack noch Daten
;               enthält. Ein Aufruf von Pop() mit einem leeren
;               Stack führt zu einer Fehlermeldung.
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
;        Revision 1.3  2000/10/11 09:31:00  kupper
;        Added a Temporary().
;
;        Revision 1.2  2000/09/25 09:13:13  saam
;        * added AIM tag
;        * update header for some files
;        * fixed some hyperlinks
;
;        Revision 1.1  1997/11/12 17:11:09  kupper
;               Schöpfung der komplexen Datentypen.
;               Die Liste ist noch nicht vollständig implementiert!
;               (Positions-Parameter fehlen noch.)
;               Stacks & Queues sollten hoffentlich vollständig sein.
;
;-

Function Pop, Stack

   If not contains(Stack.info, 'STACK', /IGNORECASE) then message, 'Not a Stack!'

   List = Stack.List
   Top = Retrieve(List, /first, /NO_COPY) ;immer von oben runter!
   Kill, List, /first
   Stack.List = Temporary(List)
   return, Top

End
