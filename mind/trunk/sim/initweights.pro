;+
; NAME:
;   InitWeights()
;
; AIM:
;   initializes weight structures for simulation (used by <A>Sim</A>) 
;
; PURPOSE:
;   Initializes weigth matrices for simulation. It is internally called
;   by SIM.
;
; CATEGORY:
;  Input
;  Internal
;  MIND
;  Simulation
;
; CALLING SEQUENCE:
;   DW=InitWeights(DWW)
;
; COMMON BLOCKS:
;   ATTENTION
;
; SEE ALSO:
;   <A>Sim</A>
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

      IF ExtraSet(DWW, "DEPRESS") then begin
          OPT = CREATE_STRUCT(OPT, 'DEPRESS', 1,'TAU_REC', DWW.TAU_REC, 'U_SE', DWW.U_SE)
      endif



      ; INIT THE DELAYS
      IF ExtraSet(DWW, 'DINIT') THEN BEGIN
         IF Contains(DWW.DINIT.TYPE, 'CONST') THEN BEGIN      
            OPT = Create_Struct(OPT, 'D_CONST', [OS*DWW.DINIT.C, DWW.DINIT.R])
        END ELSE IF Contains(DWW.DINIT.TYPE, 'INIT') THEN BEGIN
            OPT = Create_Struct(OPT, 'D_INIT',[DWW.DINIT.D])
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
