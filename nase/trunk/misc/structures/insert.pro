;+
; NAME: insert          ( Das Gegenstück zu retrieve(). )
;
;             s.a. InitList(), retrieve(), kill, FreeList
;
; PURPOSE: Einfügen eines Datums in eine Liste.
;
; CATEGORY: Universell.
;
; CALLING SEQUENCE: Insert,   MyList, Datum, Position  [,/FIRST] [,/LAST] [,/NO_COPY]
;
; INPUTS: MyList   : Eine mit InitList() initialisierte Listenstruktur.
;         Datum    : Das einzufügende Datum. Dies kann jeden
;                     IDL-üblichen Datentyp haben (auch Arrays,
;                     Strukturen, Handles,... ,Listen, Stacks, Queues,... ,
;                     sogar den Typ <Undefined>.)
;         Position : Die Position in der Liste, an der das Datum
;                     eingefügt werden soll (d.h. nach dem Einfügen
;                     ist es das Position-te Element in der Liste.)
;                     Kann weggelassen werden, wenn /FIRST oder /LAST
;                     angegeben wird.
;
; KEYWORD PARAMETERS: FIRST   : Das Datum wird ganz vorne in der Liste
;                                eingetragen. Dies entspricht der Angabe
;                                von 1 im Parameter "Position" (der
;                                damit wegfallen kann.)
;                     LAST    : Das Datum wird ganz hinten in der Liste
;                                eingetagen. (Der Parameter "Position"
;                                kann damit wegfallen.)
;                     NO_COPY : Wie bei den meisten IDL-Routinen, die
;                                Daten übertragen, bewirkt die Angabe
;                                dieses Schlüsselwortes, daß der
;                                Inhalt von "Datum" nicht kopiert,
;                                sondern direkt teil der Liste
;                                wird. Dies hat nur Effekt, wenn in
;                                "Datum" eine Variable übergeben
;                                wird. In diesem Fall ist der Datentyp
;                                der Variable nach dem Aufruf <Undefined>.
;
; SIDE EFFECTS: Belegt dynamischen Speicher, daher Aufruf von freelist
;               nach Beendigung nicht vergessen!
;
; RESTRICTIONS: Keine. Im Gegenteil: Dies ist eine Typunabhängige
;               Liste, d.h. sie kann sogar verschiedene
;               Datentypen gleichzeitig enthalten.
;
;     ACHTUNG!    DER POSITION-PARAMETER IST ZUR ZEIT NOCH NICHT IMPLEMENTIERT!
;                        /FIRST und /LAST funktionieren aber.
;
; PROCEDURE: Handle anfordern, belegen und einfügen, wie's Sommer
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

Pro Insert, List, Wert, Pos, FIRST=first, LAST=last, NO_COPY=no_copy

   If not contains(List.info, 'LIST', /IGNORECASE) then message, 'Not a List!'

   If List.First eq List.hook then begin
      List.First = Handle_Create(List.hook)
      Handle_Value, List.First, Wert, /SET, NO_COPY=no_copy
      List.Last = List.First
      return
   endif

   If Keyword_Set(LAST) then begin
      List.Last = Handle_Create(List.Last)
      Handle_Value, List.Last, Wert, /SET, NO_COPY=no_copy
      If List.First eq List.hook then List.First = List.Last
      return
   endif

   If Keyword_Set(FIRST) then begin
      Temp = Handle_Create(List.Hook, /FIRST_CHILD)
      Handle_Move, Temp, List.First, /FIRST_CHILD
      List.First = Temp
      Handle_Value, List.First, Wert, /SET, NO_COPY=no_copy
      If List.Last eq List.hook then List.Last = List.First
      return
   endif

   If Set(Pos) then message, 'Pos-Parameter noch nicht implementiert!'

   message, 'Keine Position angegeben!'
End
