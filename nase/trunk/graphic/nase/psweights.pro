;+
; NAME: PSWeights
;
;
; PURPOSE: Ausgabe einer Gewichtsmatrix in einer PostScript-Datei
;          Grosse Gewichte werden hier im Gegensatz zu ShowWeights
;          dunkel dargestellt, kleine Gewichte hell.
;
; CATEGORY: GRAPHIC
;
; CALLING SEQUENCE: PSWeights, Matrix 
;                               {, /FROMS |, /TOS |, PROJECTIVE |, /RECEPTIVE } 
;                               [, /DELAYS]
;                               [, WIDTH=Breite] [, HEIGHT=Hoehe]
;                               [, XTITLE=XText][,YTITLE=YText]
;                               [, PSFILE='Filename']
;                               [, /EPS] [,BPP=bitsperpixel]
;                               [, /COLOR]
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
;                  XText, YText: Achsenbeschriftung
;                  Filename:     der Name des PostScript-Files, das
;                                erzeugt wird. Die Endung .ps bzw .eps wird
;                                automatisch angefuegt.
;                  bitsperpixel: bestimmt die Anzahl der fuer das Bild
;                                verwendeten Grauwerte. Zahl der
;                                Grauwerte = 2^bitsperpixel
;	
; KEYWORD PARAMETERS: PROJECTIVE(FROMS) / RECEPTIVE(TOS) : siehe ShowWeights
;                     DELAYS      : siehe ShowWeights
;                     EPS         : erzeugt eine Encapsulated PostScript-Datei
;                     COLOR       : das PostScript-Bild ist farbig,
;                                   aehnlich der <A HREF="#SHOWWEIGHTS">ShowWeights()</A>-Darstellung
;                                   (!none=blau, postiv=gruen)   
;
; OUTPUTS: Eine Postscript- (.ps) bzw Encapsulated PostScript- (.eps)
;          Datei, die ein Bild der Gewichtsmatrix enthaelt. 
;
; RESTRICTIONS: Wird das Schluesselwort COLOR nicht angegeben, so
;               erzeugt die Prozedur ein Schwarz/Weiss-Bild der
;               Gewichtsmatrix. Bei dieser Darstellung werden nur die absoluten
;               Gewichtsgroessen gezeigt, d.h. starke negative Gewichte erscheinen
;               genauso wie starke positive Gewichte dunkel.
;
; PROCEDURE: Set()
;
; EXAMPLE: TestMatrix=InitDw(S_width=5, S_height=3, t_width=3, t_height=5, W_Random=[0,1])
;          PSWeights, TestMatrix, PSFILE='beispiel', /TOS, width=10, YTITLE='uebsilon-akse'
;
;          Hier wird eine Gewichtsmatrix initialisiert und
;          anschliessend in einem PostScript-File namens 'beispiel'
;          ausgegeben. Das resultierende Bild schwarzweiss, 10 cm breit und
;          quadratisch.
;
;          Oder in bunt:
;
;          TestMatrix=InitDw(S_width=10,S_height=12,t_width=11,t_height=13,W_DOG=[1,2,4],W_NOCON=7,/W_TRUNCATE)
;          w=GetWeight(TestMatrix,S_ROW=6,S_COL=5)
;          w(where(w ne !NONE))=-w(where(w ne !NONE))
;          SetWeight, TestMatrix ,w ,S_ROW=6, S_COL=5
;	   PSWeights, TestMatrix, PSFILE='buntesbeispiel', /froms, /COLOR
;
; SEE ALSO: <A HREF="#SHOWWEIGHTS">ShowWeights()</A>
;
; MODIFICATION HISTORY:
;
;       $Log$
;       Revision 2.8  2000/08/31 10:10:10  kupper
;       Changed to restore previous output device after writing PS. (Not
;       expecitely 'X' as before.)
;
;       Revision 2.7  1998/03/04 15:17:48  thiel
;              Wurde auch auf die neue Verwaltung der Gewichtsmatrizen
;              umgestellt.
;
;       Revision 2.6  1997/10/30 13:49:50  kupper
;              PROJECTIVE/RECEPTIVE
;
;       Revision 2.5  2028/10/16 20:37:45  thiel
;              Die Achsen koennen jetzt beschriftet werden.
;              Keywords: XTITLE und YTITLE
;
;
;       Thu Sep 4 12:09:09 1997, Andreas Thiel
;		EPS-Files erhalten jetzt explizit Hoehe und Breite.
;
;       Wed Aug 27 14:15:02 1997, Andreas Thiel
;		Farbe der !NONEs ist jetzt hellblau.
;
;       Tue Aug 26 14:36:13 1997, Andreas Thiel
;		Keyword /COLOR eingebaut.
;
;       Tue Aug 26 11:40:11 1997, Andreas Thiel
;		Erste Version kreiert.
;
;-



