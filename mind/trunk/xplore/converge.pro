;+
; NAME:                CONVERGE
;
; PURPOSE:             Displays the convergence of a learned weight matrix.
;                      The underlying video is a DblArr(3) containing euklidian distance every
;                      P.SIM_CONVERGE_BIN bins divided by this factor, the medium and the maximal
;                      weight.
;                       
; CATEGORY:            MIRKO CALC
;
; CALLING SEQUENCE:    CONVERGE
;
; COMMON BLOCKS:       ATTENTION : simulation parameters
;                      SH_CONV   : sheet definitions
;
; SEE ALSO:            SIMN
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 1.1  2000/02/16 13:37:38  saam
;           fixed DWW problem (org: sim/idl/calc/converge.pro)
;
;     Revision 1.2  1998/10/12 13:56:08  saam
;           first version
;
;     Revision 1.1  1998/10/12 13:55:48  saam
;           Initial revision
;
;-
PRO _Converge, DWindex, STOP=stop, _EXTRA=e

   COMMON ATTENTION
   COMMON SH_CONV, CONVwins, CONV_1


   IF ExtraSet(e, 'NOGRAPHIC') THEN BEGIN
      CONV_1  = DefineSheet(/NULL)
      CONVwins = 0
   END ELSE IF ExtraSet(e, 'PS') THEN BEGIN
      CONV_1 = DefineSheet(/PS, FILENAME=P.file+'converge', MULTI=[3,3,1])
      CONVwins = 0
   END ELSE BEGIN
      IF (SIZE(CONVwins))(1) EQ 0 THEN BEGIN
         CONV_1 = DefineSheet(/Window, XSIZE=200, YSIZE=100, TITLE='Weight Convergence', MULTI=[3,3,1])
         CONVwins = 1
      END
   END

   tmp =  Handle_Val(P.LEARNW(DWindex))
   RC =  tmp.RECCON
   IF RC GT 0 THEN BEGIN
      CDW = Handle_Val(P.DWW(tmp.DW))
      Video =  LoadVideo(P.File+'.'+CDW.FILE+'.dist', GET_LENGTH=n)
      WD    = DblArr(n)
      WMean = DblArr(n)
      WMax = DblArr(n)
      FOR i=0l,n-1 DO BEGIN
         tmp = Replay(Video)
         WD(i)    = tmp(0)
         WMean(i) = tmp(1)
         WMax(i)  = tmp(2)
      END 
      Eject, Video, /SHUTUP, /NOLABEL

      OpenSheet, CONV_1, 0
      wd(0) = 0
      PLOT, LIndGen(n)*RC, wd, TITLE='Distance', XTITLE='t / ms'
      CloseSheet, CONV_1, 0
      OpenSheet, CONV_1, 1
      PLOT, LIndGen(n)*RC, WMean, TITLE='Mean Weight', XTITLE='t / ms'
      CloseSheet, CONV_1, 1
      OpenSheet, CONV_1, 2
      PLOT, LIndGen(n)*RC, WMax, TITLE='Maximal Weight', XTITLE='t / ms'
      CloseSheet, CONV_1, 2
 
   END
   IF Keyword_Set(STOP) THEN STOP

END

PRO CONVERGE, DWindex, _EXTRA=e
   
   Default, DWindex, 0
   iter = foreach('_CONVERGE', DWindex, _EXTRA=e)

END
