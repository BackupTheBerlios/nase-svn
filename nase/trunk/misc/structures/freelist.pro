;+
; NAME: FreeList          ( Gegenstück zu InitList(). )
;
; AIM: frees a general list initialized with <A>InitList</A>
;
;             s.a. InitList(), insert, retrieve, kill
;
; PURPOSE: Löschen einer gesamten Liste und freigeben des dynamischen Speichers.
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
;     kill braucht -NICHT- für alle Elemente aufgerufen zu werden,
;        wenn die Liste gelöscht werden soll. 
;
; PROCEDURE: Hook-Handle freigeben. (Das ist alles...)
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
;        Revision 1.2  2000/09/25 09:13:13  saam
;        * added AIM tag
;        * update header for some files
;        * fixed some hyperlinks
;
;        Revision 1.1  1997/11/12 17:11:04  kupper
;               Schöpfung der komplexen Datentypen.
;               Die Liste ist noch nicht vollständig implementiert!
;               (Positions-Parameter fehlen noch.)
;               Stacks & Queues sollten hoffentlich vollständig sein.
;
;-

Pro FreeList, List

   If not contains(List.info, 'LIST', /IGNORECASE) then message, 'Not a List!'

   Handle_Free, List.hook
   List.info = "DELETED"

End
