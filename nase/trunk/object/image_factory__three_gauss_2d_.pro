Pro image_factory::three_gauss_2D_

   common common_random, seed

   SIGMA = 0.1 ;; in normal coordinates

   If self.image_info eq Ptr_New() $;; NULL
    then self.image_info = Ptr_new({phi: 360*randomu(seed, 3), $
                                    r  : randomu(seed, 3)     })

   width = self->areawidth_()

   ;; The first dot should always have r=1.0
   *self.image = gauss_2d(self.height, self.width, $
                          self->mindim_()*SIGMA*self->size(), $
                          0, width/2.0, PHI=-(*self.image_info).phi[0])      

   for dot=1, 2 do begin
      ;; dot position relative to center:
      dh = (*self.image_info).r[dot]*width/2.0 * sin((*self.image_info).phi[dot])
      dw = (*self.image_info).r[dot]*width/2.0 * cos((*self.image_info).phi[dot])
      
      *self.image = Temporary(*self.image) + $
       gauss_2d(self.height, self.width, $
                self->mindim_()*SIGMA*self->size(), $
                0, width/2.0*(*self.image_info).r[dot], $
                PHI=-(*self.image_info).phi[dot])
   endfor

   *self.image = Temporary(*self.image) < 1.0
End
