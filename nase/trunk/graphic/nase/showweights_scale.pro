;+
; NAME: ShowWeights_Scale()
;
; PURPOSE: Wurde aus ShowWeights ausgelagert.
;          Ein Array wird so skaliert, daß es mit TV ausgegeben werden 
;          kann und dann aussieht wie bei ShowWeights.
;          Optional kann auch die Farbtabelle entsprechend gesetzt werden.
;
; CATEGORY: Grafik
;
; CALLING SEQUENCE: TV_Array = ShowWeights_Scale( Array [,SETCOL={1|2}] ,[/PRINTSTYLE]
;                                                       [,COLORMODE=mode]
;                                                       [,RANGE_IN=upper_boundary]
;                                                       [,GET_COLORMODE={+1|-1}]
;
;                                                       [,GET_MAXCOL=Farbindex]
;                                                       [,GET_RANGE_IN =scaling_boundaries_in ]
;                                                       [,GET_RANGE_OUT=scaling_boundaries_out])
;
; INPUTS: Array: Ein (nicht notwendigerweise, aber wohl meist)
;                NASE-Array. (D.h. es darf auch !NONE-Werte
;                enthalten..., ganz positiv oder positiv/negativ sein.)
;
; KEYWORD PARAMETERS: SETCOL: Wird dieses Schlüsselwort auf 1 gesetzt, so
;                             initialisiert die Routine auch die
;                             Farbtabelle und paßt die Werte von 
;                             !P.Background und Set_Shading
;                             entsprechend an.
;                             (Graustufen für positive Arrays,
;                             Rot/Grün für gemischtwertige.)
;
;                             Wird dieses Schlüsselwort auf 2
;                             gesetzt, so initialisiert die
;                             Routine NUR die Farbtabelle und
;                             paßt die Werte von !P.Background
;                             und Set_Shading entsprechend
;                             an. Das Array wird NICHT
;                             skaliert. Der Rückgabewert ist in
;                             diesem Fall 0.
;
;                             Hat nur Effekt, wenn /NASE oder
;                             /NEUTRAL angegeben wurde.
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
;                   RANGE_IN: The positive scalar value given in RANGE_IN
;                             will be scaled to the maximum
;                             color (white / full green). Note
;                             that this exact value does not
;                             have to be contained in the array.
;                             If the array contains values
;                             greater than RANGE_IN, the result
;                             will contain invalid color
;                             indices.
;                             By default, this value will be
;                             determined from the arrays
;                             contents such as to span the whole 
;                             available color range.
;
; OUTPUTS: TV_Array: Das geeignet skalierte Array, das direkt mit TV
;                    oder NASETV dargestellt werden kann.
;
; OPTIONAL OUTPUTS: GET_MAXCOL: ShowWeights benutzt die Farben Blau für 
;                               !NONE-Verbindungen und Orange für das
;                               Liniengitter.
;                               Daher stehen für die Bilddarstellung
;                               nicht mehr alle Farbindizes zur
;                               Verfügung. In GET_MAXCOL kann der
;                               letzte verwendbare Index abgefragt werden.
;                GET_COLORMODE: Liefert als Ergebnis +1, falls der
;                               schwarz/weiss-Modus zur Darstellung
;                               benutzt wurde (DW-Matrix enthielt nur
;                               positive Werte), und -1, falls der
;                               rot/grün-Modus benutzt wurde (DW-Matrix
;                               enthielt negative Werte).
;                GET_RANGE_IN,
;                GET_RANGE_OUT: Diese Werte können direkt an den 
;                               Befehl <A HREF="../../misc/arrays/#SCL">Scl</A> weitergereicht
;                               werden, um weitere Arrays so zu
;                               skalieren, daß deren Farbwerte
;                               direkt vergleichbar sind
;                               (d.h. ein Wert w eines so
;                               skalierten Arrays wird auf den
;                               gleichen Farbindex abgebildet,
;                               wie ein Wert w, der im
;                               Originalarray enthalten war).
;
;                Zur Information: Es gelten die Beziehungen
;
;                     GET_RANGE_IN  = [0, Range_In  ], falls Range_In angegeben wurde,
;                                   = [0, max(Array)]  sonst.
;
;                     GET_RANGE_OUT = [0, GET_MAXCOL]
;
; SIDE EFFECTS: Gegebenenfalls wird Farbtabelle geändert.
;        	    Außerdem setzt es !P.BACKGROUND stets auf den Farbindex für schwarz
;               und initialisiert SET_SHADING geeignet, damit folgende Surface-Plots nicht
;               seltsam aussehen.
;
; PROCEDURE: Aus Showweights, Rev. 2.15 ausgelagert.
;
; EXAMPLE: 1. NASETV, ShowWeights_Scale( GetWeight( MyDW, T_INDEX=0 ), /SETCOL ), ZOOM=10
;          2. Window, /FREE, TITLE="Membranpotential"
;             LayerData, MyLayer, POTENTIAL=M
;             NASETV, ShowWeights_Scale( M, /SETCOL), ZOOM=10
;          3. a = gauss_2d(100,100)
;             WINDOW, 0
;             NASETV, ShowWeights_Scale( a, /SETCOL, $
;                                        GET_RANGE_IN=ri, GET_RANGE_OUT=ro )
;             WINDOW, 1
;             NASETV, Scl( 0.5*a, ro, ri )
;            Die Werte der Arrays in den beiden Fenstern können 
;            nun direkt verglichen werden.
;            Der letzte Befehl ist übrigens identisch mit
;             NASETV, ShowWeights_Scale( 0.5*a, RANGE_IN=ri(1) )
;
; SEE ALSO: <A HREF="#SHOWWEIGHTS">ShowWeights()</A>
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 2.18  2000/04/04 12:57:46  saam
;              fixed 2 bugs concerning changes of color
;              management with true color displays and
;              the decomposed method
;
;        Revision 2.17  1999/11/12 16:56:33  kupper
;        Oops! Corrected some errors...
;
;        Revision 2.16  1999/11/12 16:39:35  kupper
;        Updated Docu.
;        Added SETCOL=2 - Mode.
;
;        Revision 2.15  1999/09/23 14:15:20  kupper
;        Range_In=0 is now interpreted as not set, not as literal 0 as
;        before.
;        Removed false "Range=ABS(Range)".
;
;        Revision 2.14  1999/09/23 08:21:00  kupper
;        Added some lines to docu.
;
;        Revision 2.13  1999/09/22 16:49:51  kupper
;        Implemented Keywords RANGE_IN, GET_RANGE_IN and GET_RANGE_OUT.
;
;        Revision 2.12  1999/09/22 09:55:44  kupper
;        Added a "Temporary" here and there to save memory.
;
;        Revision 2.11  1998/06/12 14:04:00  saam
;              path for nase color tables had changed
;
;        Revision 2.10  1998/05/26 13:15:43  kupper
;               1. Die Routinen benutzen die neuen NASE-Colortables
;               2. Noch nicht alle Routinen kannten das !PSGREY. Daher mal wieder
;                  Änderungen an der Postcript-Sheet-Verarbeitung.
;                  Hoffentlich funktioniert alles (war recht kompliziert, wie immer.)
;
;        Revision 2.9  1998/05/21 17:57:37  kupper
;               ...noch immer...
;
;        Revision 2.8  1998/05/21 17:34:03  kupper
;               Test wegen PS-Bug.
;
;        Revision 2.7  1998/05/19 12:38:01  kupper
;               Hoffentlich noch alles heil nach einem CVS-Konflikt.
;                Glaube, ich hatte das PRINTSTYLE-Keyword implementiert,
;                und Mirko eine Änderung am !P.BACKGROUND gemacht.
;
;        Revision 2.6  1998/05/18 19:46:42  saam
;              minor problem with colortable on true color displays fixed
;
;        Revision 2.5  1998/04/16 16:51:24  kupper
;               Keyword PRINTSTYLE implementiert für TomWaits-Print-Output.
;
;        Revision 2.4  1998/02/27 13:09:03  saam
;              benutzt nun UTvLCT
;
;        Revision 2.3  1998/02/26 17:28:54  kupper
;               Benutzt jetzt die neue !TOPCOLOR-Systemvariable.
;        	Außerdem setzt es die !P.BACKGROUND stets auf den Farbindex für schwarz
;        	und initialisiert SET_SHADING geeignet, damit folgende Surface-Plots nicht
;                seltsam aussehen.
;
;        Revision 2.2  1998/02/18 13:48:18  kupper
;               Schlüsselworte COLORMODE,GET_COLORMODE,GET_MAXCOL zugefügt.
;
;        Revision 2.1  1998/02/11 15:36:32  kupper
;               Schöpfung durch Auslagern.
;
;-

