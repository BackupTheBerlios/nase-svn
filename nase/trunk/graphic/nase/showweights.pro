;+
; NAME: ShowWeights
;
; PURPOSE: formt eine Gewichtsmatrix um und stellt diese auf dem Bildschirm dar.
;          dabei werden die Gewichte der Verbindungen NACH Neuron#0 in der linken
;          oberen Ecke des Fensters als grau-schattierte Kaestchen
;          gezeigt (Keyword /Tos), die Gewichte der Verbindungen NACH Neuron#1 rechts
;          daneben usw.
;          Seit Version 1.5 k�nnen alternativ auch die Verbindungen VON
;          den Neuronen dargestellt werden (Keyword, /FROMS).
;          Set Version 1.13 werden auch Matrizen mit negativen Werten
;          verarbeitet. Sie werden in gr�n/rot-Schattierungen f�r
;          positive/negative Werte angezeigt.
;
;          Merke: DER WERT 0 HAT STETS DIE FARBE SCHWARZ!
;
;          Nichtexistierende Verbindungen (!NONE) werden set Version 1.17 
;          dunkelblau dargestellt.
;   
; CATEGORY: GRAPHIC
;
; CALLING SEQUENCE: ShowWeights, Matrix {, /FROMS |, /TOS }
;                               [,TITEL='Titel'][,GROESSE=Fenstergroesse][,WINNR=FensterNr][,/DELAYS]
;                               [/SLIDE [,XVISIBLE] [,YVISIBLE] ]
;
; INPUTS: Matrix: Gewichtsmatrix, die dargestellt werden soll, G(Target,Source)
;                 Matrix ist eine vorher mit DelayWeigh definierte Struktur 
; 
; KEYWORD PARAMETERS: TITEL: Titel des Fensters, das die Darstellung
;                            enthalten soll 
;                     GROESSE: Faktor fuer die Vergroesserung der Darstellung
;                     WINNR: Nr des Fensters, in dem die Darstellung
;                            erfolgen soll (muss natuerlich offen
;                            sein). Ist WinNr gesetzt, sind evtl vorher angegebene
;                            Titel und Groessen unwirksam (klar,
;                            Fenster war ja schon vorher offen).
;                     FROMS: Mu� gesetzt werden, wenn man in den
;                            Untermatrizen die Verbindungen VON den
;                            Neuronen sehen will.
;                     TOS  : Mu� gesetzt werden, wenn man die
;                            Verbindungen ZU den Neuronen sehen will.
;                     DELAYS: Falls gesetzt, werden nicht die Gewichte, sondern die Delays visualisiert
;                     SLIDE: Ist dieses Keword gesetzt, so wird die Matrix in einem SLIDE_WINDOW angezeigt
;                            (n�tzlich, wenn sie nicht auf den Bildschirm pa�t!)
;                     XVISIBLE,YVISIBLE: Gr��e des sichtbaren Ausschnitts, wenn SLIDE gesetzt ist.
;
; OUTPUTS: Gewichtsmatrix, an die Fenstergroesse angepasst.
;
; OPTIONAL OUTPUTS: separates Fenster, das die Darstellung der Gewichtmatrix enthaelt.
;                   Wird WinNr UND SLIDE angegeben, so wird die Matrix wie gewohnt im angegebenen Fenster dargestellt.
;                       Ein Slide-WIndow wird au�erdem ge�ffnet.
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
;       $Log$
;       Revision 2.3  1997/10/14 15:46:18  saam
;              Delays konnten zwischenzeitlich nicht dargestellt
;              werden...geht wieder
;
;       Thu Sep 4 17:12:07 1997, Ruediger Kupper
;       <kupper@sisko.physik.uni-marburg.de>
;
;		SLIDE, XVISIBLE, YVISIBLE implementiert.
;
;       Mon Aug 18 19:59:18 1997, Ruediger Kupper
;       <kupper@sisko.physik.uni-marburg.de>
;
;		Nichtexistierende Verbindungen werden jetzt blau dargestell.
;
;       Mon Aug 18 16:58:34 1997, Mirko Saam
;       <saam@ax1317.Physik.Uni-Marburg.DE>
;
;		nicht vorhandene Verbindungen werden vorlaeufig mit Wert NULL dargestellt
;
;                       Erste Version vom 25. Juli '97, Andreas.
;                       Diese Version (Verbesserte Parameterabfrage) vom 28. Juli '97, Andreas
;                       Versucht, Keyword FROMS zuzuf�gen, R�diger,
;                       30.7.1997
;                       Es ist mir gelungen! Au�erdem hat die Darstellung jetzt Gitterlinien!, R�diger, 31.7.1997
;                       Ich hab die interne Verarbeitung von Source und Target vertauscht, da sie so unseren Arraystrukturen angemessener ist.
;                           Ausserdem hab ich die Array-Operationen beim TV zusammengefasst.
;                           Das alles sollte einen gewissen Geschwindigkeitsvorteil bringen.
;                           Ausserdem normiert die Routine jetzt auf den maximal verf�gbaren ColorTable-Index,
;                           was auf Displays mit weniger als 256 freien Indizes (d.h. wenn IDL eine Public Colormap benutzt)
;                           den maximalen Kontrast erreicht.
;                           R�diger, 1.8.1997
;                       Schluesselwort DELAYS hinzugefuegt, sodass nun auch alternativ auch die Verzoegerungen dargestellt werden koennen, Mirko, 3.8.97
;                       Bug bei WSet korrigiert, wenn WinNR uebergeben wird, Mirko, 3.8.97
;                       wird WINNR nicht gesetzt, so wird NEUES Fenster aufgemacht, Mirko, 3.8.97
;                       Matrizen mit negativen Gewichten werden jetzt in rot/gr�n dargestellt. R�diger, 5.8.97
;
;                       gibt man WINNR an, und das Fenster ist zu klein fuer die Darstellung, bricht die Routine mit
;                       unverstaendlichem Fehler ab. Das wird nun abgefangen, indem die Gewichte mit kleinster GROESSE (=1)
;                       dargestellt werden (und somit zum Teil abgeschnitten); ausserdem wird ne Warnung ausgegeben, Mirko, 13.8.97
;-


