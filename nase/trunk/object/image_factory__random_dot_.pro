Pro image_factory::random_dot_

   common common_random, seed

   If self.image_info eq Ptr_New() $;; NULL
    then self.image_info = Ptr_new(2*!PI*randomu(seed)) ;angle

   width = self->areawidth_()
;   pos = (self->mindim_()-width)/2
   
   *self.image = fltarr(self.height, self.width)
   ;; center:
   ch = (self.height-1)/2.0
   cw = (self.width-1) /2.0
   ;; dot position relative to center:
   dh = width/2.0 * sin(*self.image_info)
   dw = width/2.0 * cos(*self.image_info)

   (*self.image)[round(ch+dh), round(cw+dw)] = 1
      
End
