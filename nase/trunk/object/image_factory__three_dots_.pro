Pro image_factory::three_dots_

   common common_random, seed

   If self.image_info eq Ptr_New() $;; NULL
    then self.image_info = Ptr_new({phi: 2*!PI*randomu(seed, 3), $
                                    r  : randomu(seed, 3)       })

   width = self->areawidth_()
;   pos = (self->mindim_()-width)/2
   
   *self.image = fltarr(self.height, self.width)
   ;; center:
   ch = (self.height-1)/2.0
   cw = (self.width-1) /2.0

   (*self.image_info).r[0] = 1.0 ; The first dot should always have r=1.0

   for dot=0, 2 do begin
      ;; dot position relative to center:
      dh = (*self.image_info).r[dot]*width/2.0 * sin((*self.image_info).phi[dot])
      dw = (*self.image_info).r[dot]*width/2.0 * cos((*self.image_info).phi[dot])
      
      (*self.image)[round(ch+dh), round(cw+dw)] = 1
   endfor
End
