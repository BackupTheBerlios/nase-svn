;+
; NAME:               ShowDW
;
; PURPOSE:            Restores DW-Structures and displays them via TomWaits
;
; CATEGORY:           MIND XPLORE 
;
; CALLING SEQUENCE:   ShowDW [, DWindex] [,/STOP] [_EXTRA=e]
;
; OPTIONAL INPUTS:    DWindex: the index of the weight structure to be displayed,
;                              default is 0
;                     EXTRA:   see options for <A HREF=http://neuro.physik.uni-marburg.de/mind/internal/#READDW>readdw</A>
;
; KEYWORD PARAMETERS: STOP  : stop after displaying
;
; COMMON BLOCKS:      ATTENTION
;
; SEE ALSO:           <A HREF=http://neuro.physik.uni-marburg.de/mind/internal/#READDW>readdw</A>, <A HREF=http://neuro.physik.uni-marburg.de/mind/control/#FOREACH>foreach</A>, <A HREF=http://neuro.physik.uni-marburg.de/nase/graphic/nase/#TOMWAITS>tomwaits</A>
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 1.4  2000/06/20 10:22:23  saam
;           + EXTRA arguments are passed to TomWaits
;           + there is a Default DWindex now
;
;     Revision 1.3  2000/01/14 11:02:21  saam
;           changed dw structures to anonymous/handles
;
;     Revision 1.2  2000/01/11 14:16:47  saam
;           now use the new readdw routine for data aquisition
;
;     Revision 1.1  1999/12/21 11:09:45  saam
;           sheet section is obsolete at the moment
;           calls tomwaits with no_block=0
;
;
;-
PRO _ShowDw, DWindex, STOP=stop, _EXTRA=e

   COMMON ATTENTION
   
   Default, DWindex, 0

;   IF ExtraSet(e, 'NEWWIN') THEN BEGIN
;      IF Set(DC_1) THEN DestroySheet, DC_1
;      DCwins = 0
;   END
;   IF ExtraSet(e, 'NOGRAPHIC') THEN BEGIN
;      DC_1 = DefineSheet(/NULL)
;      DCwins = 0
;   END ELSE IF ExtraSet(e, 'PS') THEN BEGIN
;      SetPS
;      DC_1 = DefineSheet(/PS, /INCREMENTAL, FILENAME='showdw')
;      DCwins = 0
;   END ELSE IF ExtraSet(e, 'EPS') THEN BEGIN
;      SetPS
;      DC_1 = DefineSheet(/PS, /INCREMENTAL, /ENCAPSULATED, FILENAME='distcorr')
;      DCwins = 0
;   END ELSE BEGIN
;      IF (SIZE(DCwins))(1) EQ 0 THEN BEGIN
;         SetX
;         DC_1 = DefineSheet(/Window, XSIZE=400, YSIZE=300, TITLE='DistCorr')
;         DCwins = 1
;      END
;   END
   IF Set(e) THEN BEGIN
      Deltag, e, "EPS"
      Deltag, e, "PS"
      Deltag, e, "NEWWIN"
      Deltag, e, "NOGRAPHIC"
   END

   DW = ReadDW(DWIndex, _EXTRA=e)
   curDW = Handle_Val(P.DWW(DWindex))

   IF curDW.T2S THEN BEGIN 
      PROJECTIVE = 0
      RECEPTIVE = 1
      Title = 'Receptive '
   END ELSE BEGIN
      PROJECTIVE = 1
      RECEPTIVE = 0
      Title = 'Projective '
   END
   
   Title = Title + 'Fields, '+curDW.NAME
   
   TomWaits, DW, TITLE=title, NO_BLOCK=0, _EXTRA=e
   
   IF Keyword_Set(STOP) THEN STOP

   FreeDW, DW
END



PRO ShowDw, DWindex, _EXTRA=e

   COMMON ATTENTION

   Default, DWindex, 0
   iter = foreach('_ShowDW', DWindex, _EXTRA=e)

END
