
;; ------------ Member access methods -----------------------
Function image_factory::image
   return, (*self.image)
End
Function image_factory::imageptr
   return, self.image
End

Function image_factory::width
   return, self.width
End
Pro image_factory::width, value
   self.width = value
   self->recompute_
End

Function image_factory::height
   return, self.height
End
Pro image_factory::height, value
   self.height = value
   self->recompute_
End

Function image_factory::type
   return, self.type
End
Pro image_factory::type, string
   self.type = string

   Ptr_Free, self.image_info
   self.image_info = Ptr_New()  ; NULL
   ;; the above will request a completely new variation of the current
   ;; image.
   self->recompute_
End

Function image_factory::size
   return, self.size
End
Pro image_factory::size, value
   self.size = value
   self->recompute_
End

Function image_factory::brightness
   return, self.brightness
End
Pro image_factory::brightness, value
   *self.image = *self.image / self.brightness * value
   self.brightness = value
End

;; ------------ Constructor, Destructor & Resetter ----------
Function image_factory::init, HEIGHT=height, WIDTH=width
   message, /Info, "I am created."
   Default, height, 32
   Default, width, 32
   self.height = height
   self.width = width

   self.size = 1.0
   self.brightness = 1.0
   self.type = "gauss"

   self.image = Ptr_New(/Allocate_Heap) ;let it point to an undefined variable
   self->recompute_
   return, 1                    ;TRUE
End

Pro image_factory::cleanup, _dummy=_dummy
   message, /Info, "I'm dying!"
   PTR_FREE, self.image
   PTR_FREE, self.image_info
End

Pro image_factory::reset
   self->prevent_recompute
   self->size, 1.0
   self->brightness, 1.0
   self->type, "gauss"
   self->allow_recompute ;; The queued recompute request will now be executed.
End


;; ------------ Public --------------------
Function image_factory::types
   PushD, "/homes/kupper/Promo/Source/image_factory"
   ;; for platform-independency, use FILEPATH() like in nase-startup!
   methods = FindFile("image_factory__*_.pro")
   PopD
   methods = strmid(methods, 15)
   for i=1, n_elements(methods) do methods[i-1] = strmid(methods[i-1], 0, strlen(methods[i-1])-5)

   return, methods
End

Pro image_factory::prevent_recompute
   self.prevent_recompute_flag = 1
End
Pro image_factory::allow_recompute
   self.prevent_recompute_flag = 0
   ;; did any recompute requests arrive while recomputing was prohibited?
   if self.delayed_recompute_request_flag then begin
      self->recompute_
      self.delayed_recompute_request_flag = 0
   endif
End


;; ------------ Private --------------------
Function image_factory::mindim_
   return, min([self.height, self.width])
End

Function image_factory::areawidth_
   return, self.size * self->mindim_()
End

Pro image_factory::recompute_
   If self.prevent_recompute_flag then begin
      self.delayed_recompute_request_flag = 1 ;store the request
   endif else begin ;;recompute
      Message, /INFO, "Creating image."
      call_method, self.type+"_", self
      *self.image = Temporary(*self.image) * self.brightness
   Endelse
End






;; ------------ Object definition ---------------------------
Pro image_factory__DEFINE
   dummy = {image_factory, $
            $
            image: PTR_NEW(), $
            width: 0l, $
            height: 0l, $
            $
            type: "", $
            size: 0.0, $
            brightness: 0.0, $
            $
            prevent_recompute_flag: 0, $
            delayed_recompute_request_flag: 0b, $
            $
            image_info: PTR_NEW() $;; will hold any information (if
            ;;          any) that is needed to recreate the current image.
           }
End

