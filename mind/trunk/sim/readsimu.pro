;+
; NAME:
;  ReadSimu()
;
; VERSION:
;  $Id$
;
; AIM:
;  restores all kind of neural actitvity from a simulation
;
; PURPOSE:
;  This routine reads your simulation data. 
;
; CATEGORY:
;  DataStorage
;  Layers
;  MIND
;  Simulation
;
; CALLING SEQUENCE:
;  R = ReadSimu([{LAYER | LAYER=...} [,FILE=file] [,OS=os]
;               [,SUFF=suff] [,/TD] [UDS=uds])
;
; INPUTS:
;   LAYER :: species the layer to be read. You may
;            use the layer index or the file string
;            associated with the layer
;  
; INPUT KEYWORDS:
;   LAYER :: species the layer to be read. You may
;            use the layer index or the file string
;            associated with the layer
;   FILE  :: you may specify a path/file (without suffices), if not the latest
;            simulation (COMMON BLOCK ATTENTION) is taken
;   SUFF  :: specify a suffix that will be appended
;            behind the layer's ID
;   OS    :: the data's oversampling factor (it takes latest ATTENTION value if
;            not specified)
;   TD    :: returns the result in dimensions of the actual
;            layer. This option is ignored if you restore partial data
;            using <*>SELECT<*> as documented in <A>ReadSim</A>.
;
; OPTIONAL OUTPUTS:
;   UDS  :: will contain parameters (saved as structur) saved during simulation.
;           This can be used to preserve simulation or other
;           relevant parameters.
;
;*---------
;*IMPORTANT: see ReadSim for additional keywords
;*---------
;
; OUTPUTS:
;  R :: data read 
;
; COMMON BLOCKS:
;  ATTENTION
;
; SEE ALSO:
;  <A>ReadSim</A>
;
;-
FUNCTION ReadSIMU, Layer, LAYER=_layer, FILE=file, SUFF=suff, OS=OS, TD=TD, INFO=info, UDS=uds, _EXTRA=e

   COMMON ATTENTION

   On_Error, 2
   Default, INFO, ''
   Default, SUFF, ''

   ;----->
   ;-----> COMPLETE COMMAND LINE SYNTAX
   ;----->
   Default, OS    , 1./(1000.*P.SIMULATION.SAMPLE)
   IF Set(_Layer) THEN Default, Layer, _Layer
   Default, LAYER , 0
   IF NOT Set(FILE) THEN file = P.File

   IF ExtraSet(e, 'time') THEN BEGIN
      n = N_Elements(e.time)
      IF n GE 1 THEN e.time(0) = e.time(0)*OS
      IF n GE 2 THEN e.time(1) = e.time(1)*OS
   END

   ;----->
   ;----->  GLOBAL DEFINES
   ;----->

   IF TypeOf(Layer) EQ 'STRING' THEN BEGIN
       i = -1 & lidx = !NONE
       REPEAT BEGIN
            i=i+1
            L = Handle_Val(P.LW(i))
            IF Contains(L.file, layer) THEN BEGIN
                lidx = i
                i = N_Elements(P.LW)+1 ; terminate loop
            END
       END UNTIL (i GE N_Elements(P.LW)-1)
   END ELSE lidx = layer
   IF ((lidx LT 0) OR (lidx GT N_Elements(P.LW))) THEN Console, 'unknown layer', /FATAL
   L = Handle_Val(P.LW(lidx))
   w = L.w
   h = L.h
   filename = FILE+'.'+L.FILE
   
   console, 'restoring '+L.name
   
   data = ReadSim(filename+suff, INFO=info, UDS=uds, _EXTRA=e)
   
   IF Keyword_Set(TD) THEN BEGIN
       IF ExtraSet(e, "SELECT") THEN Console, "can't reform a partial restore to array dimensions ... ignoring /TD"  $
       ELSE data = REFORM(data, h, w, (SIZE(data))(2), /OVERWRITE)
   END

   RETURN, data
END
