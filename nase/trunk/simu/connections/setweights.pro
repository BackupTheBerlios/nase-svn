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
;     Revision 2.2  1998/02/05 13:16:09  saam
;           + Gewichte und Delays als Listen
;           + keine direkten Zugriffe auf DW-Strukturen
;           + verbesserte Handle-Handling :->
;           + vereinfachte Lernroutinen
;           + einige Tests bestanden
;
;     Revision 2.1  1998/01/05 17:20:23  saam
;           Jo, hmm, viel Spass...
;
;
;-
PRO SetWeights, _DW, W
   
   IStr = Info(_DW) 
   IF (IStr EQ 'SDW_WEIGHT') OR (IStr EQ 'SDW_DELAY_WEIGHT') THEN sdw = 1 ELSE sdw = 0
   IF NOT sdw AND (IStr NE 'DW_WEIGHT') AND (IStr NE 'DW_DELAY_WEIGHT') THEN Message,'DW structure expected, but got '+iStr+' !'
   
   tS = DWDim(_DW, /TW)*DWDim(_DW, /TH)
   sS = DWDim(_DW, /SW)*DWDim(_DW, /SH)

   IF sdw THEN _DW = SDW2DW(_DW)
      
   Handle_Value, _DW, DW, /NO_COPY 
      S = Size(W)
      IF S(0) NE 2  THEN Message, 'Weight-Matrix has to be two-dimensional'
      IF S(1) NE tS THEN Message, 'wrong target dimensions'
      IF S(2) NE sS THEN Message, 'wrong source dimensions'
      DW.Weights = W
   Handle_Value, _DW, DW, /NO_COPY, /SET

   IF sdw THEN DW2SDW, _DW
END
