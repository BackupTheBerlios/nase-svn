;+
; NAME:                 Out2Vector
;
; PURPOSE:              Proceed_Layer? gibt ein Handle auf die aktiven Neuronen zurueck.
;                       Mit Hilfe von Out2Vector kann der tatsaechliche Ausgabevektor
;                       ermittelt werden.
;
; CATEGORY:             SIMU
;
; CALLING SEQUENCE:     Vector = Out2Vector(OutHandle)
;
; INPUTS:               OutHandle: ein Handle auf eine sparse Liste, z.B. Layer.O
;
; OUTPUTS:              Vector: das resultierende BytArray aktiver Neurone
;
; EXAMPLE:              
;                       LayerProceed, L1
;                       L1Out = Out2Vector(L1.O)
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 2.1  1997/09/17 10:25:53  saam
;     Listen&Listen in den Trunk gemerged
;
;
;-
FUNCTION Out2Vector, OutHandle

   RETURN, SSpass2Vector(Handle_Val(OutHandle))

END
