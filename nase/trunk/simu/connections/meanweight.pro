;+
; NAME:
;  MeanWeight()
;
; AIM: Fast computation of mean connection strength in DW structure.
;
; PURPOSE:           Ermittelt das durchschnittliche Gewicht in einer SDW-Struktur. 
;                    Das kann man natuerlich auch mit Weights(SDW) 
;                    erreichen, dieser Zugriff ist aber schreiend ineffizient
;                    (Faktor 150(!!!!) beim Example unten)
;                    Au�erdem werden hier !NONE-Verbindungen
;                    automatisch ingoriert.                   
; 
; CATEGORY:
;  Simulation / Connections
;
; CALLING SEQUENCE:  MW = MeanWeight(DW)
;
; INPUTS:            DW: eine mit InitDW erzeugte SDW-Struktur
;
; OUTPUTS:           MW: das mittlere Gewicht aller (existierenden) Verbindungen.
;
; EXAMPLE:
;                    NTYPE  = InitPara_1()
;                    L      = InitLayer_1(Type=NTYPE, WIDTH=21, HEIGHT=21)   
;                    DWS    = InitDW (S_Layer=L, T_Layer=L, $
;                                     D_LINEAR=[1,2,10], /D_TRUNCATE, $
;                                     D_NRANDOM=[0,0.1], /D_NONSELF, $
;                                     W_GAUSS=[1,5], /W_TRUNCATE, $
;                                     W_RANDOM=[0,0.3], /W_NONSELF)
;                    print, MeanWeight(DWS)
;
; SEE ALSO:          <A HREF="#INITDW">InitD</A>, <A HREF="#WEIGHTS">Weights()</A>, <A HREF="#MINWEIGHT">MinWeight()</A>,
;                    <A HREF="#MAXWEIGHT">MaxWeight()</A>
;
;-
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 2.3  2000/09/25 16:49:13  thiel
;         AIMS added.
;
;     Revision 2.2  1998/03/09 16:02:47  kupper
;            Nimmt jetzt auch oldstyle-DWs.
;
;     Revision 2.1  1998/03/06 13:14:10  kupper
;            Sch�pfung durch Anpassung von MaxWeight.
;
;
;

FUNCTION MeanWeight, _DW

   TestInfo, _DW, "DW"          ;Ist es �berhaupt eine DW oder SDW?

   ;;------------------> SDW - This is easy!
   If contains(Info(_DW), "SDW") then begin 
      Handle_Value, _DW, DW, /NO_COPY
      M = TOTAL(DW.W)/double(N_Elements(DW.W))
      Handle_Value, _DW, DW, /NO_COPY, /SET

      RETURN, M
      
   Endif
   ;;--------------------------------

   ;;------------------> It's DW, so ignore !NONEs...
   Handle_Value, _DW, DW, /NO_COPY
   count = 0
   nones = Where(DW.Weights eq !NONE, count)
   If count ne 0 then begin
      DW.Weights(nones) = 0           ;Set Nones to 0
   Endif
   M = TOTAL(DW.Weights)/double(N_Elements(DW.Weights) - count) ;NONES will not count...
   If count ne 0 then DW.Weights(nones) = !NONE ;Undo Changes
   Handle_Value, _DW, DW, /NO_COPY, /SET

   Return, M
   ;;--------------------------------

END
