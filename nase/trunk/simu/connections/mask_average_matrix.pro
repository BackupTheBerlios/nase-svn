;+
; NAME:
;  Mask_average_Matrix
;
; AIM: Average the RFs or PFs of a 4-dim. weight matrix specified by a
;      binary mask.
;  
; PURPOSE:
;  -please specify-
;  
; CATEGORY:
;  Simulation / Connections
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
;        Revision 2.2  2000/09/25 16:49:13  thiel
;            AIMS added.
;
;        Revision 2.1  2000/09/07 17:34:16  kupper
;        Useful for DW Auswertung.
;
;

Function mask_average_matrix, w, mask, RECEPTIVE=receptive, $
                         PROJECTIVE=projective
   
   if not Keyword_Set(RECEPTIVE) and not Keyword_Set(PROJECTIVE) then $
    console, /FATAL, "Please specify /RECEPTIVE or /PROJECTIVE."

   th = (Size(w, /Dimensions))[0]
   tw = (Size(w, /Dimensions))[1]
   sh = (Size(w, /Dimensions))[2]
   sw = (Size(w, /Dimensions))[3]
   
   If Keyword_Set(RECEPTIVE) then begin
      ;;-------------- here are handled receptive fields --------------
      
      if a_ne(size(mask, /Dimensions), [th, tw]) then $
       console, "Binary mask has wrong dimensions.", /Fatal

      indices = Where(mask, c)
      If c eq 0 then console, "Binary mask is empty.", /Fatal
      
      ;; collapse target indices to 1-dim:
      w_ = Reform(nonone(w), /Overwrite, th*tw, sh, sw)
      ;; form is now: w(target_index, source_row, source_col)
      
      return, Total(w_[Where(mask), *, *], 1) 
      
      ;;-------------- end: here are handled receptive fields ---------
   Endif Else begin
      ;;-------------- here are handled projective fields --------------
      
      if a_ne(size(mask, /Dimensions), [sh, sw]) then $
       console, "Binary mask has wrong dimensions.", /Fatal

      indices = Where(mask, c)
      If c eq 0 then console, "Binary mask is empty.", /Fatal
      
      ;; collapse source indices to 1-dim:
      w_ = Reform(nonone(w), /Overwrite, th, tw, sh*sw)
      ;; form is now: w(target_row, target_col, source_index)

      ;; we need an additional Reform here, in case c is one. IDL
      ;; would then strip the leftover dimension of one, causing the
      ;; Total command to average over the wrong dimension!
      return, Total(Reform(w_[*, *, Where(mask)], /Overwrite, th, tw, c), 3) 
     
      ;;-------------- end: here are handled projective fields ---------
   EndElse   
      
End
