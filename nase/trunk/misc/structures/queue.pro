;+
; NAME: Queue()
;
;          s.a. InitQueue(), InitFQueue(), EnQueue, DeQueue(), Head(), Tail(), FreeQueue
;
; PURPOSE: Auslesen einer gesamten Fixed-Queue als Array.
;
; CATEGORY: Universell, Simulation
;
; CALLING SEQUENCE: Array = Queue ( MyQueue )
;
; INPUTS: MyQueue: Eine mit InitQueue()
;                  initialisierte Queue-Struktur.
;
; OUTPUTS: Array : Array, das die Elemente der Queue enth�lt, und zwar
;                  das zuletzt eingereihte (neuste) Element am Ende,
;                  und an der Position 0 das �lteste Element, das noch
;                  in der Queue gespeichert ist.
;          
; RESTRICTIONS: Queue ist bisher nur f�r Fixed Queues ( InitFQueue() )
;               implementiert, und die Implementierung fur Dynamic
;               Queues d�rfte problematisch sein, da darin
;               verschiedene Datentypen enthalten sein k�nnen. Daher
;               kann die Ausgabe sicher kein Array sein...
;
; EXAMPLE:    ;Ich habe eine Simulation �ber 100 Zeitschritte, die in
;             ;jedem Schritt ein Float als Ergebnis liefert.
;            
;             Ergebnisse = InitFQueue (100)
;
;             For n=1,100 do begin
;                 < SIMULTION >
;                 EnQueue, Ergebnisse, Ergebnis_dieses_Zeitschritts
;             End
;
;             Plot, Queue( Ergebnisse ) ;Mal mir alle Ergebnisse auf!
;
;             FreeQueue, Ergebnisse    
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 1.1  1997/11/12 17:11:10  kupper
;               Sch�pfung der komplexen Datentypen.
;               Die Liste ist noch nicht vollst�ndig implementiert!
;               (Positions-Parameter fehlen noch.)
;               Stacks & Queues sollten hoffentlich vollst�ndig sein.
;
;-

Function Queue, Queue

   If not contains(Queue.info, 'QUEUE', /IGNORECASE) then message, 'Not a Queue!'

   If contains(Queue.info, 'FIXED_QUEUE', /IGNORECASE) then return, shift(Queue.Q, -Queue.Pointer-1)

   If contains(Queue.info, 'DYNAMIC_QUEUE', /IGNORECASE) then message, 'Not yet implemented for Dynamic Queues!'
End
