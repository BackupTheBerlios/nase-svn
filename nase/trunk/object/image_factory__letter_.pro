Pro image_factory::letter_

   common common_random, seed

   ;; find out, if a new letter should be chosen, or if the last
   ;; letter should be reused:
   If self.image_info eq Ptr_New() $;; NULL
    then self.image_info = Ptr_New(string(65b+32b+byte(25*randomu(seed))))
   
   awidth = round(self->areawidth_()) > 2
   winsize = awidth*10
   current_win = !d.window
   Window, /FREE, /PIXMAP, XSize=winsize, YSize=winsize
   xyouts, +0.15, +0.25, /normal, "!17"+*self.image_info+"!X", $
    charsize=0.1*winsize, $
    charthick=0.1*winsize, COLOR=1

   image = Rebin( float(TvRd(/ORDER)), awidth, $
                    awidth )
   WDelete
   WSet, current_win
   
   *self.image = inssubarray( fltarr(self.height, $
                                     self.width), $ 
                              Transpose(temporary(image)), /Center )
   
End
