Pro image_factory::alison_
   
   alison =  float(rotate( $ 
                          Read_BMP(Getenv('NASEPATH')+ $
                                   '/graphic/alison_greyscale.bmp'), $
                          1 $
                         ))
   
   iheight = self.height*self.size
   iwidth  = self.width *self.size
   
   If (iheight lt 312) or (iwidth lt 385) then begin
      ;; image has to be shrunken
      fac = max([312/iheight, 385/iwidth])
      insertimage = SubSample(temporary(alison), fac, $
                              /Edge_Truncate)
    Endif else begin
      ;; image has to be inflated
      fac = min([iheight/float(312), iwidth/float(385)])
      insertimage = Congrid(temporary(alison), $
                            fac*312, fac*385, $
                            /Minus_One, Cubic=-0.5)
   Endelse
   
   max = max(insertimage)

   *self.image = inssubarray( fltarr(self.height, $
                                     self.width), $ 
                              temporary(insertimage)/max, $
                              /Center )

End
