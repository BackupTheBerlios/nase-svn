Pro image_factory::disc_

   self.image = PTR_NEW( $
                        $ ;; please insert image creation commands:
                        CutTorus( fltarr(self.height, self.width)+1, 0.5*self->areawidth_()) $
                       )

End
