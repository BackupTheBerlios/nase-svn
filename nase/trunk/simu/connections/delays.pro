;+
; NAME:                Delays
;
; PURPOSE:             Ermittelt die zu einer DelayWeigh-Struktur 
;                      gehoerende Delaymatrix 
;
; CATEGORY:            SIMULATION CONNECTIONS
;
; CALLING SEQUENCE:    W = Delays(DW)
;
; INPUTS:              DW: Eine mit InitDW initialisierte DelayWeigh-
;                          Struktur
;
; OUTPUTS:             die Gewichtsmatrix
;
; EXAMPLE:             DW = InitDW(S_WIDTH=10, S_HEIGHT=10, 
;                                  T_WIDTH=5, T_HEIGHT=5,
;                                  WEIGHT=4.0, DELAY=2)
;                      D = Delays(DW)
;                      help, D
;
;                      Output:
;                               D               FLOAT     = Array(25, 100)  
;
; SEE ALSO:            <A HREF="#INITDW">InitDW</A>
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 2.5  1998/03/19 15:27:43  kupper
;            copy&pase-bug korrigiert (muss chon ganz alt sein...)
;
;     Revision 2.4  1998/03/14 14:12:19  saam
;           handling of empty dw-structures now works
;
;     Revision 2.3  1998/02/05 14:16:26  saam
;           loop variable was integer
;
;     Revision 2.2  1998/02/05 13:15:59  saam
;           + Gewichte und Delays als Listen
;           + keine direkten Zugriffe auf DW-Strukturen
;           + verbesserte Handle-Handling :->
;           + vereinfachte Lernroutinen
;           + einige Tests bestanden
;
;     Revision 2.1  1997/12/10 15:34:32  saam
;           Creation
;
;
;-
FUNCTION Delays, _DW
   
   IF (Info(_DW) EQ 'DW_WEIGHT') OR (Info(_DW) EQ 'DW_DELAY_WEIGHT') THEN BEGIN
      Handle_Value, _DW, DW, /NO_COPY
      D = DW.Delays
      Handle_Value, _DW, DW, /NO_COPY, /SET
      RETURN, D
   END

   IF (Info(_DW) NE 'SDW_WEIGHT') AND (Info(_DW) NE 'SDW_DELAY_WEIGHT') THEN Message, '[S]DW[_DELAY]_WEIGHT expected, but got '+STRING(Info(_DW))+' !'
   
   sS = DWDim(_DW, /SW) * DWDim(_DW, /SH)
   tS = DWDim(_DW, /TW) * DWDim(_DW, /TH)
   
   D = Make_Array(tS, sS, /FLOAT, VALUE=!NONE)

   Handle_Value, _DW, DW, /NO_COPY
   IF NOT (N_Elements(DW.D) EQ 1 AND DW.D(0) EQ 0) THEN BEGIN
      FOR wi=0l, N_Elements(DW.D)-1 DO D(DW.c2t(wi),DW.c2s(wi)) = DW.D(wi)
   END
   Handle_Value, _DW, DW, /NO_COPY, /SET
   RETURN, D
END
