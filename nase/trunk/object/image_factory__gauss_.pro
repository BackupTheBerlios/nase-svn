Pro image_factory::gauss_

   self.image = PTR_NEW( $
                        $ ;; please insert image creation commands:
                        gauss_2d( self.height, self.width, $
                                  hwb=0.25*self->areawidth_() ) $
                       )
End
