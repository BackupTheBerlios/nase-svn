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
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 2.1  1997/12/10 15:34:34  saam
;           Creation
;
;
;-
FUNCTION Weights, _DW
   
   Handle_Value, _DW, DW, /NO_COPY 
   W = DW.Weights
   Handle_Value, _DW, DW, /NO_COPY, /SET
   
   RETURN, W
END
