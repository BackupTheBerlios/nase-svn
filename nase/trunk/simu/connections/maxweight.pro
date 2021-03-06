;+
; NAME:
;  MaxWeight()
;
; AIM: Fast search for maximum connection strength in DW structure.
;
; PURPOSE:           Ermittelt das maximale Gewicht in einer SDW-Struktur. 
;                    Das kann man natuerlich auch mit MAX(Weights(SDW)) 
;                    erreichen, dieser Zugriff ist aber schreiend ineffizient
;                    (Faktor 150(!!!!) beim Example unten)                   
; 
; CATEGORY:
;  Simulation / Connections
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
; SEE ALSO:          <A HREF="#INITDW">InitD</A>, <A HREF="#WEIGHTS">Weights()</A>, <A HREF="#MINWEIGHT">MinWeight()</A>,
;                    <A HREF="#MEANWEIGHT">MeanWeight()</A>
;
;-
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 2.4  2000/09/25 16:49:13  thiel
;         AIMS added.
;
;     Revision 2.3  1998/03/09 16:02:46  kupper
;            Nimmt jetzt auch oldstyle-DWs.
;
;     Revision 2.2  1998/02/19 13:47:44  saam
;           Hyperlinks geupdated
;
;     Revision 2.1  1998/02/19 13:06:51  saam
;           wow ist das schnell; sogar wesentlich schneller als
;           vor der Umstellung, da nun das Maximum nur ueber
;           tatsaechlich vorhandene Gewichte gebildet wird.
;
;

FUNCTION MaxWeight, _DW

   TestInfo, _DW, "DW"          ;Ist es �berhaupt eine DW oder SDW?

   Handle_Value, _DW, DW, /NO_COPY
 
   If contains(Info(DW), "SDW") then M = MAX(DW.W) $ ;SDW
   else M = MAX(DW.Weights)     ;DW
   
   Handle_Value, _DW, DW, /NO_COPY, /SET
      
   RETURN, M
END
