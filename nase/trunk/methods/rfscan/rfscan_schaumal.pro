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
      
   For i=0, LayerSize(OutLayer)-1 do begin
      RF = GetWeight(RFS.RFs, T_INDEX=i)
      RF = RF + Out(i)*RFS.Picture
      SetWeight, RFS.RFs, T_INDEX=i, RF
   endfor

   RFS.divide = RFS.divide+1
End
