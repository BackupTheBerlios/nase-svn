;+
; NAME:                SetWeights
;
; PURPOSE:             Setzt die Gewichtsmatrix der DelayWeigh-Struktur 
;
; CATEGORY:            SIMULATION CONNECTIONS
;
; CALLING SEQUENCE:    SetDelays, DW, D
;
; INPUTS:              DW: Eine mit InitDW initialisierte DelayWeigh-
;                          Struktur
;                      D : die zu setzende Gewichtsmatrix
;
; EXAMPLE:             DW = InitDW(S_WIDTH=10, S_HEIGHT=10, 
;                                  T_WIDTH=5, T_HEIGHT=5,
;                                  WEIGHT=4.0)
;                      D = FltArr(5*5, 10*10)
;                      SetDelays, DW, D
;
; SEE ALSO:            <A HREF="#INITDW">InitDW</A>, <A HREF="#WEIGHTS#">Weights</A>
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 2.1  1998/01/05 17:20:24  saam
;           Jo, hmm, viel Spass...
;
;
;-
PRO SetDelays, _DW, W
   
   Handle_Value, _DW, DW, /NO_COPY 
   
   S = Size(W)
   IF S(0) NE 2                 THEN Message, 'Delay Matrix has to be two-dimensional'
   IF S(1) NE target_h*target_s THEN Message, 'wrong target dimensions'
   IF S(2) NE source_w*source_h THEN Message, 'wrong source dimensions'
   DW.Delays = W

   Handle_Value, _DW, DW, /NO_COPY, /SET
   
END
