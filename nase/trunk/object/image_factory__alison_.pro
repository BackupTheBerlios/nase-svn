Pro image_factory::alison_

   alison =  rotate( $ 
                       Read_BMP(Getenv('NASEPATH')+ $
                                '/graphic/alison_greyscale.bmp'), $
                    1 $
                   ) / 255.0
   
   iheight = self.height*self.size
   iwidth  = self.width *self.size

   If (iheight lt 312) or (iwidth lt 385) then begin
      ;; image has to be shrunken
      fac = max([312/iheight, 385/iwidth])
      *self.image = inssubarray( fltarr(self.height, $
                                        self.width), $ 
                                 SubSample(temporary(alison), fac, $
                                           /Edge_Truncate), $
                                 /Center )
   Endif else begin
      ;; image has to be inflated
      fac = min([iheight/float(312), iwidth/float(385)])
      *self.image = inssubarray( fltarr(self.height, $
                                        self.width), $ 
                                 Congrid(temporary(alison), $
                                         fac*312, fac*385, $
                                         Cubic=-0.5, /Minus_One), $
                                 /Center )
   Endelse

End
