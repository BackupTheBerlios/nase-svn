;+
; NAME: FreeList          ( Gegenst�ck zu InitList(). )
;
;             s.a. InitList(), insert, retrieve, kill
;
; PURPOSE: L�schen einer gesamten Liste und freigeben des dynamischen Speichers.
;
; CATEGORY: Universell.
;
; CALLING SEQUENCE: FreeList, MyList
;
; INPUTS: MyList   : Eine mit InitList() initialisierte
;                    Listenstruktur, die auch noch Daten enthalten
;                    darf.
;        
; RESTRICTIONS:
;
;     FreeList erledigt alle!
;     kill braucht -NICHT- f�r alle Elemente aufgerufen zu werden,
;        wenn die Liste gel�scht werden soll. 
;
; PROCEDURE: Hook-Handle freigeben. (Das ist alles...)
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
;        Revision 1.1  1997/11/12 17:11:04  kupper
;               Sch�pfung der komplexen Datentypen.
;               Die Liste ist noch nicht vollst�ndig implementiert!
;               (Positions-Parameter fehlen noch.)
;               Stacks & Queues sollten hoffentlich vollst�ndig sein.
;
;-

Pro FreeList, List

   If not contains(List.info, 'LIST', /IGNORECASE) then message, 'Not a List!'

   Handle_Free, List.hook
   List.info = "DELETED"

End
