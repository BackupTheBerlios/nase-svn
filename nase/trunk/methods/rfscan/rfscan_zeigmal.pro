;+
; NAME:
;  RFScan_Zeigmal()
;
; VERSION:
;  $Id$
;
; AIM:
;  Get the next automatically generated input for the (simplified) RF-Cinematogram.
;
; PURPOSE:
;  see <A>RFScan_Init</A>
;
; CATEGORY:
;  NASE
;  Statistics
;  Signals
;  Simulation
;
; CALLING SEQUENCE:
;*Inputbild = RFScan_Zeigmal(My_RFScan [,Picture])
;
; INPUTS:
;  My_RFScan::Eine mit <A>RFScan_Init</A> initialisierte
;             RFScan-Struktur.
;
; OPTIONAL INPUTS:
;  Picture:: Wurde bei der Initialisierung der manuelle Modus gewählt
;            (vgl. <A>RFScan_Init</A>), so muß beim Aufruf das
;            gewünschte Inputbild manuell übergeben werden. In diesem
;            Fall wird genau dieses Bild auch von der Fubktion zurückgegeben.
;
; OUTPUTS:
;  Inputbild:: Ein FloatArray passender Größe, das dem zu
;              testenden Netz als Input präsentiert werden
;              soll.
;              Dieses Bild muß mindestens einen Zeitschritt
;              lang (i.a. aber beliebig lang) als Input
;              angelegen haben, bevor <A>RFScan_Schaumal</A>
;              aufgerufen wird.
;
; COMMON BLOCKS:
;  common_Random (Standard)
;
; EXAMPLE:
;*MyPic = RFScan_Zeigmal(My_RFScan)
;
; SEE ALSO:
;  <A>RFScan_Init</A>, <A>RFScan_Schaumal</A>, <A>RFScan_Return</A>
;-


Function ReturnPic, RFS
   If Keyword_Set(RFS.VISUALIZE) then begin
      ActWin = !D.Window
      
      WSet, RFS.WinIn
      NASETV, ShowWeights_Scale(RFS.Picture, COLORMODE=RFS.ColorMode), ZOOM=RFS.VISUALIZE(0)

      If ActWin ne -1 then WSet, ActWin
   EndIf
   Return, RFS.Picture
End

Function Make_OnOff, arry, arrx, onpos, offpos
;
; Array-Index:     0 1 2 3 4 5 6 . . n            n := arry-1
;                 | | | | | | | | | | |
;                 | | | | | | | | | | |
; Kantenpos:      0 1 2 3 4 5 6 . . n 0
;
   common common_random, seed

   a=fltarr(arry,arrx)
   if onpos eq offpos then return, a

   if onpos le offpos then begin
      a(*, onpos:offpos-1) = 1.
   endif else begin
      a(*, offpos:onpos-1) = 1.
      a = 1.-a
   endelse

   return, a
end


