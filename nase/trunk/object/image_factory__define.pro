
;; ------------ Member access methods -----------------------
Function image_factory::image
   If self.recompute then begin
      Message, /INFO, "Creating image."
      PTR_FREE, self.image
      call_method, self.type+"_", self
      self.recompute = 0
   Endif
   return, (*self.image)*self.brightness
End

Function image_factory::width
   return, self.width
End
Pro image_factory::width, value
   self.width = value
   self.recompute = 1
End

Function image_factory::height
   return, self.height
End
Pro image_factory::height, value
   self.height = value
   self.recompute = 1
End

Function image_factory::type
   return, self.type
End
Pro image_factory::type, string
   self.type = string
   self.recompute = 1
End

Function image_factory::size
   return, self.size
End
Pro image_factory::size, value
   self.size = value
   self.recompute = 1
End

Function image_factory::brightness
   return, self.brightness
End
Pro image_factory::brightness, value
   self.brightness = value
End

;; ------------ Constructor, Destructor & Resetter ----------
Function image_factory::init, HEIGHT=height, WIDTH=width
   message, /Info, "I am created."
   Default, height, 32
   Default, width, 32
   self.height = height
   self.width = width

   self->reset                  ;init values

   return, 1                    ;TRUE
End

Pro image_factory::cleanup, _dummy=_dummy
   message, /Info, "I'm dying!"
   PTR_FREE, self.image
End

Pro image_factory::reset
   self->size, 1.0
   self->brightness, 1.0
   self->type, "gauss"   
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

;; ------------ Private --------------------
Function image_factory::mindim_
   return, min([self.height, self.width])
End

Function image_factory::areawidth_
   return, self.size * self->mindim_()
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
            recompute: 0 $
           }
End

