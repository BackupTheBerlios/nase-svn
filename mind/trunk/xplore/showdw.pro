;+
; NAME:               ShowDW
;
; PURPOSE:            Restores DW-Structures and displays them via TomWaits
;
; CATEGORY:           MIND XPLORE 
;
; CALLING SEQUENCE:   ShowDW [, DWindex] [,/INIT] [,/STOP]
;
; OPTIONAL INPUTS:    DWindex: the index of the weight structure to be displayed,
;                              default is 0
;
; KEYWORD PARAMETERS: INIT  : show the initial weight distribution before learning
;                     STOP  : stop after displaying
;
; COMMON BLOCKS:      ATTENTION
;
; SEE ALSO:           <A HREF=http://neuro.physik.uni-marburg.de/mind/control/#FOREACH>foreach</A>, <A HREF=http://neuro.physik.uni-marburg.de/nase/graphic/nase/#TOMWAITS>tomwaits</A>
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 1.1  1999/12/21 11:09:45  saam
;           sheet section is obsolete at the moment
;           calls tomwaits with no_block=0
;
;
;-
PRO _ShowDw, DWindex, STOP=stop, INIT=init, _EXTRA=e

   COMMON ATTENTION
   
   IF ExtraSet(e, 'NEWWIN') THEN BEGIN
      IF Set(DC_1) THEN DestroySheet, DC_1
      DCwins = 0
   END
   IF ExtraSet(e, 'NOGRAPHIC') THEN BEGIN
      DC_1 = DefineSheet(/NULL)
      DCwins = 0
   END ELSE IF ExtraSet(e, 'PS') THEN BEGIN
      SetPS
      DC_1 = DefineSheet(/PS, /INCREMENTAL, FILENAME='distcorr')
      DCwins = 0
   END ELSE IF ExtraSet(e, 'EPS') THEN BEGIN
      SetPS
      DC_1 = DefineSheet(/PS, /INCREMENTAL, /ENCAPSULATED, FILENAME='distcorr')
      DCwins = 0
   END ELSE BEGIN
      IF (SIZE(DCwins))(1) EQ 0 THEN BEGIN
         SetX
         DC_1 = DefineSheet(/Window, XSIZE=400, YSIZE=300, TITLE='DistCorr')
         DCwins = 1
      END
   END


   Default, DWindex, 0
   
   file = P.file+'.'+P.DWW(DWindex).file
   IF Keyword_Set(INIT) THEN file = file + '.ini.dw' ELSE file = file + '.dw'


   lun = UOpenR(file)
   DW = RestoreDW(LoadStruc(lun))
   UClose, lun

   IF P.DWW(DWindex).T2S THEN BEGIN 
      PROJECTIVE = 0
      RECEPTIVE = 1
      Title = 'Receptive '
   END ELSE BEGIN
      PROJECTIVE = 1
      RECEPTIVE = 0
      Title = 'Projective '
   END
   
   Title = Title + 'Fields, '+P.DWW(DWindex).NAME
   
   TomWaits, DW, TITLE=title, NO_BLOCK=0
   
   IF Keyword_Set(STOP) THEN STOP

   FreeDW, DW
END



PRO ShowDw, DWindex, _EXTRA=e

   COMMON ATTENTION

   iter = foreach('_ShowDW', DWindex, _EXTRA=e)

END
