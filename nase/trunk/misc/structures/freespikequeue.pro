;+
; NAME: 		FreeSpikeQueue
;
; AIM:                  frees queue initialized with <A>InitSpikeQueue</A>
;
; PURPOSE:		Gibt den von einer SpikeQueue allokierten Speicher wieder frei
;
; CATEGORY:		MISC/STRUCTURES
;
; CALLING SEQUENCE:	FreeSpikeQueue, Queue
;
; INPUTS:               Queue: eine mit InitSpikeQueue initialisierte SpikeQueue
;	
; EXAMPLE:              Queue        = InitSpikeQueue( INIT_DELAYS=[0,5,7,100,442,2] )
;                       OutputSpikes = SpikeQueue( Queue, [1,0,1,0,1,0] ) 
;                       FreeSpikeQueue, Queue
;
; SEE ALSO:             <A HREF="#INITSPIKEQUEUE">InitSpikeQueue</A>, <A HREF="#SPIKEQUEUE">SpikeQueue</A>
;
; MODIFICATION HISTORY: 
;
;       $Log$
;       Revision 1.2  2000/09/25 09:13:13  saam
;       * added AIM tag
;       * update header for some files
;       * fixed some hyperlinks
;
;       Revision 1.1  1997/12/02 09:42:25  saam
;            n->o->i->s->r->e->v->r->U
;
;
;-
PRO FreeSpikeQueue, Qu

   FOR i=1,Qu(0) DO BEGIN
      Handle_Free, Qu(i)
   END

END
