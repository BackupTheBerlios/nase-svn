;+
; NAME: 		InitSpikeQueue
;
; PURPOSE:		Initialisierung einer Bounded Queue zur Realisierung eines Spike-Delays
;
; CATEGORY:		MISC/STRUCTURES
;
; CALLING SEQUENCE:	Queue = InitSpikeQueue ( INIT_DELAYS = Delay_Array )
;
; KEYWORD PARAMETERS:	INIT_DELAYS: Die Dimension des Arrays gibt an, wieviele Spiketrains die Queue fassen soll.
;				     Die Werte geben das Delay für jeden Spiketrain in Zeitschritten (=Aufrufschritten)
;				     an. Erlaubte Werte sind alle natuerlichen Zahlen. (Für 0 wird der Input sofort wieder ausgegeben!)
;	
; OUTPUTS:		Queue: Eine leere Queue mit entsprechenden Delays
;
; EXAMPLE:              Queue        = InitSpikeQueue( INIT_DELAYS=[0,5,7,100,442,2] )
;                       OutputSpikes = SpikeQueue( Queue, [1,0,1,0,1,0] ) 
;                       FreeSpikeQueue, Queue
;
; PROCEDURE:            Diese Routinen benutzen die BasicSpikeQueues, indem sie entsprechend viele davon hintereinanderschalten.
;                       Die Aufrufsyntax wurde erhalten, lediglich die Beschraenkung auf eine maximales Delay von 30 faellt weg.
;
; SEE ALSO:             <A HREF="#SPIKEQUEUE">SpikeQueue</A>, <A HREF="#FREESPIKEQUEUE">FreeSpikeQueue</A>, <A HREF="#INITBASICSPIKEQUEUE">InitBasicSpikeQueue</A>
;
; MODIFICATION HISTORY: 
;
;       $Log$
;       Revision 1.4  1997/12/02 09:42:24  saam
;            n->o->i->s->r->e->v->r->U
;
;
;-
FUNCTION InitSpikeQueue, INIT_DELAYS=init_delays

   tmpDelay = init_delays
   md       = MAX(tmpDelay)
   
   numQu = (md-1)/30 + 1
   
   Qu    = LonArr(numQu+1)
   Qu(0) = numQu

   FOR i=1,numQu DO BEGIN
      Qu(i) = Handle_Create(VALUE=InitBasicSpikeQueue(INIT_DELAYS=(tmpDelay < 30)))
      tmpDelay = tmpDelay - (tmpDelay < 30)
   END

   RETURN, Qu
END
