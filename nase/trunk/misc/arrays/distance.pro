;+
; NAME:
;  Distance()
;
; PURPOSE:
;  Same as DIST(), but without cyclic edges.
;  Returns an array with every element set to the distance this element has to a 
;  given point in the array. Distance is measured -not- accross the edges.
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
;  ch,cw: Center relative to which the distance values are computed. This should 
;         be integer values (any fractional part is discarded).
;         Default: ch=h/2, cw=w/2.
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
            ch = h/2
            cw = w/2         
         End
      2: Begin ;;ch and cw were not given
            ch = h/2
            cw = w/2                     
         End
      3: Begin ;;w was not given
            cw = ch
            ch = w
            w = h
         End
      4: ;; do nothing
        
      else: message, "Please specify one to four parameters."
   endcase

   ch = fix(ch)
   cw = fix(cw)
  
   xa = make_array(/Nozero, w, /Long)
   ya = make_array(/Nozero, h, /Long)
   
   xa[0:cw] = Rotate(LIndgen(cw+1), 2)
   xa[cw:w-1] = LIndgen(w-cw)
   ya[0:ch] = Rotate(LIndgen(ch+1), 2)
   ya[ch:h-1] = LIndgen(h-ch)

   xa = REBIN( Transpose(Temporary(xa)^2), h, w)
   ya = REBIN(           Temporary(ya)^2 , h, w)

   If Keyword_Set(QUADRATIC) then $
    return, Temporary(ya)+Temporary(xa) $
   else $
    return, Sqrt(Temporary(ya)+Temporary(xa))
End
