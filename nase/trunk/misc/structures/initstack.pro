;+
; NAME: InitStack()
;
;          s.a. InitStack(), Push, Pop(), FreeStack
;
; PURPOSE: Initialisierung eines Stacks
;
; CATEGORY: Universell
;
; CALLING SEQUENCE: MyStack = InitStack()
;
; OUTPUTS: MyStack: Eine initialisierte Stack-Struktur, die den
;                   Info-Tag 'STACK' enth�lt.
;
; SIDE EFFECTS: Es wird dynamischer Speicher belegt. Daher nach
;               beendigung ein FreeStack nicht vergessen!
;
; RESTRICTIONS: Keine. Der Stack darf sp�ter sogar verschiedene
;               Datentypen incl. Structures, Arrays, Listen, Queues,
;               Stacks oder <UNDEFINED> enthalten.
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
;        Revision 1.1  1997/11/12 17:11:07  kupper
;               Sch�pfung der komplexen Datentypen.
;               Die Liste ist noch nicht vollst�ndig implementiert!
;               (Positions-Parameter fehlen noch.)
;               Stacks & Queues sollten hoffentlich vollst�ndig sein.
;
;-

Function InitStack

   return, {info   : 'STACK', $
            List   : InitList()}
End
