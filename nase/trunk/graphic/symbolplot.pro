;+
; NAME: SymbolPlot
;
; PURPOSE: Darstellung eines Arrays auf dem Bildschirm in allerlei
;          hübscher und erbaulicher Weise...
;          Die Arraywerte werden in der Symbolgröße codiert.
;          Farb- und Orientierungswerte können überlagert werden.
;
; CATEGORY: Graphic, Visualisierung
;
; CALLING SEQUENCE: SymbolPlot, Array [,posx, posy [,OFFSET = Offset]]
;                               [,/OPLOT]
;                               [,POSSYM = SymbolIndex] [,NEGSYM = SymbolIndex]
;                               [,POSCOLOR = color] [,NEGCOLOR = color] [,COLORS = ColorIndexArray] [,/NASCOL]
;                               [,POSORIENT= angle] [,NEGORIENT= angle] [,ORIENTATIONS=OrientArray] [,/RAD] [,/DIRECTION] [,/FILL]
;                               [,/NASE] [,/NOSCALE]
;                               [,THICK = LinienDicke]
;                               [other Plot-Parameters]
;
; INPUTS: Array: Das zu plottende Array.
;                Wird /NOSCALE angegeben, so sollten alle Werte im Bereich [-1,+1] liegen.
;
; OPTIONAL INPUTS: 
;                  posx,
;                  posy  : Optionale Arrays, die die Position des jeweiligen Symbols angeben. Die Groesse dieser
;                          Arrays muss identisch mit Array sein. Die Achsen werden entsprechend skaliert (siehe
;                          auch Keyword OFFSET).
;                  POSSYM: Das Symbol, das für positive Werte verwendet wird.
;                          Default: leeres Kästchen.
;                  NEGSYM: Das Symbol, das für positive Werte verwendet wird.
;                          Default: X.
;                 NONESYM: Das Symbol, das bei Angabe von /NASE für
;                          NONE-Werte verwendet wird.
;                          Default: N.
;
;                  zusätzlich zu den normalen IDL-Symbolen kennt SymbolPlot noch
;                  die Symbole Nr.9 und Nr.11, ein ausgefülltes
;                  Kästchen und ein 'N'.
;                  Es gibt also Folgende vordefinierte Symbole:
;                     1	Plus sign (+)	
;                     2	Asterisk (*)	
;                     3	Period (.)	
;                     4	Diamond	
;                     5	Triangle	
;                     6	Square	
;                     7	X	
;                     8	User-defined. See USERSYM procedure. (Standard-IDL)
;                     9     Filled Square
;                    11     N.
;
;                POSCOLOR: Die Farbe, mit der positive Werte geplottet werden.
;                          Default: !P.COLOR.
;                NEGCOLOR: Die Farbe, mit der positive Werte geplottet werden.
;                          Default: RGB("red", /NOALLOC).
;               NONECOLOR: Bei Angabe von /NASE die Farbe, mit der
;                          NONES geplottet werden.
;                          Default: RGB("pale blue", /NOALLOC).
;                  COLORS: Ein Array mit den gleichen Ausmaßen wie "Array", das für jedes Element
;                          den zu verwendenden Farbindex enthält.
;                          (Man beachte, daß hier -hoffentlich- auch auf TrueColor-Displays die Farbtabelle 
;                          benutzt wird).
;                          NEG/POSCOLOR wird dann ignoriert.
;                  OFFSET: (!zeigt nur einen Effekt, wenn posx und posy uebergeben werden!) Offset soll das Problem
;                          beheben, dass grosse Symbole am Achsenrand ueber die Achsen hinaus gezeichnet werden.
;                          Daher kann ein positiver Wert von OFFSET die Achsenskalierung erweitern, sodass die
;                          die Achsen von MIN(posx)-OFFSET bis MAX(posx)+OFFSET (und analog fuer y) gezeichnet werden.
;               POSORIENT: Wenn angegeben, für positive Werte ein Orientierungs-/Richtungssymbol
;                          mit entsprechendem Winkel benutzt (vgl. <A HREF="#ORIENTSYM">OrientSym</A>).
;                          POSSYM wird dann ignoriert.
;               NEGORIENT: Wenn angegeben, für negative Werte ein Orientierungs-/Richtungssymbol
;                          mit entsprechendem Winkel benutzt  
;                          NEGSYM wird dann ignoriert.
;            ORIENTATIONS: Ein Array mit den gleichen Ausmaßen wie "Array", das für jedes Element
;                          die zu verwendende Orientierung enthält.
;                          POS/NEG-SYM/ORIENT werden dann ignoriert.
;
;                   THICK: Bei Liniensymbolen die Liniendicke. (Normal ist 1)
;
; [other Plot-Parameters]: Solche Dinge wie [X/Y]TITLE u.s.w.
;
; KEYWORD PARAMETERS: OPLOT: Das Koordinatensystem wird nicht neu gezeichnet, sondern nur die
;                            Symbole in das bestehende Fenster geplottet.
;                    NASCOL: Als Plotfarben wird die gebräuchliche NASE-Farbskalierung verwendet.
;                            (vgl. <A HREF="#SHOWWEIGHTS_SCALE">ShowWeights_Scale()</A>, <A HREF="nonase/#PLOTTVSCL">PlotTVScl</A>.)
;                            NEG/POSCOL und COLORS werden dann ignoriert.
;                       RAD: Wird dieses Schlüsselwort gesetzt, so
;                            werden alle Winkelangaben als Radiant
;                            interpretiert, sonst als Grad.
;                 DIRECTION: Es werden Richtungssymbole generiert
;                            (Pfeile), sonst Orientierungssymbole
;                            (gerade Linien).
;                      FILL: Es werden ausgefüllt Orientierungssymbole verwendet.
;                      NASE: Die Arrays werden NASEtypisch interpretiert (Hoehe,Breite)
;                   NOSCALE: Die Werte im Array werden direkt übernommen.
;                            Sie sollten dann im Bereich [0,1] für positive Arrays und
;                            im Bereich [-1,1] für positiv/negative Arrays liegen.
;                            Der Wert 0 hat stets die Symbolgröße 0 (kein Symbol).
;
; OUTPUTS: klar!
;
; SIDE EFFECTS: Das UserSymbol wird ev. umdefiniert.
;
; PROCEDURE: IDL-basiert, Plot, PlotS, UserSym usw.
;
; EXAMPLE: Naja, es kann halt ziemlich viel. Man probiere mal:
;          1. SymbolPlot, Gauss_2d(32,32)
;          2. ULoadCT,5 & SymbolPlot, Gauss_2d(32,32)-0.5
;          3. ULoadCT,5 & SymbolPlot, Gauss_2d(32,32)-0.5, POSCOL=255, NEGCOL=255, POSSYM=9, NEGSYM=6
;          4. ULoadCT,5 & SymbolPlot, Gauss_2d(32,32)-0.5, POSSYM=9, NEGSYM=9
;          5. SymbolPlot, Gauss_2d(32,32)-0.5, /NASCOL, /NASE, POSSYM=9, NEGSYM=9
;          Es kann sogar aussehen wie ein PlotTVScl:
;          6. SymbolPlot, intarr(32,32)+1.5, /NOSCALE, POSSYM=9, NEGSYM=9, COLORS=ShowWeights_Scale(Gauss_2d(32,32)-0.5, /SETCOL), /NASE
;          7. SymbolPlot, Gauss_2d(32,32)-0.5, POSORIENT=0, NEGORIENT=90
;          8. SymbolPlot, Gauss_2d(32,32)-0.5, POSORIENT=0, NEGORIENT=90, /DIRECTION, /FILL
;          9. SymbolPlot, Gauss_2d(32,32)-0.5, /NASE, /NASCOL, ORIENTATIONS=indgen(32,32)/1024.*360, /FILL, /DIRECTION
;         10. SymbolPlot, Gauss_2d(32,32), POSORIENT=0
;             SymbolPlot, /OPLOT, 1-Gauss_2d(32,32), POSORIENT=45
;
; SEE ALSO: <A HREF="#ORIENTSYM">OrientSym</A>, <A HREF="#PLOTTVSCL">PlotTVScl</A>.
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 2.7  1999/12/02 15:02:15  saam
;              + new positional arguments posx, posy for
;                arbitrary symbol positions
;              + keyword parameter OFFSET to change the
;                scaling behaviour
;
;        Revision 2.6  1999/11/04 17:31:40  kupper
;        Kicked out all the Device, BYPASS_TRANSLATION commands. They
;        -extremely- slow down performance on True-Color-Displays when
;        connecting over a network!
;        Furthermore, it seems to me, the only thing they do is to work
;        around a bug in IDL 5.0 that wasn't there in IDL 4 and isn't
;        there any more in IDL 5.2.
;        I do now handle this special bug by loading the translation table
;        with a linear ramp. This is much faster.
;        However, slight changes in behaviour on a True-Color-Display may
;        be encountered.
;
;        Revision 2.5  1998/06/30 20:42:49  thiel
;               Neue Keywords X/YTICKNAMESHIFT koennen an PrepareNasePlot
;               durchgereicht werden.
;
;        Revision 2.4  1998/06/08 10:28:29  thiel
;               NoNone durch NoNone_Proc ersetzt.
;
;        Revision 2.3  1998/06/07 14:23:15  kupper
;               Bug bei Arrays mit Nullelement am Anfang behoben.
;
;        Revision 2.2  1998/05/27 13:01:03  kupper
;               Beherrscht jetzt auch !NONES in der NASE-Darstellung.
;
;        Revision 2.1  1998/05/26 14:42:25  kupper
;               Neu und wunderschön...
;
;-

