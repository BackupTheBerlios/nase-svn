Pro image_factory::square_

   width = self->areawidth_()
   pos = (self->mindim_()-width)/2
   
   self.image = PTR_NEW( $
                        fltarr(self.height, self.width) $
                       )
   (*self.image)[pos:(pos+width-1) > pos, pos:(pos+width-1) > pos] = 1

End
