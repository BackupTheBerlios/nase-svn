Pro image_factory::T_

   width = self->areawidth_()
   pos = (self->mindim_()-width)/2
   
   self.image = PTR_NEW( $
                        fltarr(self.height, self.width) $
                       )
      (*self.image)[pos, pos:(pos+width-1) > pos] = 1
      (*self.image)[pos+1, pos:(pos+width-1) > pos] = 1
      (*self.image)[pos:(pos+width-1) > pos, self->mindim_()/2] = 1
      (*self.image)[pos:(pos+width-1) > pos, self->mindim_()/2-1] = 1
      
End
