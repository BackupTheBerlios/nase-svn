;+
; NAME: ProceedLayer_9
;
; AIM:
;  Compute output of Four Compartment Object Neurons in current timestep.
;
; PURPOSE: Führt einen Simulationsschritt für eine Schicht aus Neuronen 
;          des Typs 9 durch. Dazu werden die 
;          entsprechenden DGLn für die Compartments mit der IDL-
;          Runge-Kutta-Integrationsmethode gelöst. Input in die Neuronen
;          muß vor dem ProceedLayer_9-Aufruf mit InputLayer_9 
;          festgelegt werden.
;
; CATEGORY: SIMULATION / LAYERS
;
; CALLING SEQUENCE: ProceedLayer_9, layer
;
; INPUTS: layer: eine durch <A HREF="#INITLAYER_8">InitLayer_8</A> erzeugte Layer
;
; COMMON BLOCKS: common_random
;                proceedlayer_8_cb (für die Übergabe der Parameter an die
;                                    Runge-Kutta-Funktion)
;
;
; MODIFICATION HISTORY: 
;
;      $Log$
;      Revision 2.1  2000/09/28 13:05:27  thiel
;          Added types '9' and 'lif', also added AIMs.
;
;      Revision 1.3  1999/03/08 09:54:59  thiel
;             Hyperlink-Korrektur.
;
;      Revision 1.2  1999/03/05 14:32:53  thiel
;             Header-Ergänzung.
;
;      Revision 1.1  1999/03/05 13:10:19  thiel
;             Neuer Neuronentyp 8, ein Vier-Compartment-Modellneuron.
;
;- 



PRO ProceedLayer_9, _layer, VARTIMESTEP=vartimestep, _EXTRA=_extra

   COMMON common_random, seed

   Handle_Value, _layer, layer, /NO_COPY

   IF Set(VARTIMESTEP) THEN BEGIN

      deltat = 0.
      layer.cells -> Info, GET_DELTAT = deltat
      oldstate = layer.cells -> State()

      faststep = layer.fastcells -> Proceed() 
      faststate = layer.fastcells -> State()

      slowstep1 = layer.cells -> Proceed()
      slowstate1 = layer.cells -> State()
      slowstep2 = layer.cells -> Proceed()
      slowstate2 = layer.cells -> State()


      error = Total(Abs(faststate(*,0)-slowstate2(*,0)))

      IF error GT layer.errbound(1) THEN BEGIN
         deltat = 0.5*deltat
         layer.cells -> Set, SET_STATE = oldstate, SET_DELTAT=deltat
         layer.fastcells -> Set, SET_STATE = oldstate, SET_DELTAT=2.0*deltat
         newout = [0,1]
         vartimestep = 0         
      ENDIF ELSE $
       IF error LT layer.errbound(0) THEN BEGIN
         deltat = 2.0*deltat
         layer.cells -> Set, SET_DELTAT=deltat
         layer.fastcells -> Set, SET_DELTAT=2.0*deltat
         newout = faststep
         vartimestep = 2
      ENDIF ELSE BEGIN
         layer.cells -> Set, SET_STATE = slowstate1
         layer.fastcells -> Set, SET_STATE = slowstate1
         newout = slowstep1
         vartimestep = 1
      ENDELSE
      
   ENDIF ELSE $
    newout = layer.cells -> Proceed(_EXTRA=_extra)


   Handle_Value, layer.o, newout, /SET   


   Handle_Value, _layer, layer, /NO_COPY, /SET


END
