;+
; NAME:
;  DelayWeigh()
;
; VERSION:
;  $Id$
;
; AIM:
;  Propagate spikes or analog values through a connection matrix.
;
; PURPOSE:
;  Propagate the ouput of a layer through a connection matrix (SDW
;  structure). Weights, delays and synaptic depression are handled as
;  specified in the SDW structure that is passed as the first
;  argument. If more than one spike is passed to a single target
;  neuron, the weights are combined according to the conjunction
;  method specified in the SDW structure.
;
; CATEGORY:
;  Connections
;  NASE
;  Simulation
;
; CALLING SEQUENCE:
;* outvector = DelayWeigh(connections, inhandle)
;
; INPUTS:
;  connections:: A structure created by <A>InitDW()</A> describing the
;                properties of the connections.
;  inhandle:: A handle to a list of input activities. This list has to
;             be in sparse format, either generated by
;             <A>Spassmacher()</A> (for analog input) or
;             <A>SSpassmacher()</A> (spike input). Usually, the output
;             of <A>LayerOut()</A> is directly applied here.
;
; OUTPUTS:
;  outvector:: A vector in sparse format, containing delayed and
;              synptically modified activity that can be used as input to
;              some layer of model neurons (see <A>InputLayer</A>).
;
; RESTRICTIONS:
;  The input's dimensions must fit the connections, this is not
;  checked and may lead to errors. Furthermore, one should keep in mind
;  that sparse arrays (Spass) are discriminated from binary sparse
;  arrays (SSpass) only according to their dimensions.   
;
; PROCEDURE:
;  Quite sophisticated.
;
; EXAMPLE:
;* MyDelMat = InitDW(S_WIDTH=2, S_HEIGHT=2, T_WIDTH=3, T_HEIGHT=1, $
;*                   WEIGHT=3.0, D_CONST=[4,2])
;* in = Handle_Create(!MH, VALUE=SSpassmacher([1,1,1,1]))
;* outvector = DelayWeigh(MyDelMat, in)
;* Print, SpassBeiseite(OutVector)
;*
;*> 0.000000     0.000000     0.000000
;*
;* For z=0,6 DO $
;*    Print, SpassBeiseite(DelayWeigh(MyDelMat, Handle_Create(!MH, VALUE=Spassmacher([0,0,0,0]))) )
;*
;*> 0.000000     0.000000     0.000000
;*> 0.000000     0.000000     0.000000
;*> 0.000000     0.000000     0.000000
;*> 12.0000      12.0000      12.0000
;*> 0.000000     0.000000     0.000000
;*> 0.000000     0.000000     0.000000
;*> 0.000000     0.000000     0.000000
;
; SEE ALSO:
;  <A>InitDW()</A>, <A>InputLayer</A>, <A>Spassmacher()</A>, <A>SSpassmacher()</A>.
;-



PRO Register_Output, outvector, targetneuron, strength, method
   CASE method OF
      ;; 1: SUM
      1: outvector(targetneuron) = outvector(targetneuron) + strength
      ;; 2: MAX
      2: outvector(targetneuron) = outvector(targetneuron) > strength
      ELSE: Message, "SDW struct specified unknown conjunction-method '"+ $
       Str(method)+"'."
   ENDCASE
END



FUNCTION DelayWeigh, _DW, InHandle
   

   Handle_Value, _DW, DW, /NO_COPY
   Handle_Value, InHandle, In
 

   ;; Only if depressive synapses are used:  
   ;; last_ap saves the number of timesteps since the last spike.
   IF DW.depress EQ 1 THEN  DW.LAST_AP = DW.LAST_AP + 1
     
   ;; These are needed to compute if the input is in SPASS or
   ;; SSPASS format.
   indim = (Size(in))(0)
   indimeq1 = indim EQ 1
;   indimne1 = indim NE 1


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

      
      ;; asi : active source index
      ;; asn : active source neuron
      ;; wi  : weight indices
      vector = FltArr(DW.target_w*DW.target_h)
      
      ;; The following loop either runs through every entry of the input if
      ;; indim eq 1, i.e. input is in SSPASS format or runs through
      ;; every second element if indim eq 2, i.e. input is in SPASS format.
      FOR asi=1l*indim+indimeq1,in(0)*indim+indimeq1, indim DO BEGIN
         asn = in(asi)
         IF DW.S2C(asn) NE -1 THEN BEGIN
            Handle_Value, DW.S2C(asn), wi, /NO_COPY
            ;; C2T(wi) has each target neuron only once,
            ;; because there is only one connection between
            ;; source and target; therefore next assignment is ok
            tN = DW.C2T(wi) 

            ;; only if depressive synapses are used:
            IF DW.depress EQ 1 THEN BEGIN
            ;; regeneration of relative transmitteramount 
               DW.TRANSM(wi) = (1 - (1 - DW.TRANSM(wi)) * $
                                DW.exp_array(DW.last_ap(wi) < (4*DW.tau_rec)))
               DW.LAST_AP(wi) = 0
               
               ;; Normalization:
               ;; Same behavior as non-depressive synapses with transm=1.
