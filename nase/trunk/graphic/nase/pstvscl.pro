;+
; NAME: PSTVScl
;
;
; PURPOSE: Erzeugen eines Postscript-Bildes entsprechend dem TVScl-Befehl
;
; CATEGORY: GRAPHIC
;
; CALLING SEQUENCE: PSTVScl, Feld [,PSFILE=Dateiname]
;                                 [.XTITLE=XText][,YTITLE=YText]
;                                 [,WIDTH=Breite][,HEIGHT=Hoehe]
;                                 [,BPP=Farbtiefe]
;                                 [,/EPS] [,/COLOR] [,/ORDER]
; 
; INPUTS: Feld : Das darzustellende Array
;
; OPTIONAL INPUTS: Dateiname     : Gibt an, in wie die erzeugte Datei
;                                  heissen soll, Default ist 'postscript_tvscl'
;                  XText, YText  : Achsenbeschriftung
;	           Breite, Hoehe : Breite und Hoehe des erzeugten
;	                           Bildes, Default ist 5 cm breit und
;	                           quadratisch. Wird nur Hoehe oder
;	                           Breite angegeben, ist das Ergebnis
;	                           ebenfalls quadratisch.
;                  Farbtiefe     : Die Farbteife des Ausdrucks, Default ist 8
;                                  Bits per Pixel.
;
; KEYWORD PARAMETERS: EPS   : Erzeugt ein Encapsulated-PostScript-File
;                             (*.eps)
;                     COLOR : Erzeugt ein farbiges PS-File
;                     ORDER : Entspricht dem ORDER-Keyword des TVScl-Befehls 
;
; OUTPUTS: Ein Postscript- oder Encapsulated-PostScript-File mit dem
;          gewuenschten Namen.
;
; PROCEDURE: Vor dem eigentlichen TVScl-Befehl kehrt das Programm die
;            Farben um und oeffnet ein Postscript-File mit der
;            gewuenschten Groesse. Danach wird noch ein Rahmen um die
;            Darstellung des Arrays gemalt.
;            Optional wird mit XYOUTS die Achsenbeschriftung ausgegeben.
;
; EXAMPLE: BspMatrix = indgen(5,5)       
;          PSTVScl, BspMatrix, psfile='~/postscriptfernsehen', XTITLE='icksaxe', /eps, /order 
;
; MODIFICATION HISTORY:
; 
; $Log$
; Revision 2.2  1997/10/07 11:37:08  thiel
;        PostScript-TVScales koennen jetzt mit
;        Achsenbeschriftung erzeugt werden.
;
;   
;       Fri Sep 5 14:33:06 1997, Andreas Thiel
;		Erste Version wird verfuegbar.
;
;-


PRO PSTVScl, _Array, PSFILE=PSFile, WIDTH=Width, HEIGHT=Height, $
                 XTITLE=XTitle, YTITLE=YTitle, $
                 EPS=eps, BPP=bpp, COLOR=Color, _EXTRA=e

If Not Set(PSFILE) Then PSFile = 'postscript_tvscl'

If Not Set(WIDTH) Then Begin
   If Not Set(HEIGHT) Then Begin
       Width = 5.0 ;cm
       Height = 5.0 ;cm
      Endif Else Width = Height
  Endif Else Begin
   If Not Set (Height) Then Height = Width
  EndElse

Width = Float(Width)
Height = Float(Height)


If Not Set(BPP) Then bpp=8 

min = min(_Array)
max = max(_Array)

;-----Zusaetzlichen Rand fuer die Beschriftung vorsehen:
IF Set(YTITLE) THEN XRand = Width/5.0 ELSE XRand = 0.0
IF Set(XTITLE) THEN YRand = Height/5.0 ELSE YRand = 0.0

SET_PLOT, 'PS'

If Not Set(EPS) Then Begin
    DEVICE, Filename = PSFile+'.ps'
    DEVICE, Encapsulated=0
    Endif Else Begin
        DEVICE, Filename = PSFile+'.eps'
        DEVICE, /Encapsulated
        DEVICE, XSize=Width + (2.0*XRand)
        DEVICE, YSize=Height + (2.0*YRand)
    Endelse

If Set(COLOR) Then DEVICE, /Color Else DEVICE, Color=0

DEVICE, Bits_per_pixel=bpp


if min eq 0 and max eq 0 then max = 1; Falls Array nur Nullen enthält!

If Not Set(COLOR) Then Begin ;-----Schwarzweissbild

    Array = (254)-_Array/double(max)*(254)

Endif Else Begin ;-----Farbild
    ts = !D.TABLE_SIZE-1 ;----Anzahl der Farben haengt von der gewaehlten Farbtiefe ab
    Arrary = _Array/double(max)*(ts)
EndElse


TVscl, Array, XRand, YRand, XSize=Width, YSize=Height, /Centimeters ,_EXTRA=e

;-----Rahmen um die TVSCL-Graphik:
plots, 1000.0*XRand, 1000.0*YRand , /DEVICE 
plots, 1000.0*(width+XRand), 1000.0*YRand ,/Continue, /DEVICE 
plots, 1000.0*(width+XRand), 1000.0*(Height+YRand),/Continue, /DEVICE
plots, 1000.0*XRand, 1000.0*(height+YRand) ,/Continue, /DEVICE 
plots, 1000.0*XRand, 1000.0*YRand, /Continue, /DEVICE 

;-----Die Beschriftung (zentriert):
IF Set(XTITLE) THEN XYOuts, 1000.0*((Width+(2.0*XRand))/2.0), 1000.0*(YRand/2.0), XTITLE, ALIGNMENT=0.5, /DEVICE, SIZE=0.8
IF Set(YTITLE) THEN XYOuts, 1000.0*(XRand/2.0), 1000.0*((Height+(2.0*YRand))/2.0), YTITLE, ALIGNMENT=0.5, /DEVICE, ORIENTATION=90, Size=0.8

DEVICE, /Close
SET_PLOT, 'X'

Print, 'PS-File erzeugt.'


END 