PRO ShowWeights, _Matrix, titel=TITEL, groesse=GROESSE, winnr=WINNR, $
                 SLIDE=slide, XVISIBLE=xvisible, YVISIBLE=yvisible, $
                 FROMS=froms,  TOS=tos, DELAYS=delays

   If not keyword_set(FROMS) and not keyword_set(TOS) then message, 'Eins der Schl�sselw�rter FROMS oder TOS mu� gesetzt sein!'

   if keyword_set(TOS) then begin ; Source- und Targetlayer vertauschen:

      IF _Matrix.info EQ 'DW_WEIGHT' THEN BEGIN
         Matrix = {Weights : Transpose(_Matrix.Weights), $
                   source_w: _Matrix.target_w, $
                   source_h: _Matrix.target_h, $
                   target_w: _Matrix.source_w, $
                   target_h: _Matrix.source_h}
      END ELSE IF _Matrix.info EQ 'DW_DELAY_WEIGHT' THEN BEGIN
         Matrix = {Weights : Transpose(_Matrix.Weights), $
                   Delays : Transpose(_Matrix.Delays),$
                   source_w: _Matrix.target_w, $
                   source_h: _Matrix.target_h, $
                   target_w: _Matrix.source_w, $
                   target_h: _Matrix.source_h}
      END ELSE Message, 'keine gueltige DelayWeigh-Struktur uebergeben'
   ENDIF ELSE Matrix = _Matrix


