;+
; NAME:
;  Centric_align_DW
;
; AIM: Align the RFs od PFs of a DW matrix in a concentric manner.
;  
; PURPOSE:
;  -please specify-
;  
; CATEGORY:
;  -please specify-
;  
; CALLING SEQUENCE:
;  -please specify-
;  
; INPUTS:
;  -please remove any sections that do not apply-
;  
; OPTIONAL INPUTS:
;  -please remove any sections that do not apply-
;  
; KEYWORD PARAMETERS:
;  -please remove any sections that do not apply-
;  
; OUTPUTS:
;  -please remove any sections that do not apply-
;  
; OPTIONAL OUTPUTS:
;  -please remove any sections that do not apply-
;  
; COMMON BLOCKS:
;  -please remove any sections that do not apply-
;  
; SIDE EFFECTS:
;  -please remove any sections that do not apply-
;  
; RESTRICTIONS:
;  -please remove any sections that do not apply-
;  
; PROCEDURE:
;  -please specify-
;  
; EXAMPLE:
;  -please specify-
;  
; SEE ALSO:
;  -please remove any sections that do not apply-
;  <A HREF="#MY_ROUTINE">My_Routine()</A>
;  
;-
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 2.1  2000/09/07 17:34:16  kupper
;        Useful for DW Auswertung.
;
;

Pro centric_align_DW, DW, DEALIGN=dealign, CENTER=center, $
                      PIVOT=pivot, RECEPTIVE=receptive, $
                      PROJECTIVE=projective

   w = Weights(DW, /Dimensions)

   centric_align_matrix, w, DEALIGN=DEALIGN, CENTER=CENTER, $
    PIVOT=PIVOT, RECEPTIVE=RECEPTIVE, PROJECTIVE=PROJECTIVE

   SetWeights, DW, Temporary(w), /Dimensions

End
