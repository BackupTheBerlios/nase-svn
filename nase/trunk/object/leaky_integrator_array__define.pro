;+
; NAME:
; (Hint: Insert name in THIS line, if you want it to appear in the
; HTML-help. If you put it elsewhere, the HTML-help item will be 
; generated from the filename.)
;
; PURPOSE: 
;
; CATEGORY: 
;
; CALLING SEQUENCE: 
;
; PUBLIC METHODS:
;   input, val
;
;   result()
;
;   asymptote(const_in): returns asymptotic value expected for a constant input.
;
; INPUTS: 
;
; OPTIONAL INPUTS: -please remove any sections that do not apply-
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
; SEE ALSO: <A HREF="#MY_ROUTINE">My_Routine()</A>
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 1.7  2000/03/15 18:38:31  kupper
;        Added resultptr method.
;
;        Revision 1.6  2000/03/10 14:35:10  kupper
;        added method asymptote().
;
;        Revision 1.5  2000/03/09 17:23:41  kupper
;        corrected tau() method.
;
;        Revision 1.4  2000/03/09 17:12:53  kupper
;        really corrected reset method...
;
;        Revision 1.3  2000/03/09 17:10:26  kupper
;        Corrected comparison of array dimensions.
;        Corrected reset method.
;
;        Revision 1.2  2000/03/09 16:04:53  kupper
;        First version.
;        should work.
;
;-


;; ------------ Member access methods -----------------------
Pro leaky_integrator_array::tau, tau
   self.decay_factor = exp(-1/float(tau))
End
Function leaky_integrator_array::tau
   return, -1/alog(self.decay_factor)
End

;; ------------ Constructor, Destructor & Resetter ----------
Function leaky_integrator_array::init, Dimensions=dimensions, Tau=tau
   On_Error, 2                  ;return to caller if dimensions were not specified
   self.data = Ptr_New(Make_Array(Dimension=dimensions))
   self->tau, tau
   return, 1                    ;TRUE
End

Pro leaky_integrator_array::cleanup, _dummy=_dummy
   message, /Info, "I'm dying!"
   Ptr_Free, self.data
End

Pro leaky_integrator_array::reset
   (*self.data)[*] = 0
End


;; ------------ Public --------------------
Pro leaky_integrator_array::input, a
;   On_Error, 2                  ;retutn to caller
   If a_ne(size(a, /Dimensions), size(*self.data,  /Dimensions)) then $
    message, "Array  has incompatible dimensions."

   *self.data = *self.data * self.decay_factor + a
End

Function leaky_integrator_array::result
   return, *self.data
End
Function leaky_integrator_array::resultptr
   return, self.data
End

Function leaky_integrator_array::asymptote, constin
   return, float(constin)/(1-self.decay_factor)
End
;; ------------ Private --------------------






;; ------------ Object definition ---------------------------
Pro leaky_integrator_array__DEFINE
   dummy = {leaky_integrator_array, $
            $
            data: PTR_NEW(), $
            decay_factor: 0.0 $
           }
End

