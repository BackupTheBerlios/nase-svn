;+
; NAME:               ReadSimu
;
; AIM:                restores all kind of neural actitvity from a simulation
;
; PURPOSE:            This routine reads your simulation data. 
;
; CATEGORY:           MIND SIM
;
; CALLING SEQUENCE:   R = ReadSimu([LAYER] [,FILE=file] [,OS=os]
;                                  [,SUFF=suff] [,/TD])
;
; KEYWORD PARAMETERS: LAYER : species the layer to be read. You may
;                             use the layer index or the file string
;                             associated with the layer
;                     FILE  : you may specify a path/file (without suffices), if not the latest
;                             simulation (COMMON BLOCK ATTENTION) is taken
;                     SUFF  : specify a suffix that will be appended
;                             behind the layer's ID
;                     OS    : the data's oversampling factor (it takes latest ATTENTION value if
;                             not specified)
;                     TD    : returns the result in dimensions of the actual layer
;
;    ---------
;    IMPORTANT:       see ReadSim for additional keywords
;    ---------
;
; OUTPUTS:            R: complete data read 
;
; COMMON BLOCKS:      ATTENTION
;
; SEE ALSO:           <A HREF=http://neuro.physik.uni-marburg.de/mind/internal#READSIM>readsim</A>
;
; MODIFICATION HISTORY:
;
;       $Log$
;       Revision 1.8  2000/09/29 08:10:38  saam
;       added the AIM tag
;
;       Revision 1.7  2000/06/20 13:16:16  saam
;             + new keyword SUFF
;
;       Revision 1.6  2000/05/16 16:25:11  saam
;             layer syntax extended
;
;       Revision 1.5  2000/04/06 09:34:51  saam
;             passes INFO keyword from and to readsim
;
;       Revision 1.4  2000/01/05 13:53:48  saam
;             minus in doc was missing
;
;       Revision 1.3  1999/12/21 09:49:39  saam
;             doc header updated
;
;       Revision 1.2  1999/12/21 09:48:54  saam
;            error in TD section
;
;       Revision 1.1  1999/12/21 09:43:14  saam
;            first version
;            changed from PRO to FUNCTION
;
;
;-
FUNCTION ReadSIMU, Layer, FILE=file, SUFF=suff, OS=OS, TD=TD, INFO=info, _EXTRA=e

   COMMON ATTENTION

   On_Error, 2
   Default, INFO, ''
   Default, SUFF, ''

   ;----->
   ;-----> COMPLETE COMMAND LINE SYNTAX
   ;----->
   Default, OS    , 1./(1000.*P.SIMULATION.SAMPLE)
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
   
   data = ReadSim(filename+suff, INFO=info, _EXTRA=e)
   IF Keyword_Set(TD) THEN data = REFORM(data, h, w, (SIZE(data))(2), /OVERWRITE)

   RETURN, data
END
