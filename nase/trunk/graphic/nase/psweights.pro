;+
; NAME: PSWeights
;
;
; PURPOSE: Ausgabe einer Gewichtsmatrix in einer PostScript-Datei
;          Grosse Gewichte werden hier im Gegensatz zu ShowWeights
;          dunkel dargestellt, kleine Gewichte hell.
;          !None-Verbindungen sind weiss, also unsichtbar.
;
; CATEGORY: GRAPHIC
;
; CALLING SEQUENCE: PSWeights, Matrix 
;                               {, /FROMS |, /TOS } 
;                               [, /DELAYS=delays]
;                               [, WIDTH=Breite] [, HEIGHT=Hoehe,]
;                               [, PSFILE='Filename']
;                               [, /EPS] [,BPP=bitsperpixel]
;
; INPUTS: Matrix : eine DW-Struktur
;      
; OPTIONAL INPUTS: Breite: die Breite des resultierenden Bildes in cm,
;                          Default: 15 cm
;                  Hoehe: die Hoehe des resultierenden Bildes in cm,
;                          Default: 15 cm 
;                  Wird weder Breite noch Hoehe angegeben, so ist das
;                  Bild 15x15 cm gross, ungefaehr die Breite eines
;                  DINA4-Blattes. Wird entweder Breite oder Hoehe
;                  angegeben, so ist das Bild quadratisch mit der
;                  gewuenschten Groesse. 
;
;                  Filename:     der Name des PostScript-Files, das
;                                erzeugt wird. Die Endung .ps bzw .eps wird
;                                automatisch angefuegt.
;                  bitsperpixel: bestimmt die Anzahl der fuer das Bild
;                                verwendeten Grauwerte. Zahl der
;                                Grauwerte = 2^bitsperpixel
;	
; KEYWORD PARAMETERS: FROMS / TOS : siehe ShowWeights
;                     DELAYS      : siehe ShowWeights
;                     EPS         : erzeugt eine Encapsulated PostScript-Datei
;
; OUTPUTS: Eine Postscript- (.ps) bzw Encapsulated PostScript- (.eps)
;                           Datei, die ein Bild der Gewichtsmatrix enthaelt. 
;
; OPTIONAL OUTPUTS: ---
;
; COMMON BLOCKS: ---
;
; SIDE EFFECTS: ---
;
; RESTRICTIONS: Arbeitet bisher nur mit positiven Gewichten
;
; PROCEDURE: Set()
;
; EXAMPLE: TestMatrix=InitDw(S_width=5, S_height=3, t_width=3, t_height=5, W_Random=[0,1])
;          PSWeights, TestMatrix, PSFILE='beispiel', /TOS, width=10
;
;          Hier wird eine Gewichtsmatrix initialisiert und
;          anschliessend in einem PostScript-File namens 'beispiel'
;          ausgegeben. Das resultierende Bild ist 10 cm breit und
;          quadratisch.

; MODIFICATION HISTORY:
;
;       Tue Aug 26 11:40:11 1997, Andreas Thiel
;		Erste Version kreiert.
;
;-



PRO PSWeights, _Matrix, FROMS=froms, TOS=tos, DELAYS=delays, PSFILE=PSFile, WIDTH=Width, HEIGHT=Height, EPS=eps, BPP=bpp

If not keyword_set(FROMS) and not keyword_set(TOS) then message, 'Eins der Schlüsselwörter FROMS oder TOS muß gesetzt sein!'

if keyword_set(TOS) then begin                   ; Source- und Targetlayer vertauschen:
   Matrix = {Weights: Transpose(_Matrix.Weights), $
             Delays : Transpose(_Matrix.Delays),$
             source_w: _Matrix.target_w, $
             source_h: _Matrix.target_h, $
             target_w: _Matrix.source_w, $
             target_h: _Matrix.source_h}
endif else Matrix = _Matrix


   
If Not Set(PSFILE) Then PSFile = 'gewichtsmatrix'

If Not Set(WIDTH) Then Begin
   If Not Set(HEIGHT) Then Begin
       Width = 15.0 ;cm
       Height = 15.0 ;cm
      Endif Else Width = Height
  Endif Else Begin
   If Not Set (Height) Then Height = Width
  EndElse

Width = Float(Width)
Height = Float(Height)


If Not Set(BPP) Then bpp=8 


IF Keyword_Set(Delays) THEN BEGIN
   MatrixMatrix= reform(Matrix.Delays, Matrix.target_h, Matrix.target_w, Matrix.source_h, Matrix.source_w)
