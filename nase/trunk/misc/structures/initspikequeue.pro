;+
; NAME: InitSpikeQueue
;
; AIM: initializes queue for efficient storage of binary arrays
;
; PURPOSE: Initialisierung einer Bounded Queue zur Realisierung eines 
;          Spike-Delays.
;
; CATEGORY: MISCELLANEOUS / DATA STRUCTURES
;
; CALLING SEQUENCE: Queue = InitSpikeQueue ( INIT_DELAYS = Delay_Array )
;
; INPUTS: delay_array: Die Dimension des Arrays gibt an, wieviele Spiketrains 
;                      (Kanäle) die Queue fassen soll. Die Werte geben das 
;                      Delay für jeden Spikekanal in Zeitschritten 
;                      (=Aufrufschritten) an. Erlaubte Werte sind alle 
;                      natürlichen Zahlen. 
;                      (Für 0 wird der Input sofort wieder ausgegeben!)
;	
; OUTPUTS: Queue: Eine leere Queue mit entsprechenden Delays.
;                 Queue ist ein Long-Array mit den Einträgen:
;                 queue(0): Die Zahl der BasicSpikequeues, aus denen die
;                           gsamte Spikequeue zusammengesetzt ist.
;                 queue(1:queue(0)): Handles auf die BasicSpikequeues.
;                 queue(queue(0)+1:N_Elemenets(queue).1): Die tatsächlichen
;                                                         Delays der einzelnen
;                                                         Kanäle.
;                 
; EXAMPLE: Queue        = InitSpikeQueue( INIT_DELAYS=[0,5,7,100,442,2] )
;          OutputSpikes = SpikeQueue( Queue, [1,0,1,0,1,0] ) 
;          FreeSpikeQueue, Queue
;
; PROCEDURE: Diese Routinen benutzen die BasicSpikeQueues, indem sie 
;            entsprechend viele davon hintereinanderschalten.
;            Die Aufrufsyntax wurde erhalten, lediglich die Beschränkung auf 
;            ein maximales Delay von 30 fällt weg.
;
; SEE ALSO: <A HREF="#SPIKEQUEUE">SpikeQueue</A>, <A HREF="#FREESPIKEQUEUE">FreeSpikeQueue</A>, <A HREF="#INITBASICSPIKEQUEUE">InitBasicSpikeQueue</A>
;
; MODIFICATION HISTORY: 
;
;       $Log$
;       Revision 1.7  2000/09/25 09:13:13  saam
;       * added AIM tag
;       * update header for some files
;       * fixed some hyperlinks
;
;       Revision 1.6  1999/07/28 12:53:53  thiel
;           Returned array now also contains the overall delays.
;
;       Revision 1.5  1997/12/18 11:37:39  saam
;             fieser Rundungsfehler bei Float-Delays
;
;       Revision 1.4  1997/12/02 09:42:24  saam
;            n->o->i->s->r->e->v->r->U
;
;
;-
FUNCTION InitSpikeQueue, INIT_DELAYS=init_delays

   tmpDelay = init_delays
   md       = ROUND(MAX(tmpDelay))
   
   numQu = (md-1)/30 + 1
   
;last version:   Qu    = LonArr(numQu+1) 
;now: longer array to save delays explicitly

   qu = LonArr(numqu+1+N_Elements(tmpdelay))
   Qu(0) = numQu ; Number of BasicSpikeQueues

   qu(numqu+1:N_Elements(qu)-1) = Round(tmpdelay)

   FOR i=1,numQu DO BEGIN
      Qu(i) = Handle_Create(VALUE=InitBasicSpikeQueue(INIT_DELAYS=(tmpDelay < 30)))
      tmpDelay = tmpDelay - (tmpDelay < 30)
   END

   RETURN, Qu
END
