Pro image_factory::a_
   
   awidth = round(self->areawidth_()) > 2
   winsize = awidth*10
   current_win = !d.window
   Window, /FREE, /PIXMAP, XSize=winsize, YSize=winsize
   xyouts, -0.14, -0.01, /normal, "!17a!X", $
    charsize=0.2*winsize, $
    charthick=0.1*winsize, COLOR=1

   image = Rebin( float(TvRd()), awidth, $
                    awidth )
   WDelete
   WSet, current_win
   
   self.image = PTR_NEW( $
                        inssubarray( fltarr(self.height, $
                                            self.width), $ 
                                     temporary(image), /Center )$
                       )   
   
End
