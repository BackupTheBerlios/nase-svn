;+
; NAME:                SetWeights
;
; PURPOSE:             Setzt die Gewichtsmatrix der DelayWeigh-Struktur 
;
; CATEGORY:            SIMULATION CONNECTIONS
;
; CALLING SEQUENCE:    SetWeights, DW, W
;
; INPUTS:              DW: Eine mit InitDW initialisierte DelayWeigh-
;                          Struktur
;                      W : die zu setzende Gewichtsmatrix
;
; EXAMPLE:             DW = InitDW(S_WIDTH=10, S_HEIGHT=10, 
;                                  T_WIDTH=5, T_HEIGHT=5,
;                                  WEIGHT=4.0)
;                      W = FltArr(5*5, 10*10)
;                      SetWeights, DW, W
;
; SEE ALSO:            <A HREF="#INITDW">InitDW</A>, <A HREF="#WEIGHTS#">Weights</A>
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 2.1  1998/01/05 17:20:23  saam
;           Jo, hmm, viel Spass...
;
;
;-
PRO SetWeights, _DW, W
   
   Handle_Value, _DW, DW, /NO_COPY 
   
   S = Size(W)
   IF S(0) NE 2                 THEN Message, 'Weight-Matrix has to be two-dimensional'
   IF S(1) NE target_h*target_s THEN Message, 'wrong target dimensions'
   IF S(2) NE source_w*source_h THEN Message, 'wrong source dimensions'
   DW.Weights = W

   Handle_Value, _DW, DW, /NO_COPY, /SET
   
END