;               IF dw.realscale EQ 0 THEN vector(tN) = vector(tn) + DW.W(wi) * DW.TRANSM(wi) $
;               ELSE vector(tN) = vector(tn) + DW.W(wi) * DW.TRANSM(wi) * dw.U_se(wi) 
               IF dw.realscale EQ 0 THEN $
                ;Register_Output, vector, tN $
                ;, DW.W(wi)*(indimeq1+(indimne1*in(asi*indim+1))) $
                ;*DW.TRANSM(wi), DW.conjunction_method $
               transm=dw.transm(wi) $
               ELSE $
                ;Register_Output, vector, tN, $
                ;DW.W(wi)*(indimeq1+(indimne1*in(asi*indim+1))) $
                ;*DW.TRANSM(wi)*dw.U_se(wi), DW.conjunction_method
               transm = DW.TRANSM(wi)*dw.U_se(wi)

               DW.TRANSM(wi) =  (1- DW.U_se(wi))*DW.TRANSM(wi)

            ; non-depressive case:   
;            END ELSE vector(tN) = Temporary(vector(tn)) + DW.W(wi)*in(1,asi)
;            END ELSE vector(tN) = Temporary(vector(tn)) + DW.W(wi)*(indimeq1+(indimne1*in(asi*indim+1)))
            END ELSE BEGIN ;; non-depressive case:
               transm = 1.
            ENDELSE

            ;; Input values have to be considered if input is in SPASS
            ;; format, i.e. if input dimensions are ne 1.
            IF indimeq1 THEN Register_Output, vector, tN, $
             DW.W(wi)*transm, DW.conjunction_method $
            ELSE Register_Output, vector, tN, $
             DW.W(wi)*in(asi+1)*transm, DW.conjunction_method

            Handle_Value, DW.S2C(asn), wi, /NO_COPY, /SET
         END
      END
      
      Handle_Value, _DW, DW, /NO_COPY, /SET 
      
      RETURN, Spassmacher(vector)

      
      
      
;----- Der Teil mit Delays:      
   END ELSE IF (DW.Info EQ 'SDW_DELAY_WEIGHT') THEN BEGIN
      
      IF NOT indimeq1 THEN Console, /FATAL $
       , 'SPASS input cannot be propagated through delay lines yet.'

      ; acili: active connection index list IN
      ; acilo: active connection index list OUT
      ; asi  : active source index
      ; asn  : active source neuron
      ; atn  : active target neurons

      acili_empty = 1 ;TRUE


      ; compute the weight indices receiving input from IN in a list named ACILI
      FOR asi= 2l, In(0)+1 DO BEGIN
         asn = In(asi)
         IF DW.S2C(asn) NE -1 THEN BEGIN
            Handle_Value, DW.S2C(asn), wi            
            IF NOT acili_empty THEN BEGIN
               acili = [acili, wi] 
            END ELSE BEGIN
               acili = wi
               acili_empty = 0
            END
         END
      END

      ; convert ACILI into an SSpass list 
      IF NOT acili_empty THEN BEGIN
         acili = [n_elements(acili), N_Elements(DW.W), acili]
      END ELSE BEGIN
         acili = [0, N_Elements(DW.W)]
      END

      ; enQueue it and deQueue results in ACILO
      Handle_Value, DW.queuehdl, tmpQU, /NO_COPY ; tmpQU = DW.Queue
      acilo = SpikeQueue( tmpQu, acili ) 
      Handle_Value, DW.queuehdl, tmpQU, /NO_COPY, /SET ; DW.Queue = tmpQu

      IF Handle_Info(DW.Learn) THEN Handle_Value, DW.Learn, acilo, /SET $
      ELSE DW.Learn = Handle_Create(_DW, VALUE=acilo)

      vector = FltArr(DW.target_w*DW.target_h)

      ; create a Spass vector with the output activity
      IF acilo(0) GT 0 THEN BEGIN
         counter = 0
         acilo = acilo(2:acilo(0)+1)
         
         ; wi: weight index
         FOR i=0l,N_Elements(acilo)-1 DO BEGIN
            wi = acilo(i)
            ; get corresponding target index
            tN = DW.C2T(wi)
     
            ; wie im teil ohne delays :
            IF DW.depress EQ 1 THEN begin
               DW.TRANSM(wi) = (1 - ((1 - DW.TRANSM(wi)) * DW.exp_array(DW.last_ap(wi) < (4*DW.tau_rec))))
               DW.LAST_AP(wi) = 0
               
               IF dw.realscale EQ 0 THEN register_Output, vector, tN, DW.W(wi) * DW.TRANSM(wi), DW.conjunction_method $
                ELSE register_Output, vector, tN, DW.W(wi) * DW.TRANSM(wi)*dw.U_se(wi), DW.conjunction_method
               DW.TRANSM(wi) =  (1 - DW.U_se(wi))*DW.TRANSM(wi)
              
               
            END ELSE register_Output, vector, tN, DW.W(wi), DW.conjunction_method
            
         END
         
         Handle_Value, _DW, DW, /NO_COPY, /SET 
         RETURN, Spassmacher(vector)
      END ELSE BEGIN
         tS = DW.target_w*DW.target_h 
         Handle_Value, _DW, DW, /NO_COPY, /SET 
         RETURN, [0, tS]
      END
              

   END ELSE Message, 'SDW[_DELAY]_WEIGHT structure expected, but got '+Info(DW)



END   
