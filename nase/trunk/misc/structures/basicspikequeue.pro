;+
; NAME: 		BasicSpikeQueue
;
; AIM:                  en- and dequeues data from queue initialized with <A>InitBasicSpikeQueue</A>
;
; PURPOSE:		Bounded Queue zur realisierung eines Spike-Delays von bis zu 30 Zeitschritten
;
; CATEGORY:		MISC/STRUCTURES
;
; CALLING SEQUENCE:	Output = BasicSpikeQueue ( My_Queue, Input)
;
; INPUTS:		My_Queue: Eine zuvor mit InitQuikeQueue initialisierte Queue-Struktur
;			Input   : (Array von) Booleans - Achtung! Darf nur 0 oder 1 enthalten!
;				  Die Dimension muss mit der Dimension von INIT_DELAYS bei der Initialisierung
;				  übereinstimmen. (Ansonsten wird ein Warnmeldung ausgegeben!)
;
; OUTPUTS:		Output: Der Input von vor (Delay) Zeitschritten (=Aufrufen)
;			
; RESTRICTIONS: 	Input darf nur 0 oder 1 enthalten und muß gleiche Dimension wie INIT_DELAYS haben.
;			INIT_DELAYS darf nur Integer im Bereich 0..30 enthalten!		
;
; PROCEDURE:            Die Spikes entsprechen Bits in einen Integer/Long (je nachdem, der maximale Delay >15), die 
;                       jeden Zeitschritt um 1 geshiftet werden.
;
; EXAMPLE: Ruedigers_Qeueu   = InitBasicSpikeQueue( INIT_DELAYS=[0,5,7] )  ; erzeugt eine Queue für drei Spiketrains mit den Delays 0, 5 und 7
;          Ankommende_Spikes = BasicSpikeQueue( Ruedigers_Queue, [1,0,1] ) ; Steckt in die erste und dritte Queue einen Spike,
;									und liest am anderen Ende je einen Spike aus.
;
; SEE ALSO:             <A HREF="#INITBASICSPIKEQUEUE">InitBasicSpikeQueue</A>
;
; MODIFICATION HISTORY: 
;
;       $Log$
;       Revision 1.2  2000/09/25 09:13:12  saam
;       * added AIM tag
;       * update header for some files
;       * fixed some hyperlinks
;
;       Revision 1.1  1997/12/02 09:26:40  saam
;             Umbenennung von SpikeQueue, Header-Update
;
;       Revision 1.4  1997/12/01 11:40:53  saam
;             Behandelt nun auch Delays bis max. 30
;
;
;       Mon Sep 8 12:17:01 1997, Mirko Saam
;       <saam@ax1317.Physik.Uni-Marburg.DE>
;
;		Umstellung auf Sparse beginnt
;
;       Thu Aug 14 16:09:28 1997, Mirko Saam
;       <saam@ax1317.Physik.Uni-Marburg.DE>
;
;		Auftrennung von Initialisierung und Betrieb
;               Optimierungen
;
;
;               Erstellt am 22.7.1997, Rüdiger
;
;-
Function BasicSpikeQueue, Queue, In

   
   active = WHERE(Queue.Q NE 0, count)
   IF count NE 0 THEN Queue.Q(active) = IShft(Queue.Q(active), -1)	
   
   IF (In(0) NE 0) THEN BEGIN
      shortIn = In(2:In(0)+1)
      Queue.Q(shortIn) = Queue.Q(shortIn) + Queue.starts(shortIn) 
   END

   result = WHERE((Queue.Q AND 1) EQ 1, count)
   IF count NE 0 THEN BEGIN
      return, [count, In(1), result]
   END ELSE BEGIN
      return, [count, In(1)]
   END	
END
