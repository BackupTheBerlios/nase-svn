;+
; NAME: RFScan_Zeigmal()
;
; PURPOSE: siehe <A HREF="#RFSCAN_INIT">RFScan_Init()</A>
;
; CALLING SEQUENCE: Inputbild = RFScan_Zeigmal( My_RFScan [,Picture] )
;
; INPUTS: My_RFScan: Eine mit <A HREF="#RFSCAN_INIT">RFScan_Init()</A> initialisierte
;                    RFScan-Struktur.
;
; OPTIONAL INPUTS: Picture: Wurde bei der Initialisierung der manuelle Modus gewählt
;                           (vgl. <A HREF="#RFSCAN_INIT">RFScan_Init()</A>), so muß beim Aufruf das
;                           gewünschte Inputbild manuell übergeben werden. In diesem
;                           Fall wird genau dieses Bild auch von der Fubktion zurück-
;                           gegeben.
;
; OUTPUTS: Inputbild: Ein FloatArray passender Größe, das dem zu
;                     testenden Netz als Input präsentiert werden
;                     soll.
;                     Dieses Bild muß mindestens einen Zeitschritt
;                     lang (i.a. aber beliebig lang) als Input
;                     angelegen haben, bevor <A HREF="#RFSCAN_SCHAUMAL">RFScan_Schaumal</A>
;                     aufgerufen wird.
;
; COMMON BLOCKS: common_Random (Standard)
;
; EXAMPLE: MyPic = RFScan_Zeigmal( My_RFScan )
;
; SEE ALSO: <A HREF="#RFSCAN_INIT">RFScan_Init()</A>, <A HREF="#RFSCAN_SCHAUMAL">RFScan_Schaumal</A>, <A HREF="#RFSCAN_RETURN">RFScan_Return()</A>
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 1.4  1998/03/03 14:44:21  kupper
;               RFScan_Schaumal ist jetzt viel schneller, weil es
;                1. direkt auf den Weights-Tag der (Oldstyle)-DW-Struktur zugreift.
;                   Das ist zwar unelegant, aber schnell.
;                2. Beim Spikes-Observieren von den SSParse-Listenm Gebrauch
;                   macht und daher nur für die tatsächlich feuernden Neuronen
;                   Berechnungen durchführt.
;
;        Revision 1.3  1998/02/16 14:59:48  kupper
;               VISUALIZE ist jetzt implementiert. WRAP auch.
;
;        Revision 1.2  1998/01/30 17:02:53  kupper
;               Header geschrieben und kosmetische Veränderungen.
;                 VISULAIZE ist noch immer nicht implementiert.
;
;        Revision 1.1  1998/01/29 14:45:07  kupper
;               Erste Beta-Version.
;                 Header mach ich noch...
;                 VISUALIZE-Keyword ist noch nicht implementiert...
;
;-

Function ReturnPic, RFS
   If Keyword_Set(RFS.VISUALIZE) then begin
      ActWin = !D.Window
      
      WSet, RFS.WinIn
      NASETV, ShowWeights_Scale(RFS.Picture, COLORMODE=RFS.ColorMode), ZOOM=RFS.VISUALIZE(0)

      WSet, ActWin
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
      If not set(Picture) then message, "Please specify Picture to present!"
      RFS.Picture = Picture
      RFS.count = RFS.count+1
      Return, ReturnPic(RFS)
   EndIf
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
            message, /INFORM, "Edge has been presented at all possible vertical positions"
            message, /INFORM, " - new cycle starting NOW."
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
            message, /INFORM, "Edges have been presented at all possible vertical positions"
            message, /INFORM, " - new cycle starting NOW."
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
            message, /INFORM, "Edge has been presented at all possible horizontal positions"
            message, /INFORM, " - new cycle starting NOW."
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
            message, /INFORM, "Edges have been presented at all possible vertical positions"
            message, /INFORM, " - new cycle starting NOW."
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
         message, /INFORM, "Picture has been presented at all possible vertical positions"
         message, /INFORM, " - new cycle starting NOW."
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
         message, /INFORM, "Picture has been presented at all possible horizontal positions"
         message, /INFORM, " - new cycle starting NOW."
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
         message, /INFORM, "Picture has been presented at all possible positions"
         message, /INFORM, " - new cycle starting NOW."
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
