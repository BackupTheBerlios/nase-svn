;+
; NAME:               InitWeights
;
; AIM:                initializes weight structures for simultion (used by <A>Sim</A>) 
;
; PURPOSE:            Initializes weigth matrices for simulation. It is internally called
;                     by SIM.
;
; CATEGORY:           MIND SIM INTERNAL
;
; CALLING SEQUENCE:   DW=InitWeights(DWW)
;
; COMMON BLOCKS:      ATTENTION
;
; SEE ALSO:           <A HREF=http://neuro.physik.uni-marburg.de/mind/sim/#SIM>sim</A>
;
; MODIFACTION HISTORY:
;
;       $Log$
;       Revision 1.7  2000/09/29 08:10:38  saam
;       added the AIM tag
;
;       Revision 1.6  2000/08/31 09:45:53  saam
;             fixed broken RandomU support for non-delayed DW structures
;
;       Revision 1.5  2000/08/11 14:07:27  thiel
;           Now supports RandomU initialization of weights and delays.
;
;       Revision 1.4  2000/05/16 16:32:30  saam
;             + new weight type INIT
;             + fixed bug with undefined W_RANDOM
;
;       Revision 1.3  2000/01/20 14:41:51  saam
;             the dinit may be completely omitted if
;             no delays are necessary
;
;       Revision 1.2  2000/01/19 17:26:36  saam
;             does non-delays as what they are (and
;             doesn't emulate them as delay-0 delays)
;
;       Revision 1.1  1999/12/10 09:36:47  saam
;             * hope these are all routines needed
;             * no test, yet
;
;
;-
FUNCTION InitWeights, DWW
   
   COMMON ATTENTION

   tts = DWW.T2S
   OS = 1./(1000*P.SIMULATION.SAMPLE)
   IF DWW.bound EQ 'TOROID' THEN TRUNCATE = 0 ELSE TRUNCATE = 1
   S = DWW.SOURCE
   T = DWW.TARGET

   curLayer = Handle_Val(P.LW(s))
   SW = curLayer.W
   SH = curLayer.H
   curLayer = Handle_Val(P.LW(t))
   TW = curLayer.W
   TH = curLayer.H
   CON = 0l



   IF Contains(DWW.WINIT.TYPE,'LOAD') THEN BEGIN
      ; RESTORE ALREADY EXISTING DW 
      lun = UOpenR(P.file+'.'+DWW.FILE+'.dw')
      CON = RestoreDW(LoadStruc(lun))
      UClose, lun
   END ELSE BEGIN

      
      ; INIT THE WEIGHTS
      IF Contains(DWW.WINIT.TYPE, 'CONST') THEN BEGIN  
         OPT = Create_Struct('W_CONST',[DWW.WINIT.A, DWW.WINIT.R], 'W_TRUNCATE', truncate, 'NOCON', DWW.WINIT.R)
      END ELSE IF Contains(DWW.WINIT.TYPE, 'INIT') THEN BEGIN
          OPT = Create_Struct( 'W_INIT',[DWW.WINIT.W])
      END ELSE IF Contains(DWW.WINIT.TYPE, 'GAUSSIAN') THEN BEGIN
         IF DWW.WINIT.NORM EQ 1 THEN BEGIN
            OPT = Create_Struct( 'W_GAUSS',[DWW.WINIT.A, DWW.WINIT.S, 1], 'W_TRUNCATE',truncate, 'NOCON', DWW.WINIT.R)
         END ELSE BEGIN
            OPT = Create_Struct( 'W_GAUSS',[DWW.WINIT.A, DWW.WINIT.S], 'W_TRUNCATE',truncate, 'NOCON', DWW.WINIT.R)
         END
      END ELSE IF Contains(DWW.WINIT.TYPE, 'NONE') THEN BEGIN
         OPT = Create_Struct('WEIGHT', !NONE)
      END ELSE IF Contains(DWW.WINIT.TYPE, 'WEIGHT') THEN BEGIN
         OPT = Create_Struct('WEIGHT', DWW.WINIT.W)
      END ELSE Message, 'unknown option for weights'

      IF ExtraSet(DWW.WINIT, "N") THEN OPT = Create_Struct(OPT, 'W_RANDOM', [0,DWW.WINIT.N])
      IF ExtraSet(DWW.WINIT, "RandomU") THEN $
       OPT = Create_Struct(OPT, 'W_RANDOM', DWW.WINIT.randomu)


      ; INIT THE DELAYS
      IF ExtraSet(DWW, 'DINIT') THEN BEGIN
         IF Contains(DWW.DINIT.TYPE, 'CONST') THEN BEGIN      
            OPT = Create_Struct(OPT, 'D_CONST', [OS*DWW.DINIT.C, DWW.DINIT.R])
         END ELSE IF Contains(DWW.DINIT.TYPE, 'LINEAR') THEN BEGIN
            OPT = Create_Struct(OPT, 'D_LINEAR', [OS*DWW.DINIT.M, OS*DWW.DINIT.D, DWW.DINIT.R])
;      END ELSE IF Contains(DWW.DINIT.TYPE, 'NONE') THEN BEGIN
;         OPT = Create_Struct(OPT, 'DELAY', 0)
         END ELSE IF Contains(DWW.DINIT.TYPE, 'DELAY') THEN BEGIN
            OPT = Create_Struct(OPT, 'DELAY', DWW.DINIT.C)
         END                    ;ELSE Message, 'unknown value for delays'
         IF ExtraSet(DWW.DINIT, "RandomU") THEN $
           OPT = Create_Struct(OPT, 'D_RANDOM', DWW.DINIT.randomu)
      END

      ; COMPLETE WIDTH LAYER DIMENSIONS
      OPT = Create_Struct(OPT, 'S_WIDTH', SW, 'S_HEIGHT', SH, 'T_WIDTH', TW, 'T_HEIGHT', TH)
      IF tts EQ 1 THEN OPT = Create_Struct(OPT, 'TARGET_TO_SOURCE', tts)

      ; CHECK FOR SELF-CONNECTIONS
      IF (DWW.Self EQ 'NONSELF') AND (S EQ T) THEN BEGIN
         OPT = Create_Struct(OPT, 'W_NONSELF', 1)
         OPT = Create_Struct(OPT, 'D_NONSELF', 1)
      END

      ; INIT WEIGHT MATRIX
      CON = InitDW(_EXTRA=OPT)

   END
   RETURN, CON

END
