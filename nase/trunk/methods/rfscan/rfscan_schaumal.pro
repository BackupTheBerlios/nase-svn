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
;                    muß der gleicher Layer sein, der auch bei der
;                    Initialisierung angegeben wurde (zumindest muß er 
;                    die gleichen Ausmaße haben...)
;
; EXAMPLE: RFScan_Schaumal, My_RFScan, SimpleCells
;
; SEE ALSO: <A HREF="#RFSCAN_INIT">RFScan_Init()</A>, <A HREF="#RFSCAN_ZEIGMAL">RFScan_Zeigmal()</A>, <A HREF="#RFSCAN_RETURN">RFScan_Return()</A>
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 1.4  1998/03/03 14:44:20  kupper
;               RFScan_Schaumal ist jetzt viel schneller, weil es
;                1. direkt auf den Weights-Tag der (Oldstyle)-DW-Struktur zugreift.
;                   Das ist zwar unelegant, aber schnell.
;                2. Beim Spikes-Observieren von den SSParse-Listenm Gebrauch
;                   macht und daher nur für die tatsächlich feuernden Neuronen
;                   Berechnungen durchführt.
;
;        Revision 1.3  1998/02/16 14:59:48  kupper
;               VISUALIZE ist jetzt implementiert. WRAP auch.
;
;        Revision 1.2  1998/01/30 17:02:52  kupper
;               Header geschrieben und kosmetische Veränderungen.
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

   RFS.divide = RFS.divide+1

   If RFS.OBSERVE_SPIKES     then begin
      Handle_Value, OutLayer.O, SSOut
      Out = Out2Vector(OutLayer, /DIMENSIONS)
   End
   If RFS.OBSERVE_POTENTIALS then LayerData, OutLayer, POTENTIAL=Out
   
   ;;------------------> VIUALIZE?
   If Keyword_Set(RFS.VISUALIZE) then begin
      ActWin = !D.Window
      
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
         ActP = !P
         !P.Multi = 0
         !P.Position = [0, 0, 0, 0]
         Shade_Surf, MiddleWeights(RFS.RFs, /RECEPTIVE, WRAP=RFS.wrap), color=RGB('orange', /NOALLOC)
         !P = ActP
      Endif

      WSet, ActWin
   EndIf
   ;;--------------------------------

   ;;------------------> Muß überhaupt etwas getan werden?
   If RFS.OBSERVE_SPIKES then If SSOut(0) eq 0 then return ;Es hat gar nichts gefeuert!
   ;;--------------------------------

;   MyRFs = RFS.RFs              ;nötig, da Weights (vielleicht) den Handle verändert!
   Handle_Value, RFS.RFs, DW, /NO_COPY
;   G = Weights(MyRFs)


   If RFS.OBSERVE_POTENTIALS then begin
      For i=0, LayerSize(OutLayer)-1 do begin
;      RF = GetWeight(MyRFs, T_INDEX=i)
;      RF = RF + Out(i)*RFS.Picture
;      SetWeight, MyRFs, T_INDEX=i, RF
;         G(i, *) = G(i, *) + Out(i)*RFS.Picture
        DW.Weights(i, *) = DW.Weights(i, *) + Out(i)*RFS.Picture
      endfor
   Endif
   If RFS.OBSERVE_SPIKES then begin
      For Neuron=1, SSOut(0) do begin ;SSOut(0) enthält die Anzahl der feuernden Neuronen
;         G(SSOut(Neuron+1), *) = G(SSOut(Neuron+1), *) + RFS.Picture
         DW.Weights(SSOut(Neuron+1), *) = DW.Weights(SSOut(Neuron+1), *) + RFS.Picture
      Endfor
   EndIf

   Handle_Value, RFS.RFs, DW, /NO_COPY, /SET
;   SetWeights, MyRFs, G
;   RFS.RFs = MyRFs
End
