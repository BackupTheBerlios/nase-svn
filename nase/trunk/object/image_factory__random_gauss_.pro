Pro image_factory::random_gauss_

   common common_random, seed

   SIGMA = 0.1 ;; in normal coordinates

   If self.image_info eq Ptr_New() $;; NULL
    then self.image_info = Ptr_new(360*randomu(seed)) ;angle

   width = self->areawidth_()
   
   *self.image = gauss_2d(self.height, self.width, $
                          self->mindim_()*SIGMA*self->size(), $
                          0, width/2.0, PHI=-*self.image_info)      
End
