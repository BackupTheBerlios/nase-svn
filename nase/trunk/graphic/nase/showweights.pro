;+
; NAME: ShowWeights
;
; PURPOSE: formt eine Gewichtsmatrix um und stellt diese auf dem Bildschirm dar.
;          dabei werden die Gewichte der Verbindungen NACH Neuron#0
;          (also dessen rezeptives Feld) in der linken
;          oberen Ecke des Fensters als grau-schattierte Kaestchen
;          gezeigt (Keyword /Tos oder /RECEPTIVE), die Gewichte der Verbindungen NACH Neuron#1 rechts
;          daneben usw.
;          Seit Version 1.5 k�nnen alternativ auch die Verbindungen VON
;          den Neuronen dargestellt werden, also deren projektives
;          Feld (Keyword, /FROMS oder /PROJECTIVE).
;          Set Version 1.13 werden auch Matrizen mit negativen Werten
;          verarbeitet. Sie werden in gr�n/rot-Schattierungen f�r
;          positive/negative Werte angezeigt.
;
;          Merke: DER WERT 0 HAT STETS DIE FARBE SCHWARZ!
;
;          Nichtexistierende Verbindungen (!NONE) werden seit Version 1.17 
;          dunkelblau dargestellt.
;   
; CATEGORY: GRAPHIC
;
; CALLING SEQUENCE: ShowWeights, Matrix { ,/FROMS | ,/PROJECTIVE | ,/TOS | /RECEPTIVE }
;                               [,TITEL='Titel'][,GROESSE=ZOOM=Fenstergroesse]
;                               [,MAXSIZE=(Xmax,ymax)]
;                               [,WINNR=FensterNr | ,/NOWIN] [,GET_WIN=FensterNr]
;                               [,/DELAYS]
;                               [,SLIDE={1,2}
;                               [,XVISIBLE=Fensterbreite]
;                               [,YVISIBLE=Fensterh�he]
;                               [,GET_BASE=Base_ID] 
;                               [,GET_MAXCOL=Farbindex] [,GET_COLORMODE=cm] ]
;
; INPUTS: Matrix: Gewichtsmatrix, die dargestellt werden soll, G(Target,Source)
;                 Matrix ist eine vorher mit DelayWeigh definierte Struktur 
; 
; KEYWORD PARAMETERS: TITEL: Titel des Fensters, das die Darstellung
;                            enthalten soll 
;         ZOOM oder GROESSE: Faktor fuer die Vergroesserung der Darstellung
;                   MAXSIZE: Ein zweielementiges Array, das die
;                            maximalen Abmessungen enth�lt, die ein
;                            von ShowWeights ge�ffnetes Fenster haben
;                            sollte. (In der Regel sind das
;                            Bildschirmbreite und -h�he). Wird die
;                            Darstellung mit dem angegebenen
;                            Zoomfaktor zu gro�, so �ffnet Showweights 
;                            automatisch ein Slide-Window.
;                     WINNR: Nr des Fensters, in dem die Darstellung
;                            erfolgen soll (muss natuerlich offen
;                            sein). Ist WinNr gesetzt, sind evtl vorher angegebene
;                            Titel und Groessen unwirksam (klar,
;                            Fenster war ja schon vorher offen).
;                     NOWIN: Wie WINNR, nur da� das gerade aktive
;                            Fenster benutzt wird, dessen Nummer man
;                            dann nicht unbedingt zu wissen braucht.
;     PROJECTIVE oder FROMS: Mu� gesetzt werden, wenn man in den
;                            Untermatrizen die Verbindungen VON den
;                            Neuronen sehen will. (Projektive Felder)
;      RECEPTIVE oder TOS  : Mu� gesetzt werden, wenn man die
;                            Verbindungen ZU den Neuronen sehen will. (Rezeptive Felder)
;                     DELAYS: Falls gesetzt, werden nicht die Gewichte, sondern die Delays visualisiert
;                     SLIDE: Ist dieses Keword ungleich null, so wird die Matrix in einem SLIDE_WINDOW angezeigt
;                            (n�tzlich, wenn sie nicht auf den
;                            Bildschirm pa�t!)
;                            F�r SLIDE=1 wird die
;                              IDL-Slide_Window-Routine benutzt, die
;                              zwei Fenster (eins mit dem verkleinerten
;                              Bild der Matrix und eins mit Rollbalken)
;                              darstellt.
;                            F�r SLIDE=2 wird meine ScrollIt-Routine
;                              benutzt, die nur ein einziges Fenster
;                              mit Rollbalken darstellt.
;                     XVISIBLE,YVISIBLE: Gr��e des sichtbaren Ausschnitts, wenn SLIDE gesetzt ist.
;
; OUTPUTS: Gewichtsmatrix, an die Fenstergroesse angepasst.
;
; OPTIONAL OUTPUTS: separates Fenster, das die Darstellung der Gewichtmatrix enthaelt.
;                   Wird WinNr UND SLIDE angegeben, so wird die Matrix wie gewohnt im angegebenen Fenster dargestellt.
;                       Ein Slide-WIndow wird au�erdem ge�ffnet.
;                   
;                    GET_WIN: Hier wird die Nummer des Fensters zur�ckgegeben, das 
;                             f�r die Darstellung verwendet wurde.
;                   GET_BASE: Wird SLIDE angegeben, so kann hier die
;                             ID des erstellten Base-Widgets
;                             zur�ckgegeben werden, um das Fenster
;                             sp�ter mit einem
;                               WIDGET_CONTROL, Base_ID, /DESTROY
;                             schlie�en zu k�nnen.
;                 GET_MAXCOL: ShowWeights benutzt die Farben Blau f�r 
;                             !NONE-Verbindungen und Orange f�r das
;                             Liniengitter.
;                             Daher stehen f�r die Bilddarstellung
;                             nicht mehr alle Farbindizes zur
;                             Verf�gung. In GET_MAXCOL kann der
;                             letzte verwendbare Index abgefragt
;                             werden.
;              GET_COLORMODE: Liefert als Ergebnis +1, falls der
;                             schwarz/weiss-Modus zur Darstellung
;                             benutzt wurde (DW-Matrix enthielt nur
;                             positive Werte), und -1, falls der
;                             rot/gr�n-Modus benutzt wurde (DW-Matrix
;                             enthielt negative Werte).
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
; SEE ALSO: <A HREF="../simu/connections/index.html#INITDW">InitDW()</A>, <A HREF="file:/usr/ax1303/neuroadm/nase/simu/connections/index.html#FREEDW">FreeDW</A>, <A HREF="file:/usr/ax1303/neuroadm/nase/simu/connections/index.html#RESTOREDW">RestoreDW</A>,
;           <A HREF="../simu/connections/index.html#SETWEIGHT">SetWeight</A>, <A HREF="file:/usr/ax1303/neuroadm/nase/simu/connections/index.html#SETDELAY">SetDelay</A>,
;           <A HREF="../simu/connections/index.html#SETCONSTWEIGHT">SetConstWeight</A>, <A HREF="file:/usr/ax1303/neuroadm/nase/simu/connections/index.html#SETCONSTDELAY">SetConstDelay</A>,
;           <A HREF="../simu/connections/index.html#SETLINEARWEIGHT">SetLinearWeight</A>, <A HREF="file:/usr/ax1303/neuroadm/nase/simu/connections/index.html#SETLINEARDELAY">SetLinearDelay</A>,
;           <A HREF="../simu/connections/index.html#SETGAUSSWEIGHT">SetGaussWeight</A>, <A HREF="file:/usr/ax1303/neuroadm/nase/simu/connections/index.html#SETGAUSSDELAY">SetGaussDelay</A>,
;           <A HREF="../simu/connections/index.html#SETDOGWEIGHT">SetDogWeight</A>,
;           <A HREF="../simu/connections/index.html#DELAYWEIGH">DelayWeigh()</A>
;
; MODIFICATION HISTORY: 
;
;       $Log$
;       Revision 2.18  1998/02/26 14:13:50  saam
;             kleine Aenderung fuer 32-Bit-Display
;             Max-Size noch falsch behandelt
;
;       Revision 2.17  1998/02/26 13:58:49  kupper
;              TV durch UTV ersetzt. Mal sehen...
;
;       Revision 2.16  1998/02/18 13:48:18  kupper
;              Schl�sselworte COLORMODE,GET_COLORMODE,GET_MAXCOL zugef�gt.
;
;       Revision 2.15  1998/02/05 14:13:17  saam
;             bug in FROMS (noncritical) corrected
;
;       Revision 2.14  1998/02/05 13:22:39  saam
;             Anpassung an neue DW-Struktur
;
;       Revision 2.13  1998/02/04 17:23:48  kupper
;              Showweights benutzt jetzt brav objektorientiert die Weights(), Delays() und DWDim()-Funktionen.
;              Das MAXSIZE-Schl�sselwort wurde implementiert, weil ich mich immer ge�rgert habe, da� die Fenster
;               nicht auf meinen Bildschirm passen...
;
;       Revision 2.11  1998/02/03 17:29:15  kupper
;              Statt GROESSE kann nun alternativ ZOOM verwendet werden.
;              GET_WIN-Schl�sselwort zugef�gt.
;
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
;              Header �berarbeitet, Hyperlinks eingef�gt.
;
;       Revision 2.6  1997/12/01 15:32:28  kupper
;              SLIDE-Keyword hat jetzt zwei m�gliche Optionen.
;              GET_BASE implementiert.
;
;       Revision 2.5  1997/11/13 13:24:14  saam
;             Device Null wird uenterstuetzt
;
;       Revision 2.4  1997/10/30 13:00:53  kupper
;              PROJECTIVE, RECEPTIVE als Alternative zu TOS, FROMS eingef�hrt.
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