PRO PSWeights, __Matrix, FROMS=froms, TOS=tos, DELAYS=delays, $
               XTITLE=XTitle, YTITLE=YTitle, PSFILE=PSFile, WIDTH=Width, HEIGHT=Height, $
               EPS=eps, BPP=bpp, COLOR=Color, $
               PROJECTIVE=projective, RECEPTIVE=receptive

   Default, FROMS, PROJECTIVE
   Default, TOS, RECEPTIVE

   If not keyword_set(FROMS) and not keyword_set(TOS) then message, 'Eins der Schlüsselwörter PROJECTIVE/FROMS oder RECEPTIVE/TOS muß gesetzt sein!'

   ;;------------------> Hier basteln wir uns eine DW-Struktur der ganz, ganz alten Form!
   ;;                     (das hat natürlich historische Gründe...) 
   if keyword_set(TOS) then begin ; Source- und Targetlayer vertauschen:
      
      IF info(__Matrix) EQ 'DW_WEIGHT' OR info(__Matrix) EQ 'SDW_WEIGHT' THEN BEGIN
         Matrix = {Weights : Transpose(Weights(__Matrix)), $
                   source_w: DWDim(__Matrix, /TW), $
                   source_h: DWDim(__Matrix, /TH), $
                   target_w: DWDim(__Matrix, /SW), $
                   target_h: DWDim(__Matrix, /SH)}
      END ELSE IF info(__Matrix) EQ 'DW_DELAY_WEIGHT' OR info(__Matrix) EQ 'SDW_DELAY_WEIGHT' THEN BEGIN
         Matrix = {Weights : Transpose(Weights(__Matrix)), $
                   Delays : Transpose(Delays(__Matrix)),$
                   source_w: DWDim(__Matrix, /TW), $
                   source_h: DWDim(__Matrix, /TH), $
                   target_w: DWDim(__Matrix, /SW), $
                   target_h: DWDim(__Matrix, /SH)}
      END ELSE Message, 'keine gueltige DelayWeigh-Struktur übergeben!'

   ENDIF ELSE begin             ; Source- und Targetlayer NICHT vertauschen:
      
      IF info(__Matrix) EQ 'DW_WEIGHT' OR info(__Matrix) EQ 'SDW_WEIGHT' THEN BEGIN
         Matrix = {Weights : Weights(__Matrix), $
                   source_w: DWDim(__Matrix, /SW), $
                   source_h: DWDim(__Matrix, /SH), $
                   target_w: DWDim(__Matrix, /TW), $
                   target_h: DWDim(__Matrix, /TH)}
      END ELSE IF info(__Matrix) EQ 'DW_DELAY_WEIGHT' OR info(__Matrix) EQ 'SDW_DELAY_WEIGHT' THEN BEGIN
         Matrix = {Weights : Weights(__Matrix), $
                   Delays : Delays(__Matrix),$
                   source_w: DWDim(__Matrix, /SW), $
                   source_h: DWDim(__Matrix, /SH), $
                   target_w: DWDim(__Matrix, /TW), $
                   target_h: DWDim(__Matrix, /TH)}
      END ELSE Message, 'keine gueltige DelayWeigh-Struktur übergeben!'

   Endelse
   ;;--------------------------------

   
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

;-----Zusaetzlichen Rand fuer die Beschriftung vorsehen:
IF Set(YTITLE) THEN XRand = Width/15.0 ELSE XRand = 0.0
IF Set(XTITLE) THEN YRand = Height/15.0 ELSE YRand = 0.0


current_device = !D.Name
SET_PLOT, 'PS'

If Not Set(EPS) Then Begin
    DEVICE, Filename = PSFile+'.ps'
    DEVICE, Encapsulated=0
    Endif Else Begin
        DEVICE, Filename = PSFile+'.eps'
        DEVICE, /Encapsulated
        DEVICE, XSize=Width + XRand
        DEVICE, YSize=Height + YRand
    Endelse