END ELSE BEGIN
   MatrixMatrix= reform(Matrix.Weights, Matrix.target_h, Matrix.target_w, Matrix.source_h, Matrix.source_w)
END


no_connections = WHERE(MatrixMatrix EQ !NONE, count)
IF count NE 0 THEN MatrixMatrix(no_connections) = 0 ;Damits vorerst bei der Berechnung nicht stört!

min = min(MatrixMatrix)
max = max(MatrixMatrix)




if min eq 0 and max eq 0 then max = 1; Falls Array nur Nullen enthält!

if min ge 0 then begin
   MatrixMatrix = (254)-MatrixMatrix/double(max)*(254)
endif else begin
   g = ((2*indgen(ts)-ts+1) > 0)/double(ts-1)*255
   tvlct, rotate(g, 2), g, bytarr(ts)         ;Rot-Grün
   MatrixMatrix = MatrixMatrix/2.0/double(max([max, -min]))
   MatrixMatrix = (MatrixMatrix+0.5)*(ts-3)
endelse

;-----nichtexistente Verbindungen sind weiss:
IF count NE 0 THEN MatrixMatrix(no_connections) = 255



SET_PLOT, 'PS'

If Not Set(EPS) Then Begin
    DEVICE, Filename = PSFile+'.ps'
    DEVICE, Encapsulated=0
    Endif Else Begin
        DEVICE, Filename = PSFile+'.eps'
        DEVICE, /Encapsulated
    EndElse

DEVICE, Bits_per_pixel=bpp

;-----Zwischenraeume sind 10% der Kaestchengroesse:
Strichbreite = Width / (Matrix.Source_w) /10.0
Strichhoehe = Height / (Matrix.Source_h) /10.0

Unterbildbreite = Width / (Matrix.Source_w) - Strichbreite
Unterbildhoehe  = Height / (Matrix.Source_h) - Strichhoehe


for YY= 0, Matrix.source_h-1 do begin
   for XX= 0, Matrix.source_w-1 do begin  

;-----Untermatrizen:
      tv, transpose(MatrixMatrix(*, *, YY, XX)), $
          XSize=Unterbildbreite, YSize=Unterbildhoehe, /Centimeters, $
          /Order, $
          XX*(Unterbildbreite+Strichbreite), (Matrix.source_h-1-YY)*(Unterbildhoehe+Strichhoehe)

;-----Begrenzungslinien:
      plots, [1000.0*(XX*(Unterbildbreite+Strichbreite)-Strichbreite/2.0), $
              1000.0*((XX+1)*(Unterbildbreite+Strichbreite)-Strichbreite/2.0)], $
               [1000.0*((Matrix.source_h-1-YY)*(Unterbildhoehe+Strichhoehe)-Strichhoehe/2.0), $
                1000.0*((Matrix.source_h-1-YY)*(Unterbildhoehe+Strichhoehe)-Strichhoehe/2.0)], Color=0, /DEVICE 
      plots, [1000.0*(XX*(Unterbildbreite+Strichbreite)-Strichbreite/2.0), $
              1000.0*(XX*(Unterbildbreite+Strichbreite)-Strichbreite/2.0)], $
               [1000.0*((Matrix.source_h-1-YY)*(Unterbildhoehe+Strichhoehe)-Strichhoehe/2.0), $
                1000.0*((Matrix.source_h-1-YY+1)*(Unterbildhoehe+Strichhoehe)-Strichhoehe/2.0)], Color=0, /DEVICE 

  end
end

;-----Linien oben und rechts:
plots, [-1000.0*Strichhoehe/2.0, 1000.0*(Matrix.Source_w*(Unterbildbreite+Strichbreite)-Strichbreite/2.0)], $
         [1000.0*((Matrix.source_h)*(Unterbildhoehe+Strichhoehe)-Strichhoehe/2.0), $
          1000.0*((Matrix.source_h)*(Unterbildhoehe+Strichhoehe)-Strichhoehe/2.0)], Color=0, /DEVICE 
plots, [1000.0*(Matrix.Source_w*(Unterbildbreite+Strichbreite)-Strichbreite/2.0), $
        1000.0*(Matrix.Source_w*(Unterbildbreite+Strichbreite)-Strichbreite/2.0)], $
         [-1000.0*Strichhoehe/2.0, 1000.0*((Matrix.source_h)*(Unterbildhoehe+Strichhoehe)-Strichhoehe/2.0)], Color=0, /DEVICE 



DEVICE, /Close
SET_PLOT, 'X'

Print, 'PS-File erzeugt.'


END 
