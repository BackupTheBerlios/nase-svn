;+
; NAME:               MeanWeights
;
; PURPOSE:            Reads learned weight matrices created by SIM, computes
;                     the mean matrix for each iteration and saves each result in a video '*.mw'.
;                     Each Matrix is displayed as ShadeSurf-Plot.
;
; CATEGORY:           MIND XPLORE
;
; CALLING SEQUENCE:   MeanWeights, DWIndex [,/CENTER]
;
; INPUT:              DWindex: the index of the DW-structure to be averaged
;
; KEYWORD PARAMETERS: CENTER: centers the mean weight matrix (only needed
;                             if its not working automatically)
;                     EXTRA : all extra keywords are passed to ReadDW                            
;
; COMMON BLOCKS:      ATTENTION: simulation parameters
;                     SH_MW    : sheet definitions
;
; SEE ALSO:           <A HREF=http://neuro.physik.uni-marburg.de/mind/internal/#READDW>readdw</A>, <A HREF=http://neuro.physik.uni-marburg.de/nase/methods#MIDDLEWEIGHTS>middleweights</A>, <A HREF=http://neuro.physik.uni-marburg.de/mind/control/#FOREACH>foreach</A>
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 1.2  2000/02/16 13:37:06  saam
;           now works with new dww system
;
;     Revision 1.1  2000/01/11 14:16:47  saam
;           now use the new readdw routine for data aquisition
;
;
;-
PRO _MeanWeights, WAIT=wait, DWIndex, CENTER=CENTER, STOP=stop, _EXTRA=e
   
   COMMON ATTENTION
   COMMON SH_MW, MWwins, MW_1

   Default, DWIndex, 0
   IF DWIndex GT N_Elements(P.DWW)-1 THEN Message, 'a dont have more than '+STR(N_Elements(P.DWW))+'DWs !'
   
   
   
   IF ExtraSet(e, 'NOGRAPHIC') THEN BEGIN
      MW_1 = DefineSheet(/NULL, MULTI=[3,3,1])      
      MW = 0
   END ELSE IF ExtraSet(e, 'PS') THEN BEGIN
      MW_1 = DefineSheet(/PS, FILENAME='meanweights', MULTI=[3,3,1], /COLOR)
      MWwins = 0
   END ELSE IF ExtraSet(e, 'EPS') THEN BEGIN
      MW_1 = DefineSheet(/PS, FILENAME='meanweights', MULTI=[3,3,1], /COLOR, /ENCAPSULATED)
      MWwins = 0
   END ELSE BEGIN
      IF (SIZE(MWwins))(1) EQ 0 THEN BEGIN
         MW_1 = DefineSheet(/Window, XSIZE=350, YSIZE=250, XPOS=600, YPOS=350, TITLE='MeanWeights', MULTI=[3,3,1])
         MWwins = 1
      END
   END

   IF Set(e) THEN BEGIN
      Deltag, e, "EPS"
      Deltag, e, "PS"
      Deltag, e, "NEWWIN"
      Deltag, e, "NOGRAPHIC"
   END

   DW = ReadDW(DWIndex, FILE=file, _EXTRA=e)

   CDW = Handle_Val(P.DWW(DWindex))
   IF CDW.bound EQ 'TOROID' THEN WRAP = 1 ELSE WRAP = 0
   IF CDW.T2S THEN BEGIN 
      PROJECTIVE = 0
      RECEPTIVE = 1
   END ELSE BEGIN
      PROJECTIVE = 1
      RECEPTIVE = 0
   END
stop
   Matrix = MiddleWeights(DW, sd, PROJECTIVE=PROJECTIVE, RECEPTIVE=RECEPTIVE, WRAP=WRAP)

   IF keyword_set(CENTER) THEN Matrix = Shift(Matrix, P.LW((P.DWW(DWindex).SOURCE)).h/2+1, P.LW((P.DWW(DWindex).SOURCE)).w/2+1)

   Video =  InitVideo( Matrix, TITLE=file+'.mw', /SHUTUP, /ZIPPED )
   dummy = CamCord( Video, Matrix)
   Eject, Video, /NOLABEL, /SHUTUP
   
   ;-------------> PLOT THE WEIGHT-MATRIX
   OpenSheet, MW_1, 0
   ushade_surf, Matrix
   CloseSheet, MW_1, 0
   OpenSheet, MW_1, 1
   PlotTvScl, Matrix, /LEGEND, TITLE='Mean Weights'
   CloseSheet, MW_1, 1
   OpenSheet, MW_1, 2
   PlotTvScl, SD, /LEGEND, TITLE='Standard Deviation'
   CloseSheet, MW_1, 2

   
   IF Keyword_Set(WAIT) THEN Waiting
   IF Keyword_Set(STOP) THEN Stop
   FreeDW, DW
END



PRO MeanWeights, DWindex, _EXTRA=e

   COMMON ATTENTION

   iter = foreach('_MeanWeights', DWindex, _EXTRA=e)

END
