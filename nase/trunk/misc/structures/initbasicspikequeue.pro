;+
; NAME: 		InitBasicSpikeQueue
;
; PURPOSE:		Bounded Queue zur realisierung eines Spike-Delays von bis zu 30 Zeitschritten
;
; CATEGORY:		MISC/STRUCTURES
;
; CALLING SEQUENCE:	My_Queue = InitBasicSpikeQueue ( INIT_DELAYS = Delay_Array )
;
; KEYWORD PARAMETERS:	INIT_DELAYS: Wird dieser Parameter angegeben, so wird ein leere Queue erzeugt.
;				     Die Dimension des Arrays gibt an, wieviele Spiketrains die Queue fassen soll.
;				     Die Werte geben das Delay für jeden Spiketrain in Zeitschritten (=Aufrufschritten)
;				     an. Erlaubte Werte sind 0..30. (Für 0 wird der Input sofort wieder ausgegeben!)
;	
; OUTPUTS:		My_Queue: Eine leere Queue mit entsprechenden Delays
;
; RESTRICTIONS: 	Input darf nur 0 oder 1 enthalten und muß gleiche Dimension wie INIT_DELAYS haben.
;			INIT_DELAYS darf nur Integer im Bereich 0..30 enthalten!		
;
; PROCEDURE:            Die Spikes entsprechen Bits in einen Integer/Long (je nachdem, der maximale Delay >15), die 
;                       jeden Zeitschritt um 1 geshiftet werden.
;
; EXAMPLE: Ruedigers_Qeueu   = InitBasicSpikeQueue( INIT_DELAYS=[0,5,7] )  ; erzeugt eine Queue für drei Spiketrains mit den Delays 0, 5 und 7
;          Ankommende_Spikes = BasicSpikeQueue( Ruedigers_Queue, [1,0,1] ) ; Steckt in die erste und dritte Queue einen Spike,
;									     und liest am anderen Ende je einen Spike aus.
;
; SEE ALSO:             <A HREF="#BASICSPIKEQUEUE">BasicSpikeQueue</A>
;
; MODIFICATION HISTORY: 
;
;       $Log$
;       Revision 1.3  1999/08/05 14:21:14  thiel
;           Changed maximal length for integer-queue from 15 to 14.
;
;       Revision 1.2  1997/12/02 10:40:22  saam
;             Fehler in Hyperlinks korrigiert
;
;       Revision 1.1  1997/12/02 09:27:06  saam
;             Umbenennung von InitSpikeQueue; Header-Update
;
;       Revision 1.3  1997/12/01 11:38:20  saam
;             Bearbeitet jetzt auch Delays bis maximal 30 Bins
;
;
;       Mon Aug 18 16:33:26 1997, Mirko Saam
;       <saam@ax1317.Physik.Uni-Marburg.DE>
;
;		Fehler bei Belegung von starts korrigiert, fix(2^x) != 2^(fix(x))
;
;       Thu Aug 14 16:06:05 1997, Mirko Saam
;       <saam@ax1317.Physik.Uni-Marburg.DE>
;
;		Urversion, entstanden aus spikequeue.pro Version 1.1
;                       
;
;-
FUNCTION InitBasicSpikeQueue, INIT_DELAYS=init_delays

   IF MAX(init_delays) GT 30 THEN Message, 'maximal delay is 30'

   IF MAX(init_delays) LE 14 THEN BEGIN
      Queue={Q     : intarr(n_elements(init_delays)), $
             starts: 2^round(init_delays)}
   END ELSE BEGIN
      Queue={Q     : lonarr(n_elements(init_delays)), $
             starts: 2l^round(init_delays)}
   END

   RETURN, Queue

end
