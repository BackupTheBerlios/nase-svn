;+
; NAME: haus2_SIMULATE
;
; AIM:
;  The main simulation routine of the simulation application.
;
; PURPOSE: Teilprogramm zur Demonstration der Benutzung von <A HREF="#FACEIT">FaceIt</A>.
;          *_SIMULATE sollte den Simulationskern enthalten: Inputbestimmung, 
;          Lernen, Berechnen des neuen Netwerkzustands usw werden hier 
;          durchgeführt. *_SIMULATE wird vom FaceIt regelmäßig aufgerufen, 
;          sobald der Simulationsablauf mit dem START-Button gestartet wurde.
;          Die Darstellung des Simulationsgeschehens auf dem Bildschirm erfolgt
;          in der separaten Routine <A HREF="#HAUS2_DISPLAY">*_DISPLAY</A>.
;          
;          Zum Aufbau einer eigenen Simulation empfiehlt es sich, diese Routine
;          zu kopieren, den haus2-Teil des Namens durch den der eigenen
;          Simulation zu ersetzen und die Routine nach den eigenen Wünschen 
;          abzuwandeln.
;
; CATEGORY: GRAPHICS / WIDGETS / FACEIT_DEMO
;
; CALLING SEQUENCE: result = haus2_SIMULATE, dataptr
;
; INPUTS: dataptr: Ein Pointer auf eine Struktur, die alle notwendigen
;                  Simulationsdaten (Parameter, NASE-Strukturen wie Layer und
;                  DWs) enthält. Die Struktur muß vom Benutzer in <A HREF="#HAUS2_INITDATA">*_INITDATA</A>
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
; SEE ALSO: <A HREF="../#FACEIT">FaceIt</A>, <A HREF="#HAUS2_INITDATA">haus2_INITDATA</A>, <A HREF="#HAUS2_DISPLAY">haus2_DISPLAY</A>,
;           <A HREF="../../../simu/layers/#INPUTLAYER">InputLayer</A>, <A HREF="../../../simu/layers/#PROCEEDLAYER">ProceedLayer</A>, <A HREF="../../../simu/connections/#DELAYWEIGH">DelayWeigh</A>.
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 1.3  2000/10/01 14:52:11  kupper
;        Added AIM: entries in document header. First NASE workshop rules!
;
;        Revision 1.2  1999/09/03 14:24:46  thiel
;            Better docu.
;
;        Revision 1.1  1999/09/01 16:46:31  thiel
;            Moved in repository.
;
;        Revision 1.1  1999/09/01 13:38:10  thiel
;            First version of FaceIt-Demo-Routines. Doku not yet complete.
;
;-



FUNCTION haus2_SIMULATE, dataptr

;--- CHANGE THE FOLLOWING PART TO BUILD YOUR OWN SIUMLATION: 

   ; Generate external input if period is over:
   IF (*dataptr).counter EQ 0 THEN  $
    inparr=Make_Array((*dataptr).prew*(*dataptr).preh, /FLOAT, VALUE=(*dataptr).extinpampl) $
   ELSE $
    inparr=Make_Array((*dataptr).prew*(*dataptr).preh, /FLOAT, VALUE=0.0)

   ; Make sparse version of external input:
   inpspass = Spassmacher(inparr)
   feed_pre = inpspass

   ; Calculate feeding input from intra-layer-connections:
   feed_pre_pre = DelayWeigh( (*dataptr).CON_pre_pre, LayerOut((*dataptr).pre))

      
   InputLayer, (*dataptr).pre, FEEDING=feed_pre
   InputLayer, (*dataptr).pre, FEEDING=feed_pre_pre

   
   ProceedLayer, (*dataptr).pre

   ; Increment counter and reset if period is over:
   (*dataptr).counter = ((*dataptr).counter+1) mod (*dataptr).extinpperiod
   
   ; Allow continuation of simulation:
   Return, 1 ; TRUE

;--- NO CHANGES NECESSARY BELOW THIS LINE.


END ; haus2_SIMULATE
