;+
; NAME: haus2_SIMULATE
;
; PURPOSE: Teilprogramm zur Demonstration der Beutzung von <A HREF="#FACEIT">FaceIt</A>.
;          *_SIMULATE sollte den Simulationskern enthalten: Inputbestimmung, 
;          Lernen, Berechnen des neuen Netwerkzustands usw werden hier 
;          durchgeführt.
;          
;          Zum Aufbau einer eigenen Simulation empfiehlt es sich, diese Routine
;          zu kopieren, den haus2-Teil des Namens durch den der eigenen
;          Simulation zu ersetzen und die Routine nach den eigenen Wünschen 
;          abzuwandeln.
;
; CATEGORY: SIMULATION / FACEIT
;
; CALLING SEQUENCE: haus2_SIMULATE, dataptr
;
; INPUTS: dataptr
;
; OUTPUTS: 1 (True)
;
; COMMON BLOCKS:
;
; SIDE EFFECTS:
;
; RESTRICTIONS:
;
; PROCEDURE:
;
; EXAMPLE:
;
; SEE ALSO:
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 1.1  1999/09/01 16:46:31  thiel
;            Moved in repository.
;
;        Revision 1.1  1999/09/01 13:38:10  thiel
;            First version of FaceIt-Demo-Routines. Doku not yet complete.
;
;-



FUNCTION haus2_SIMULATE, dataptr

   IF (*dataptr).counter EQ 0 THEN  $
    inparr=Make_Array((*dataptr).prew*(*dataptr).preh, /FLOAT, VALUE=(*dataptr).extinpampl) $
   ELSE $
    inparr=Make_Array((*dataptr).prew*(*dataptr).preh, /FLOAT, VALUE=0.0)


   inpspass = Spassmacher(inparr)
   feed_pre = inpspass

 
   feed_pre_pre = DelayWeigh( (*dataptr).CON_pre_pre, LayerOut((*dataptr).pre))

      
   InputLayer, (*dataptr).pre, FEEDING=feed_pre
   InputLayer, (*dataptr).pre, FEEDING=feed_pre_pre

   
   ProceedLayer, (*dataptr).pre

   
   (*dataptr).counter = ((*dataptr).counter+1) mod (*dataptr).extinpperiod
   
   Return, 1                    ;TRUE
END ; haus2_SIMULATE
