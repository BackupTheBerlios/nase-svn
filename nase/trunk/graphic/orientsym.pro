;+
; NAME: OrientSym()
;
; AIM:
;  Define plotmarks indicating a given direction or orientation
;  (oriented arrow/line).
;
; PURPOSE: Definition eines User-Plotsymbols entsprechend einer
;          angegebenen Orientierung.
;
; CATEGORY:
;  Array
;  Graphic
;  NASE
;
; CALLING SEQUENCE: Der Aufruf erfolgt üblicherweise innerhalb eines
;                   Plot-Kommandos:
;*Plot, (blablabla), PSYM = OrientSym( angle [,/RAD] [,/DIRECTION] 
;*                                     [,/FILL] [,/THICK] )
;
; INPUTS: angle: Der Orientierungswinkel in Grad. (Wenn /RAD angegeben 
;                wird in Radiant.)
;
; KEYWORD PARAMETERS: 
;                    RAD:: Wird dieses Schlüsselwort gesetzt, so
;                          werden alle Winkelangaben als Radiant
;                          interpretiert, sonst als Grad.
;              DIRECTION:: Es wird ein Richtungssymbol generiert (ein
;                          Pfeil), sonst ein Orientierungssymbol (eine 
;                          gerade Linie)
;                   FILL:: Es werden ausgefüllte Symbole generiert,
;                          sonst nur Strichsymbole.
;                  THICK:: Gibt bei Strichsymbolen die dicker der
;                          Striche an. Default ist 1.
;               DISPLACE:: Generate a plotsymbol that is slightly
;                          displaced from the plotting center,
;                          perpendicular to the symbol
;                          orientation. This may be used to prevent
;                          covering of symbols when overplotting with
;                          <*>OPLOT</*>. <*>DISPLACE</*>
;                          should be set to a small value, in the
;                          range of <*>[-1,1]</*>. <BR>
;                          Note: When using
;                          the <*>/FILL</*> option, lines and arrows
;                          will have a thickness of <*>0.3</*>. So
;                          setting <*>DISPLACE=0.3</*> when
;                          overplotting should place symbols right
;                          aside the original symbols.
;
; OUTPUTS: Das Funktionsergebnis ist - völlig unabhängig von jeglichem 
;          Input (!) - immer 8.
;          Grund: 8 ist der IDL-Index für Userdefinierte Symbole.
;
; SIDE EFFECTS: Das aktuelle User-Symbol wird entsprechend umdefiniert.
;
; PROCEDURE: Symbolkoordinaten richtig drehen und dann Symbol mit
;            UserSym (Standard-IDL) definieren. 8 zurückgeben.
;
; EXAMPLE:
;*Plot, indgen(10), PSYM=-OrientSym(45, /DIRECTION, /FILL), SYMSIZE=5
;
; SEE ALSO:
;  <A>SymbolPlot</A>
;-

Function OrientSym, _angle, rad=RAD, DIRECTION=direction, FILL=fill, $
                    THICK=thick, DISPLACE=displace

   Default, fill, 0
   Default, thick, 0
   Default, displace, 0

   If not Keyword_Set(RAD) then angle = _angle/180.*!DPI else angle = _angle

   ;;------------------> Symbols in 0°-direction
   line  = [ [-1,  0], $       
             [ 1,  0] ]       
   arrow = [ [-1, 0], $         ;1. Punkt x,y
             [ 1, 0], $         ;2. Punkt x,y
             [ 0, 0.5], $
             [ 1, 0], $
             [ 0, -0.5] ] 
   fillline = [ [-1, 0.15], $
               [-1, -0.15], $
               [ 1, -0.15], $
               [ 1, 0.15] ]
   fillarrow = [ [-1, 0.15], $
                 [-1, -0.15], $
                 [0,  -0.15], $
                 [0, -0.5], $
                 [1, 0], $
                 [0, 0.5], $
                 [0, 0.15] ]
   ;;--------------------------------

   ;;------------------> Rotationsmatrix:
   rotmatrix = [ [ cos(angle), sin(angle) ], $
                 [ -sin(angle), cos(angle) ] ]
   ;;--------------------------------

   If Keyword_Set(DIRECTION) then begin
      If Keyword_Set(FILL) then symbol = fillarrow else symbol = arrow
   Endif else begin
      If Keyword_Set(FILL) then symbol = fillline else symbol = line
   EndElse

   ;;------------------> Displacement in y-direction:
   symbol = float(Temporary(symbol))
   symbol[1, *] = symbol[1, *]+displace
   ;;--------------------------------

   usersym, rotmatrix#symbol, FILL=fill, THICK=thick

   Return, 8                    ;Number for user-symbol!
   
End