PRO ShowWeights, __Matrix, titel=TITEL, groesse=GROESSE, ZOOM=zoom, winnr=WINNR, $
                 SLIDE=slide, XVISIBLE=xvisible, YVISIBLE=yvisible, GET_BASE=get_base, $
                 FROMS=froms,  TOS=tos, DELAYS=delays, $
                 PROJECTIVE=projective, RECEPTIVE=receptive, $
                 NOWIN = nowin, GET_WIN=get_win, $
                 MAXSIZE=maxsize, $
                 GET_MAXCOL=get_maxcol, GET_COLORMODE=get_colormode

   IF !D.Name EQ 'NULL' THEN RETURN

   Default, GROESSE, ZOOM       ;Die Schl�sselworte k�nnen alternativ verwendet werden.
;   MAXSIZE = Get_Screen_Size()  ;Wu�te fr�her nicht, da� es diese Funktion gibt, sorry...
   MAXSIZE = [1280,1024]

;   Handle_Value, __Matrix, _Matrix, /NO_COPY 

   Default, FROMS, PROJECTIVE
   Default, TOS, RECEPTIVE

   IF Keyword_Set(NOWIN) THEN Winnr = !D.Window
   If not keyword_set(FROMS) and not keyword_set(TOS) then message, 'Eins der Schl�sselw�rter PROJECTIVE/FROMS oder RECEPTIVE/TOS mu� gesetzt sein!'

   ;;------------------> Hier basteln wir uns eine DW-Struktur der ganz, ganz alten Form!
   ;;                     (das hat nat�rlich historische Gr�nde...) 
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
      END ELSE Message, 'keine gueltige DelayWeigh-Struktur �bergeben!'

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
      END ELSE Message, 'keine gueltige DelayWeigh-Struktur �bergeben!'

   Endelse
   ;;--------------------------------

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

   ;;------------------> Auto-Slide ?
   If not keyword_set(SLIDE) then begin ;Eventuell doch ein SLIDE Fenster �ffnen
      XS=(XGroesse*Matrix.target_w +1)*Matrix.source_w
      YS=(YGroesse*Matrix.target_h +1)*Matrix.source_h
      If (XS+8 gt MAXSIZE(0)) or (YS+20 gt MAXSIZE(1)) then begin ;Fensterr�nder+Schieber ca. 20, 55 Pixel...
         ;;Window would not fit an Screen - so make it a SLIDE-Window
         SLIDE = 2
         XVISIBLE = XS < (MAXSIZE(0)-40)
         YVISIBLE = YS < (MAXSIZE(1)-58) ;Fensterr�nder ca 8, 20 Pixel
      Endif
   Endif
   ;;--------------------------------


   Default, xvisible, 256
   Default, yvisible, 256

      If Not Set(WINNR) Then Begin
         If keyword_set(SLIDE) then begin
            case SLIDE of 1: Window, /PIXMAP, /FREE , XSize=(XGroesse*Matrix.target_w +1)*Matrix.source_w, YSize=(YGroesse*Matrix.target_h +1)*Matrix.source_h, Title=titel
               else: GET_WIN = Scrollit (XDRAWSIZE=(XGroesse*Matrix.target_w +1)*Matrix.source_w, YDRAWSIZE=(YGroesse*Matrix.target_h +1)*Matrix.source_h, $
                                         XSIZE=xvisible, YSIZE=yvisible, TITLE=titel, GET_BASE=get_base, $
                                         XPOS=0, YPOS=0)
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


