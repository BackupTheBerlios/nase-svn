;+
; NAME: ShowWeights
;
; PURPOSE: formt eine Gewichtsmatrix um und stellt diese auf dem Bildschirm dar.
;          dabei werden die Gewichte der Verbindungen NACH Neuron#0
;          (also dessen rezeptives Feld) in der linken
;          oberen Ecke des Fensters als grau-schattierte Kaestchen
;          gezeigt (Keyword /Tos oder /RECEPTIVE), die Gewichte der Verbindungen NACH Neuron#1 rechts
;          daneben usw.
;          Seit Version 1.5 können alternativ auch die Verbindungen VON
;          den Neuronen dargestellt werden, also deren projektives
;          Feld (Keyword, /FROMS oder /PROJECTIVE).
;          Set Version 1.13 werden auch Matrizen mit negativen Werten
;          verarbeitet. Sie werden in grün/rot-Schattierungen für
;          positive/negative Werte angezeigt.
;
;          Merke: DER WERT 0 HAT STETS DIE FARBE SCHWARZ!
;
;          Nichtexistierende Verbindungen (!NONE) werden set Version 1.17 
;          dunkelblau dargestellt.
;   
; CATEGORY: GRAPHIC
;
; CALLING SEQUENCE: ShowWeights, Matrix { ,/FROMS | ,/PROJECTIVE | ,/TOS | /RECEPTIVE }
;                               [,TITEL='Titel'][,GROESSE=Fenstergroesse][,WINNR=FensterNr | ,/NOWIN]
;                               [,/DELAYS]
;                               [/SLIDE [,XVISIBLE=Fensterbreite] [,YVISIBLE=Fensterhöhe] [,GET_BASE=Base_ID] ]
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
;                     NOWIN: Wie WINNR, nur daß das gerade aktive
;                            Fenster benutzt wird, dessen Nummer man
;                            dann nicht unbedingt zu wissen braucht.
;     PROJECTIVE oder FROMS: Muß gesetzt werden, wenn man in den
;                            Untermatrizen die Verbindungen VON den
;                            Neuronen sehen will. (Projektive Felder)
;      RECEPTIVE oder TOS  : Muß gesetzt werden, wenn man die
;                            Verbindungen ZU den Neuronen sehen will. (Rezeptive Felder)
;                     DELAYS: Falls gesetzt, werden nicht die Gewichte, sondern die Delays visualisiert
;                     SLIDE: Ist dieses Keword ungleich null, so wird die Matrix in einem SLIDE_WINDOW angezeigt
;                            (nützlich, wenn sie nicht auf den
;                            Bildschirm paßt!)
;                            Für SLIDE=1 wird die
;                              IDL-Slide_Window-Routine benutzt, die
;                              zwei Fenster (eins mit dem verkleinerten
;                              Bild der Matrix und eins mit Rollbalken)
;                              darstellt.
;                            Für SLIDE=2 wird meine ScrollIt-Routine
;                              benutzt, die nur ein einziges Fenster
;                              mit Rollbalken darstellt.
;                     XVISIBLE,YVISIBLE: Größe des sichtbaren Ausschnitts, wenn SLIDE gesetzt ist.
;
; OUTPUTS: Gewichtsmatrix, an die Fenstergroesse angepasst.
;
; OPTIONAL OUTPUTS: separates Fenster, das die Darstellung der Gewichtmatrix enthaelt.
;                   Wird WinNr UND SLIDE angegeben, so wird die Matrix wie gewohnt im angegebenen Fenster dargestellt.
;                       Ein Slide-WIndow wird außerdem geöffnet.
;                   
;                   GET_BASE: Wird SLIDE angegeben, so kann hier die
;                             ID des erstellten Base-Widgets
;                             zurückgegeben werden, um das Fenster
;                             später mit einem
;                               WIDGET_CONTROL, Base_ID, /DESTROY
;                             schließen zu können.
;
; EXAMPLE:
;          MyMatrix = InitDW( S_WIDTH=4, S_HEIGHT=3, T_WIDTH=2, T_HEIGHT=2 )
;          SetWeight, MyMatrix, 1.0, S_INDEX=5, T_INDEX=2 ; connection from 5 --> 2
;          SetWeight, MyMatrix, 2.0, S_INDEX=6, T_INDEX=0 ; connection from 6 --> 0
;
;          ShowWeights, MyMatrix, Titel='wunderschoene Matrix', /PROJECTIVE, Groesse=50
;
;          FreeDW, MyMatrix
;
;          stellt die zuvor definierte MyMatrix zwischen dem Source-Layer der Breite 4 und
;          Hoehe 3 und dem Target-Layer der Breite und Hoehe 2 50-fach
;          vergroessert in einem Fenster mit Titel 'wunderschoene
;          Matrix' dar.
;
;
; SEE ALSO: <A HREF="file:/usr/ax1303/neuroadm/nase/simu/connections/index.html#INITDW">InitDW()</A>, <A HREF="file:/usr/ax1303/neuroadm/nase/simu/connections/index.html#FREEDW">FreeDW</A>, <A HREF="file:/usr/ax1303/neuroadm/nase/simu/connections/index.html#RESTOREDW">RestoreDW</A>,
;           <A HREF="file:/usr/ax1303/neuroadm/nase/simu/connections/index.html#SETWEIGHT">SetWeight</A>, <A HREF="file:/usr/ax1303/neuroadm/nase/simu/connections/index.html#SETDELAY">SetDelay</A>,
;           <A HREF="file:/usr/ax1303/neuroadm/nase/simu/connections/index.html#SETCONSTWEIGHT">SetConstWeight</A>, <A HREF="file:/usr/ax1303/neuroadm/nase/simu/connections/index.html#SETCONSTDELAY">SetConstDelay</A>,
;           <A HREF="file:/usr/ax1303/neuroadm/nase/simu/connections/index.html#SETLINEARWEIGHT">SetLinearWeight</A>, <A HREF="file:/usr/ax1303/neuroadm/nase/simu/connections/index.html#SETLINEARDELAY">SetLinearDelay</A>,
;           <A HREF="file:/usr/ax1303/neuroadm/nase/simu/connections/index.html#SETGAUSSWEIGHT">SetGaussWeight</A>, <A HREF="file:/usr/ax1303/neuroadm/nase/simu/connections/index.html#SETGAUSSDELAY">SetGaussDelay</A>,
;           <A HREF="file:/usr/ax1303/neuroadm/nase/simu/connections/index.html#SETDOGWEIGHT">SetDogWeight</A>,
;           <A HREF="file:/usr/ax1303/neuroadm/nase/simu/connections/index.html#DELAYWEIGH">DelayWeigh()</A>
;
; MODIFICATION HISTORY: 
;
;       $Log$
;       Revision 2.10  1998/01/26 18:23:47  saam
;             Fehler bei Null-Device korrigiert
;
;       Revision 2.9  1997/12/10 15:57:55  saam
;             Es werden jetzt keine Strukturen mehr uebergeben, sondern
;             nur noch Tags. Das hat den Vorteil, dass man mehrere
;             DelayWeigh-Strukturen in einem Array speichern kann,
;             was sonst nicht moeglich ist, da die Strukturen anonym sind.
;
;       Revision 2.8  1997/12/08 12:48:02  kupper
;       *** empty log message ***
;
;       Revision 2.7  1997/12/01 16:06:53  kupper
;              Header überarbeitet, Hyperlinks eingefügt.
;
;       Revision 2.6  1997/12/01 15:32:28  kupper
;              SLIDE-Keyword hat jetzt zwei mögliche Optionen.
;              GET_BASE implementiert.
;
;       Revision 2.5  1997/11/13 13:24:14  saam
;             Device Null wird uenterstuetzt
;
;       Revision 2.4  1997/10/30 13:00:53  kupper
;              PROJECTIVE, RECEPTIVE als Alternative zu TOS, FROMS eingeführt.
;
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


