;+
; NAME: retrieve()          ( Ein Gegenstück zu insert. )
;
; AIM: retrieves data from arbitrary positions of a general list initialized with <A>InitList</A>
;
;             s.a. InitList(), insert, kill, FreeList
;
; PURPOSE: Auslesen eines Datums aus einer Liste.
;
; CATEGORY: Universell.
;
; CALLING SEQUENCE: Result = retrieve( MyList, Position [,/FIRST] [,/LAST] [,/NO_COPY])
;
; INPUTS: MyList   : Eine mit InitList() initialisierte Listenstruktur.
;         Position : Die Position in der Liste, von der das Datum
;                     gelesen werden soll.
;                     Kann weggelassen werden, wenn /FIRST oder /LAST
;                     angegeben wird.
;
; OUTPUTS: Das an der entsprechenden Position in MyList geseicherte Datum.
;
; KEYWORD PARAMETERS: FIRST   : Das Datum ganz vorne in der Liste wird
;                                zurückgegeben. Dies entspricht der Angabe
;                                von 1 im Parameter "Position" (der
;                                damit wegfallen kann.)
;                     LAST    : Das Datum ganz hinten in der Liste wird
;                                zurückgegeben. (Der Parameter "Position"
;                                kann damit wegfallen.)
;                     NO_COPY : Wie bei den meisten IDL-Routinen, die
;                                Daten übertragen, bewirkt die Angebe
;                                dieses Schlüsselwortes, daß der
;                                Wert von "Datum" nicht kopiert,
;                                sondern direkt der Queue entnommen
;                                wird. In diesem Fall ist der Datentyp,
;                                der in der Liste verbleibt <Undefined>.
;                      ACHTUNG!  DAS IST IN DER REGEL -NICHT- SINNVOLL!
;                                Von der Verwendung des
;                                NO_COPY-Schlüsselwortes wird daher
;                                abgeraten. Es ist im wesentlichen
;                                implementiert, da es für die
;                                Implementierung von DeQueue() und
;                                Pop() nützlich ist.
;
; RESTRICTIONS:
;
;     ACHTUNG!    DER POSITION-PARAMETER IST ZUR ZEIT NOCH NICHT IMPLEMENTIERT!
;                        /FIRST und /LAST funktionieren aber.
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
;-
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 1.2  2000/09/25 09:13:14  saam
;        * added AIM tag
;        * update header for some files
;        * fixed some hyperlinks
;
;        Revision 1.1  1997/11/12 17:11:10  kupper
;               Schöpfung der komplexen Datentypen.
;               Die Liste ist noch nicht vollständig implementiert!
;               (Positions-Parameter fehlen noch.)
;               Stacks & Queues sollten hoffentlich vollständig sein.
;


Function Retrieve, List, Pos, FIRST=first, LAST=last, NO_COPY=no_copy

   If not contains(List.info, 'LIST', /IGNORECASE) then message, 'Not a List!'
   If List.Last eq List.Hook then message, 'List is empty! Use FreeList/FreeQueue/FreeStack to destroy.'

   If Keyword_Set(LAST) then begin
      Handle_Value, List.Last, Wert, NO_COPY=no_copy
      return, Wert
   endif

   If Keyword_Set(FIRST) then begin
      Handle_Value, List.First, Wert, NO_COPY=no_copy
      return, Wert
   endif

   If Set(Pos) then message, 'Pos-Parameter noch nicht implementiert!'

End

