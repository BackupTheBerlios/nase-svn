;+
; NAME:               ReadSimu
;
; PURPOSE:            This routine reads your simulation data. 
;
; CATEGORY:           MIND SIM
;
; CALLING SEQUENCE:   R = ReadSimu([LAYER] [,FILE=file] [,OS=os] [,/TD])
;
; KEYWORD PARAMETERS: LAYER : species the layer to be read. Currently you have to
;                             specify the index (name or filename may be implemented).
;                     FILE  : you may specify a path/file (without suffices), if not the latest
;                             simulation (COMMON BLOCK ATTENTION) is taken
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
FUNCTION ReadSIMU, Layer, FILE=file, OS=OS, TD=TD, INFO=info, _EXTRA=e

   COMMON ATTENTION

   On_Error, 2
   Default, INFO, ''

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
   L = Handle_Val(P.LW(LAYER))
   w = L.w
   h = L.h
   filename = FILE+'.'+L.FILE
   
   data = ReadSim(filename, INFO=info, _EXTRA=e)
   IF Keyword_Set(TD) THEN data = REFORM(data, h, w, (SIZE(data))(2), /OVERWRITE)

   RETURN, data
END
