;+
; NAME: RFScan_Return()
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
; SEE ALSO:
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 1.1  1998/01/29 14:45:09  kupper
;               Erste Beta-Version.
;                 Header mach ich noch...
;                 VISUALIZE-Keyword ist noch nicht implementiert...
;
;-

Function RFScan_Return, RFS

   If RFS.divide ne 0 then begin
      BoostWeight, RFS.RFs, 1.0/float(RFS.divide)
      RFS.divide = 0
   EndIf

   return, RFS.RFs

End
