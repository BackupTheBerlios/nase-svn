;+
; NAME: kill          ( Ein Gegenstück zu insert. )
;
;             s.a. InitList(), insert, retrieve, FreeList
;
; PURPOSE: Entfernen eines Datums aus einer Liste.
;
; CATEGORY: Universell.
;
; CALLING SEQUENCE: kill, MyList, Position  [,/FIRST] [,/LAST]
;
; INPUTS: MyList   : Eine mit InitList() initialisierte Listenstruktur.
;         Position : Die Position in der Liste, von der ein Datum
;                     entfernt werden soll.
;                     Kann weggelassen werden, wenn /FIRST oder /LAST
;                     angegeben wird.
;
; KEYWORD PARAMETERS: FIRST   : Das Datum ganz vorne in der Liste wird
;                                entfernt. Dies entspricht der Angabe
;                                von 1 im Parameter "Position" (der
;                                damit wegfallen kann.)
;                     LAST    : Das Datum ganz hinten in der Liste wird
;                                entfernt. (Der Parameter "Position"
;                                kann damit wegfallen.)
;
; RESTRICTIONS:
;
;     ACHTUNG!    DER POSITION-PARAMETER IST ZUR ZEIT NOCH NICHT IMPLEMENTIERT!
;                        /FIRST und /LAST funktionieren aber.
;
;     kill braucht -NICHT- für alle Elemente aufgerufen zu werden,
;        wenn die Liste gelöscht werden soll. FreeList() erledigt alle!
;
; PROCEDURE: wie's Sommer
;             einen lehrt...
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
;        Revision 1.1  1997/11/12 17:11:08  kupper
;               Schöpfung der komplexen Datentypen.
;               Die Liste ist noch nicht vollständig implementiert!
;               (Positions-Parameter fehlen noch.)
;               Stacks & Queues sollten hoffentlich vollständig sein.
;
;-

Pro Kill, List, Pos, FIRST=first, LAST=last

   If not contains(List.info, 'LIST', /IGNORECASE) then message, 'Not a List!'
   If List.Last eq List.Hook then message, 'List is empty! Use FreeList/FreeQueue/FreeStack to destroy.'

   If List.First eq List.Last then begin
      Handle_Free, List.First
      List.First = List.hook
      List.Last = List.hook
      return
   endif

   If Keyword_Set(LAST) then begin
      Temp = Handle_Info(List.Last, /PARENT)
      Handle_Free, List.Last
      List.Last = Temp
      return
   endif

   If Keyword_Set(FIRST) then begin
      second = Handle_Info(List.First, /FIRST_CHILD)
      Handle_Move, List.Hook, second, /FIRST_CHILD
      Handle_Free, List.First
      List.First = second
      return
   endif

   If Set(Pos) then message, 'Pos-Parameter noch nicht implementiert!'

   message, 'Kein Positionsparameter angegeben!'

End
