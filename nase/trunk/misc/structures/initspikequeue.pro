;+
; NAME: 		InitSpikeQueue
;
; PURPOSE:		Bounded Queue zur realisierung eines Spike-Delays von bis zu 15 Zeitschritten
;
; CATEGORY:		Neuro-Simulation
;
; CALLING SEQUENCE:	My_Queue = InitSpikeQueue ( INIT_DELAYS = Delay_Array )
;
; INPUTS:	        ---
;
; OPTIONAL PARAMETERS:  ---
;
; KEYWORD PARAMETERS:	INIT_DELAYS: Wird dieser Parameter angegeben, so wird ein leere Queue erzeugt.
;				     Die Dimension des Arrays gibt an, wieviele Spiketrains die Queue fassen soll.
;				     Die Werte geben das Delay für jeden Spiketrain in Zeitschritten (=Aufrufschritten)
;				     an. Erlaubte Werte sind 0..15. (Für 0 wird der Input sofort wieder ausgegeben!)
;	
; OUTPUTS:		My_Queue: Eine leere Queue mit entsprechenden Delays
;
; OPTIONAL OUTPUTS: -
;
; COMMON BLOCKS: -
;
; SIDE EFFECTS: -
;
; RESTRICTIONS: 	Input darf nur 0 oder 1 enthalten und muß gleiche Dimension wie INIT_DELAYS haben.
;			INIT_DELAYS darf nur Integer im Bereich 0..15 enthalten!		
;
; PROCEDURE: -
;
; EXAMPLE: Ruedigers_Qeueu   = InitSpikeQueue( INIT_DELAYS=[0,5,7] )  ; erzeugt eine Queue für drei Spiketrains mit den Delays 0, 5 und 7		
;          Ankommende_Spikes = SpikeQueue( Ruedigers_Queue, [1,0,1] ) ; Steckt in die erste und dritte Queue einen Spike,
;									und liest am anderen Ende je einen Spike aus.
;
; MODIFICATION HISTORY: 
;
;       Thu Aug 14 16:06:05 1997, Mirko Saam
;       <saam@ax1317.Physik.Uni-Marburg.DE>
;
;		Urversion, entstanden aus spikequeue.pro Version 1.1
;                       
;
;-

FUNCTION InitSpikeQueue, INIT_DELAYS=init_delays

   Queue={Q     : intarr(n_elements(init_delays)), $
          starts: fix(2^init_delays)}
   
   RETURN, Queue

end