PRO ShowWeights, __Matrix, titel=TITEL, groesse=GROESSE, winnr=WINNR, $
                 SLIDE=slide, XVISIBLE=xvisible, YVISIBLE=yvisible, GET_BASE=get_base, $
                 FROMS=froms,  TOS=tos, DELAYS=delays, $
                 PROJECTIVE=projective, RECEPTIVE=receptive, $
                 NOWIN = nowin

   IF !D.Name EQ 'NULL' THEN RETURN

   Handle_Value, __Matrix, _Matrix, /NO_COPY 

   Default, FROMS, PROJECTIVE
   Default, TOS, RECEPTIVE

   IF Keyword_Set(NOWIN) THEN Winnr = !D.Window
   If not keyword_set(FROMS) and not keyword_set(TOS) then message, 'Eins der Schlüsselwörter PROJECTIVE/FROMS oder RECEPTIVE/TOS muß gesetzt sein!'

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


;;;;;;;
;;;;;;; MIRKO -> 1D-Darstellung 
;;;;;;;
;   minIndex = MIN([Matrix.source_w, Matrix.source_h])
;   IF minIndex EQ 1 THEN BEGIN
;      print, 'Mapping Row/Column to Square'
;      tmpWidth = ROUND(SQRT(Matrix.source_w*Matrix.source_h))
;      tmpHeight = (Matrix.source_w*Matrix.source_h) / tmpWidth
;      tmpHeight = 

