;+
; NAME: PSTVScl
;
;
; PURPOSE: Erzeugen eines Postscript-Bildes entsprechend dem TVScl-Befehl
;
; CATEGORY: GRAPHIC
;
; CALLING SEQUENCE: PSTVScl, Feld [,PSFILE=Dateiname] 
;                                 [,Width=Breite] [,Height=Hoehe]
;                                 [,BPP=Farbtiefe]
;                                 [,/EPS] [,/COLOR] [,/ORDER]
; 
; INPUTS: Feld : Das darzustellende Array
;
; OPTIONAL INPUTS: Dateiname     : Gibt an, in wie die erzeugte Datei
;                                  heissen soll, Default ist 'postscript_tvscl' 
;	           Breite, Hoehe : Breite und Hoehe des erzeugten
;	                           Bildes, Default ist 5 cm breit und
;	                           quadratisch. Wird nur Hoehe oder
;	                           Breite angegeben, ist das Ergebnis
;	                           ebenfalls quadratisch.
;                  Farbiefe      : Die Farbteife des Ausdrucks, Default ist 8
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
;
; EXAMPLE: BspMatrix = indgen(5,5)       
;          PSTVScl, BspMatrix, psfile='~/postscriptfernsehen', /eps, /order 
;
; MODIFICATION HISTORY:
;
;       Fri Sep 5 14:33:06 1997, Andreas Thiel
;		Erste Version wird verfuegbar.
;
;-


PRO PSTVScl, _Array, PSFILE=PSFile, WIDTH=Width, HEIGHT=Height, EPS=eps, BPP=bpp, COLOR=Color, _EXTRA=e

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


SET_PLOT, 'PS'

If Not Set(EPS) Then Begin
    DEVICE, Filename = PSFile+'.ps'
    DEVICE, Encapsulated=0
    Endif Else Begin
        DEVICE, Filename = PSFile+'.eps'
        DEVICE, /Encapsulated
        DEVICE, XSize=width
        DEVICE, YSize=height
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


TVscl, Array, XSize=Width, YSize=Height, /Centimeters ,_EXTRA=e

plots, 0, 0 , /DEVICE 
plots, 1000.0*width, 0 ,/Continue, /DEVICE 
plots, 1000.0*width, 1000.0*height ,/Continue, /DEVICE
plots, 0, 1000.0*height ,/Continue, /device 
plots, 0, 0, /continue, /DEVICE 


DEVICE, /Close
SET_PLOT, 'X'

Print, 'PS-File erzeugt.'


END 
