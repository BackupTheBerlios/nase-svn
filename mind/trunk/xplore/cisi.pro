;+
; NAME:               CISI
;
; PURPOSE:            Computes the individual inter-spike-intervals for a layer
;                     of neurons and also display the histogram.
;
; CATEGORY:           MIND XPLORE
;
; CALLING SEQUENCE:   CISI [, LayerIndex] [,CUTOFF=cutoff]
;
; INPUTS:             LayerIndex: the index of the layer to be displayed
;
; KEYWORD PARAMETERS: CUTOFF: the amount of events to be displayed, this is useful
;                             because some few neurons have very high isis and these
;                             squeeze the display of the results. Default is 0.99 
;                     EXTRA : keywords are passed to ReadSimu
;
; COMMON BLOCKS:      ATTENTION
;                     SH_CISI   : sheets
;
; SEE ALSO:           <A HREF=http://neuro.physik.uni-marburg.de/nase/methods/signals#ISI>isi</A>, <A HREF=http://neuro.physik.uni-marburg.de/mind/sim#READSIMU>readsimu</A>, <A HREF=http://neuro.physik.uni-marburg.de/mind/control/#FOREACH>foreach</A>
;ISIH, ForEach, ReadSimu
;
; MODIFICATION HISTORY:
;
;      $Log$
;      Revision 1.1  2000/01/04 13:58:26  saam
;           + taken from idl/calc
;           + improved axis labeling
;
;
;
PRO _CISI, LayerIndex, CUTOFF=cutoff, _EXTRA=e   

   COMMON ATTENTION
   COMMON SH_CISI, CISIwins, CISI_1

   Default, CUTOFF, 0.99

   ;----->
   ;-----> ORGANIZE THE SHEETS
   ;----->
   IF ExtraSet(e, 'NEWWIN') THEN BEGIN
      DestroySheet, CISI_1
      CISIwins = 0
   END
   IF ExtraSet(e, 'NOGRAPHIC') THEN BEGIN
      CISI_1 = DefineSheet(/NULL)
      CISIwins = 0
   END ELSE IF ExtraSet(e, 'PS') THEN BEGIN
      CISI_1 = DefineSheet(/PS, /ENCAPSULATED, FILENAME=P.File+'isi', MULTI=[2,2,1])
      CISIwins = 0
   END ELSE BEGIN
      IF (SIZE(CISIwins))(1) EQ 0 THEN BEGIN
         CISI_1 = DefineSheet(/Window, XSIZE=300, YSIZE=300, XPOS=600, TITLE='CISI', MULTI=[2,2,1])
         CISIwins = 1
      END
   END


   ;----->
   ;-----> READ SPIKE TRAINS
   ;----->
   nt = ReadSimu(LayerIndex, _EXTRA=e)

   ;----->
   ;-----> COMPUTE ISI
   ;-----> 
   isih = isi(nt, HISTO=histo)

   maxISI = N_Elements(histo)
   cummulate = LonArr(maxISI)
   cummulate(0) = histo(0)
   FOR i=1l, maxISI-1 DO cummulate(i) = cummulate(i-1)+histo(i)

   cutOff =  WHERE(cummulate LE CUTOFF*TOTAL(histo),c)
   IF c NE 0 THEN BEGIN
      cutOff = MAX(cutOff)
      isih = isih(*,0:cutOff)
   END

   ;----->
   ;-----> PLOT ISI
   ;----->
   OpenSheet, CISI_1, 0
   ULoadCt, 5
   L = Handle_Val(P.LW(LayerIndex))
   PlotTvScl, isih, /LEGEND, /FULLSHEET, XTITLE='neuron #', YTITLE='#', TITLE='ISI: '+L.NAME
   XYOuts, 1.0, 0.9, 'MAX ISI: '+STRCOMPRESS(maxISI, /REMOVE_ALL), /NORMAL, ALIGNMENT=1, COLOR=RGB('white', /NOALLOC)
   XYOUTs, 1.0, 0.8, 'Cutoff : '+STRCOMPRESS(STRING(cutoff,FORMAT="(G0.0)"), /REMOVE_ALL), /NORMAL, ALIGNMENT=1, COLOR=RGB('white', /NOALLOC)
   Inscription, AP.ofile, /INSIDE, /RIGHT, /TOP, CHARSIZE=0.4, CHARTHICK=1
   CloseSheet, CISI_1, 0

   OpenSheet, CISI_1, 1
   Plot, histo, TITLE='ISI-Histogram: '+L.NAME, XTITLE='ISI / BIN', YTITLE='#'
   Inscription, AP.ofile, /INSIDE, /RIGHT, /TOP, CHARSIZE=0.4, CHARTHICK=1
   CloseSheet, CISI_1, 1

END

PRO CISI, LayerIndex, _EXTRA=e

   COMMON ATTENTION

   Default, LayerIndex, 0
   iter = foreach('_CISI', LayerIndex, _EXTRA=e)

END
