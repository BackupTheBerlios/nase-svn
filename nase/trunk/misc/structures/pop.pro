;+
; NAME: Pop()
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
;               enth�lt. Ein Aufruf von Pop() mit einem leeren
;               Stack f�hrt zu einer Fehlermeldung.
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
;        Revision 1.1  1997/11/12 17:11:09  kupper
;               Sch�pfung der komplexen Datentypen.
;               Die Liste ist noch nicht vollst�ndig implementiert!
;               (Positions-Parameter fehlen noch.)
;               Stacks & Queues sollten hoffentlich vollst�ndig sein.
;
;-

Function Pop, Stack

   If not contains(Stack.info, 'STACK', /IGNORECASE) then message, 'Not a Stack!'

   List = Stack.List
   Top = Retrieve(List, /first, /NO_COPY) ;immer von oben runter!
   Kill, List, /first
   Stack.List = List
   return, Top

End