;no_connections = WHERE(Matrix.Weights EQ !NONE, count)
;IF count NE 0 THEN Matrix.Weights(no_connections) = 0.0
   
   If Not Set(TITEL) Then titel = 'Gewichtsmatrix'
   If Not Set(GROESSE) Then Begin 
      XGroesse = 1
      YGroesse = 1 
   Endif Else Begin 
      XGroesse = Groesse
      YGroesse = Groesse
   Endelse

   Default, xvisible, 256
   Default, yvisible, 256

      If Not Set(WINNR) Then Begin
         If keyword_set(SLIDE) then pix = 1 else pix = 0
         Window, PIXMAP=pix, /FREE , XSize=(XGroesse*Matrix.target_w +1)*Matrix.source_w, YSize=(YGroesse*Matrix.target_h +1)*Matrix.source_h, Title=titel
      Endif Else Begin 
         WSet, WinNr
         XGroesse = (!D.X_Size-Matrix.source_w)/(Matrix.target_W*Matrix.source_W)
         YGroesse = (!D.Y_Size-Matrix.source_h)/(Matrix.target_H*Matrix.source_H)

         IF XGroesse EQ 0 THEN BEGIN
            XGroesse = 1
            Print, 'ShowWeights: ACHTUNG, horizontale Darstellung unvollst�ndig !!'
         END
         IF YGroesse EQ 0 THEN BEGIN
            YGroesse = 1
            Print, 'ShowWeights: ACHTUNG, vertikale Darstellung unvollst�ndig !!'
         END
      EndElse    


   IF Keyword_Set(Delays) THEN BEGIN
      MatrixMatrix= reform(Matrix.Delays, Matrix.target_h, Matrix.target_w, Matrix.source_h, Matrix.source_w)
   END ELSE BEGIN
      MatrixMatrix= reform(Matrix.Weights, Matrix.target_h, Matrix.target_w, Matrix.source_h, Matrix.source_w)
   END


   no_connections = WHERE(MatrixMatrix EQ !NONE, count)
   IF count NE 0 THEN MatrixMatrix(no_connections) = 0 ;Damits vorerst bei der Berechnung nicht st�rt!

   min = min(MatrixMatrix)
   max = max(MatrixMatrix)
   ts = !D.Table_Size-1

   if min eq 0 and max eq 0 then max = 1 ; Falls Array nur Nullen enth�lt!

   if min ge 0 then begin
      g = indgen(ts)/double(ts-1)*255
      tvlct, g, g, g            ;Grauwerte
      MatrixMatrix = MatrixMatrix/double(max)*(ts-3)
   endif else begin
      g = ((2*indgen(ts)-ts+1) > 0)/double(ts-1)*255
      tvlct, rotate(g, 2), g, bytarr(ts) ;Rot-Gr�n
      MatrixMatrix = MatrixMatrix/2.0/double(max([max, -min]))
      MatrixMatrix = (MatrixMatrix+0.5)*(ts-3)
   endelse

   IF count NE 0 THEN MatrixMatrix(no_connections) = ts-2 ;Das sei der Index f�r nichtexistente Verbindungen

   SetColorIndex, ts-2, 0, 0, 100 ;Blau sei die Farbe f�r nichtexistente Verbindungen


   erase, rgb(255,100,0, INDEX=ts-1) ;Orange die f�r die Trennlinien


   for YY= 0, Matrix.source_h-1 do begin
      for XX= 0, Matrix.source_w-1 do begin  
         tv, rebin( /sample, $
                    transpose(MatrixMatrix(*, *, YY, XX)), $
                    xGroesse*Matrix.target_w,  yGroesse*Matrix.target_h), $
          /Order, $
          XX*(1+Matrix.target_w*xGroesse), (Matrix.source_h-1-YY)*(1+Matrix.target_h*yGroesse)
      end
   end

   If Keyword_Set(SLIDE) then begin
      Image = TVRd()
      If not set(WINNR) then wdelete 
      Slide_Image, Image, /RETAIN, $
                         XSIZE=(XGroesse*Matrix.target_w +1)*Matrix.source_w, YSIZE=(YGroesse*Matrix.target_h +1)*Matrix.source_h, $
                         XVISIBLE=xvisible, YVISIBLE=yvisible, $
                         Title=titel
   endif

END        
        





