;+
; NAME:
;  FloatWeigh
;
; AIM: Propagate analog input values through connections given in DW structure.
; 
; PURPOSE:
;  -please specify-
;  
; CATEGORY:
;  -please specify-
;  
; CALLING SEQUENCE:
;  -please specify-
;  
; INPUTS:
;  -please remove any sections that do not apply-
;  
; OPTIONAL INPUTS:
;  -please remove any sections that do not apply-
;  
; KEYWORD PARAMETERS:
;  -please remove any sections that do not apply-
;  
; OUTPUTS:
;  -please remove any sections that do not apply-
;  
; OPTIONAL OUTPUTS:
;  -please remove any sections that do not apply-
;  
; COMMON BLOCKS:
;  -please remove any sections that do not apply-
;  
; SIDE EFFECTS:
;  -please remove any sections that do not apply-
;  
; RESTRICTIONS:
;  -please remove any sections that do not apply-
;  
; PROCEDURE:
;  -please specify-
;  
; EXAMPLE:
;  -please specify-
;  
; SEE ALSO:
;  -please remove any sections that do not apply-
;  <A HREF="#MY_ROUTINE">My_Routine()</A>
;  
;-
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 2.1  2000/09/25 16:49:13  thiel
;            AIMS added.
;
;




FUNCTION FloatWeigh, _DW, In
   

   Handle_Value, _DW, DW, /NO_COPY
 

; Nur bei Depression:  
; in last_ap stehen fuer jede Verbindung die Anzahl der Zeitschritte seit der letzten Aktivitaet
   IF DW.depress EQ 1 THEN  DW.LAST_AP = DW.LAST_AP + 1
     

;----- Der Teil ohne Delays:   

   IF (DW.Info EQ 'SDW_WEIGHT') THEN BEGIN


      IF Handle_Info(DW.Learn) THEN Handle_Value, DW.Learn, In, /SET $
      ELSE  DW.Learn = Handle_Create(_DW, VALUE=In)

      IF In(0) EQ 0 THEN BEGIN
         result = FltArr(2,1)
         result(1,0) = DW.target_w*DW.target_h
         Handle_Value, _DW, DW, /NO_COPY, /SET 
         RETURN, result
                                ;aus der Funktion rausspringen, wenn
                                ;ohnehin keine Aktivitaet im Input vorliegt:
      END

      
      ; asi : active source index
      ; asn : active source neuron
      ; wi  : weight indices
      vector = FltArr(DW.target_w*DW.target_h)
      


      FOR asi=2l,In(0)+1 DO BEGIN
         asn = In(0,asi-1)
         IF DW.S2C(asn) NE -1 THEN BEGIN
            Handle_Value, DW.S2C(asn), wi, /NO_COPY
            ; C2T(wi) has each target neuron only once,
            ; because there is only one connection between
            ; source and target; therefore next assignment is ok
            tN = DW.C2T(wi) 


            ; nur bei depression :
            IF DW.depress EQ 1 THEN begin
            ; regeneration der relativen transmitterzahl 
               DW.TRANSM(wi) = (1 - (1 - DW.TRANSM(wi)) * DW.exp_array(DW.last_ap(wi) < (4*DW.tau_rec)))
               DW.LAST_AP(wi) = 0
               
            ; normierung :
            ; gleiches verhalten wie non-depressive synapsen bei transm=1 ; nicht mehr
               IF dw.realscale EQ 0 THEN vector(tN) = vector(tn) + DW.W(wi) * DW.TRANSM(wi) $
               ELSE vector(tN) = vector(tn) + DW.W(wi) * DW.TRANSM(wi) * dw.U_se(wi) 
                                                                  
               DW.TRANSM(wi) =  (1- DW.U_se(wi))*DW.TRANSM(wi)

            ; nichtdepressiver fall :   
            END ELSE vector(tN) = Temporary(vector(tn)) + DW.W(wi)*in(1,asi-1)
           
            Handle_Value, DW.S2C(asn), wi, /NO_COPY, /SET
         END
      END
      
handle_Value, _DW, DW, /NO_COPY, /SET 
RETURN, Spassmacher(vector)

      
      
      
;----- Der Teil mit Delays:      
   END ELSE IF (DW.Info EQ 'SDW_DELAY_WEIGHT') THEN BEGIN
      
      Message, 'Error: Floats cannot be propagated through delay lines.'

      ; acili: active connection index list IN
      ; acilo: active connection index list OUT
      ; asi  : active source index
      ; asn  : active source neuron
      ; atn  : active target neurons

;      acili_empty = 1 ;TRUE


;      ; compute the weight indices receiving input from IN in a list named ACILI
;      FOR asi= 2l, In(0)+1 DO BEGIN
;         asn = In(asi)
;         IF DW.S2C(asn) NE -1 THEN BEGIN
;            Handle_Value, DW.S2C(asn), wi            
;            IF NOT acili_empty THEN BEGIN
;               acili = [acili, wi] 
;            END ELSE BEGIN
;               acili = wi
;               acili_empty = 0
;            END
;         END
;      END

;      ; convert ACILI into an SSpass list 
;      IF NOT acili_empty THEN BEGIN
;         acili = [n_elements(acili), N_Elements(DW.W), acili]
;      END ELSE BEGIN
;         acili = [0, N_Elements(DW.W)]
;      END

;      ; enQueue it and deQueue results in ACILO
;      Handle_Value, DW.queuehdl, tmpQU, /NO_COPY ; tmpQU = DW.Queue
;      acilo = SpikeQueue( tmpQu, acili ) 
;      Handle_Value, DW.queuehdl, tmpQU, /NO_COPY, /SET ; DW.Queue = tmpQu

;      IF Handle_Info(DW.Learn) THEN Handle_Value, DW.Learn, acilo, /SET $
;      ELSE DW.Learn = Handle_Create(_DW, VALUE=acilo)

;      vector = FltArr(DW.target_w*DW.target_h)

;      ; create a Spass vector with the output activity
;      IF acilo(0) GT 0 THEN BEGIN
;         counter = 0
;         acilo = acilo(2:acilo(0)+1)
         
;         ; wi: weight index
;         FOR i=0l,N_Elements(acilo)-1 DO BEGIN
;            wi = acilo(i)
;            ; get corresponding target index
;            tN = DW.C2T(wi)
     
;            ; wie im teil ohne delays :
;            IF DW.depress EQ 1 THEN begin
;               DW.TRANSM(wi) = (1 - ((1 - DW.TRANSM(wi)) * DW.exp_array(DW.last_ap(wi) < (4*DW.tau_rec))))
;               DW.LAST_AP(wi) = 0
               
;               IF dw.realscale EQ 0 THEN vector(tN) = vector(tn) + DW.W(wi) * DW.TRANSM(wi) $
;                ELSE vector(tN) = vector(tn) + DW.W(wi) * DW.TRANSM(wi)*dw.U_se(wi)  
;               DW.TRANSM(wi) =  (1 - DW.U_se(wi))*DW.TRANSM(wi)
              
               
;            END ELSE vector(tN) = vector(tn) + DW.W(wi)
            
;         END
         
;         Handle_Value, _DW, DW, /NO_COPY, /SET 
;         RETURN, Spassmacher(vector)
;      END ELSE BEGIN
;         tS = DW.target_w*DW.target_h 
;         Handle_Value, _DW, DW, /NO_COPY, /SET 
;         RETURN, [0, tS]
;      END
              
      
   END ELSE Message, 'SDW[_DELAY]_WEIGHT structure expected, but got '+Info(DW)



END   
