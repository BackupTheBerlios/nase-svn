;+
; NAME: RFScan_Zeigmal()
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
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 1.1  1998/01/29 14:45:07  kupper
;               Erste Beta-Version.
;                 Header mach ich noch...
;                 VISUALIZE-Keyword ist noch nicht implementiert...
;
;-

Function RFScan_Zeigmal, RFS, Picture
   common common_random, seed
  
   If not contains(RFS.info, "RFSCAN", /IGNORECASE) then message, "Hey - this is not a RFScan-Structure!"
   
   ;;------------------> Manual Definition of Picture
   If RFS.manual then begin
      If not set(Picture) then message, "Please specify Picture to present!"
      RFS.Picture = Picture
      RFS.count = RFS.count+1
      Return, Picture
   EndIf
   ;;--------------------------------
   
   ;;------------------> (AUTO_RANDOMDOTS) (gee, this is easy...)
   If Keyword_Set(RFS.auto_randomdots) then begin
      RFS.count = RFS.count+1
      RFS.Picture = fltarr(RFS.HEIGHT, RFS.WIDTH)
      randoms = randomu(seed, RFS.HEIGHT, RFS.WIDTH)
      wo = where(randoms lt RFS.auto_randomdots, count)
      If count ne 0 then RFS.Picture(wo) = 1.0
      return, RFS.Picture
   Endif
   ;;--------------------------------

   ;;------------------> (AUTO_HORIZONTALEDGE)
   If Keyword_Set(RFS.auto_horizontaledge) then begin
      If RFS.count eq RFS.height-1 then begin
         message, /INFORM, "Edge has been presented at all possible vertical positions"
         message, /INFORM, " - new cycle starting NOW."
         RFS.shiftpositions = all_random(RFS.height) 
      Endif
      RFS.count = (RFS.count+1) mod RFS.height ;Index of next Position
      pos = RFS.shiftpositions(RFS.count) ;Next Position
      RFS.Picture = fltarr(RFS.HEIGHT, RFS.WIDTH)
      RFS.Picture(0:pos, *) = 1.0
      If RFS.auto_horizontaledge eq 2 then RFS.Picture = 1.0-RFS.Picture
      Return, RFS.Picture
   EndIf
   ;;--------------------------------

   ;;------------------> (AUTO_VERTICALEDGE)
   If Keyword_Set(RFS.auto_verticaledge) then begin
      If RFS.count eq RFS.width-1 then begin
         message, /INFORM, "Edge has been presented at all possible horizontal positions"
         message, /INFORM, " - new cycle starting NOW."
         RFS.shiftpositions = all_random(RFS.width) 
      Endif
      RFS.count = (RFS.count+1) mod RFS.width ;Index of next Position
      pos = RFS.shiftpositions(RFS.count) ;Next Position
      RFS.Picture = fltarr(RFS.HEIGHT, RFS.WIDTH)
      RFS.Picture(*, 0:pos) = 1.0
      If RFS.auto_verticaledge eq 2 then RFS.Picture = 1.0-RFS.Picture
      Return, RFS.Picture
   EndIf
   ;;--------------------------------

   ;;------------------> Vertically Shift predefined Picture (SHIFT_VERTICAL)
   If Keyword_Set(RFS.shift_vertical) then begin
      If RFS.count eq RFS.height-1 then begin
         message, /INFORM, "Picture has been presented at all possible vertical positions"
         message, /INFORM, " - new cycle starting NOW."
         RFS.shiftpositions = all_random(RFS.height) 
      Endif
      RFS.count = (RFS.count+1) mod RFS.height ;Index of next Position
      pos = RFS.shiftpositions(RFS.count) ;Next Position
      RFS.Picture = Shift(RFS.Original, pos, 0)
      Return, RFS.Picture
   EndIf
   ;;--------------------------------

   ;;------------------> Horizontally Shift predefined Picture (SHIFT_HORIZONTAL)
   If Keyword_Set(RFS.shift_horizontal) then begin
      If RFS.count eq RFS.width-1 then begin
         message, /INFORM, "Picture has been presented at all possible horizontal positions"
         message, /INFORM, " - new cycle starting NOW."
         RFS.shiftpositions = all_random(RFS.width) 
      Endif
      RFS.count = (RFS.count+1) mod RFS.width ;Index of next Position
      pos = RFS.shiftpositions(RFS.count) ;Next Position
      RFS.Picture = Shift(RFS.Original, 0, pos)
      Return, RFS.Picture
   EndIf
   ;;--------------------------------

   ;;------------------> Shift predefined Picture in both directions (SHIFT_BOTH)
   If Keyword_Set(RFS.shift_both) then begin
      If RFS.count eq (RFS.width*RFS.height)-1 then begin
         message, /INFORM, "Picture has been presented at all possible positions"
         message, /INFORM, " - new cycle starting NOW."
         RFS.shiftpositions = all_random(RFS.width*RFS.height) 
      Endif
      RFS.count = (RFS.count+1) mod (RFS.width*RFS.height) ;Index of next Position
      pos = RFS.shiftpositions(RFS.count) ;Next Position (onedimensional index)
      pos = Subscript(RFS.Picture, pos) ;Next Position (twodimensional index)
      RFS.Picture = Shift(RFS.Original, pos(0), pos(1))
      Return, RFS.Picture
   EndIf
   ;;--------------------------------


   
End
