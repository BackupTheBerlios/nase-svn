;+
; NAME:
;  Distance()
;
; PURPOSE:
;  Same as DIST(), but without cyclic edges.
;  Returns an array with every element set to the distance this element has to a 
;  given point in the array. Distance is measured -not- accross the edges.
;  Optionally, the square distance can be returned.
;    For those of us having a more visual view on things:
;  Distance() returns a conic profile with a half opening angle of 45°, open to
;  the top, and it's tip located at a given point.
;  Optionally, a second order paraboloid can be returned, open to the top, and
;  it's tip located at a given point.
;
; CATEGORY:
;  Arrays, image processing
;
; CALLING SEQUENCE:
;  result = Distance( h [,w] [,ch ,cw] [,/QUADRATIC] )
;
; INPUTS:
;  h: Height (first dimension) of the array to return.
;
; OPTIONAL INPUTS:
;  w: Width (second dimension) of the array to return.
;     If w is not specified, a square array of dimensions h is returned.
;
;  ch,cw: Center relative to which the distance values are computed. These are
;         not required to be integer values, nor to be lacated inside th array.
;         Default: ch=(h-1)/2.0, cw=(w-1)/2.0, i.e. the center of the array.
;
; KEYWORD PARAMETERS:
;  QUADRATIC: If set, the values returned are quadratic distances.
;             A call to Distance(..., /QUADRATIC) is completely equivalent to
;             calling (Distance(...)^2). However, quadratic distances are always 
;             computed as a sub-result. (In fact, the routine returns the square
;             root of this value.) Thus, using the QUADRATIC keyword
;             reduces the computational overhead of taking the root and
;             restoring the original values afterwards.
;
; OUTPUTS:
;  result: Array of floats, containing the distance values.
;
; PROCEDURE:
;  Some array operations. No loops.
;
; EXAMPLE:
;  Surfit, Distance(23)
;  Surfit, Distance(23,5,5)
;  
; SEE ALSO:
;  IDL routine DIST()
;  
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 1.3  2000/03/23 13:41:34  kupper
;        cw,ch can now be fractional and located outside tha array.
;        Added "visual" purpose description.
;
;        Revision 1.2  2000/03/23 13:10:39  kupper
;        Implemented QUADRATIC keyword.
;
;        Revision 1.1  2000/03/22 15:17:18  kupper
;        Often needed...
;
;-

Function distance, h, w, ch, cw, QUADRATIC=quadratic
   On_Error, 2

   case N_Params() of
      1: Begin ;;only h was given
            w = h
            ch = (h-1)/2.0
            cw = (w-1)/2.0
         End
      2: Begin ;;ch and cw were not given
            ch = (h-1)/2.0
            cw = (w-1)/2.0                   
         End
      3: Begin ;;w was not given
            cw = ch
            ch = w
            w = h
         End
      4: ;; do nothing
        
      else: message, "Please specify one to four parameters."
   endcase


   xa = FIndgen(w)-cw
   ya = FIndgen(h)-ch

   xa = REBIN( Transpose(Temporary(xa)^2), h, w)
   ya = REBIN(           Temporary(ya)^2 , h, w)

   If Keyword_Set(QUADRATIC) then $
    return, Temporary(ya)+Temporary(xa) $
   else $
    return, Sqrt(Temporary(ya)+Temporary(xa))
End
