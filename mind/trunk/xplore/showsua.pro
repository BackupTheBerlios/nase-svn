;+
; NAME:               ShowSUA
;
; PURPOSE:            Shows previously recorded SUA as TrainSpotting and
;                     VCR.
;
; CATEGORY:           MIND XPLORE 
;
; CALLING SEQUENCE:   ShowSUA [,LayerIndex] [,/VCR] [,EXTRA=e] [,/STOP]
;
; INPUTS:             LayerIndex: the index of the layer to be displayed
;
; KEYWORD PARAMETERS: 
;                     VCR   : displays the spatio-temporal activity profile
;                             as a video (you probably want to use VCR's
;                             ZOOM=x option, to scale the video)
;                     STOP  : stop after displaying
;                     EXTRA : all Keywords are passed to VCR/TrainSpotting
;                             selectively
;
; SEE ALSO:           <A HREF=http://neuro.physik.uni-marburg.de/nase/graphic#VCR>vcr</A>, <A HREF=http://neuro.physik.uni-marburg.de/nase/graphic#TRAINSPOTTING>trainspotting</A>, <A HREF=http://neuro.physik.uni-marburg.de/mind/sim#READSIMU>readsimu</A>, <A HREF=http://neuro.physik.uni-marburg.de/mind/control/#FOREACH>foreach</A>
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 1.1  2000/01/04 10:37:21  saam
;           ok
;
;
;-
PRO _ShowSUA, LayerIndex, VCR=vcr, STOP=stop, _EXTRA=e

   On_Error, 2

   COMMON SH_SS, SSwins, SS_1
   
   ;-----> ORGANIZE THE SHEETS
   IF ExtraSet(e, 'NEWWIN') THEN BEGIN
      DestroySheet, SS_1
      SSwins = 0
   END
   IF ExtraSet(e, 'NOGRAPHIC') THEN BEGIN
      SS_1 = DefineSheet(/NULL)
      SSwins = 0
   END ELSE IF ExtraSet(e, 'PS') THEN BEGIN
      SS_1 = DefineSheet(/NULL)
      SSwins = 0
   END ELSE BEGIN
      IF (SIZE(SSwins))(1) EQ 0 THEN BEGIN
         SS_1 = DefineSheet(/Window, XSIZE=1000, YSIZE=200, TITLE='Show SUA')
         SSwins = 1
      END
   END

   NT = ReadSimu(LayerIndex, /TD, _EXTRA=e)

   OpenSheet, SS_1
   s = SIZE(NT)
   Trainspotting, Reform(Nt, s(1)*s(2), s(3)), OFFSET=0
   CloseSheet, SS_1

   IF Keyword_Set(VCR) THEN BEGIN
      IF Set(e) THEN BEGIN
         NewE = ExtraDiff(E, ["NASE", "DELAY", "TITLE", "SCALE", "ZOOM", "XSIZE", "YSIZE"], /LEAVE) 
      END
      IF TYPEof(NewE) EQ 'STRUCT' THEN VCR, NT, /NASE, _EXTRA=NewE ELSE VCR, NT, /NASE
   END

   IF Keyword_Set(STOP) THEN STOP

END


PRO ShowSUA, LayerIndex, _EXTRA=e

   Default, LayerIndex, 0
   iter = foreach('_ShowSUA', LayerIndex, _EXTRA=e)

END
