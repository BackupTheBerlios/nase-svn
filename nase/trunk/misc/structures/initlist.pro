;+
; NAME: InitList()
;
;             s.a. <A HREF="#INSERT">insert</A>, <A HREF="#ReTrIeVe">retrieve()</A>, kill, FreeList
;
; PURPOSE: Initialisierung einer Listenstruktur.
;
; CATEGORY: Universell.
;
; CALLING SEQUENCE: MyList = InitList()
;
; INPUTS: -keine-
;
; OUTPUTS: MyList: Eine initialisierte Listenstruktur, auf die die
;                  Befehle
;                                  insert
;                                  retrieve()
;                                  kill
;                                  freelist
;
;                  angewandt werden können.
;
;                  Die Struktur enthält einen Info-Tag und hat folgendes Format:
;
;                  MyList = {info   : 'LIST', $
;                            hook   : (handle), $
;                            first  : (handle), $
;                            last   : (handle)}
;
; SIDE EFFECTS: Belegt dynamischen Speicher, daher Aufruf von freelist
;               nach Beendigung nicht vergessen!
;
; RESTRICTIONS: Keine. Im Gegenteil: Dies ist eine Typunabhängige
;               Liste, d.h. daß bei der Initialisierung nicht
;               festgelegt zu werden braucht, welchen Datentyp die
;               Liste enthalten soll. (Sie kann sogar verschiedene
;               Datentypen gleichzeitig enthalten.)
;
; PROCEDURE: Hook-Handle anfordern, Struktur erzeugen und zurückliefern.
;
; EXAMPLE: MyList = InitList()
;
;          insert, /LAST,  MyList, 'hinten'
;          insert, /FIRST, MyList, 'vorne'
;          insert, /FIRST, MyList, 'vorgedrängelt'
;
;          print, retrieve( /FIRST, MyList )
;
;          kill, /FIRST, MyList
;
;          print, retrieve( /FIRST, MyList )
;
;          FreeList, MyList
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 1.2  1997/11/14 16:36:58  kupper
;               VERSUCH, in den Header Hyperlinks einzubauen.
;
;        Revision 1.1  1997/11/12 17:11:06  kupper
;               Schöpfung der komplexen Datentypen.
;               Die Liste ist noch nicht vollständig implementiert!
;               (Positions-Parameter fehlen noch.)
;               Stacks & Queues sollten hoffentlich vollständig sein.
;
;-

Function InitList

   hook = Handle_Create()

   return, {info   : 'LIST', $
            hook   : hook, $
            first  : hook, $
            last   : hook}
End
