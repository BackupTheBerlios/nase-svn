;+
; NAME:
;  Mask_average_DW
;
; AIM: Average the RFs or PFs of a DW specified by a binary mask.
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

Function mask_average_DW, DW, mask, RECEPTIVE=receptive, $
                         PROJECTIVE=projective
   
   return, mask_average_matrix(Weights(DW, /Dimensions), mask, $
                               RECEPTIVE=receptive, $
                               PROJECTIVE=projective)

End
