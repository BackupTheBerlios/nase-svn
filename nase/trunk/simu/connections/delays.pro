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
;     Revision 2.1  1997/12/10 15:34:32  saam
;           Creation
;
;
;-
FUNCTION Delays, _DW
   
   Handle_Value, _DW, DW, /NO_COPY 
   D = DW.Delays
   Handle_Value, _DW, DW, /NO_COPY, /SET
   
   RETURN, D
END
