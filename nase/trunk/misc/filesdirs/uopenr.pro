;+
; NAME:
;
; PURPOSE:
;
; CATEGORY:
;
; CALLING SEQUENCE:
;
; INPUTS:
;
; OPTIONAL INPUTS:
;
; KEYWORD PARAMETERS:
;
; OUTPUTS:
;
; OPTIONAL OUTPUTS:
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
;     $Log$
;     Revision 2.1  1998/10/12 10:32:02  saam
;           first version
;
;
;-
FUNCTION UOpenR, file, VERBOSE=verbose

   On_Error, 2

   IF N_Params() NE 1 THEN Message,' exactly one argument expected'
   
   exists = ZipStat(file, ZIPFILES=zf, NOZIPFILES=nzf, BOTHFILES=bf)

   IF exists THEN BEGIN
      IF zf(0) NE '-1' THEN BEGIN
         IF Keyword_Set(Verbose) THEN print, 'UOpenR: no unzipped version found...unzipping'
         UnZip, file
      END
      OpenR, lun, file, /GET_LUN
      RETURN, lun
   END ELSE BEGIN
      IF Keyword_Set(Verbose) THEN print, 'UOpenR: neither unzipped nor zipped version found!'
      RETURN, -1
   END

END