Function RFScan_Zeigmal, RFS, Picture
   common common_random, seed

   TestInfo, RFS, "RFScan"
   
   ;;------------------> Manual Definition of Picture
   If RFS.manual then begin
      If not set(Picture) then console, /fatal , "Please specify Picture to present!"
      RFS.Picture = Picture
      RFS.count = RFS.count+1
      Return, ReturnPic(RFS)
   EndIf
   ;;--------------------------------
   
   ;;------------------> (AUTO_SINGLEDOT) (gee, this is easy...)
   If Keyword_Set(RFS.auto_singledot) then begin
      RFS.count = RFS.count+1
      RFS.Picture = fltarr(RFS.HEIGHT, RFS.WIDTH)
      wo = fix(randomu(seed)*N_Elements(RFS.Picture))
      RFS.Picture(wo) = 1.0
      Return, ReturnPic(RFS)
   Endif
   ;;--------------------------------

   ;;------------------> (AUTO_RANDOMDOTS) (gee, this is easy...)
   If Keyword_Set(RFS.auto_randomdots) then begin
      RFS.count = RFS.count+1
      RFS.Picture = fltarr(RFS.HEIGHT, RFS.WIDTH)
      randoms = randomu(seed, RFS.HEIGHT, RFS.WIDTH)
      wo = where(randoms lt RFS.auto_randomdots, count)
      If count ne 0 then RFS.Picture(wo) = 1.0
      Return, ReturnPic(RFS)
   Endif
   ;;--------------------------------

   ;;------------------> (AUTO_HORIZONTALEDGE)
   If Keyword_Set(RFS.auto_horizontaledge) then begin
      If RFS.auto_horizontaledge le 2 then begin ;Einzelne Kanten
         If RFS.count eq RFS.height-1 then begin
            console, /msg, "Edge has been presented at all possible vertical positions"
            console, /msg, " - new cycle starting NOW."
            RFS.shiftpositions = all_random(RFS.height) 
         Endif
         RFS.count = (RFS.count+1) mod RFS.height ;Index of next Position
         pos = RFS.shiftpositions(RFS.count) ;Next Position
         RFS.Picture = fltarr(RFS.HEIGHT, RFS.WIDTH)
         RFS.Picture(0:pos, *) = 1.0
         If RFS.auto_horizontaledge eq 2 then RFS.Picture = 1.0-RFS.Picture
      End
      If RFS.auto_horizontaledge eq 3 then begin ;Zwei Kanten
         If RFS.count eq RFS.height-1 then begin
            console, /msg, "Edges have been presented at all possible vertical positions"
            console, /msg, " - new cycle starting NOW."
            RFS.shiftpositions = all_random(RFS.height)
            RFS.shiftpositions2 = all_random(RFS.height)
         Endif
         RFS.count = (RFS.count+1) mod RFS.height ;Index of next Position
         onpos  = RFS.shiftpositions(RFS.count) ;Next On-Position
         offpos = RFS.shiftpositions2(RFS.count) ;Next Off-Position
         RFS.Picture = Rotate( Make_OnOff(RFS.width, RFS.height, onpos, offpos), 1 )
      Endif
      Return, ReturnPic(RFS)
   EndIf
   ;;--------------------------------

   ;;------------------> (AUTO_VERTICALEDGE)
   If Keyword_Set(RFS.auto_verticaledge) then begin
      If RFS.auto_verticaledge le 2 then begin ;Einzelne Kanten
         If RFS.count eq RFS.width-1 then begin
            console, /msg, "Edge has been presented at all possible horizontal positions"
            console, /msg, " - new cycle starting NOW."
            RFS.shiftpositions = all_random(RFS.width) 
         Endif
         RFS.count = (RFS.count+1) mod RFS.width ;Index of next Position
         pos = RFS.shiftpositions(RFS.count) ;Next Position
         RFS.Picture = fltarr(RFS.HEIGHT, RFS.WIDTH)
         RFS.Picture(*, 0:pos) = 1.0
         If RFS.auto_verticaledge eq 2 then RFS.Picture = 1.0-RFS.Picture
      EndIf
      If RFS.auto_verticaledge eq 3 then begin ;Zwei Kanten
         If RFS.count eq RFS.width-1 then begin
            console, /msg, "Edges have been presented at all possible vertical positions"
            console, /msg, " - new cycle starting NOW."
            RFS.shiftpositions = all_random(RFS.width)
            RFS.shiftpositions2 = all_random(RFS.width)
         Endif
         RFS.count = (RFS.count+1) mod RFS.width ;Index of next Position
         onpos  = RFS.shiftpositions(RFS.count) ;Next On-Position
         offpos = RFS.shiftpositions2(RFS.count) ;Next Off-Position
         RFS.Picture = Make_OnOff(RFS.height, RFS.width, onpos, offpos)
      Endif
      Return, ReturnPic(RFS)
   EndIf
   ;;--------------------------------



   ;;------------------> Vertically Shift predefined Picture (SHIFT_VERTICAL)
   If Keyword_Set(RFS.shift_vertical) then begin
      If RFS.count eq RFS.height-1 then begin
         console, /msg, "Picture has been presented at all possible vertical positions"
         console, /msg, " - new cycle starting NOW."
         RFS.shiftpositions = all_random(RFS.height) 
      Endif
      RFS.count = (RFS.count+1) mod RFS.height ;Index of next Position
      pos = RFS.shiftpositions(RFS.count) ;Next Position
      RFS.Picture = Shift(RFS.Original, pos, 0)
      Return, ReturnPic(RFS)
   EndIf
   ;;--------------------------------

   ;;------------------> Horizontally Shift predefined Picture (SHIFT_HORIZONTAL)
   If Keyword_Set(RFS.shift_horizontal) then begin
      If RFS.count eq RFS.width-1 then begin
         console, /msg, "Picture has been presented at all possible horizontal positions"
         console, /msg, " - new cycle starting NOW."
         RFS.shiftpositions = all_random(RFS.width) 
      Endif
      RFS.count = (RFS.count+1) mod RFS.width ;Index of next Position
      pos = RFS.shiftpositions(RFS.count) ;Next Position
      RFS.Picture = Shift(RFS.Original, 0, pos)
      Return, ReturnPic(RFS)
   EndIf
   ;;--------------------------------

   ;;------------------> Shift predefined Picture in both directions (SHIFT_BOTH)
   If Keyword_Set(RFS.shift_both) then begin
      If RFS.count eq (RFS.width*RFS.height)-1 then begin
         console, /msg, "Picture has been presented at all possible positions"
         console, /msg, " - new cycle starting NOW."
         RFS.shiftpositions = all_random(RFS.width*RFS.height) 
      Endif
      RFS.count = (RFS.count+1) mod (RFS.width*RFS.height) ;Index of next Position
      pos = RFS.shiftpositions(RFS.count) ;Next Position (onedimensional index)
      pos = Subscript(RFS.Picture, pos) ;Next Position (twodimensional index)
      RFS.Picture = Shift(RFS.Original, pos(0), pos(1))
      Return, ReturnPic(RFS)
   EndIf
   ;;--------------------------------


   
End
