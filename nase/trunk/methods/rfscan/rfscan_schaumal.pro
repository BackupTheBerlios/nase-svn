;+
; NAME: RFScan_Schaumal
;
; PURPOSE:
;
; CATEGORY:
;
; CALLING SEQUENCE:
;
; INPUTS:
;
; OPTIONAL INPUTS:
;
; KEYWORD PARAMETERS:
;
; OUTPUTS:
;
; OPTIONAL OUTPUTS:
;
; COMMON BLOCKS:
;
; SIDE EFFECTS:
;
; RESTRICTIONS:
;
; PROCEDURE:
;
; EXAMPLE:
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 1.1  1998/01/29 14:45:08  kupper
;               Erste Beta-Version.
;                 Header mach ich noch...
;                 VISUALIZE-Keyword ist noch nicht implementiert...
;
;-

Pro RFScan_Schaumal, RFS, OutLayer

   If RFS.OBSERVE_SPIKES     then LayerData, OutLayer, OUTPUT=Out
   If RFS.OBSERVE_POTENTIALS then LayerData, OutLayer, POTENTIAL=Out
      
   For i=0, LayerSize(OutLayer)-1 do begin
      RF = GetWeight(RFS.RFs, T_INDEX=i)
      RF = RF + Out(i)*RFS.Picture
      SetWeight, RFS.RFs, T_INDEX=i, RF
   endfor

   RFS.divide = RFS.divide+1
End