Function ShowWeights_Scale, Matrix, SETCOL=setcol, GET_MAXCOL=get_maxcol, $
                    COLORMODE=colormode, GET_COLORMODE=get_colormode, $
                    PRINTSTYLE=printstyle, $
                    RANGE_IN=range_in, $
                    GET_RANGE_IN=get_range_in, GET_RANGE_OUT=get_range_out


   Default, SETCOL, 0

   
   If not Keyword_set(PRINTSTYLE) then begin
      ts = !TOPCOLOR+1          ;ehemals !D.Table_Size
      GET_MAXCOL = ts-3
   endif else begin
      ts = !D.Table_Size
      GET_MAXCOL = ts-1
   endelse


   ;;------------------> Make local copy and wipe out !NONEs
   MatrixMatrix = NoNone_Func( Matrix, NONES=no_connections, COUNT=count )
   ;;Named MatrixMatrix for historical reasons...
   ;;--------------------------------
   
   min = min(MatrixMatrix)
   max = max(MatrixMatrix)
   
   ;;------------------> The Range value will be scaled to white/green:
   If Keyword_Set(Range_In) then Range = Range_In ;Range_In should not be changed.
                                ;cannot use "Default", by the way,
                                ;as Range_In=0 should be
                                ;interpreted as not set (not as
                                ;literal 0)
   Default, Range, max([max, -min]) ; for positive Arrays this equals max.
   If N_Elements(Range) gt 1 then begin ;was a 2-Element Array supplied?
      message, /INFO, "Lower Range_In boundary is always 0 for NASE scaling. Ignored supplied value."
      Range = Range(1)
   End
   ;;--------------------------------
   
   ;;------------------> Optional Outputs
   GET_RANGE_IN  = [0, Range]
   GET_RANGE_OUT = [0, GET_MAXCOL]
   ;;--------------------------------
   
   if min eq 0 and max eq 0 then max = 1 ; Falls Array nur Nullen enthält!
   
   




   If not Keyword_Set(COLORMODE) then $
    If min ge 0 then COLORMODE = 1 else COLORMODE = -1



   if COLORMODE eq 1 then begin       ;positives Array

      GET_COLORMODE = 1
      If Keyword_Set(SETCOL) then begin
