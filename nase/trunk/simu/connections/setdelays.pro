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
;     Revision 2.2  1998/01/29 16:15:39  saam
;           last revision was completely unusable,
;           now it seems to work :-0
;
;     Revision 2.1  1998/01/05 17:20:24  saam
;           Jo, hmm, viel Spass...
;
;
;-
PRO SetDelays, _DW, W
   
   IF NOT Contains(Info(_DW), 'DW_DELAY_WEIGHT', /IGNORECASE) THEN Message, 'no DelayWeigh structure, but ...'+Info(_DW)
   
   Handle_Value, _DW, DW, /NO_COPY 
   
   S = Size(W)
   IF S(0) NE 2                 THEN Message, 'Delay Matrix has to be two-dimensional'
   IF S(1) NE DW.target_w*DW.target_h THEN Message, 'wrong target dimensions'
   IF S(2) NE DW.source_w*DW.source_h THEN Message, 'wrong source dimensions'
   DW.Delays = W

   FreeSpikeQueue, DW.Queue
   DW.Queue = InitSpikeQueue(INIT_DELAYS = DW.Delays)

   Handle_Value, _DW, DW, /NO_COPY, /SET
   
END
