;+
; NAME:               TotalRecall
;
; PURPOSE:            Die Prozedur erhaelt als Input die 
;                     (verzoegerten oder unverzoegerten) praesynaptischen 
;                     Aktionspotentiale (VORSICHT: das passiert
;                     bereits in DelayWeigh!) und aktualisiert alle 
;                     Lernpotentiale, die in der mit <A HREF="#INITRECALL">InitRecall</A>
;                     erzeugten Struktur enthalten sind. Wird kein 
;                     In-Handle uebergeben, so werden die Potentiale 
;                     nur abgeklungen.
;
; CATEGORY:           SIMULATION / PLASTICITY
;
; CALLING SEQUENCE:   TotalRecall, LP [, DW]
;
; INPUTS:             LP: Eine mit InitRecall erzeugte Struktur
;                     DW: die zugehoerige DW-Struktur
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
;                  ProceedLayer_1(My_Layer, ....)
;                  <Simulationsschleife STOP>
;
; SEE ALSO: <A HREF="#INITRECALL">InitRecall</A>, <A HREF="#LEARNHEBBLP">LearnHebbLP</A>
;
;
; MODIFICATION HISTORY:
;
;       $Log$
;       Revision 2.11  1998/11/08 17:51:38  saam
;             LearnTag added
;
;       Revision 2.10  1998/08/23 12:54:06  saam
;             now time-amplitude functionality: second-order-leaky-integrator
;
;       Revision 2.9  1998/04/30 12:30:16  thiel
;              Neues Schluesselwort SUSTAIN.
;
;       Revision 2.8  1998/04/29 12:32:03  thiel
;              Neues Schluesselwort NOACCUMULATION
;
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

PRO TotalRecall, _LP, _DW, LearnTag=LearnTag

   Handle_Value, _LP, LP, /NO_COPY

   IF LP.sust AND NOT Handle_Info(LP.last) THEN LP.Last = Handle_Create(!MH, VALUE=[0,0])

   IF LP.info EQ 'a' THEN nottoosmall = WHERE(LP.leak2 GT !NoMercyForPot, count) ELSE nottoosmall = WHERE(LP.values GT !NoMercyForPot, count)
   
   IF count NE 0 THEN BEGIN
      IF Handle_Info(LP.last) THEN Handle_Value, LP.last, lastspikes ELSE lastspikes = [0]
      IF lastspikes(0) NE 0 THEN BEGIN 
         i = [nottoosmall,lastspikes(2:lastspikes(0)+1)]
         i = i(Sort(i))
         w = Where((i NE Shift(i,1)) AND (i NE shift(i,-1)), count)
         IF count EQ 0 THEN i = -1 ELSE i = i(w)
      ENDIF ELSE i = nottoosmall
      IF i(0) NE -1 THEN BEGIN
         IF LP.info EQ 'e' THEN LP.values(i) = LP.values(i) * LP.dec 
         IF LP.info EQ 'l' THEN LP.values(i) = LP.values(i) - LP.dec
         IF LP.info EQ 'a' THEN BEGIN
            LP.leak1(i) = LP.leak1(i) * LP.dec1
            LP.leak2(i) = LP.leak2(i) * LP.dec2
            LP.values(i) = (LP.leak2(i)-LP.leak1(i))
         END
      ENDIF
      
      toosmall = WHERE(LP.values(nottoosmall) LT !NoMercyForPot, count)
      IF count NE 0 THEN LP.values(nottoosmall(toosmall)) = 0.0
   END
   
   IF N_Params() GT 1 OR Set(LearnTag) THEN BEGIN
      IF Set(LearnTag) THEN In = LearnTag ELSE In = LearnAP(_DW)
      IF In(0) NE 0 THEN BEGIN
         IF LP.noacc THEN BEGIN
            IF LP.info EQ 'a' THEN BEGIN
               LP.leak1(In(2:In(0)+1))  = LP.v
               LP.leak2(In(2:In(0)+1))  = LP.v
               LP.values(In(2:In(0)+1)) = ( LP.leak2(In(2:In(0)+1))-LP.leak1(In(2:In(0)+1)) )
            END ELSE LP.values(In(2:In(0)+1)) = LP.v
         END ELSE BEGIN
            IF LP.info EQ 'a' THEN BEGIN
               LP.leak1(In(2:In(0)+1))  = LP.leak1(In(2:In(0)+1)) + LP.v
               LP.leak2(In(2:In(0)+1))  = LP.leak2(In(2:In(0)+1)) + LP.v
               LP.values(In(2:In(0)+1)) = ( LP.leak2(In(2:In(0)+1))-LP.leak1(In(2:In(0)+1)) )
            END ELSE LP.values(In(2:In(0)+1)) = LP.values(In(2:In(0)+1)) + LP.v
         END   
      END
      IF Handle_Info(LP.last) THEN Handle_Value, LP.last, In, /SET
   END
   
   Handle_Value, _LP, LP, /NO_COPY, /SET

END
