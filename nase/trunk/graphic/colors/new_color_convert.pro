;+
; NAME:
;
; PURPOSE:
;
; CATEGORY:
;
; CALLING SEQUENCE:
;
; INPUTS:
;
; OPTIONAL INPUTS:
;
; KEYWORD PARAMETERS:
;
; OUTPUTS:
;
; OPTIONAL OUTPUTS:
;
; COMMON BLOCKS:
;
; SIDE EFFECTS:
;
; RESTRICTIONS:
;
; PROCEDURE:
;
; EXAMPLE:
;
; SEE ALSO:
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 2.4  1998/02/19 17:13:29  kupper
;               Fiese Skalar/Array-Seltsamkeit von IDL...
;
;        Revision 2.3  1998/02/19 16:15:58  kupper
;               Fehlerchen...
;
;        Revision 2.2  1998/02/19 16:09:21  kupper
;               Fehlerchen...
;
;        Revision 2.1  1998/02/19 16:04:42  kupper
;               Aus der Not geboren...
;
;-
Pro New_Color_Convert, I0, I1, I2, O0, O1, O2, $
       RGB_YIC=rgb_yic, YIC_RGB=yic_rgb, $
       HSV_YIC=hsv_yic, YIC_HSV=yic_hsv, $
       HLS_YIC=hls_yic, YIC_HLS=yic_hls, $
       _EXTRA=_extra

   RGB2YIC = [ [0.299,  0.587,  0.114], $
               [0.596, -0.275, -0.321], $
               [0.212, -0.528,  0.311] ]
   YIC2RGB = Invert (RGB2YIC)

   If Keyword_Set(RGB_YIC) then begin
      If (Size(I0))(0) eq 0 then begin ;Skalare übergeben!
         YIC = [I0, I1, I2] # RGB2YIC
         O0  = YIC(0)
         O1  = YIC(1)
         O2  = YIC(2)
      Endif Else Begin          ;Arrays übergeben!
         YIC = [[I0], [I1], [I2]] # RGB2YIC
         O0  = YIC(*, 0)
         O1  = YIC(*, 1)
         O2  = YIC(*, 2)
      EndElse
      Return
   endif
      
   If Keyword_Set(YIC_RGB) then begin
      If (Size(I0))(0) eq 0 then begin ;Skalare übergeben!
         MyRGB = [I0, I1, I2] # YIC2RGB
         O0  = MyRGB(0)
         O1  = MyRGB(1)
         O2  = MyRGB(2)
      Endif Else Begin          ;Arrays übergeben!
         MyRGB = [[I0], [I1], [I2]] # YIC2RGB
         O0  = MyRGB(*, 0)
         O1  = MyRGB(*, 1)
         O2  = MyRGB(*, 2)
      EndElse
      Return
   endif

   If Keyword_Set(HSV_YIC) then begin
      Color_Convert, I0, I1, I2, II0, II1, II2, /HSV_RGB
      New_Color_Convert, II0, II1, II2, O0, O1, O2, /RGB_YIC
      Return
   endif

   If Keyword_Set(YIC_HSV) then begin
      New_Color_Convert, I0, I1, I2, OO0, OO1, OO2, /YIC_RGB
      Color_Convert, OO0, OO1, OO2, O0, O1, O2, /RGB_HSV
      Return
   endif
   
   If Keyword_Set(HLS_YIC) then begin
      Color_Convert, I0, I1, I2, II0, II1, II2, /HLS_RGB
      New_Color_Convert, II0, II1, II2, O0, O1, O2, /RGB_YIC
      Return
   endif

   If Keyword_Set(YIC_HLS) then begin
      New_Color_Convert, I0, I1, I2, OO0, OO1, OO2, /YIC_RGB
      Color_Convert, OO0, OO1, OO2, O0, O1, O2, /RGB_HLS
      Return
   endif

   Color_Convert, I0, I1, I2, O0, O1, O2, _EXTRA=_extra
End