;   no_connections = WHERE(MatrixMatrix EQ !NONE, count)
;   IF count NE 0 THEN MatrixMatrix(no_connections) = 0 ;Damits vorerst bei der Berechnung nicht st�rt!

;   min = min(MatrixMatrix)
;   max = max(MatrixMatrix)
;   ts = !D.Table_Size;-1

;   if min eq 0 and max eq 0 then max = 1 ; Falls Array nur Nullen enth�lt!

;   if min ge 0 then begin
;      g = indgen(ts)/double(ts-1)*255
;      tvlct, g, g, g            ;Grauwerte
;      MatrixMatrix = MatrixMatrix/double(max)*(ts-3)
;   endif else begin
;      g = ((2*indgen(ts)-ts+1) > 0)/double(ts-1)*255
;      tvlct, rotate(g, 2), g, bytarr(ts) ;Rot-Gr�n
;      MatrixMatrix = MatrixMatrix/2.0/double(max([max, -min]))
;      MatrixMatrix = (MatrixMatrix+0.5)*(ts-3)
;   endelse

;   IF count NE 0 THEN MatrixMatrix(no_connections) = ts-2 ;Das sei der Index f�r nichtexistente Verbindungen

;   SetColorIndex, ts-2, 0, 0, 100 ;Blau sei die Farbe f�r nichtexistente Verbindungen
;   erase, rgb(255,100,0, INDEX=ts-1) ;Orange die f�r die Trennlinien

   MatrixMatrix = ShowWeights_Scale(MatrixMatrix, /SETCOL, GET_MAXCOL=GET_MAXCOL, GET_COLORMODE=GET_COLORMODE)
   erase, GET_MAXCOL+2

   Device, BYPASS_TRANSLATION=0
   for YY= 0, Matrix.source_h-1 do begin
      for XX= 0, Matrix.source_w-1 do begin  
         tv, rebin( /sample, $
                    transpose(MatrixMatrix(*, *, YY, XX)), $
                    xGroesse*Matrix.target_w,  yGroesse*Matrix.target_h), $
          /Order, $
          XX*(1+Matrix.target_w*xGroesse), (Matrix.source_h-1-YY)*(1+Matrix.target_h*yGroesse)
      end
   end
   Device, /BYPASS_TRANSLATION

   If Keyword_Set(SLIDE) then begin
      if (SLIDE eq 1) then begin
         Image = TVRd()
         If not set(WINNR) then wdelete
         
         ;; Ein zweifenstriges IDL-Slide-Window:
         Slide_Image, Image, /RETAIN, $
          XSIZE=(XGroesse*Matrix.target_w +1)*Matrix.source_w, YSIZE=(YGroesse*Matrix.target_h +1)*Matrix.source_h, $
          XVISIBLE=xvisible, YVISIBLE=yvisible, $
          Title=titel, TOP_ID=Base, SLIDE_WINDOW=GET_WIN ;Fensternummer zur�ckliefern
         Default, get_base, Base ;Base-ID-zur�ckgeben, falls ein Widget mit SLIDE erstellt wurde.
      endif
   endif


;   Handle_Value, __Matrix, _Matrix, /NO_COPY, /SET

   ;;------------------> Fensternummer zur�ckliefern:
   If not keyword_set(SLIDE) then GET_WIN = !D.Window 
   ;;--------------------------------

END        
        





