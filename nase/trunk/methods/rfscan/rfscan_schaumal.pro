;+
; NAME: RFScan_Schaumal
;
; PURPOSE: siehe <A HREF="#RFSCAN_INIT">RFScan_Init()</A>
;
; CALLING SEQUENCE: RFScan_Schaumal, My_RFScan, OutLayer
;
; INPUTS: My_RFScan: Eine mit <A HREF="#RFSCAN_INIT">RFScan_Init()</A> initialisierte
;                    RFScan-Struktur.
;         OutLayer : Der Layer mit den zu untersuchenden Neuronen. Das 
;                    muﬂ der gleicher Layer sein, der auch bei der
;                    Initialisierung angegeben wurde (zumindest muﬂ er 
;                    die gleichen Ausmaﬂe haben...)
;
; EXAMPLE: RFScan_Schaumal, My_RFScan, SimpleCells
;
; SEE ALSO: <A HREF="#RFSCAN_INIT">RFScan_Init()</A>, <A HREF="#RFSCAN_ZEIGMAL">RFScan_Zeigmal()</A>, <A HREF="#RFSCAN_RETURN">RFScan_Return()</A>
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 1.3  1998/02/16 14:59:48  kupper
;               VISUALIZE ist jetzt implementiert. WRAP auch.
;
;        Revision 1.2  1998/01/30 17:02:52  kupper
;               Header geschrieben und kosmetische Ver‰nderungen.
;                 VISULAIZE ist noch immer nicht implementiert.
;
;        Revision 1.1  1998/01/29 14:45:08  kupper
;               Erste Beta-Version.
;                 Header mach ich noch...
;                 VISUALIZE-Keyword ist noch nicht implementiert...
;
;-

Pro RFScan_Schaumal, RFS, OutLayer

   TestInfo, RFS, "RFScan"

   If RFS.OBSERVE_SPIKES     then LayerData, OutLayer, OUTPUT=Out
   If RFS.OBSERVE_POTENTIALS then LayerData, OutLayer, POTENTIAL=Out
      
   ;;------------------> VIUALIZE?
   If Keyword_Set(RFS.VISUALIZE) then begin
      WSet, RFS.WinOut          ;Draw Observed Pattern
      If RFS.OBSERVE_SPIKES then NASETV, RFS.MaxCol*Out, ZOOM=RFS.VISUALIZE(1)
      If RFS.OBSERVE_POTENTIALS then begin
         NASETV, ShowWeights_Scale(Out, /SETCOL, GET_COLORMODE=colormode), ZOOM=RFS.VISUALIZE(1)
         RFS.ColorMode = colormode
      EndIf
      If (RFS.divide MOD RFS.VISUALIZE(3)) eq 0 then begin ;Draw Estimated RFs
         ShowWeights, RFS.RFs, WIN=RFS.WinRFs, /RECEPTIVE, ZOOM=RFS.VISUALIZE(2), GET_COLORMODE=ColorMode
         RFS.ColorMode = colormode
         WSet, RFS.WinMean      ;Draw Mean RF
         Shade_Surf, MiddleWeights(RFS.RFs, /RECEPTIVE, WRAP=RFS.wrap)
      Endif
   EndIf
   ;;--------------------------------

   MyRFs = RFS.RFs              ;nˆtig, da Weights (vielleicht) den Handle ver‰ndert!
   G = Weights(MyRFs)

   For i=0, LayerSize(OutLayer)-1 do begin
;      RF = GetWeight(MyRFs, T_INDEX=i)
;      RF = RF + Out(i)*RFS.Picture
;      SetWeight, MyRFs, T_INDEX=i, RF
      G(i, *) = G(i, *) + Out(i)*RFS.Picture
   endfor

   SetWeights, MyRFs, G
   RFS.RFs = MyRFs

   RFS.divide = RFS.divide+1
End
