;+
; NAME:               ReadDW
;
; PURPOSE:            Reads weight matrices used/learned by a 
;                     MIND simulation. This routine is used by
;                     high-level routines like showdw.
;
; CATEGORY:           MIND INTERNAL
;
; CALLING SEQUENCE:   dw = ReadDW(DWindex [,/INIT])
;
; INPUTS:             DWindex: the index of the weight matrix to be read
;
; KEYWORD PARAMETERS: INIT: reads the initial version of the weight matrix
;                           (before the simulation modifies it)
;
; OUTPUTS:            dw: the recovered DelayWeigh structure 
;
; OPTIONAL OUTPUTS:   FILE: returns the filename used for loading
;
; SEE ALSO:           <A HREF=http://neuro.physik.uni-marburg.de/mind/xplore#SHOWDW>showdw</A>, <A HREF=http://neuro.physik.uni-marburg.de/nase/misc/files+dirs/#UOPENR>uopenr</A>, <A HREF=http://neuro.physik.uni-marburg.de/nase/simu/connections/#RESTOREDW>restoredw</A>
;        
; MODIFICATION HISTORY:
;
;      $Log$
;      Revision 1.3  2000/01/14 11:10:11  saam
;            chaged dw to anonymous/handles
;
;      Revision 1.2  2000/01/11 14:16:00  saam
;            added the FILE keyword
;
;      Revision 1.1  2000/01/11 14:05:07  saam
;            dont know what happens if file doesn't exist
;
;
;-
FUNCTION ReadDW, DWindex, INIT=init, FILE=file

   COMMON ATTENTION
   
   curDW = Handle_Val(P.DWW(DWindex))
   file = P.file+'.'+curDW.file
   IF Keyword_Set(INIT) THEN file = file + '.ini.dw' ELSE file = file + '.dw'
   
   lun = UOpenR(file)
   tmp = LoadStruc(lun)
   Close, lun
   Free_Lun, lun
   DW = RestoreDW(tmp)
   
   RETURN, DW
END
