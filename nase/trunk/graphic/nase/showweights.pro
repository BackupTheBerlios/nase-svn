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
;          Set Version 1.13 werden auch Matrizen mit negativen Werten
;          verarbeitet. Sie werden in grün/rot-Schattierungen für
;          positive/negative Werte angezeigt.
;
;          Merke: DER WERT 0 HAT STETS DIE FARBE SCHWARZ!
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
;                     DELAYS: Falls gesetzt, werden nicht die Gewichte, sondern die Delays visualisiert
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
; MODIFICATION HISTORY: 
;
;       Mon Aug 18 16:58:34 1997, Mirko Saam
;       <saam@ax1317.Physik.Uni-Marburg.DE>
;
;		nicht vorhandene Verbindungen werden vorlaeufig mit Wert NULL dargestellt
;
;                       Erste Version vom 25. Juli '97, Andreas.
;                       Diese Version (Verbesserte Parameterabfrage) vom 28. Juli '97, Andreas
;                       Versucht, Keyword FROMS zuzufügen, Rüdiger,
;                       30.7.1997
;                       Es ist mir gelungen! Außerdem hat die Darstellung jetzt Gitterlinien!, Rüdiger, 31.7.1997
;                       Ich hab die interne Verarbeitung von Source und Target vertauscht, da sie so unseren Arraystrukturen angemessener ist.
;                           Ausserdem hab ich die Array-Operationen beim TV zusammengefasst.
;                           Das alles sollte einen gewissen Geschwindigkeitsvorteil bringen.
;                           Ausserdem normiert die Routine jetzt auf den maximal verfügbaren ColorTable-Index,
;                           was auf Displays mit weniger als 256 freien Indizes (d.h. wenn IDL eine Public Colormap benutzt)
;                           den maximalen Kontrast erreicht.
;                           Rüdiger, 1.8.1997
;                       Schluesselwort DELAYS hinzugefuegt, sodass nun auch alternativ auch die Verzoegerungen dargestellt werden koennen, Mirko, 3.8.97
;                       Bug bei WSet korrigiert, wenn WinNR uebergeben wird, Mirko, 3.8.97
;                       wird WINNR nicht gesetzt, so wird NEUES Fenster aufgemacht, Mirko, 3.8.97
;                       Matrizen mit negativen Gewichten werden jetzt in rot/grün dargestellt. Rüdiger, 5.8.97
;
;                       gibt man WINNR an, und das Fenster ist zu klein fuer die Darstellung, bricht die Routine mit
;                       unverstaendlichem Fehler ab. Das wird nun abgefangen, indem die Gewichte mit kleinster GROESSE (=1)
;                       dargestellt werden (und somit zum Teil abgeschnitten); ausserdem wird ne Warnung ausgegeben, Mirko, 13.8.97
;-


PRO ShowWeights, _Matrix, titel=TITEL, groesse=GROESSE, winnr=WINNR, FROMS=froms,  TOS=tos, DELAYS=delays

If not keyword_set(FROMS) and not keyword_set(TOS) then message, 'Eins der Schlüsselwörter FROMS oder TOS muß gesetzt sein!'

if keyword_set(TOS) then begin                   ; Source- und Targetlayer vertauschen:
   Matrix = {Weights: Transpose(_Matrix.Weights), $
             Delays : Transpose(_Matrix.Delays),$
             source_w: _Matrix.target_w, $
             source_h: _Matrix.target_h, $
             target_w: _Matrix.source_w, $
             target_h: _Matrix.source_h}
endif else Matrix = _Matrix


no_connections = WHERE(Matrix.Weights EQ !NONE, count)
IF count NE 0 THEN Matrix.Weights(no_connections) = 0.0
   
If Not Set(TITEL) Then titel = 'Gewichtsmatrix'
If Not Set(GROESSE) Then Begin 
    XGroesse = 1
    YGroesse = 1 
Endif Else Begin 
    XGroesse = Groesse
    YGroesse = Groesse
    Endelse

If Not Set(WINNR) Then Begin
    Window, /FREE , XSize=(XGroesse*Matrix.target_w +1)*Matrix.source_w, YSize=(YGroesse*Matrix.target_h +1)*Matrix.source_h, Title=titel
         Endif Else Begin 
                      WSet, WinNr
                      XGroesse = (!D.X_Size-Matrix.source_w)/(Matrix.target_W*Matrix.source_W)
                      YGroesse = (!D.Y_Size-Matrix.source_h)/(Matrix.target_H*Matrix.source_H)

                      IF XGroesse EQ 0 THEN BEGIN
                         XGroesse = 1
                         Print, 'ShowWeights: ACHTUNG, horizontale Darstelleung unvollstaendig !!'
                      END
                      IF YGroesse EQ 0 THEN BEGIN
                         YGroesse = 1
                         Print, 'ShowWeights: ACHTUNG, vertikale Darstelleung unvollstaendig !!'
                      END
                  EndElse    



IF Keyword_Set(Delays) THEN BEGIN
   MatrixMatrix= reform(Matrix.Delays, Matrix.target_h, Matrix.target_w, Matrix.source_h, Matrix.source_w)
END ELSE BEGIN
   MatrixMatrix= reform(Matrix.Weights, Matrix.target_h, Matrix.target_w, Matrix.source_h, Matrix.source_w)
END

min = min(MatrixMatrix)
max = max(MatrixMatrix)
ts = !D.Table_Size-1

if min eq 0 and max eq 0 then max = 1; Falls Array nur Nullen enthält!

if min ge 0 then begin
   g = indgen(ts)/double(ts-1)*255
   tvlct, g, g, g                    ;Grauwerte
   MatrixMatrix = MatrixMatrix/double(max)*(ts-2)
endif else begin
   g = ((2*indgen(ts)-ts+1) > 0)/double(ts-1)*255
   tvlct, rotate(g, 2), g, bytarr(ts)         ;Rot-Grün
   MatrixMatrix = MatrixMatrix/2.0/double(max([max, -min]))
   MatrixMatrix = (MatrixMatrix+0.5)*(ts-2)
endelse

erase, rgb(255,100,0, INDEX=ts-1)


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
        