;         g = indgen(GET_MAXCOL+1)/double(GET_MAXCOL)*255;1
         If !D.NAME eq "PS" then begin
;            If not Keyword_Set(PRINTSTYLE) then begin
;             ; utvlct, GET_MAXCOL-g, GET_MAXCOL-g, GET_MAXCOL-g
;               uloadct, FILE=GetEnv("NASEPATH")+"/graphic/NaseColors.tbl", 3, NCOLORS=GET_MAXCOL+1
;               !REVERTPSCOLORS = 1 ;0
;            endif else begin
             ;  utvlct, g, g, g
            If !PSGREY then begin
               !REVERTPSCOLORS = 1 
               !P.Background = !D.n_colors-1 ;weiss
            endif else begin
                                ;umgedrehte Graupalette laden:
               uloadct, FILE=GetEnv("NASEPATH")+"/graphic/nase/NaseColors.tbl", !NASETABLE.PAPER_POS,NCOLORS=GET_MAXCOL+1
               !REVERTPSCOLORS = 0
               !P.BACKGROUND = 0 ;weiss
            endelse
;            endelse
         endif else uloadct, FILE=GetEnv("NASEPATH")+"/graphic/nase/NaseColors.tbl", !NASETABLE.POS,NCOLORS=GET_MAXCOL+1;utvlct, g, g, g ;Grauwerte
         IF (!D.NAME eq "X") THEN !P.BACKGROUND = 0 ;Index für Schwarz
         Set_Shading, VALUES=[0, GET_MAXCOL] ;verbleibende Werte für Shading
      Endif
      
      If (SETCOL lt 2) then MatrixMatrix = Temporary(MatrixMatrix)/double(Range)*GET_MAXCOL

   endif else begin             ;pos/neg Array

      GET_COLORMODE = -1
      If Keyword_Set(SETCOL) then begin
;         g = ((2*indgen(GET_MAXCOL+1)-GET_MAXCOL) > 0)/double(GET_MAXCOL)*255
         If !D.Name eq "PS" then begin ;helle Farbpalette
            uloadct, FILE=GetEnv("NASEPATH")+"/graphic/nase/NaseColors.tbl", !NASETABLE.PAPER_NEGPOS,NCOLORS=GET_MAXCOL+1 ;utvlct, 255-g, 255-rotate(g,2), 255-(g+rotate(g,2)) ;Rot-Grün
            !REVERTPSCOLORS = 0
            !P.BACKGROUND = GET_MAXCOL/2 ;weiss
         endif else begin       ;dunkle Farbpalette
            uloadct, FILE=GetEnv("NASEPATH")+"/graphic/nase/NaseColors.tbl", !NASETABLE.NEGPOS,NCOLORS=GET_MAXCOL+1;utvlct, rotate(g, 2), g, bytarr(ts) ;Rot-Grün
         endelse
         IF (!D.NAME eq "X") THEN !P.BACKGROUND = GET_MAXCOL/2  ;Index für Schwarz 
         Set_Shading, VALUES=[GET_MAXCOL/2, GET_MAXCOL] ;Grüne Werte für Shading nehmen
      EndIf

      If (SETCOL lt 2) then begin
         MatrixMatrix = Temporary(MatrixMatrix)/2.0/double(Range)
         MatrixMatrix = (Temporary(MatrixMatrix)+0.5)*GET_MAXCOL
      EndIf

   endelse



   If not keyword_set(PRINTSTYLE) then begin
      IF count NE 0 THEN MatrixMatrix(no_connections) = ts-2 ;Das sei der Index für nichtexistente Verbindungen
      If Keyword_Set(SETCOL) then begin
         SetColorIndex, ts-2, 0, 0, 100 ;Blau sei die Farbe für nichtexistente Verbindungen
         SetColorIndex, ts-1, 255, 100, 0 ;Orange die für die Trennlinien
      Endif
   EndIf

   If (SETCOL lt 2) then Return, MatrixMatrix else Return, 0
End