If Set(COLOR) Then DEVICE, /Color Else DEVICE, Color=0

DEVICE, Bits_per_pixel=bpp


if min eq 0 and max eq 0 then max = 1; Falls Array nur Nullen enthält!

If Not Set(COLOR) Then Begin ;-----Schwarzweissbild

    MatrixMatrix = abs(MatrixMatrix) ;nur die absolute Staerke der Gewichte wird beachtet
    MatrixMatrix = (254)-MatrixMatrix/double(max)*(254)
    IF count NE 0 THEN MatrixMatrix(no_connections) = 255
    Linienfarbe = 0

Endif Else Begin ;-----Farbild
    ts = !D.TABLE_SIZE-1 ;----Anzahl der Farben haengt von der gewaehlten Farbtiefe ab
    if min ge 0 then begin
        g = 255-indgen(ts)/double(ts-1)*255
        tvlct, g, g, g          ;Grauwerte
        MatrixMatrix = MatrixMatrix/double(max)*(ts-3)
    endif else begin
        g = ((2*indgen(ts)-ts+1) > 0)/double(ts-1)*255
        tvlct, 255-g, 255-rotate(g,2), 255-(g+rotate(g,2)) ;Rot-Grün
        MatrixMatrix = MatrixMatrix/2.0/double(max([max, -min]))
        MatrixMatrix = (MatrixMatrix+0.5)*(ts-3)
    endelse

    IF count NE 0 THEN MatrixMatrix(no_connections) = ts-2 ;Das sei der Index für nichtexistente Verbindungen

    SetColorIndex, ts-2, 200, 200, 255 ;Blau sei die Farbe für nichtexistente Verbindungen
    SetColorIndex, ts-1, 255, 100, 0  ;Orange die für die Trennlinien
    Linienfarbe = ts-1
EndElse





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
                1000.0*((Matrix.source_h-1-YY)*(Unterbildhoehe+Strichhoehe)-Strichhoehe/2.0)], Color=Linienfarbe, /DEVICE 
      plots, [1000.0*(XX*(Unterbildbreite+Strichbreite)-Strichbreite/2.0), $
              1000.0*(XX*(Unterbildbreite+Strichbreite)-Strichbreite/2.0)], $
               [1000.0*((Matrix.source_h-1-YY)*(Unterbildhoehe+Strichhoehe)-Strichhoehe/2.0), $
                1000.0*((Matrix.source_h-1-YY+1)*(Unterbildhoehe+Strichhoehe)-Strichhoehe/2.0)], Color=Linienfarbe, /DEVICE 

  end
end

;-----Linien oben und rechts:
plots, [-1000.0*Strichhoehe/2.0, 1000.0*(Matrix.Source_w*(Unterbildbreite+Strichbreite)-Strichbreite/2.0)], $
         [1000.0*((Matrix.source_h)*(Unterbildhoehe+Strichhoehe)-Strichhoehe/2.0), $
          1000.0*((Matrix.source_h)*(Unterbildhoehe+Strichhoehe)-Strichhoehe/2.0)], Color=Linienfarbe, /DEVICE 
plots, [1000.0*(Matrix.Source_w*(Unterbildbreite+Strichbreite)-Strichbreite/2.0), $
        1000.0*(Matrix.Source_w*(Unterbildbreite+Strichbreite)-Strichbreite/2.0)], $
         [-1000.0*Strichhoehe/2.0, 1000.0*((Matrix.source_h)*(Unterbildhoehe+Strichhoehe)-Strichhoehe/2.0)], Color=Linienfarbe, /DEVICE 

;-----Die Beschriftung (zentriert):
IF Set(XTITLE) THEN XYOuts, 1000.0*(Width/2.0), 1000.0*(Height+YRand/2.0), XTITLE, ALIGNMENT=0.5, /DEVICE, SIZE=1.0
IF Set(YTITLE) THEN XYOuts, 1000.0*(Width+XRand/2.0), 1000.0*(Height/2.0), YTITLE, ALIGNMENT=0.5, /DEVICE, ORIENTATION=270, Size=1.0

DEVICE, /Close
SET_PLOT, current_device        ;restore previous device.

Print, 'PS-File erzeugt.'


END 