Pro SymbolPlot, _a, posx, posy, OPLOT=oplot, POSSYM=possym, NEGSYM=negsym, NONESYM=nonesym, $
               POSCOLOR=poscolor, NEGCOLOR=negcolor, NONECOLOR=nonecolor, COLORS=_colors, NASCOL=nascol, $
               POSORIENT=posorient, NEGORIENT=negorient, ORIENTATIONS=_orientations, RAD=rad, DIRECTION=direction, $
               NASE=nase, noscale=noscale, $
               THICK=thick, FILL=fill, $
               OFFSET=offset,$
               XTICKNAMESHIFT=xticknameshift, YTICKNAMESHIFT=yticknameshift, $
                _EXTRA=_extra

   Default, thick, 0
   Default, nase, 0
   Default, possym, 6
   Default, negsym, 7
   Default, nonesym, 11
   Default, POSCOLOR, !P.COLOR
   Default, NEGCOLOR, RGB("red", /NOALLOC)
   Default, NONECOLOR, RGB("pale blue", /NOALLOC)
   Default, OFFSET, 1

   If Keyword_Set(NASCOL) then begin
      If not Keyword_Set(NASE) then message, /INFORM, "/NASCOL-Schlüsselwort gesetzt, aber nicht /NASE - sicher?"
      _colors = ShowWeights_Scale(_a, /SetCol)
   Endif

   If Keyword_Set(NASE) then begin 
      a = rotate(_a, 3)
      NoNone_Proc, a, NONES=nones
      If Set(_colors) then colors = rotate(_colors, 3)
      If Set(_orientations) then orientations = rotate(_orientations, 3)
   Endif else begin
      If Set(_colors) then colors = _colors
      If Set(_orientations) then orientations = _orientations
      a = _a
      nones = -1
   Endelse

   If not Keyword_Set(NOSCALE) then a = a/float(max([max(a), -min(a)]))
   
   If Keyword_Set(NASE) and (nones(0) ne -1) then a(nones) = 0.75 ;Größe eines NONE-Symbols

   s = size(a)
   width = s(1)
   height = s(2)


   IF Set(posx) AND Set(posy) THEN BEGIN
      noprepare = 1
      If Keyword_Set(OPLOT) then noerase = 1 else noerase = 0
      plot, [0], /NODATA, NOERASE=noerase, XRANGE=[FIX(MIN(posx))-offset, FIX(MAX(posx))+offset], YRANGE=[FIX(MIN(posy))-offset, FIX(MAX(posy))+offset],XSTYLE=1, YSTYLE=1, _EXTRA=_extra
   END ELSE BEGIN
     ;;------------------> !X und !Y geeignet setzen
      PrepareNasePlot, width, height, /OFFSET, NONASE=1-NASE, GET_OLD=oldplot, $
       XTICKNAMESHIFT=xticknameshift, YTICKNAMESHIFT=yticknameshift
     ;;--------------------------------

      ;;------------------> Koordinatensystem plotten
      If Keyword_Set(OPLOT) then noerase = 1 else noerase = 0
      plot, [0], /NODATA, NOERASE=noerase, _EXTRA=_extra
      ;;--------------------------------
   END

   Default, posx, REBIN(Indgen(width)+1, width, height)
   Default, posy, TRANSPOSE(REBIN(Indgen(height)+1, height, width))   



   ;;------------------> PlotBereich bestimmen
   dev00 = Convert_Coord(0, 0, /DATA, /TO_DEVICE)
   dev11 = Convert_Coord(1, 1, /DATA, /TO_DEVICE)
   pixelxsize = dev11(0)-dev00(0)
   pixelysize = dev11(1)-dev00(1)
   pixelsize = min([pixelxsize, pixelysize])
   If !D.Name eq "PS" then symsize=pixelsize/250. else $
    symsize = pixelsize/7.      ;SymSize für Wert 1.0
   ;;--------------------------------

   ;;------------------> Symbole plotten
   Sym = 0                      ;Nur damits definiert ist!
   For y=0, height-1 do $
    For x=0, width-1 do begin
      If Keyword_Set(NASE) and TOTAL((y*width+x) eq nones) gt 0 then begin
         If set(COLORS) then col = COLORS(x, y) else col = nonecolor
         sym = nonesym
      Endif else begin          ;kein None
         If a(x, y) gt 0 then begin
            If set(COLORS) then col = COLORS(x, y) else col = poscolor
            If set(ORIENTATIONS) then sym = OrientSym(orientations(x, y), RAD=rad, FILL=fill, THICK=thick, DIRECTION=direction) $
            else If set(POSORIENT) then sym = OrientSym(posorient, RAD=rad, FILL=fill, THICK=thick, DIRECTION=direction) $
            else sym = possym
         endif
         If a(x, y) lt 0 then begin
            If set(COLORS) then col = COLORS(x, y) else col = negcolor
            If set(ORIENTATIONS) then sym = OrientSym(orientations(x, y), RAD=rad, FILL=fill, THICK=thick, DIRECTION=direction) $
            else If set(NEGORIENT) then sym = OrientSym(negorient, RAD=rad, FILL=fill, THICK=thick, DIRECTION=direction) $
            else sym = negsym
         endif
      Endelse                   ;kein None
      ;;------------------> Ev. Plotting-Symbol als ausgef. Kästchen
      ;;                    oder N definieren
      If sym eq 9 then begin
         usersym, [-1, 1, 1, -1], [-1, -1, 1, 1], /fill
         sym = 8                ;use user Symbol
      EndIf      
      If sym eq 11 then begin
         usersym, [-0.75, -0.75, 0.75, 0.75], [-1, 1, -1, 1], thick=thick
         sym = 8                ;use user Symbol
      EndIf      
      ;;--------------------------------
      If a(x, y) ne 0 then PlotS, posx(x,y), posy(x,y), PSym=sym, Color=col, SYMSIZE=symsize*abs(a(x, y)), THICK=thick
   EndFor
   ;;--------------------------------
  
   ;;------------------> !X und !Y restaurieren
   IF NOT Set(noprepare) THEN PrepareNasePlot, RESTORE_OLD=oldplot
   ;;--------------------------------

End
