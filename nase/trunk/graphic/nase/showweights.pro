;+
; NAME: ShowWeights
;
; PURPOSE: formt eine Gewichtsmatrix um und stellt diese auf dem Bildschirm dar.
;          dabei werden die Gewichte der Verbindungen NACH Neuron#0 in der linken
;          oberen Ecke des Fensters als grau-schattierte Kaestchen
;          gezeigt (Keyword /Tos), die Gewichte der Verbindungen NACH Neuron#1 rechts
;          daneben usw.
;          Seit Version 1.5 können alternativ auch die Verbindungen VON
;          den Neuronen dargestellt werden (Keyword, /FROMS).
;
;   
; CATEGORY: GRAPHIC
;
; CALLING SEQUENCE: ShowWeights, Matrix {, /FROMS |, /TOS }
;                               [,TITEL='Titel'][,GROESSE=Fenstergroesse][,WINNR=FensterNr]
;
; INPUTS: Matrix: Gewichtsmatrix, die dargestellt werden soll, G(Target,Source)
;                 Matrix ist eine vorher mit DelayWeigh definierte Struktur 
; 
; OPTIONAL INPUTS: ---
;
; KEYWORD PARAMETERS: TITEL: Titel des Fensters, das die Darstellung
;                            enthalten soll 
;                     GROESSE: Faktor fuer die Vergroesserung der Darstellung
;                     WINNR: Nr des Fensters, in dem die Darstellung
;                            erfolgen soll (muss natuerlich offen
;                            sein). Ist WinNr gesetzt, sind evtl vorher angegebene
;                            Titel und Groessen unwirksam (klar,
;                            Fenster war ja schon vorher offen).
;                     FROMS: Muß gesetzt werden, wenn man in den
;                            Untermatrizen die Verbindungen VON den
;                            Neuronen sehen will.
;                     TOS  : Muß gesetzt werden, wenn man die
;                            Verbindungen ZU den Neuronen sehen will.
;
; OUTPUTS: Gewichtsmatrix, an die Fenstergroesse angepasst.
;
; OPTIONAL OUTPUTS: separates Fenster, das die Darstellung der Gewichtmatrix enthaelt
;
; COMMON BLOCKS: ---
;
; SIDE EFFECTS: ---
;
; RESTRICTIONS: ---
; 
; PROCEDURE: ---
;
; EXAMPLE: weights = IntArr(4,12)
;          weights(2,5) = 1.0  ; connection from 5 --> 2
;          weights(0,6) = 2.0  ; connection from 6 --> 0
;
;          MyMatrix =  DelayWeigh( INIT_WEIGHTS=weights, SOURCE_W=4, SOURCE_H=3, TARGET_W=2, TARGET_H=2)
;          ShowWeights, MyMatrix, Titel='wunderschoene Matrix', Groesse=50
;
;          stellt die zuvor definierte MyMatrix zwischen dem Source-Layer der Breite 4 und
;          Hoehe 3 und dem Target-Layer der Breite und Hoehe 2 50-fach
;          vergroessert in einem Fenster mit Titel 'wunderschoene
;          Matrix' dar.
;
; MODIFICATION HISTORY: Erste Version vom 25. Juli '97, Andreas.
;                       Diese Version (Verbesserte Parameterabfrage) vom 28. Juli '97, Andreas
;                       Versucht, Keyword FROMS zuzufügen, Rüdiger, 30.7.1997
;                       Es ist mir gelungen! Außerdem hat die Darstellung jetzt Gitterlinien!, Rüdiger, 31.7.1997
;                       Ich hab die interne Verarbeitung von Source und Target vertauscht, da sie so unseren Arraystrukturen angemessener ist.
;                           Ausserdem hab ich die Array-Operationen beim TV zusammengefasst.
;                           Das alles sollte einen gewissen Geschwindigkeitsvorteil bringen.
;                           Ausserdem normiert die Routine jetzt auf den maximal verfügbaren ColorTable-Index,
;                           was auf Displays mit weniger als 256 freien Indizes (d.h. wenn IDL eine Public Colormap benutzt)
;                           den maximalen Kontrast erreicht.
;                           Rüdiger, 1.8.1997
;
;-


PRO ShowWeights, _Matrix, titel=TITEL, groesse=GROESSE, winnr=WINNR, FROMS=froms,  TOS=tos

If not keyword_set(FROMS) and not keyword_set(TOS) then message, 'Eins der Schlüsselwörter FROMS oder TOS muß gesetzt sein!'

if keyword_set(TOS) then begin                   ; Source- und Targetlayer vertauschen:
   Matrix = {Weights: Transpose(_Matrix.Weights), $
             source_w: _Matrix.target_w, $
             source_h: _Matrix.target_h, $
             target_w: _Matrix.source_w, $
             target_h: _Matrix.source_h}
endif else Matrix = _Matrix
   
If Not Set(TITEL) Then titel = 'Gewichtsmatrix'
If Not Set(GROESSE) Then Begin 
    XGroesse = 1
    YGroesse = 1 
Endif Else Begin 
    XGroesse = Groesse
    YGroesse = Groesse
    Endelse

If Not Set(WINNR) Then Begin
    Window, 0 , XSize=(XGroesse*Matrix.target_w +1)*Matrix.source_w, YSize=(YGroesse*Matrix.target_h +1)*Matrix.source_h, Title=titel
    WSet, 0
         Endif Else Begin 
                      XGroesse = (!D.X_Size-Matrix.source_w)/(Matrix.target_W*Matrix.source_W)
                      YGroesse = (!D.Y_Size-Matrix.source_h)/(Matrix.target_H*Matrix.source_H)
                      WSet, WinNr
                  EndElse    

MaxFarbe = !D.Table_Size-1

SetColorIndex, MaxFarbe,  255,100,0
erase, MaxFarbe




Max_Amp = max(Matrix.Weights)
if Max_Amp eq 0 then Max_Amp = 1 ;falls Array nur Nullen enthält

MatrixMatrix= reform(Matrix.Weights/Max_Amp*(MaxFarbe-1), Matrix.target_h, Matrix.target_w, Matrix.source_h, Matrix.source_w)

for YY= 0, Matrix.source_h-1 do begin
   for XX= 0, Matrix.source_w-1 do begin  
      tv, rebin( /sample, $
                 transpose(MatrixMatrix(*, *, YY, XX)), $
                 xGroesse*Matrix.target_w,  yGroesse*Matrix.target_h), $
          /Order, $
          XX*(1+Matrix.target_w*xGroesse), (Matrix.source_h-1-YY)*(1+Matrix.target_h*yGroesse)
   end
end

END        
        
