;+
; NAME:
;  RFScan_Schaumal
;
; VERSION:
;  $Id$
;
; AIM:
;  Register the current output of a neuron layer for the (simplified) RF-Cinematogram.
;
; PURPOSE:
;  see <A>RFScan_Init</A>.
;
; CATEGORY:
;  NASE
;  Statistics
;  Signals
;  Simulation
;
; CALLING SEQUENCE:
;*RFScan_Schaumal, My_RFScan, OutLayer [,/NOVISUALIZE]
;
; INPUTS:
;  My_RFScan:: Eine mit <A>RFScan_Init</A> initialisierte
;              RFScan-Struktur.
;  OutLayer:: Der Layer mit den zu untersuchenden Neuronen. Das 
;             muß der gleicher Layer sein, der auch bei der
;             Initialisierung angegeben wurde (zumindest muß er 
;             die gleichen Ausmaße haben...) 
;
; INPUT KEYWORDS:
;  NOVISUALIZE:: Wenn gesetzt, wird kein Update der
;                Visualisierung gemacht
;                (zeitsparend)
;                Wurde <A>RFScan_Init</A> ohne <*>VISUALIZE</*>
;                initialisiert, so wird dieses
;                Keyword ignoriert.
;
; EXAMPLE:
;*RFScan_Schaumal, My_RFScan, SimpleCells
;
; SEE ALSO:
;  <A>RFScan_Init</A>, <A>RFScan_Zeigmal</A>, <A>RFScan_Return</A>
;-



Pro RFScan_Schaumal, RFS, OutLayer, NOVISUALIZE=novisualize

   TestInfo, RFS, "RFScan"

   RFS.divide = RFS.divide+1

   If RFS.OBSERVE_SPIKES     then begin
      Handle_Value, LayerOut(OutLayer), SSOut
      Out = LayerSpikes(OutLayer, /DIMENSIONS)
   End
   If RFS.OBSERVE_POTENTIALS then LayerData, OutLayer, POTENTIAL=Out
   
   ;;------------------> VISUALIZE?
   If Keyword_Set(RFS.VISUALIZE) and not Keyword_Set(NOVISUALIZE) then begin
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
         Shade_Surf, Rotate(MiddleWeights(RFS.RFs, /RECEPTIVE, WRAP=RFS.wrap), 3), color=RGB('orange', /NOALLOC)
         !P = ActP
      Endif

      If ActWin ne -1 then WSet, ActWin
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
