;+
; NAME:              MaxWeight
;
; PURPOSE:           Ermittelt das maximale Gewicht in einer SDW-Struktur. 
;                    Das kann man natuerlich auch mit MAX(Weights(SDW)) 
;                    erreichen, dieser Zugriff ist aber schreiend ineffizient
;                    (Faktor 150(!!!!) beim Example unten)                   
; 
; CATEGORY:          SIMULATION CONNECTIONS
;
; CALLING SEQUENCE:  MW = MaxWeight(DW)
;
; INPUTS:            DW: eine mit InitDW erzeugte SDW-Struktur
;
; OUTPUTS:           MW: das maximale Gewicht
;
; EXAMPLE:
;                    NTYPE  = InitPara_1()
;                    L      = InitLayer_1(Type=NTYPE, WIDTH=21, HEIGHT=21)   
;                    DWS    = InitDW (S_Layer=L, T_Layer=L, $
;                                     D_LINEAR=[1,2,10], /D_TRUNCATE, $
;                                     D_NRANDOM=[0,0.1], /D_NONSELF, $
;                                     W_GAUSS=[1,5], /W_TRUNCATE, $
;                                     W_RANDOM=[0,0.3], /W_NONSELF)
;                    print, MaxWeight(DWS)
;
; SEE ALSO:          <A HREF="#INITDW">InitD</A>, <A HREF="#WEIGHTS">Weights</A>, <A HREF="#MINWEIGHT">MinWeight</A>,
;                    <A HREF="#MAXWEIGHT">MaxWeight</A>
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 2.1  1998/03/06 13:14:10  kupper
;            Sch�pfung durch Anpassung von MaxWeight.
;
;
;
;-
FUNCTION MeanWeight, _DW

   Handle_Value, _DW, DW, /NO_COPY
   M = TOTAL(DW.W)/double(N_Elements(DW.W))
   Handle_Value, _DW, DW, /NO_COPY, /SET

   RETURN, M
END
