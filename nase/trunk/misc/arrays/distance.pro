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
;  result = Distance( h [,w] [,ch ,cw] ) 
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
;        Revision 1.1  2000/03/22 15:17:18  kupper
;        Often needed...
;
;-

Function distance, h, w, ch, cw
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

   xa = REBIN( Transpose(Temporary(xa)), h, w)
   ya = REBIN(           Temporary(ya) , h, w)

   return, Sqrt(Temporary(ya)^2+Temporary(xa)^2)
End
