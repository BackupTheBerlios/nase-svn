;+
; NAME: ShowWeights
;
; PURPOSE: Formt eine Gewichtsmatrix um und stellt diese auf dem Bildschirm dar.
;          Dabei werden die Gewichte der Verbindungen NACH Neuron#0
;          (also dessen rezeptives Feld) in der linken
;          oberen Ecke des Fensters als grau-schattierte Kaestchen
;          gezeigt (Keyword /TOS oder /RECEPTIVE), die Gewichte der Verbindungen NACH Neuron#1 rechts
;          daneben usw.
;          Seit Version 1.5 können alternativ auch die Verbindungen VON
;          den Neuronen dargestellt werden, also deren projektives
;          Feld (Keyword /FROMS oder /PROJECTIVE).
;          Set Version 1.13 werden auch Matrizen mit negativen Werten
;          verarbeitet. Sie werden in grün/rot-Schattierungen für
;          positive/negative Werte angezeigt.
;
;          Merke: DER WERT 0 HAT STETS DIE FARBE SCHWARZ!
;
;          Nichtexistierende Verbindungen (!NONE) werden seit Version 1.17 
;          dunkelblau dargestellt.
;   
; CATEGORY: GRAPHICS / NASE SPECIFIC ROUTINES
;
; CALLING SEQUENCE: ShowWeights, Matrix { ,/FROMS | ,/PROJECTIVE | ,/TOS | /RECEPTIVE }
;                               [,TITEL='Titel'][,GROESSE=ZOOM=Vergrößerungsfaktor]
;                               [,XGROESSE=XZOOM=XFaktor] [,YGROESSE=YZOOM=YFaktor]
;                               [,MAXSIZE=(Xmax,ymax)]
;                               [,WINNR=FensterNr | ,/NOWIN] [,GET_WIN=FensterNr]
;                               [,/DELAYS]
;                               [,SLIDE={1,2}
;                               [,XVISIBLE=Fensterbreite]
;                               [,YVISIBLE=Fensterhöhe] ]
;                               [,/SURF [,/GRID] [,/SUPERIMPOSE]]
;                               [ weitere Surface-/Shade_Surf-Parameter ]
;                               [,COLORMODE=colormode] [,/PRINTSTYLE]
;                               [,SETCOL=setcol]
;                               [,GET_BASE=Base_ID] 
;                               [,GET_MAXCOL=Farbindex] [,GET_COLORMODE=cm]
;                             ( [,GET_INFO=positioninfo] [,GET_COLORS=usedcolors] )
;                               
;
; INPUTS: Matrix: Gewichtsmatrix, die dargestellt werden soll, G(Target,Source)
;                 Matrix ist eine vorher mit DelayWeigh definierte Struktur 
; 
; KEYWORD PARAMETERS: TITEL: Titel des Fensters, das die Darstellung
;                            enthalten soll 
;         ZOOM oder GROESSE: Faktor fuer die Vergroesserung der Darstellung oder:
;   X/YZOOM oder X/YGROESSE: Die Faktoren können auch getrennt angegeben werden.
;                   MAXSIZE: Ein zweielementiges Array, das die
;                            maximalen Abmessungen enthält, die ein
;                            von ShowWeights geöffnetes Fenster haben
;                            sollte. (In der Regel sind das
;                            Bildschirmbreite und -höhe). Wird die
;                            Darstellung mit dem angegebenen
;                            Zoomfaktor zu groß, so öffnet Showweights 
;                            automatisch ein Slide-Window.
;                     WINNR: Nr des Fensters, in dem die Darstellung
;                            erfolgen soll (muss natuerlich offen
;                            sein). Ist WinNr gesetzt, sind evtl vorher angegebene
;                            Titel und Groessen,Zoomfaktoren unwirksam (klar,
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
;                    EFFICACY: Falls gesetzt, werden nicht Gewichte oder Delays visualisiert, sondern
;                              die 'synaptic efficacy' 
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
;                  COLORMODE: Mit diesem Schlüsselwort kann unabhängig 
;                             von den Werten im Array die
;                             schwarz/weiss-Darstellung (COLORMODE=+1) 
;                             oder die rot/grün-Darstellung
;                             (COLORMODE=-1) erzwungen werden.
;                 PRINTSTYLE: Wird dieses Schlüsselwort gesetzt, so
;                             wird die gesamte zur Verfügung stehende Farbpalette
;                             für Farbschattierungen benutzt. Die Farben orange
;                             und blau werden NICHT gesetzt.
;                             (gedacht für Ausdruck von schwarzweiss-Zeichnungen.)
;                     SETCOL: Bei SETCOL=1 ändert ShowWeights bei jedem Aufruf
;                             die Farbpalette. Dieses evtl unerwünschte
;                             Verhalten kann man SETCOL=0 unterbunden werden.
;                             Default: SETCOL=1 
;                       SURF: Wenn gesetzt, werden die
;                             rezeptiven/projektiven Felder als
;                             Surface-Plots dargestellt.
;                       GRID: Wenn zusätzlich zu SURF gesetzt, wird
;                             "Surface" statt "Shade_Surf" als
;                             Darstellungsprozedur benutzt.
;                SUPERIMPOSE: Wenn zusätzlich zu SURF gesetzt, wird
;                             die jeweils "andere" Information (also
;                             Delays, wenn Weights dargestellt werden
;                             und umgekehrt) als Farbinformation auf
;                             den Surface-Plot gemapped.
;    weitere Surface-/Shade_Surf-Parameter: insbes. /LEGO, AX, AZ...        
;
; OUTPUTS: Gewichtsmatrix, an die Fenstergroesse angepasst.
;
; OPTIONAL OUTPUTS: separates Fenster, das die Darstellung der Gewichtmatrix enthaelt.
;                   Wird WinNr UND SLIDE angegeben, so wird die Matrix wie gewohnt im angegebenen Fenster dargestellt.
;                       Ein Slide-WIndow wird außerdem geöffnet.
;                   
;                    GET_WIN: Hier wird die Nummer des Fensters zurückgegeben, das 
;                             für die Darstellung verwendet wurde.
;                   GET_BASE: Wird SLIDE angegeben, so kann hier die
;                             ID des erstellten Base-Widgets
;                             zurückgegeben werden, um das Fenster
;                             später mit einem
;                               WIDGET_CONTROL, Base_ID, /DESTROY
;                             schließen zu können.
;                 GET_MAXCOL: ShowWeights benutzt die Farben Blau für 
;                             !NONE-Verbindungen und Orange für das
;                             Liniengitter.
;                             Daher stehen für die Bilddarstellung
;                             nicht mehr alle Farbindizes zur
;                             Verfügung. In GET_MAXCOL kann der
;                             letzte verwendbare Index abgefragt
;                             werden.
;              GET_COLORMODE: Liefert als Ergebnis +1, falls der
;                             schwarz/weiss-Modus zur Darstellung
;                             benutzt wurde (DW-Matrix enthielt nur
;                             positive Werte), und -1, falls der
;                             rot/grün-Modus benutzt wurde (DW-Matrix
;                             enthielt negative Werte).
;              ( GET_COLORS:  Array [black, back, fore, white,used_!TOPCOLOR]
;                             für internen Gebrauch gedacht (TomWaits) )
;              ( GET_INFO:    { x0:xoffset, y0:yoffset, x1:flaechex-xoffset, y1:flaechey-yoffset, $
;                               tvxsize: flaechex, tvysize: flaechey, subxsize:bildxsize, subysize:bildysize}
;                             Koordinaten der
;                             linken unteren und rechten oberen Ecke
;                             des TV-Ausschnits,dessen Größe und die
;                             der Untermatrizen in DEVICE-Koordinaten.
;                             für internen Gebrauch gedacht (TomWaits) )
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
;       Revision 2.29  1999/11/16 15:15:51  alshaikh
;             kann jetzt auch transmitterfreisetzungswahrscheinlichkeiten
;             (U_se) darstellen...
;
;       Revision 2.28  1999/08/18 09:56:25  thiel
;           New keyword: SETCOL to prevent color flickering in multi-sheet-
;           applications.
;
;       Revision 2.27  1998/05/26 13:15:43  kupper
;              1. Die Routinen benutzen die neuen NASE-Colortables
;              2. Noch nicht alle Routinen kannten das !PSGREY. Daher mal wieder
;                 Änderungen an der Postcript-Sheet-Verarbeitung.
;                 Hoffentlich funktioniert alles (war recht kompliziert, wie immer.)
;
;       Revision 2.26  1998/04/16 16:51:23  kupper
;              Keyword PRINTSTYLE implementiert für TomWaits-Print-Output.
;
;       Revision 2.25  1998/04/02 13:21:45  kupper
;              Tippfehler
;
;       Revision 2.24  1998/04/02 11:40:52  kupper
;              Umfangreiche Änderungen an der Darstellung (Achsen, Verwendung von
;       	NASETv, Surface-Plots)
;       	SURF, GRID, SUPERIMPOSE, GET_COLORS, GET_INFO-Schlüselworte hinzugefügt.
;       	Jetzt können gebrochene Zoomfaktoren angegeben werden, auch getrennt
;       	für X und Y. Daher fügen sich Darstellungen nun auch ohne "Ränder" in bestehende
;       	Fenster ein...
;       	Hab hoffentlich nichts vergessen.
;       	Achja: Der Output kann nun (mit /NOWIN) auch in ein aktives Postcript-Sheet
;       		gemacht werden. Allerdings funktionieren hier die SURF-Darstellungen (noch) nicht.
;
;       Revision 2.23  1998/03/22 14:07:59  kupper
;              ?size sind jetzt longs, daher auch sehr grosse fenster moeglich.
;               Scheint aber das Retain nicht mehr zu funktionieren, dann..
;
;       Revision 2.22  1998/03/19 17:11:11  kupper
;              Bet_Base liefert jetzt -1 zurück, falls ein gewöhnliches Fenster geöffnet
;               wurde, so daß man bestimmen kann, wie man es wieder schließen muß
;               (wdelete oder widget_control).
;
;       Revision 2.21  1998/03/19 15:37:15  saam
;             mysteriously a bug occurred: variable containing
;               delays-keyword had the same name as function delays
;               -> renamed
;
;       Revision 2.20  1998/02/27 13:16:29  saam
;             benutzt nun die U-Routinen
;
;       Revision 2.19  1998/02/26 15:45:56  kupper
;              Get-ScreenSize() ersetzt durch Device-Befehl für Kompatibilität zu IDL 4
;
;       Revision 2.18  1998/02/26 14:13:50  saam
;             kleine Aenderung fuer 32-Bit-Display
;             Max-Size noch falsch behandelt
;
;       Revision 2.17  1998/02/26 13:58:49  kupper
;              TV durch UTV ersetzt. Mal sehen...
;
;       Revision 2.16  1998/02/18 13:48:18  kupper
;              Schlüsselworte COLORMODE,GET_COLORMODE,GET_MAXCOL zugefügt.
;
;       Revision 2.15  1998/02/05 14:13:17  saam
;             bug in FROMS (noncritical) corrected
;
;       Revision 2.14  1998/02/05 13:22:39  saam
;             Anpassung an neue DW-Struktur
;
;       Revision 2.13  1998/02/04 17:23:48  kupper
;              Showweights benutzt jetzt brav objektorientiert die Weights(), Delays() und DWDim()-Funktionen.
;              Das MAXSIZE-Schlüsselwort wurde implementiert, weil ich mich immer geärgert habe, daß die Fenster
;               nicht auf meinen Bildschirm passen...
;
;       Revision 2.11  1998/02/03 17:29:15  kupper
;              Statt GROESSE kann nun alternativ ZOOM verwendet werden.
;              GET_WIN-Schlüsselwort zugefügt.
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


PRO ShowWeights, __Matrix, titel=TITEL, winnr=WINNR, $
                 groesse=GROESSE, XGROESSE=xgroesse, YGROESSE=ygroesse, $
                 ZOOM=zoom, XZOOM=xzoom, YZOOM=yzoom, $
                 SLIDE=slide, XVISIBLE=xvisible, YVISIBLE=yvisible, GET_BASE=get_base, $
                 FROMS=froms,  TOS=tos, DELAYS=delay, EFFICACY=efficacy, $
                 PROJECTIVE=projective, RECEPTIVE=receptive, $
                 NOWIN = nowin, GET_WIN=get_win, $
                 GET_MAXCOL=get_maxcol, GET_COLORMODE=get_colormode, COLORMODE=colormode, $
                 SURF=surf, GRID=grid, SUPERIMPOSE=superimpose, $
                 GET_INFO=get_info, GET_COLORS=get_colors, $
                 PRINTSTYLE=printstyle, SETCOL=setcol, $
                 _EXTRA=_extra

   IF !D.Name EQ 'NULL' THEN RETURN

   Default, GROESSE, ZOOM       ;Die Schlüsselworte können alternativ verwendet werden.
   Default, XGROESSE, XZOOM       ;Die Schlüsselworte können alternativ verwendet werden.
   Default, YGROESSE, YZOOM       ;Die Schlüsselworte können alternativ verwendet werden.
   Default, titel, 'Gewichtsmatrix'
   Default, Groesse, 1l
   Default, XGroesse, Groesse
   default, YGroesse, Groesse
   Default, PRINTSTYLE, 0
   Default, setcol, 1
   default, _extra, {title:''}  ;Title wird eh nich benutzt

   If !D.Name ne "PS" then begin
      device, Get_screen_size=MAXSIZE
      xrand = 25
      yrand = 25                ;25 Pixel Rand zum Ursprung des Plots
   endif else begin
      xrand = !D.X_PX_CM*1      ;1 cm Rand zum Ursprung des Plots
      yrand = !D.Y_PX_CM*1
   endelse
   Default, COLORMODE, 0        ;Keine bestimmte Darstellung erzwingen

   Default, FROMS, PROJECTIVE
   Default, TOS, RECEPTIVE

;   IF Keyword_Set(NOWIN) THEN Winnr = !D.Window
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
         IF keyword_set(EFFICACY) THEN $
          settag,Matrix,'U_se', Transpose(Use(__Matrix))

      END ELSE IF info(__Matrix) EQ 'DW_DELAY_WEIGHT' OR info(__Matrix) EQ 'SDW_DELAY_WEIGHT' THEN BEGIN
         Matrix = {Weights : Transpose(Weights(__Matrix)), $
                   Delays : Transpose(Delays(__Matrix)),$
                   source_w: DWDim(__Matrix, /TW), $
                   source_h: DWDim(__Matrix, /TH), $
                   target_w: DWDim(__Matrix, /SW), $
                   target_h: DWDim(__Matrix, /SH)}
         IF keyword_set(EFFICACY) THEN $
          settag,Matrix,'U_se', Transpose(Use(__Matrix))

      END ELSE Message, 'keine gueltige DelayWeigh-Struktur übergeben!'

   ENDIF ELSE begin             ; Source- und Targetlayer NICHT vertauschen:
      
      IF info(__Matrix) EQ 'DW_WEIGHT' OR info(__Matrix) EQ 'SDW_WEIGHT' THEN BEGIN
         Matrix = {Weights : Weights(__Matrix), $
                   source_w: DWDim(__Matrix, /SW), $
                   source_h: DWDim(__Matrix, /SH), $
                   target_w: DWDim(__Matrix, /TW), $
                   target_h: DWDim(__Matrix, /TH)}
 IF keyword_set(EFFICACY) THEN $
          settag,Matrix,'U_se', Transpose(Use(__Matrix))


      END ELSE IF info(__Matrix) EQ 'DW_DELAY_WEIGHT' OR info(__Matrix) EQ 'SDW_DELAY_WEIGHT' THEN BEGIN
         Matrix = {Weights : Weights(__Matrix), $
                   Delays : Delays(__Matrix),$
                   source_w: DWDim(__Matrix, /SW), $
                   source_h: DWDim(__Matrix, /SH), $
                   target_w: DWDim(__Matrix, /TW), $
                   target_h: DWDim(__Matrix, /TH)}
 IF keyword_set(EFFICACY) THEN $
          settag,Matrix,'U_se', Transpose(Use(__Matrix))

      END ELSE Message, 'keine gueltige DelayWeigh-Struktur übergeben!'

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
   
   ;;------------------> Matrix umformen
      IF Keyword_Set(Delay) THEN MatrixMatrix= reform(Matrix.Delays, Matrix.target_h, Matrix.target_w, Matrix.source_h, Matrix.source_w) $
       ELSE IF Keyword_Set(Efficacy) THEN MatrixMatrix= reform(Matrix.U_se, Matrix.target_h, Matrix.target_w, Matrix.source_h, Matrix.source_w) $
      ELSE MatrixMatrix= reform(Matrix.Weights, Matrix.target_h, Matrix.target_w, Matrix.source_h, Matrix.source_w)
        ;;------------------> Farben setzen und Matrix skalieren:
      IF Keyword_Set(SETCOL) THEN BEGIN
         old_topcolor = !TOPCOLOR
         IF NOT KEYWORD_SET(PRINTSTYLE) then begin
            back = RGB("very dark yellow", INDEX=!TOPCOLOR)
            fore = RGB("pale brown", INDEX=!TOPCOLOR-1)
            !TOPCOLOR = !TOPCOLOR-2
         ENDIF
      ENDIF ELSE BEGIN ; Keyword_Set(SETCOL) 
         old_topcolor = !TOPCOLOR
         IF NOT KEYWORD_SET(PRINTSTYLE) then begin
            back = RGB("very dark yellow", INDEX=!TOPCOLOR, /NOALLOC)
            fore = RGB("pale brown", INDEX=!TOPCOLOR-1, /NOALLOC)
            !TOPCOLOR = !TOPCOLOR-2
         ENDIF
      ENDELSE

         
 
      If Keyword_Set(SURF) then begin
         If keyword_set(SUPERIMPOSE) then begin
            IF Keyword_Set(Delay) THEN begin
               OtherOther= reform(Matrix.Weights, Matrix.target_h, Matrix.target_w, Matrix.source_h, Matrix.source_w)
               END ELSE IF Keyword_Set(Efficacy) THEN BEGIN
                  OtherOther= reform(Matrix.U_se, Matrix.target_h, Matrix.target_w, Matrix.source_h, Matrix.source_w)
            end ELSE begin
               OtherOther= reform(Matrix.Delays, Matrix.target_h, Matrix.target_w, Matrix.source_h, Matrix.source_w)
            endelse
            OtherOther = ShowWeights_Scale(OtherOther, SETCOL=setcol, COLORMODE=COLORMODE, GET_COLORMODE=GET_COLORMODE, GET_MAXCOL=white, PRINTSTYLE=printstyle)
         endif else begin 
            dummy = ShowWeights_Scale(0, SETCOL=setcol, COLORMODE=+1, GET_COLORMODE=GET_COLORMODE, GET_MAXCOL=white, PRINTSTYLE=PRINTSTYLE) ;Grautabelle laden
            nones = where(MatrixMatrix eq !NONE, count)
            If count ne 0 then MatrixMatrix(nones) = +999999 ;Weil ILD3.6 bei Plots nur MAX_Value kennt und kein MIN_Value
         endelse
      endif else MatrixMatrix = ShowWeights_Scale(MatrixMatrix, SETCOL=setcol, COLORMODE=COLORMODE, GET_MAXCOL=white, GET_COLORMODE=GET_COLORMODE, PRINTSTYLE=PRINTSTYLE)
;   erase, RGB('orange',/NOALLOC) ;GET_MAXCOL+2

      black = !P.Background
      GET_MAXCOL = white
      If Keyword_Set(PRINTSTYLE) then begin
         orange = 0             ;black
         fore = 0               ;black
         back = white/2         ;!D.Table_Size-1
         !TOPCOLOR = !D.Table_Size-1
      endif else orange = RGB('orange',/NOALLOC)
      GET_COLORS = [black, back, fore, white, !TOPCOLOR]
      !TOPCOLOR = old_TOPCOLOR

      ;;--------------------------------
      ;;--------------------------------


If Set(WinNr) then WSet, WinNr
If Set(WinNr) or keyword_Set(NOWIN) then Begin 
      XGroesse = (!D.X_Size-Matrix.source_w-2*xrand)/float(Matrix.target_W*(Matrix.source_W+1))
      YGroesse = (!D.Y_Size-Matrix.source_h-2*yrand)/float(Matrix.target_H*(Matrix.source_H+1))
EndIf    

   bildxsize = (1+Matrix.target_w*xGroesse) ;Groesse einer Untermatrix
   bildysize = (1+Matrix.target_h*yGroesse)
   xoffset = bildxsize/2+xrand
   yoffset = bildysize/2+yrand
 
   ;;------------------> Benötigte Zeichenfläche:
   flaechex = bildxsize*Matrix.source_w + 2*xoffset
   flaechey = bildysize*Matrix.source_h + 2*yoffset
   GET_INFO = { SHOWWEIGHTS_INFO, $
                x0:long(xoffset), y0:long(yoffset), x1:long(flaechex-xoffset), y1:long(flaechey-yoffset), $
                x00:long(xoffset), y00:long(yoffset), $
                tvxsize: long(flaechex), tvysize: long(flaechey), subxsize:long(bildxsize), subysize:long(bildysize)}
   ;;--------------------------------
   ;;------------------> Auto-Slide ?
   If !D.Name ne "PS" and (not keyword_set(SLIDE)) then begin ;Eventuell doch ein SLIDE Fenster öffnen
      XS=flaechex
      YS=flaechey
      If (XS+8 gt MAXSIZE(0)) or (YS+20 gt MAXSIZE(1)) then begin ;Fensterränder+Schieber ca. 20, 55 Pixel...
         ;;Window would not fit an Screen - so make it a SLIDE-Window
         SLIDE = 2
         XVISIBLE = XS < (MAXSIZE(0)-40)
         YVISIBLE = YS < (MAXSIZE(1)-58) ;Fensterränder ca 8, 20 Pixel
      Endif
   Endif
   ;;--------------------------------


   ;;------------------> Fenster öffnen:
   Default, xvisible, 256
   Default, yvisible, 256
   
   If (Not Set(WINNR)) and (not Keyword_Set(NOWIN)) Then Begin
      If keyword_set(SLIDE) then begin
         case SLIDE of 1: Window, /PIXMAP, /FREE , XSize=flaechex, YSize=flaechey, Title=titel
            else: GET_WIN = Scrollit (XDRAWSIZE=flaechex, YDRAWSIZE=flaechey, $
                                      XSIZE=xvisible, YSIZE=yvisible, TITLE=titel, GET_BASE=get_base, $
                                      XPOS=0, YPOS=0)
         endcase
      endif else begin
         Window, /FREE , XSize=flaechex, YSize=flaechey, Title=titel
      endelse
   Endif
   ;;--------------------------------



   ;;------------------> Koordinatensystem malen:
   PrepareNASEPlot, Matrix.source_h, Matrix.source_w, /OFFSET, GET_OLD=oldplot
   !x.Ticklen = 0.02
   !y.ticklen = 0.02            ;Damit da nichts schiefgeht
   !x.gridstyle = 0
   !y.gridstyle = 0
   !x.thick = 2
   !y.thick = 2
   Plot, indgen(1), /NODATA, POSITION=[xoffset-bildxsize/2, yoffset-bildysize/2, flaechex-xoffset+bildxsize/2, flaechey-yoffset+bildysize/2], /DEVICE, color=fore;rgb("orange", /NOALLOC)
   PrepareNASEPlot, RESTORE_OLD=oldplot
   ;;--------------------------------

   ;;------------------> Bild malen:
   If Keyword_Set(SURF) then begin
      oldP = !P
      !P.Background = back      ;von nun an dunkelgelber Hintergrund     
      !P.Multi = 0
      !P.Position = [0, 0, 0, 0] ;Damit da nichts schiefgeht
      !P.Region = [0, 0, 0, 0]
      !P.T3d = 0

      nonone = where(MatrixMatrix ne !NONE, count)
      If count ne 0 then begin
         zmax = max(MatrixMatrix(nonone))
         zmin = min(MatrixMatrix(nonone))
      endif else begin
         zmax = max(MatrixMatrix)
         zmin = min(MatrixMatrix)
      endelse
      If zmin ge 0 then zmin = 0 else begin
         maxmax = max([zmax, -zmin])
         zmax = maxmax
         zmin = -maxmax
      endelse
      weightwin = !D.window
      window, /free, xsize=bildxsize, ysize=bildysize, /PIXMAP
      pixwin = !D.window
      for YY= Matrix.source_h-1, 0, -1 do begin
         for XX= 0, Matrix.source_w-1 do begin  
            If Keyword_Set(GRID) then surfproc = "SURFACE" else surfproc = "SHADE_SURF"
            wset, pixwin
            If Keyword_Set(SUPERIMPOSE) then Call_Procedure, surfproc, COLOR=white, SHADES=rotate(OtherOther(*, *, YY, XX), 3), rotate(MatrixMatrix(*, *, YY, XX), 3), MAX_VALUE=999998, xstyle=5, ystyle=5, zstyle=5, ZRANGE=[zmin, zmax], XMARGIN=[0, 0], YMARGIN=[0, 0], _EXTRA=_extra $
            else Call_Procedure, surfproc, COLOR=white, rotate(MatrixMatrix(*, *, YY, XX), 3), MAX_VALUE=999998, xstyle=5, ystyle=5, zstyle=5, ZRANGE=[zmin, zmax], XMARGIN=[0, 0], YMARGIN=[0, 0], _EXTRA=_extra
            Wset, weightwin
            DEVICE, COPY=[0, 0, bildxsize, bildysize, xoffset+XX*bildxsize, yoffset+(Matrix.source_h-YY-1)*bildysize, pixwin]
         end
      end
      wdelete, pixwin
      !P = OldP
   endif else begin
      for YY= 0, Matrix.source_h-1 do begin
         for XX= 0, Matrix.source_w-1 do begin  
;            utv, rebin( /sample, $
;                        transpose(MatrixMatrix(*, *, YY, XX)), $
;                        xGroesse*Matrix.target_w,  yGroesse*Matrix.target_h), $
;             /Order, /DEVICE, $
;             XX*(1+Matrix.target_w*xGroesse), (Matrix.source_h-1-YY)*(1+Matrix.target_h*yGroesse)
            NaseTv, MatrixMatrix(*, *, YY, XX), $
             h_stretch=xGroesse,  v_stretch=yGroesse, $
             /DEVICE, XSIZE=bildxsize, YSIZE=bildysize, $
             xoffset+XX*(1+Matrix.target_w*xGroesse), yoffset+(Matrix.source_h-1-YY)*(1+Matrix.target_h*yGroesse)
         end
      end
   endelse
   for XX= 0, Matrix.source_w do begin  
      PLOTS, COLOR=orange, /DEVICE, xoffset+[XX*bildxsize-1, XX*bildxsize-1], yoffset+[0, bildysize*Matrix.source_h-1]
   end
   for YY= 0, Matrix.source_h do begin
      PLOTS, COLOR=orange, /DEVICE, xoffset+[0, bildxsize*Matrix.source_w-1], yoffset+[YY*bildysize-1, YY*bildysize-1]
   end
   ;;--------------------------------


   If Keyword_Set(SLIDE) then begin
      if (SLIDE eq 1) then begin
         Image = TVRd()
         If not set(WINNR) then wdelete
         
         ;; Ein zweifenstriges IDL-Slide-Window:
         Slide_Image, Image, $
          XSIZE=(XGroesse*Matrix.target_w +1)*Matrix.source_w, YSIZE=(YGroesse*Matrix.target_h +1)*Matrix.source_h, $
          XVISIBLE=xvisible, YVISIBLE=yvisible, $
          Title=titel, TOP_ID=Base, SLIDE_WINDOW=GET_WIN ;Fensternummer zurückliefern
         Default, get_base, Base ;Base-ID-zurückgeben, falls ein Widget mit SLIDE erstellt wurde.
      endif
   endif


;   Handle_Value, __Matrix, _Matrix, /NO_COPY, /SET

   ;;------------------> Fensternummer zurückliefern:
   If not keyword_set(SLIDE) then begin
      GET_WIN = !D.Window 
      GET_BASE = -1
   EndIf
   ;;--------------------------------

END        
        





