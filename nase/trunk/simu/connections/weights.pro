;+
; NAME:                Weights
;
; PURPOSE:             Ermittelt die zu einer DelayWeigh-Struktur 
;                      gehoerende Gewichtmatrix 
;
; CATEGORY:            SIMULATION CONNECTIONS
;
; CALLING SEQUENCE:    W = Weights(DW)
;
; INPUTS:              DW: Eine mit InitDW initialisierte DelayWeigh-
;                          Struktur
;
; OUTPUTS:             die Gewichtsmatrix
;
; EXAMPLE:             DW = InitDW(S_WIDTH=10, S_HEIGHT=10, 
;                                  T_WIDTH=5, T_HEIGHT=5,
;                                  WEIGHT=4.0)
;                      W = Weights(DW)
;                      help, W
;
;                      Output:
;                               W               FLOAT     = Array(25, 100)  
;
; SEE ALSO:            <A HREF="#INITDW">InitDW</A>
;                      <A HREF="#SETWEIGHTS"></A>
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 2.3  1998/02/05 13:16:10  saam
;           + Gewichte und Delays als Listen
;           + keine direkten Zugriffe auf DW-Strukturen
;           + verbesserte Handle-Handling :->
;           + vereinfachte Lernroutinen
;           + einige Tests bestanden
;
;     Revision 2.2  1998/01/27 12:54:25  kupper
;            Nur einen Verweis auf SETWEIGHTS hinzugefügt.
;
;     Revision 2.1  1997/12/10 15:34:34  saam
;           Creation
;
;
;-
FUNCTION Weights, _DW
   
   IF (Info(_DW) EQ 'DW_WEIGHT') OR (Info(_DW) EQ 'DW_DELAY_WEIGHT') THEN BEGIN
      Handle_Value, _DW, DW, /NO_COPY
      W = DW.Weights
      Handle_Value, _DW, DW, /NO_COPY, /SET
      RETURN, W
   END

   IF (Info(_DW) NE 'SDW_WEIGHT') AND (Info(_DW) NE 'SDW_DELAY_WEIGHT') THEN Message, '[S]DW[_DELAY]_WEIGHT expected, but got '+STRING(Info(_DW))+' !'
   
   sS = DWDim(_DW, /SW) * DWDim(_DW, /SH)
   tS = DWDim(_DW, /TW) * DWDim(_DW, /TH)

   W = Make_Array(tS, sS, /FLOAT, VALUE=!NONE)

   Handle_Value, _DW, DW, /NO_COPY
   FOR wi=0, N_Elements(DW.W)-1 DO W(DW.c2t(wi),DW.c2s(wi)) = DW.W(wi)
   Handle_Value, _DW, DW, /NO_COPY, /SET
   
   RETURN, W
END
