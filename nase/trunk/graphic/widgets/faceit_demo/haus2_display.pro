;+
; NAME: haus2_DISPLAY
;
; PURPOSE: Teilprogramm zur Demonstration der Beutzung von <A HREF="#FACEIT">FaceIt</A>. 
;          Hier soll die Darstellung des Netzwerkzustands während der 
;          Simulation erfolgen.
;          Zum Aufbau einer eigenen Simulation empfiehlt es sich, diese Routine
;          zu kopieren, den haus2-Teil des Namens durch den der eigenen
;          Simulation zu ersetzen und die Routine nach den eigenen Wünschen 
;          abzuwandeln.
;
; CATEGORY: SIMULATION / FACEIT
;
; CALLING SEQUENCE: haus2_DISPLAY, dataptr, displayptr
;
; INPUTS:dataptr, displayptr
;
; OUTPUTS: 1 (True)
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



FUNCTION haus2_DISPLAY, dataptr, displayptr

   ; Spiketrains and potentials:
   ; Only plot if new output is different from old one:
   preout = LayerSpikes((*dataptr).pre, /DIMENSIONS)
   IF NOT A_EQ(preout,(*dataptr).lastout) THEN BEGIN
      ShowIt_Open, (*displayptr).spikestv
      PlotTVScl, /NASE, SETCOL=0, preout, TITLE="Spikes in Layer", PLOTCOL=255
      ShowIt_Close, (*displayptr).spikestv, SAVE_COLORS=0
      (*dataptr).lastout = preout
   ENDIF

   ShowIt_Open, (*displayptr).spiketrain
   TrainSpottingScope, (*displayptr).tss, LayerOut((*dataptr).pre)
   ShowIt_Close, (*displayptr).spiketrain, SAVE_COLORS=0

   ShowIt_Open, (*displayptr).plotcillo
   LayerData, (*dataptr).pre, POTENTIAL=m, SCHWELLE=theta
   Plotcilloscope, (*displayptr).pcs, [m((*dataptr).prew*(*dataptr).preh/2),theta((*dataptr).prew*(*dataptr).preh/2)+1.0]
   ShowIt_Close, (*displayptr).plotcillo, SAVE_COLORS=0

   Return, 1                    ; TRUE


END ; haus2_DISPLAY
