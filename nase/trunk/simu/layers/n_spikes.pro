;+
; NAME:
;  N_Spikes()
;
; AIM: OBSOLETE! Equivalent to <A>LayerMUA</A>
;-

Function N_Spikes, _Layer

   Console, ' is equivalent to "LayerMUA" and will be removed soon.', /WARNING

   Return, LayerMUA(_layer)

End

   