;   END
;;;;;;;
;;;;;;; MIRKO -> ENDE
;;;;;;;


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
         If keyword_set(SLIDE) then begin
            case SLIDE of 1: Window, /PIXMAP, /FREE , XSize=(XGroesse*Matrix.target_w +1)*Matrix.source_w, YSize=(YGroesse*Matrix.target_h +1)*Matrix.source_h, Title=titel
               else: SlideWin = Scrollit (XDRAWSIZE=(XGroesse*Matrix.target_w +1)*Matrix.source_w, YDRAWSIZE=(YGroesse*Matrix.target_h +1)*Matrix.source_h, $
                                          XSIZE=xvisible, YSIZE=yvisible, TITLE=titel, GET_BASE=get_base)
            endcase
         endif else begin
            Window, /FREE , XSize=(XGroesse*Matrix.target_w +1)*Matrix.source_w, YSize=(YGroesse*Matrix.target_h +1)*Matrix.source_h, Title=titel
         endelse
      Endif Else Begin 
         WSet, WinNr
         XGroesse = (!D.X_Size-Matrix.source_w)/(Matrix.target_W*Matrix.source_W)
         YGroesse = (!D.Y_Size-Matrix.source_h)/(Matrix.target_H*Matrix.source_H)

         IF XGroesse EQ 0 THEN BEGIN
            XGroesse = 1
            Print, 'ShowWeights: ACHTUNG, horizontale Darstellung unvollständig !!'
         END
         IF YGroesse EQ 0 THEN BEGIN
            YGroesse = 1
            Print, 'ShowWeights: ACHTUNG, vertikale Darstellung unvollständig !!'
         END
      EndElse    


   IF Keyword_Set(Delays) THEN BEGIN
      MatrixMatrix= reform(Matrix.Delays, Matrix.target_h, Matrix.target_w, Matrix.source_h, Matrix.source_w)
   END ELSE BEGIN
      MatrixMatrix= reform(Matrix.Weights, Matrix.target_h, Matrix.target_w, Matrix.source_h, Matrix.source_w)
   END


   no_connections = WHERE(MatrixMatrix EQ !NONE, count)
   IF count NE 0 THEN MatrixMatrix(no_connections) = 0 ;Damits vorerst bei der Berechnung nicht stört!

   min = min(MatrixMatrix)
   max = max(MatrixMatrix)
   ts = !D.Table_Size-1

   if min eq 0 and max eq 0 then max = 1 ; Falls Array nur Nullen enthält!

   if min ge 0 then begin
      g = indgen(ts)/double(ts-1)*255
      tvlct, g, g, g            ;Grauwerte
      MatrixMatrix = MatrixMatrix/double(max)*(ts-3)
   endif else begin
      g = ((2*indgen(ts)-ts+1) > 0)/double(ts-1)*255
      tvlct, rotate(g, 2), g, bytarr(ts) ;Rot-Grün
      MatrixMatrix = MatrixMatrix/2.0/double(max([max, -min]))
      MatrixMatrix = (MatrixMatrix+0.5)*(ts-3)
   endelse

   IF count NE 0 THEN MatrixMatrix(no_connections) = ts-2 ;Das sei der Index für nichtexistente Verbindungen

   SetColorIndex, ts-2, 0, 0, 100 ;Blau sei die Farbe für nichtexistente Verbindungen


   erase, rgb(255,100,0, INDEX=ts-1) ;Orange die für die Trennlinien


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
      if (SLIDE eq 1) then begin
         Image = TVRd()
         If not set(WINNR) then wdelete
         
         ;; Ein zweifenstriges IDL-Slide-Window:
         Slide_Image, Image, /RETAIN, $
          XSIZE=(XGroesse*Matrix.target_w +1)*Matrix.source_w, YSIZE=(YGroesse*Matrix.target_h +1)*Matrix.source_h, $
          XVISIBLE=xvisible, YVISIBLE=yvisible, $
          Title=titel, TOP_ID=Base
         Default, get_base, Base ;Base-ID-zurückgeben, falls ein Widget mit SLIDE erstellt wurde.
      endif
   endif


   Handle_Value, __Matrix, _Matrix, /NO_COPY, /SET
   
END        
        





