;+
; NAME:
;  SymbolPlot
;
; VERSION:
;  $Id$
;
; AIM:
;  Plot two-dimensional array contents in a variety of styles.
;  (Indicate values by size, color, orientation, ... of plotsymbols).
;
; PURPOSE: 
;  Darstellung eines Arrays auf dem Bildschirm in allerlei
;  hübscher und erbaulicher Weise...
;  Die Arraywerte werden in der Symbolgröße codiert.
;  Farb- und Orientierungswerte können überlagert werden.
;
; CATEGORY:
;  Graphic
;
; CALLING SEQUENCE:
;* SymbolPlot, Z [,X, Y [,OFFSET = Offset]]
;*  [,/OPLOT]
;*  [,POSSYM=...] [,NEGSYM=...] [,SYMSIZE=...]
;*  [,POSCOLOR=...] [,NEGCOLOR=...] [,COLORS=...] [,/NASCOL]
;*  [,POSORIENT=...] [,NEGORIENT=...] [,ORIENTATIONS=...] [,/RAD] [,/DIRECTION] [,/FILL]
;*  [,/NASE] [,/NOSCALE]
;*  [,THICK=...]
;*  [other Plot-Parameters]
;
; INPUTS: 
;  Z:: Das zu plottende Array.
;      Wird /NOSCALE angegeben, so sollten alle Werte im Bereich [-1,+1] liegen.
;
; OPTIONAL INPUTS: 
;  X :: A vector or two-dimensional array specifying the X
;          coordinates for the symbol positions. If X is a vector,
;          each element of X specifies the X coordinate for a column
;          of Z (e.g., X[0] specifies the X coordinate for Z[0,*]). If
;          X is a two-dimensional array, each element of X specifies
;          the X coordinate of the corresponding point in Z (i.e., X<SUB>ij</SUB>
;          specifies the X coordinate for Z<SUB>ij</SUB>).
;  Y :: A vector or two-dimensional array specifying the Y coordinates
;      for the contour surface. If Y is a vector, each element of Y
;      specifies the Y coordinate for a row of Z (e.g., Y[0] specifies
;      the Y coordinate for Z[*,0]). If Y is a two-dimensional array,
;      each element of Y specifies the Y coordinate of the
;      corresponding point in Z (Y<SUB>ij</SUB> specifies the Y coordinate for Z<SUB>ij</SUB>).
;
; INPUT KEYWORDS:
;  POSSYM:: Das Symbol, das für positive Werte verwendet wird.
;           Default: leeres Kästchen.
;  NEGSYM:: Das Symbol, das für positive Werte verwendet wird.
;          Default: X.
;  SYMSIZE:: allows to adjust the maximal symbol size (default: 1)
;  NONESYM:: Das Symbol, das bei Angabe von /NASE für
;           NONE-Werte verwendet wird.
;           Default: N.
;
;           zusätzlich zu den normalen IDL-Symbolen kennt SymbolPlot noch
;           die Symbole Nr.9 und Nr.11, ein ausgefülltes
;           Kästchen und ein 'N'.
;           Es gibt also Folgende vordefinierte Symbole:
;* 1    Plus sign (+)	
;* 2    Asterisk (*)	
;* 3    Period (.)	
;* 4    Diamond	
;* 5    Triangle	
;* 6    Square	
;* 7    X
;* 8    User-defined. See USERSYM procedure. (Standard-IDL)
;* 9    Filled Square
;* 11   N.
;
;  POSCOLOR:: Die Farbe, mit der positive Werte geplottet werden.
;             Default: !P.COLOR.
;  NEGCOLOR:: Die Farbe, mit der positive Werte geplottet werden.
;             Default: RGB("red", /NOALLOC).
;  NONECOLOR:: Bei Angabe von /NASE die Farbe, mit der
;              NONES geplottet werden.
;              Default: RGB("pale blue", /NOALLOC).
;  COLORS:: Ein Array mit den gleichen Ausmaßen wie "Array", das für jedes Element
;           den zu verwendenden Farbindex enthält.
;           (Man beachte, daß hier -hoffentlich- auch auf TrueColor-Displays die Farbtabelle 
;           benutzt wird).
;           NEG/POSCOLOR wird dann ignoriert.
;  OFFSET:: (!zeigt nur einen Effekt, wenn posx und posy uebergeben werden!) Offset soll das Problem
;           beheben, dass grosse Symbole am Achsenrand ueber die Achsen hinaus gezeichnet werden.
;           Daher kann ein positiver Wert von OFFSET die Achsenskalierung erweitern, sodass die
;           die Achsen von MIN(posx)-OFFSET bis MAX(posx)+OFFSET (und analog fuer y) gezeichnet werden.
;  POSORIENT:: Wenn angegeben, für positive Werte ein Orientierungs-/Richtungssymbol
;              mit entsprechendem Winkel benutzt (vgl. <A HREF="#ORIENTSYM">OrientSym</A>).
;              POSSYM wird dann ignoriert.
;  NEGORIENT:: Wenn angegeben, für negative Werte ein Orientierungs-/Richtungssymbol
;              mit entsprechendem Winkel benutzt  
;              NEGSYM wird dann ignoriert.
;  ORIENTATIONS:: Ein Array mit den gleichen Ausmaßen wie "Array", das für jedes Element
;                 die zu verwendende Orientierung enthält.
;                 POS/NEG-SYM/ORIENT werden dann ignoriert.
;  THICK:: Bei Liniensymbolen die Liniendicke. (Normal ist 1)
;
;  [other Plot-Parameters]:: Solche Dinge wie [X/Y]TITLE u.s.w.
;
;  OPLOT:: Das Koordinatensystem wird nicht neu gezeichnet, sondern nur die
;          Symbole in das bestehende Fenster geplottet.
;  NASCOL:: Als Plotfarben wird die gebräuchliche NASE-Farbskalierung verwendet.
;           (vgl. <A HREF="#SHOWWEIGHTS_SCALE">ShowWeights_Scale()</A>, <A HREF="nonase/#PLOTTVSCL">PlotTVScl</A>.)
;           NEG/POSCOL und COLORS werden dann ignoriert.
;  RAD:: Wird dieses Schlüsselwort gesetzt, so
;        werden alle Winkelangaben als Radiant
;        interpretiert, sonst als Grad.
;  DIRECTION:: Es werden Richtungssymbole generiert
;              (Pfeile), sonst Orientierungssymbole
;              (gerade Linien).
;  FILL:: Es werden ausgefüllt Orientierungssymbole verwendet.
;  NASE:: Die Arrays werden NASEtypisch interpretiert (Hoehe,Breite)
;  NOSCALE:: Die Werte im Array werden direkt übernommen.
;            Sie sollten dann im Bereich [0,1] für positive Arrays und
;            im Bereich [-1,1] für positiv/negative Arrays liegen.
;            Der Wert 0 hat stets die Symbolgröße 0 (kein Symbol).
;  POSDISPLACE:: Generate a plotsymbols that are slightly
;             displaced from the plotting center,
;             perpendicular to the symbol
;             orientation. This may be used to prevent
;             covering of symbols when overplotting with
;             the <*>/OPLOT</*> option. <*>DISPLACE</*>
;             should be set to a small value, in the
;             range of <*>[-1,1]</*>. <BR>
;             Note: When using
;             the <*>/FILL</*> option, lines and arrows
;             will have a thickness of <*>0.3</*>. So
;             setting <*>DISPLACE=0.3</*> when
;             overplotting should place symbols right
;             aside the original symbols.
;  NEGDISPLACE:: See <*>POSDISPLACE</*>, for negative values. 
;
; SIDE EFFECTS: 
;  Das UserSymbol wird ev. umdefiniert.
;
; PROCEDURE:
;  IDL-basiert, Plot, PlotS, UserSym usw.
;
; EXAMPLE: 
; Naja, es kann halt ziemlich viel. Man probiere mal:
;* 1. SymbolPlot, Gauss_2d(32,32)
;* 2. ULoadCT,5 & SymbolPlot, Gauss_2d(32,32)-0.5
;* 3. ULoadCT,5 & SymbolPlot, Gauss_2d(32,32)-0.5, POSCOL=255, NEGCOL=255, POSSYM=9, NEGSYM=6
;* 4. ULoadCT,5 & SymbolPlot, Gauss_2d(32,32)-0.5, POSSYM=9, NEGSYM=9
;* 5. SymbolPlot, Gauss_2d(32,32)-0.5, /NASCOL, /NASE, POSSYM=9, NEGSYM=9
;
;  Es kann sogar aussehen wie ein PlotTVScl:
;* 6. SymbolPlot, intarr(32,32)+1.5, /NOSCALE, POSSYM=9, NEGSYM=9, COLORS=ShowWeights_Scale(Gauss_2d(32,32)-0.5, /SETCOL), /NASE
;* 7. SymbolPlot, Gauss_2d(32,32)-0.5, POSORIENT=0, NEGORIENT=90
;* 8. SymbolPlot, Gauss_2d(32,32)-0.5, POSORIENT=0, NEGORIENT=90, /DIRECTION, /FILL
;* 9. SymbolPlot, Gauss_2d(32,32)-0.5, /NASE, /NASCOL, ORIENTATIONS=indgen(32,32)/1024.*360, /FILL, /DIRECTION
; 10. SymbolPlot, Gauss_2d(32,32), POSORIENT=0
;     SymbolPlot, /OPLOT, 1-Gauss_2d(32,32), POSORIENT=45
;
; SEE ALSO: 
;  <A>OrientSym</A>, <A>PlotTVScl</A>.
;
;-

Pro SymbolPlot, _a, _posx, _posy, OPLOT=oplot, POSSYM=possym, NEGSYM=negsym, NONESYM=nonesym, $
               POSCOLOR=poscolor, NEGCOLOR=negcolor, NONECOLOR=nonecolor, COLORS=_colors, NASCOL=nascol, $
               POSORIENT=posorient, NEGORIENT=negorient, ORIENTATIONS=_orientations, RAD=rad, DIRECTION=direction, $
               NASE=nase, noscale=noscale, $
               THICK=thick, FILL=fill, $
               OFFSET=offset,$
               XTICKNAMESHIFT=xticknameshift, YTICKNAMESHIFT=yticknameshift, $
                SYMSIZE=_symsize, POSDISPLACE=posdisplace, NEGDISPLACE=negdisplace,$
                _EXTRA=_extra

   ON_ERROR,2 

   Default, _SYMSIZE, 1. ; this is just a scaling factor to modify the automatic symbolsize this routine choses
   Default, thick, 0
   Default, nase, 0
   Default, possym, 6
   Default, negsym, 7
   Default, nonesym, 11
   Default, POSCOLOR, GetForeground()
   Default, NEGCOLOR, RGB("red", /NOALLOC)
   Default, NONECOLOR, RGB("pale blue", /NOALLOC)
   Default, OFFSET, 1

   If Keyword_Set(NASCOL) then begin
      If not Keyword_Set(NASE) then Console, "/NASCOL-Schlüsselwort gesetzt, aber nicht /NASE - sicher?", /WARN 
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

   Default, posx, _posx
   Default, posy, _posy
   Default, posx, Indgen(width)
   Default, posy, Indgen(height)  

   IF (SIZE(posx))(0) EQ 1 THEN BEGIN
       IF N_Elements(posx) NE width THEN Console, 'wrong number of abszissa coordinates', /FATAL
       posx = REBIN(posx, width, height, /SAMPLE) 
   END
   IF (SIZE(posy))(0) EQ 1 THEN BEGIN
       IF N_Elements(posy) NE height THEN Console, 'wrong number of ordinate coordinates', /FATAL
       posy = TRANSPOSE(REBIN(posy, height, width, /SAMPLE))
   END

   IF NOT Keyword_Set(NASE) THEN BEGIN

       noprepare = 1
       IF NOT Keyword_Set(OPLOT) THEN BEGIN
         plot, [0], /NODATA, XRANGE=[FIX(MIN(posx))-offset, FIX(MAX(posx))+offset], $
                    YRANGE=[FIX(MIN(posy))-offset, FIX(MAX(posy))+offset],XSTYLE=1, YSTYLE=1, _EXTRA=_extra
       END
       
    END ELSE BEGIN
       ;;------------------> !X und !Y geeignet setzen
       PrepareNasePlot, width, height, /OFFSET, NONASE=1-NASE, GET_OLD=oldplot, $
         XTICKNAMESHIFT=xticknameshift, YTICKNAMESHIFT=yticknameshift
       ;;--------------------------------
       
       ;;------------------> posx und posy anpassen:
       ;; Dies scheint auf einen Bug in PrepareNASEPlot zurückzuführen zu sein:
       ;; Achsenbewschriftung 0 entspricht tatsächlich Plotposition 1. Dumme Sache.
       posx = Temporary(posx)+1
       posy = Temporary(posy)+1
       ;;--------------------------------      

      ;;------------------> Koordinatensystem plotten
      IF NOT Keyword_Set(OPLOT) THEN BEGIN 
          plot, [0], /NODATA, _EXTRA=_extra
      END
      ;;--------------------------------
   END


   ;;------------------> PlotBereich bestimmen
   dev00 = Convert_Coord(0, 0, /DATA, /TO_DEVICE)
   dev11 = Convert_Coord(1, 1, /DATA, /TO_DEVICE)
   pixelxsize = dev11(0)-dev00(0)
   pixelysize = dev11(1)-dev00(1)
   pixelsize = min([pixelxsize, pixelysize])
   If !D.Name eq "PS" then symsize=_symsize*pixelsize/250. else $
    symsize = _symsize*pixelsize/7.      ;SymSize für Wert 1.0
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
            If set(ORIENTATIONS) then sym = OrientSym(orientations(x, y), RAD=rad, FILL=fill, THICK=thick, DIRECTION=direction, POSDISPLACE=posdisplace) $
            else If set(POSORIENT) then sym = OrientSym(posorient, RAD=rad, FILL=fill, THICK=thick, DIRECTION=direction, POSDISPLACE=posdisplace) $
            else sym = possym
         endif
         If a(x, y) lt 0 then begin
            If set(COLORS) then col = COLORS(x, y) else col = negcolor
            If set(ORIENTATIONS) then sym = OrientSym(orientations(x, y), RAD=rad, FILL=fill, THICK=thick, DIRECTION=direction, NEGDISPLACE=negdisplace) $
            else If set(NEGORIENT) then sym = OrientSym(negorient, RAD=rad, FILL=fill, THICK=thick, DIRECTION=direction, NEGDISPLACE=negdisplace) $
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
