;+
; NAME: 		SpikeQueue
;
;
;
; PURPOSE:		Bounded Queue zur realisierung eines Spike-Delays von bis zu 15 Zeitschritten
;
;
;
; CATEGORY:		Neuro-Simulation
;
;
;
; CALLING SEQUENCE:	Initialisierung: My_Queue = SpikeQueue ( INIT_DELAYS = Delay_Array )
;      		   	Aufruf         :   Output = SpikeQueue ( My_Queue, Input)
;
; 			
; INPUTS:		My_Queue: Eine zuvor initialisierte Queue-Struktur
;			Input   : (Array von) Booleans - Achtung! Darf nur 0 oder 1 enthalten!
;				  Die Dimension muss mit der Dimension von INIT_DELAYS bei der Initialisierung
;				  übereinstimmen. (Ansonsten wird ein Warnmeldung ausgegeben!)
;
; OPTIONAL PARAMETERS: -
;
; KEYWORD PARAMETERS:	INIT_DELAYS: Wird dieser Parameter angegeben, so wird ein leere Queue erzeugt.
;				     Die Dimension des Arrays gibt an, wieviele Spiketrains die Queue fassen soll.
;				     Die Werte geben das Delay für jeden Spiketrain in Zeitschritten (=Aufrufschritten)
;				     an. Erlaubte Werte sind 0..15. (Für 0 wird der Input sofort wieder ausgegeben!)
;	
;
; OUTPUTS:		Wenn INIT_DELAYS nicht angegeben wurde:
;                        	Output: Der Input von vor (Delay) Zeitschritten (=Aufrufen)
;			
;			Wenn INIT_DELAYS angegeben wurde:
;				Output: Eine leere Queue mit entsprechenden Delays
;
; OPTIONAL OUTPUTS: -
;
;
;
; COMMON BLOCKS: -
;
;
;
; SIDE EFFECTS: -
;
;
;
; RESTRICTIONS: 	Input darf nur 0 oder 1 enthalten und muß gleiche Dimension wie INIT_DELAYS haben.
;			INIT_DELAYS darf nur Integer im Bereich 0..15 enthalten!		
;
;
; PROCEDURE: -
;
;
;
; EXAMPLE: Ruedigers_Qeueu   = SpikeQueue( INIT_DELAYS=[0,5,7] )  ; erzeugt eine Queue für drei Spiketrains mit den Delays 0, 5 und 7		
;          Ankommende_Spikes = SpikeQueue( Ruedigers_Queue, [1,0,1] ) ; Steckt in die erste und dritte Queue einen Spike,
;									und liest am anderen Ende je einen Spike aus.
;
; MODIFICATION HISTORY: Erstellt am 22.7.1997, Rüdiger
;
;-

Function SpikeQueue, Queue, In, INIT_DELAYS=init_delays
	if n_elements(init_delays) NE 0 then begin

		Queue={Q     : intarr(n_elements(init_delays)), $
		       starts: fix(2^init_delays)}
		return, Queue
		
	end
	
	If n_elements(In) NE n_elements(Queue.starts) then print, "SpikeQueue WARNUNG: Aufruf nicht kompatibel zur Initialisierung!"
	
	Queue.Q = IShft(Queue.Q, -1)	
	Queue.Q = Queue.Q + In*Queue.starts

	return, Queue.Q and 1
	
end
