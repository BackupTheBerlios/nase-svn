;+
; NAME: Queue()
;
; AIM: returns all elements of a fixed queue initialized with <A>InitFQueue</A>
;
;          s.a. InitQueue(), InitFQueue(), EnQueue, DeQueue(), Head(), Tail(), FreeQueue
;
; PURPOSE: Auslesen einer gesamten Fixed-Queue als Array.
;
; CATEGORY: Universell, Simulation
;
; CALLING SEQUENCE: Array = Queue ( MyQueue [,/VALID] )
;
; INPUTS: MyQueue: Eine mit InitQueue()
;                  initialisierte Queue-Struktur.
;
; OUTPUTS: Array : Array, das die Elemente der Queue enthält, und zwar
;                  das zuletzt eingereihte (neuste) Element am Ende,
;                  und an der Position 0 das älteste Element, das noch
;                  in der Queue gespeichert ist.
;
; KEYWORDS: VALID: Ist eine Fixed Queue noch nicht bis zum Rand mit
;                  EnQueue-Aufrufen gefüllt worden, so enthält das
;                  Queue-Array in den ersten Einträgen den
;                  Initialisierungswert (i.d.R. 0).
;                  Wird /VALID angegeben, so wird nur der Teil des
;                  Arrays zurückgeliefert, der wirklich Daten enthält, 
;                  die mit EnQueue eingereiht wurden.
;          
; RESTRICTIONS: Queue ist bisher nur für Fixed Queues ( InitFQueue() )
;               implementiert, und die Implementierung fur Dynamic
;               Queues dürfte problematisch sein, da darin
;               verschiedene Datentypen enthalten sein können. Daher
;               kann die Ausgabe sicher kein Array sein...
;
; EXAMPLE:    ;Ich habe eine Simulation über 100 Zeitschritte, die in
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
;-
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 1.6  2000/10/11 16:50:39  kupper
;        Re-implemented fixed queues to allow for using them as bounded queues
;        also. (HOPE it works...) Implemented dequeue for these queues and
;        implemented detail.
;
;        Revision 1.5  2000/10/10 14:13:06  kupper
;        re-implemented handling of VALID Keyword, to allow for partially
;        filled queues not starting at first element (which allows
;        implementation of DeQueue for Fixed Queues.)
;
;        Revision 1.4  2000/09/25 09:13:14  saam
;        * added AIM tag
;        * update header for some files
;        * fixed some hyperlinks
;
;        Revision 1.3  1998/06/20 13:51:11  kupper
;               Funktionierte nicht bei Queues der Laenge 1 (offensichtlich gings mit IDL4 aus irgendwelchen Gruenden...)
;
;        Revision 1.2  1998/05/19 18:58:44  kupper
;               VALID implementiert.
;
;        Revision 1.1  1997/11/12 17:11:10  kupper
;               Schöpfung der komplexen Datentypen.
;               Die Liste ist noch nicht vollständig implementiert!
;               (Positions-Parameter fehlen noch.)
;               Stacks & Queues sollten hoffentlich vollständig sein.
;


Function Queue, Queue, VALID=valid

   If not contains(Queue.info, 'QUEUE', /IGNORECASE) then message, 'Not a Queue!'

   If contains(Queue.info, 'FIXED_QUEUE', /IGNORECASE) then begin
      If Keyword_Set(VALID) then begin
         assert, Queue.valid gt 0, "Fixed queue does not contain any " + $
          "valid elements."
         return, (shift([Queue.Q], $
                        -cyclic_value(Queue.tail-Queue.valid+1, [0, Queue.length])))(0:Queue.valid-1)
      endif
      return, shift([Queue.Q], -Queue.abshead)
   EndIf

   If contains(Queue.info, 'DYNAMIC_QUEUE', /IGNORECASE) then message, 'Not yet implemented for Dynamic Queues!'
End
