;+
; NAME:                SetDelays
;
; PURPOSE:             Setzt die Delaysmatrix der DelayWeigh-Struktur 
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
; SEE ALSO:            <A HREF="#INITDW">InitDW</A>, <A HREF="#DELAYS#">Delays</A>
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 2.3  1998/02/05 13:16:06  saam
;           + Gewichte und Delays als Listen
;           + keine direkten Zugriffe auf DW-Strukturen
;           + verbesserte Handle-Handling :->
;           + vereinfachte Lernroutinen
;           + einige Tests bestanden
;
;     Revision 2.2  1998/01/29 16:15:39  saam
;           last revision was completely unusable,
;           now it seems to work :-0
;
;     Revision 2.1  1998/01/05 17:20:24  saam
;           Jo, hmm, viel Spass...
;
;
;-
PRO SetDelays, _DW, D
   
   IStr = Info(_DW) 
   IF (IStr EQ 'SDW_WEIGHT') OR (IStr EQ 'SDW_DELAY_WEIGHT') THEN sdw = 1 ELSE sdw = 0
   IF NOT sdw AND (IStr NE 'DW_WEIGHT') AND (IStr NE 'DW_DELAY_WEIGHT') THEN Message,'DW structure expected, but got '+iStr+' !'
   
   tS = DWDim(_DW, /TW)*DWDim(_DW, /TH)
   sS = DWDim(_DW, /SW)*DWDim(_DW, /SH)

   IF sdw THEN _DW = SDW2DW(_DW)
      
   Handle_Value, _DW, DW, /NO_COPY 
      S = Size(D)
      IF S(0) NE 2  THEN Message, 'Weight-Matrix has to be two-dimensional'
      IF S(1) NE tS THEN Message, 'wrong target dimensions'
      IF S(2) NE sS THEN Message, 'wrong source dimensions'
      DW.Delays = D
   Handle_Value, _DW, DW, /NO_COPY, /SET

   IF sdw THEN DW2SDW, _DW

END
