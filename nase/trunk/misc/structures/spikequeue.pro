;+
; NAME: 		SpikeQueue
;
; PURPOSE:		En- und Dequeue einer Bounded Queue zur Realisierung eines Spike-Delays
;
; CATEGORY:		MISC/STRUCTURES
;
; CALLING SEQUENCE:	Output = SpikeQueue ( Queue, Input)
;
; INPUTS:		Queue : Eine zuvor mit InitQuikeQueue initialisierte Queue-Struktur
;			Input : (Array von) Booleans - Achtung! Darf nur 0 oder 1 enthalten!
;				 Die Dimension muss mit der Dimension von INIT_DELAYS bei der Initialisierung
;				 übereinstimmen. (Ansonsten wird ein Warnmeldung ausgegeben!)
;
; OUTPUTS:		Output: Der Input von vor (Delay) Zeitschritten (=Aufrufen)
;			
; RESTRICTIONS: 	Input darf nur 0 oder 1 enthalten und muß gleiche Dimension wie INIT_DELAYS haben.
;
; EXAMPLE:              Queue        = InitSpikeQueue( INIT_DELAYS=[0,5,7,100,442,2] )
;                       OutputSpikes = SpikeQueue( Queue, [1,0,1,0,1,0] ) 
;                       FreeSpikeQueue, Queue
;
; SEE ALSO:             <A HREF="#INITSPIKEQUEUE">InitSpikeQueue</A>, <A HREF="#FREESPIKEQUEUE">FreeSpikeQueue</A>, <A HREF="#BASICSPIKEQUEUE">BasicSpikeQueue</A>
;
; MODIFICATION HISTORY: 
;
;       $Log$
;       Revision 1.6  1997/12/02 10:40:22  saam
;             Fehler in Hyperlinks korrigiert
;
;       Revision 1.5  1997/12/02 09:42:25  saam
;            n->o->i->s->r->e->v->r->U
;
;
;-
FUNCTION SpikeQueue, Queue, In

   QIn = In
   FOR i=1,Queue(0) DO BEGIN
      Handle_Value, Queue(i), tmpQu
      QIn = BasicSpikeQueue(tmpQu, QIn)
      Handle_Value, Queue(i), tmpQu, /SET
   END

   RETURN, QIn
END
