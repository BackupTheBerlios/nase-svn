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
;                  angewandt werden k�nnen.
;
;                  Die Struktur enth�lt einen Info-Tag und hat folgendes Format:
;
;                  MyList = {info   : 'LIST', $
;                            hook   : (handle), $
;                            first  : (handle), $
;                            last   : (handle)}
;
; SIDE EFFECTS: Belegt dynamischen Speicher, daher Aufruf von freelist
;               nach Beendigung nicht vergessen!
;
; RESTRICTIONS: Keine. Im Gegenteil: Dies ist eine Typunabh�ngige
;               Liste, d.h. da� bei der Initialisierung nicht
;               festgelegt zu werden braucht, welchen Datentyp die
;               Liste enthalten soll. (Sie kann sogar verschiedene
;               Datentypen gleichzeitig enthalten.)
;
; PROCEDURE: Hook-Handle anfordern, Struktur erzeugen und zur�ckliefern.
;
; EXAMPLE: MyList = InitList()
;
;          insert, /LAST,  MyList, 'hinten'
;          insert, /FIRST, MyList, 'vorne'
;          insert, /FIRST, MyList, 'vorgedr�ngelt'
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
;               Sch�pfung der komplexen Datentypen.
;               Die Liste ist noch nicht vollst�ndig implementiert!
;               (Positions-Parameter fehlen noch.)
;               Stacks & Queues sollten hoffentlich vollst�ndig sein.
;
;-

Function InitList

   hook = Handle_Create()

   return, {info   : 'LIST', $
            hook   : hook, $
            first  : hook, $
            last   : hook}
End
