;+
; NAME:              MinWeight
;
; PURPOSE:           Ermittelt das minimale Gewicht in einer SDW-Struktur. 
;                    Das kann man natuerlich auch mit MIN(Weights(SDW)) 
;                    erreichen, dieser Zugriff ist aber schreiend ineffizient
;                    (Faktor 150(!!!!) beim Example unten)                   
; 
; CATEGORY:          SIMULATION CONNECTIONS
;
; CALLING SEQUENCE:  MW = MinWeight(DW)
;
; INPUTS:            DW: eine mit InitDW erzeugte SDW-Struktur
;
; OUTPUTS:           MW: das minimale Gewicht
;
; EXAMPLE:
;                    NTYPE  = InitPara_1()
;                    L      = InitLayer_1(Type=NTYPE, WIDTH=21, HEIGHT=21)   
;                    DWS    = InitDW (S_Layer=L, T_Layer=L, $
;                                     D_LINEAR=[1,2,10], /D_TRUNCATE, $
;                                     D_NRANDOM=[0,0.1], /D_NONSELF, $
;                                     W_GAUSS=[1,5], /W_TRUNCATE, $
;                                     W_RANDOM=[0,0.3], /W_NONSELF)
;                    print, MinWeight(DWS)
;
; SEE ALSO:          <A HREF="#INITDW">InitD</A>, <A HREF="#WEIGHTS">Weights</A>, <A HREF="#MAXWEIGHT">MaxWeight</A>
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 2.1  1998/02/19 13:47:27  saam
;           ja,ja ich hab's erstellt
;
;
;-
FUNCTION MinWeight, _DW

   Handle_Value, _DW, DW, /NO_COPY
   M = MIN(DW.W)
   Handle_Value, _DW, DW, /NO_COPY, /SET

   RETURN, M
END
