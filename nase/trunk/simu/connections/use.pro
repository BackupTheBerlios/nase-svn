; NAME:                Use
;
; PURPOSE:             Ermittelt die zu einer DelayWeigh-Struktur 
;                      gehoerende U_se-Matrix 
;
; CATEGORY:            SIMULATION CONNECTIONS
;
; CALLING SEQUENCE:    U_se = Use(DW [,/DIMENSIONS])
;
; INPUTS:              DW: Eine mit InitDW initialisierte DelayWeigh-
;                          Struktur (SDW oder Oldstyle-DW)
;
; OUTPUTS:             U_se: die U_se-Matrix
;                         Dies ist eine zweidimensionales Array der Form
;                         U_se ( Target_Neuron, Source_Neuron ), wenn
;                         nicht das Schlüsselwort /DIMENSIONS
;                         angegeben wurde.
;
; KEYWORDS:            DIMENSIONS: Wird dieses Schlüsselwort
;                                  angegeben, so ist U_se eine
;                                  vierdimensionale Matrix (Matrix von 
;                                  Matrizen) der Form
;                                  U_se ( Target_Row,Target_Col, Source_Row,Source_Col )
;
; EXAMPLE:             DW = InitDW(S_WIDTH=10, S_HEIGHT=10, 
;                                  T_WIDTH=5, T_HEIGHT=5,
;                                  WEIGHT=4.0)
;                      u_se = use(DW)
;                      help, u_se
;
;                      Output:
;                               u_se               FLOAT     = Array(25, 100)  
;
;                 
; SEE ALSO:            
;                      
; MODIFICATION HISTORY:
;
;
;     $Log$
;     Revision 2.1  1999/11/16 15:42:14  alshaikh
;           initial version
;
;
;-




FUNCTION Use, _DW, DIMENSIONS=dimensions
   
   IF (Info(_DW) EQ 'DW_WEIGHT') OR (Info(_DW) EQ 'DW_DELAY_WEIGHT') THEN BEGIN
      Handle_Value, _DW, DW, /NO_COPY
      IF (DW.depress EQ 0) THEN Message, 'depressive synapses expected, but got none :-('
      U_se = DW.U_se
      Handle_Value, _DW, DW, /NO_COPY, /SET
      If Keyword_Set(DIMENSIONS) then U_se = Reform(/OVERWRITE, U_se, DWDim(_DW,/TH), $
                                                    DWDim(_DW,/TW), DWDim(_DW,/SH), DWDim(_DW,/SW)) $
       else U_se = Reform(/OVERWRITE, U_se, DWDim(_DW,/TH)*DWDim(_DW,/TW), DWDim(_DW,/SH)*DWDim(_DW,/SW))
      RETURN, U_se
   END


   IF (Info(_DW) NE 'SDW_WEIGHT') AND (Info(_DW) NE 'SDW_DELAY_WEIGHT') THEN $
    Message, '[S]DW[_DELAY]_WEIGHT expected, but got '+STRING(Info(_DW))+' !'
   
   sS = DWDim(_DW, /SW) * DWDim(_DW, /SH)
   tS = DWDim(_DW, /TW) * DWDim(_DW, /TH)
   
   U_se = Make_Array(tS, sS, /FLOAT, VALUE=!NONE)

   Handle_Value, _DW, DW, /NO_COPY
   IF NOT (N_Elements(DW.U_se) EQ 1 AND DW.U_se(0) EQ !NONE) THEN BEGIN
      U_se(DW.c2t,DW.c2s) = DW.U_se
   END
   Handle_Value, _DW, DW, /NO_COPY, /SET
   
   If Keyword_Set(DIMENSIONS) then U_se = Reform(/OVERWRITE, U_se, DWDim(_DW,/TH), $
                                                 DWDim(_DW,/TW), DWDim(_DW,/SH), DWDim(_DW,/SW)) $
   else U_se = Reform(/OVERWRITE, U_se, $
                      DWDim(_DW,/TH)*DWDim(_DW,/TW), DWDim(_DW,/SH)*DWDim(_DW,/SW))
   RETURN, U_se
END
