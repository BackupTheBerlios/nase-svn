;+
; NAME: schuelerwuergshop_SIMULATE
;
; PURPOSE: Teilprogramm zur Demonstration der Benutzung von <A HREF="#FACEIT">FaceIt</A>.
;          *_SIMULATE sollte den Simulationskern enthalten: Inputbestimmung, 
;          Lernen, Berechnen des neuen Netwerkzustands usw werden hier 
;          durchgeführt. *_SIMULATE wird vom FaceIt regelmäßig aufgerufen, 
;          sobald der Simulationsablauf mit dem START-Button gestartet wurde.
;          Die Darstellung des Simulationsgeschehens auf dem Bildschirm erfolgt
;          in der separaten Routine <A HREF="#schuelerwuergshop_DISPLAY">*_DISPLAY</A>.
;          
;          Zum Aufbau einer eigenen Simulation empfiehlt es sich, diese Routine
;          zu kopieren, den haus2-Teil des Namens durch den der eigenen
;          Simulation zu ersetzen und die Routine nach den eigenen Wünschen 
;          abzuwandeln.
;
; CATEGORY: GRAPHICS / WIDGETS / FACEIT_DEMO
;
; CALLING SEQUENCE: result = schuelerwuergshop_SIMULATE, dataptr
;
; INPUTS: dataptr: Ein Pointer auf eine Struktur, die alle notwendigen
;                  Simulationsdaten (Parameter, NASE-Strukturen wie Layer und
;                  DWs) enthält. Die Struktur muß vom Benutzer in <A HREF="#schuelerwuergshop_INITDATA">*_INITDATA</A>
;                  gefüllt worden sein.
;
; OUTPUTS: result: 1 (TRUE), wenn die Simulation weiterlaufen soll,
;                  0 (FALSE), wenn sie aus irgendeinem programmbedingten
;                     Grund anhalten soll. 
;
; RESTRICTIONS: Die Benutzung der gesamten FaceIt-Architektur ist erst ab 
;               IDL 5 möglich. 
;
; PROCEDURE: 1. Input von außen erzeugen, wenn die Zeit dafür reif ist.
;            2. Input aus intra-layer-Kopplung mit <A HREF="../../../simu/connections/#DELAYWEIGH">DelayWeigh</A> berechnen.
;            3. <A HREF="../../../simu/layers/#INPUTLAYER">InputLayer</A> mit den beiden Inputs.
;            4. <A HREF="../../../simu/layers/#PROCEEDLAYER">ProceedLayer</A>.
;            5. Counter weiterzählen oder zurücksetzen.
;
; EXAMPLE: FaceIt, 'haus2'
;
; SEE ALSO: <A HREF="../#FACEIT">FaceIt</A>, <A HREF="#schuelerwuergshop_INITDATA">schuelerwuergshop_INITDATA</A>, <A HREF="#schuelerwuergshop_DISPLAY">schuelerwuergshop_DISPLAY</A>,
;           <A HREF="../../../simu/layers/#INPUTLAYER">InputLayer</A>, <A HREF="../../../simu/layers/#PROCEEDLAYER">ProceedLayer</A>, <A HREF="../../../simu/connections/#DELAYWEIGH">DelayWeigh</A>.
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 1.1  2000/02/17 17:41:46  kupper
;        Fuer die lieben Schueler.
;
;        Revision 1.1  1999/09/14 15:02:29  kupper
;        Initial revision
;
;-



FUNCTION schuelerwuergshop_SIMULATE, dataptr

;--- CHANGE THE FOLLOWING PART TO BUILD YOUR OWN SIUMLATION: 

   ; Generate external input if period is over:
;   IF (*dataptr).counter EQ 0 THEN  begin
      ;(*dataptr).CurrentInput = RFScan_Zeigmal( *(*dataptr).RFScan_p ) > (*dataptr).Image_brightness*(*dataptr).images[*, *, (*dataptr).current_image]

;(*dataptr).CurrentInput = (*dataptr).Image_brightness*(*dataptr).images[*, *, (*dataptr).current_image]
;
;      (*dataptr).CurrentRETINAin = CONVOL((*dataptr).CurrentInput, (*dataptr).GaborAmplitude*(*dataptr).RETINARF, /EDGE_WRAP)
      ;RETINAin = rebin(con, (*dataptr).RETINAHeight, (*dataptr).RETINAWidth, /SAMPLE)

      *(*dataptr).CurrentRETINAin_spass = Spassmacher((*dataptr).CurrentRETINAin)
;   Endif

   InputLayer, (*dataptr).RETINA, FEEDING=*(*dataptr).CurrentRETINAin_spass
   If (*dataptr).coupling_enabled then InputLayer, (*dataptr).RETINA, FEEDING=DelayWeigh((*dataptr).RETINAtoRETINA, LayerOut((*dataptr).RETINA));additive coupling!
   ProceedLayer, (*dataptr).RETINA

;   InputLayer, (*dataptr).CORTEX, FEEDING=DelayWeigh((*dataptr).RETINAtoCORTEX, LayerOut((*dataptr).RETINA))
;   ProceedLayer, (*dataptr).CORTEX

;   RFScan_Schaumal, *(*dataptr).RFScan_p, (*dataptr).CORTEX

   ; Increment counter and reset if period is over:
;   (*dataptr).counter = ((*dataptr).counter+1) mod 50
   
   ; Allow continuation of simulation:
   Return, 1 ; TRUE

;--- NO CHANGES NECESSARY BELOW THIS LINE.


END ; schuelerwuergshop_SIMULATE
