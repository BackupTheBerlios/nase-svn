;+
; NAME:               TotalRecall
;
; PURPOSE:            Die Prozedur erhaelt als Input die (verzoegert oder nicht) praesynaptischen Aktionspotentiale 
;                     und updated alle Lernpotentiale, die in einer mit InitRecall erzeugten
;                     Struktur enthalten sind. Der Aufruf dieser Routine erfolgt eigentlich nur aus einer Lernregel.
;
; CATEGORY:           LEARNING
;
; CALLING SEQUENCE:   TotalRecall, LP, In
;
; INPUTS:             LP: Eine mit InitRecall erzeugte Struktur
;                     IN: Vektor, der die praesynaptischen (auch gewichteten) Aktionspotentiale enthaelt
;
; OPTIONAL INPUTS:    ---
;
; KEYWORD PARAMETERS: ---
;
; OUTPUTS:            ---
;
; OPTIONAL OUTPUTS:   ---
;
; COMMON BLOCKS:      ---
;
; SIDE EFFECTS:       LP wird beim Aufruf veraendert
;
; RESTRICTIONS:       ---
;
; PROCEDURE:          ---
;
; EXAMPLE:            
;                  My_Neuronentyp = InitPara_1()
;                  My_Layer       = InitLayer_1(Type=My_Neuronentyp, WIDTH=21, HEIGHT=21)   
;                  My_DWS         = InitDW (S_Layer=My_Layer, T_Layer=My_Layer, $
;                                           D_LINEAR=[1,2,10], /D_TRUNCATE, $
;                                            D_NRANDOM=[0,0.1], /D_NONSELF, $
;                                           W_GAUSS=[1,5], /W_TRUNCATE, $
;                                            W_RANDOM=[0,0.3], /W_NONSELF)
;
;                  LP = InitRecall( My_DWS, EXPO=[1.0, 10.0])
;
;                  <Simulationsschleife START>
;                  InputForMyLayer = DelayWeigh( My_DWS, My_Layer.O)
;                  TotalRecall, LP, InputForMyLayer
;                  <Learn Something between My_Layer and My_layer>
;                  LayerProceed(My_Layer, ....)
;                  <Simulationsschleife STOP>
;
;
; MODIFICATION HISTORY:
;
;       Thu Sep 4 15:42:53 1997, Mirko Saam
;       <saam@ax1317.Physik.Uni-Marburg.DE>
;
;		Header an veraenderte InitRecall-Routine angepasst
;
;       Thu Sep 4 11:38:25 1997, Mirko Saam
;       <saam@ax1317.Physik.Uni-Marburg.DE>
;
;		Schoepfung
;
;-
PRO TotalRecall, LP, InHandle

   Handle_Value, InHandle, In

   IF LP.info EQ 'e' THEN BEGIN
      active = WHERE(LP.values GT !NoMercyForPot, count)
      IF count NE 0 THEN BEGIN
         LP.values(active) = LP.values(active) * LP.dec
         toosmall = WHERE(LP.values LT !NoMercyForPot, count)
         IF count NE 0 THEN LP.values(active(toosmall)) = 0.0
      END
      
      IF In(0) NE 0 THEN LP.values(In(2:In(0)+1)) = LP.values(In(2:In(0)+1)) + LP.v
   END

   IF LP.info EQ 'l' THEN BEGIN
      active = WHERE(LP.values GE LP.dec, count)
      IF count NE 0 THEN BEGIN
         LP.values(active) = LP.values(active) - LP.dec
         toosmall = WHERE( LP.values(active) LT LP.dec, count )
         IF count NE 0 THEN LP.values(active(toosmall)) = 0.0
      END

      IF In(0) NE 0 THEN LP.values(In(2:In(0)+1)) = LP.values(In(2:In(0)+1)) + LP.v
  END

END
