;+
; NAME:               TotalRecall
;
; PURPOSE:            Die Prozedur erhaelt als Input die (verzoegert oder nicht) praesynaptischen 
;                     Aktionspotentiale und updated alle Lernpotentiale, die in einer mit InitRecall 
;                     erzeugten Struktur enthalten sind. Der Aufruf dieser Routine erfolgt eigentlich 
;                     nur aus einer Lernregel. Wird kein In-Handle uebergeben, so werden die Potentiale
;                     nur abgeklungen.
;
; CATEGORY:           LEARNING
;
; CALLING SEQUENCE:   TotalRecall, LP [, DW]
;
; INPUTS:             LP: Eine mit InitRecall erzeugte Struktur
;                     IN: die zugehoerige DW-Struktur
;
; SIDE EFFECTS:       LP wird beim Aufruf veraendert
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
;                  TotalRecall, LP, My_DWS
;                  <Learn Something between My_Layer and My_layer>
;                  LayerProceed(My_Layer, ....)
;                  <Simulationsschleife STOP>
;
;
; MODIFICATION HISTORY:
;
;       $Log$
;       Revision 2.7  1998/02/05 14:26:51  saam
;             huge bug in docu corrected
;
;       Revision 2.6  1997/12/10 15:56:50  saam
;             Es werden jetzt keine Strukturen mehr uebergeben, sondern
;             nur noch Tags. Das hat den Vorteil, dass man mehrere
;             DelayWeigh-Strukturen in einem Array speichern kann,
;             was sonst nicht moeglich ist, da die Strukturen anonym sind.
;
;       Revision 2.5  1997/09/18 14:25:43  saam
;              Bug bei exponentiellem Abklingen beseitigt
;              In-Handle nun optional
;
;       
;       Thu Sep 4 15:42:53 1997, Mirko Saam
;       <saam@ax1317.Physik.Uni-Marburg.DE>
;		Header an veraenderte InitRecall-Routine angepasst
;
;       Thu Sep 4 11:38:25 1997, Mirko Saam
;       <saam@ax1317.Physik.Uni-Marburg.DE>
;		Schoepfung
;
;-
PRO TotalRecall, _LP, _DW

   Handle_Value, _LP, LP, /NO_COPY

   IF LP.info EQ 'e' THEN BEGIN
      active = WHERE(LP.values GT !NoMercyForPot, count)
      IF count NE 0 THEN BEGIN
         LP.values(active) = LP.values(active) * LP.dec
         toosmall = WHERE(LP.values(active) LT !NoMercyForPot, count)
         IF count NE 0 THEN LP.values(active(toosmall)) = 0.0
      END
      
      IF N_Params() GT 1 THEN BEGIN
         In = LearnAP(_DW)
         IF In(0) NE 0 THEN LP.values(In(2:In(0)+1)) = LP.values(In(2:In(0)+1)) + LP.v
      END
   END

   IF LP.info EQ 'l' THEN BEGIN
      active = WHERE(LP.values GE LP.dec, count)
      IF count NE 0 THEN BEGIN
         LP.values(active) = LP.values(active) - LP.dec
         toosmall = WHERE( LP.values(active) LT LP.dec, count )
         IF count NE 0 THEN LP.values(active(toosmall)) = 0.0
      END

      IF N_Params() GT 1 THEN BEGIN
         In = LearnAP(_DW)
         IF In(0) NE 0 THEN LP.values(In(2:In(0)+1)) = LP.values(In(2:In(0)+1)) + LP.v
      END
  END

  Handle_Value, _LP, LP, /NO_COPY, /SET

END
