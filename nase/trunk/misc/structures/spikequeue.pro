;+
; NAME:                 SpikeQueue
;
; AIM:                  en- and dequeues data from spike queue initialized with <A>InitSpikeQueue</A>
;
; PURPOSE:		En- und Dequeue einer Bounded Queue zur Realisierung eines Spike-Delays
;
; CATEGORY:		MISC STRUCTURES
;
; CALLING SEQUENCE:	Output = SpikeQueue (Queue, Input)
;
; INPUTS:		Queue : Eine zuvor mit InitQuikeQueue initialisierte Queue-Struktur
;			Input : (Array von) Booleans - Achtung. Darf nur 0 oder 1 enthalten.
;				 Die Dimension muss mit der Dimension von INIT_DELAYS bei der Initialisierung
;			        ubereinstimmen. (Ansonsten wird ein Warnmeldung ausgegeben.)
;
; OUTPUTS:		Output: Der Input von vor (Delay) Zeitschritten (Aufrufen)
;			
; RESTRICTIONS: 	Input darf nur 0 oder 1 enthalten und muss gleiche Dimension wie INIT_DELAYS haben.
;
; EXAMPLE:              Queue        = InitSpikeQueue( INIT_DELAYS=[0,5,7,100,442,2] )
;                       OutputSpikes = SpikeQueue( Queue, [1,0,1,0,1,0] ) 
;                       FreeSpikeQueue, Queue
;
; SEE ALSO:             <A>InitSpikeQueue</A>, <A>FreeSpikeQueue</A>, <A>BasicSpikeQueue</A>
;
;-
; MODIFICATION HISTORY: 
;
;       $Log$
;       Revision 1.9  2000/09/27 15:59:36  saam
;       service commit fixing several doc header violations
;
;       Revision 1.8  2000/09/25 09:13:14  saam
;       * added AIM tag
;       * update header for some files
;       * fixed some hyperlinks
;
;       Revision 1.7  2000/04/12 15:57:05  thiel
;           Variable name 'Queue' changed to 'Q' because it was colliding with
;           function name 'Queue'.
;
;       Revision 1.6  1997/12/02 10:40:22  saam
;             Fehler in Hyperlinks korrigiert
;
;       Revision 1.5  1997/12/02 09:42:25  saam
;            n->o->i->s->r->e->v->r->U
;

FUNCTION SpikeQueue, Q, In

   QIn = In
   FOR i=1,Q(0) DO BEGIN
      Handle_Value, Q(i), tmpQu
      QIn = BasicSpikeQueue(tmpQu, QIn)
      Handle_Value, Q(i), tmpQu, /SET
   END

   RETURN, QIn
END
