;+
; NAME:
;  Centric_align_Matrix
;
; AIM: Align the RFs or PFs of a 4-dim. weight matrix in a concentric manner.
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

Pro centric_align_matrix, w, DEALIGN=dealign, CENTER=center, $
                          PIVOT=pivot, RECEPTIVE=receptive, $
                          PROJECTIVE=projective

   if not Keyword_Set(RECEPTIVE) and not Keyword_Set(PROJECTIVE) then $
    console, /FATAL, "Please specify /RECEPTIVE or /PROJECTIVE."

   ;; if receptive, exchange Sources and Targets:
   If Keyword_Set(RECEPTIVE) then $
    w = Transpose(Temporary(w), [2, 3, 0, 1])

   ;;-------------- here are handled projective fields --------------
   
   th = (Size(w, /Dimensions))[0]
   tw = (Size(w, /Dimensions))[1]
   sh = (Size(w, /Dimensions))[2]
   sw = (Size(w, /Dimensions))[3]

   Default, center, [(sh-1)/2.0, (sw-1)/2.0]
   Default, pivot , [(th-1)/2.0, (tw-1)/2.0]

   ;; This counts PFs (=source neurons):
   for x=0, sw-1 do begin
      for y=0, sh-1 do begin
         alpha = Deg(atan(-(y-center[0]), x-center[1]));; position, anticlockwise
         if not Keyword_Set(DEALIGN) then alpha = -alpha
         ;; now alpha is the amount to rotate, CLOCKWISE.
         ;; Rotatation directions do not change for NASE arrays
         ;; compared to mathematical arrays. There only is an offset
         ;; of 90° in absolute degrees which we don't care about
         ;; here.
         w[*, *, y, x] = Rot(w[*, *, y, x], alpha, 1.0, pivot[0], $
                             pivot[1], /Pivot, CUBIC=-0.5)
      endfor
   endfor

   ;;-------------- end: here are handled receptive fields ---------
   

    ;; if receptive, exchange Sources and Targets:
   If Keyword_Set(RECEPTIVE) then $
    w = Transpose(Temporary(w), [2, 3, 0, 1])

End
