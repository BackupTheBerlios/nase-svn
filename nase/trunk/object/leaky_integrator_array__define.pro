;; ------------ Member access methods -----------------------
Pro leaky_integrator_array::tau, tau
   self.decay_factor = exp(-1/float(tau))
End
Function leaky_integrator_array::tau
   return, alog(-1/self.decay_factor)
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
   *self.data = 0
End


;; ------------ Public --------------------
Pro leaky_integrator_array::input, a
   On_Error, 2                  ;retutn to caller
   If size(a, /Dimensions) ne size(*self.data,  /Dimensions) then $
    message, "Array  has incompatible dimensions."

   *self.data = *self.data * self.decay_factor + a
End

Function leaky_integrator_array::result
   return, *self.data
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

