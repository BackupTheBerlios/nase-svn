;+
; NAME:               ShowMUA
;
; PURPOSE:            Shows previously recorded MUA.
;
; CATEGORY:           MIND XPLORE 
;
; CALLING SEQUENCE:   ShowMUA [,/STOP]
;
; KEYWORD PARAMETERS: 
;                     STOP  : stop after displaying
;
; COMMON BLOCKS:      ATTENTION
;                     SH_SM     : sheets
;
; SEE ALSO:           <A HREF=http://neuro.physik.uni-marburg.de/mind/sim#READSIMU>readsimu</A>, <A HREF=http://neuro.physik.uni-marburg.de/mind/control/#FOREACH>foreach</A>
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 1.3  2000/06/20 10:21:12  saam
;          + i changed read&plot to read all and then plot all.
;            dunno why, but there was some important reason
;
;     Revision 1.2  2000/01/04 11:06:46  saam
;           + DOC-header updated
;           + file- and layer-titles are displayed
;
;     Revision 1.1  1999/12/21 09:58:31  saam
;           ok
;
;
;-
PRO _ShowMUA, STOP=stop, _EXTRA=e

   On_Error, 2
   COMMON SH_SM, SMwins, SM_1
   COMMON ATTENTION


   ;-----> DETERMINE MUA STATUS
   MUAmax = -1
   FOR i=0, N_Elements(P.LW)-1 DO BEGIN
      L = Handle_Val(P.LW(i))
      IF L.LEX.REC_MUA THEN BEGIN
         IF SET(MUA) THEN MUA = [MUA, i] ELSE MUA = i  ;;;--> MUA contains Indices of MUAs to be displayed
         MUAmax = MUAmax+1
      END
   END


   ;-----> ORGANIZE THE SHEETS
   IF ExtraSet(e, 'NEWWIN') THEN BEGIN
      DestroySheet, SM_1
      SMwins = 0
   END
   IF ExtraSet(e, 'NOGRAPHIC') THEN BEGIN
      SM_1 = DefineSheet(/NULL)
      SMwins = 0
   END ELSE IF ExtraSet(e, 'PS') THEN BEGIN
      SM_1 = DefineSheet(/NULL)
      SMwins = 0
   END ELSE BEGIN
      IF (SIZE(SMwins))(1) EQ 0 THEN BEGIN
         SM_1 = DefineSheet(/Window, MULTI=[MUAmax+1,0,MUAmax+1], XSIZE=1000, YSIZE=200, TITLE='Show MUA')
         SMwins = 1
      END
   END
   


   ;------> SUCCESSIVELY READ & PLOT DATA
   FOR i=0, MUAmax DO BEGIN 
      Sig = ReadSimu(MUA(i), /MUA, _EXTRA=e)
      OpenSheet, SM_1, i
      L = Handle_Val(P.LW(MUA(i)))
      Plot, FIndGen(N_Elements(sig))*(1000*P.SIMULATION.SAMPLE), sig, TITLE='MUA: '+L.NAME, XTITLE='t [ms]'
      Inscription, AP.ofile, /OUTSIDE, /RIGHT, /TOP, CHARSIZE=0.4, CHARTHICK=1
      CloseSheet, SM_1, i
   END
END


PRO ShowMUA, _EXTRA=e

   iter = foreach('_ShowMUA', _EXTRA=e)

END
