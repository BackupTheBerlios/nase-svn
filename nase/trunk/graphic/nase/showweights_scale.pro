;+
; NAME: ShowWeights_Scale()
;
; AIM: Scale array to be plotted using one of the predefined NASE
;      color tables.
;
; PURPOSE: Wurde aus ShowWeights ausgelagert.
;          Ein Array wird so skaliert, da� es mit TV ausgegeben werden 
;          kann und dann aussieht wie bei ShowWeights.
;          Optional kann auch die Farbtabelle entsprechend gesetzt werden.
;
; CATEGORY: Graphic
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
; KEYWORD PARAMETERS: SETCOL: Wird dieses Schl�sselwort auf 1 gesetzt, so
;                             initialisiert die Routine auch die
;                             Farbtabelle und pa�t die Werte von 
;                             !P.Background und Set_Shading
;                             entsprechend an.
;                             (Graustufen f�r positive Arrays,
;                             Rot/Gr�n f�r gemischtwertige.)
;
;                             Wird dieses Schl�sselwort auf 2
;                             gesetzt, so initialisiert die
;                             Routine NUR die Farbtabelle und
;                             pa�t die Werte von !P.Background
;                             und Set_Shading entsprechend
;                             an. Das Array wird NICHT
;                             skaliert. Der R�ckgabewert ist in
;                             diesem Fall 0.
;
;                             Hat nur Effekt, wenn /NASE oder
;                             /NEUTRAL angegeben wurde.
;                  COLORMODE: Mit diesem Schl�sselwort kann unabh�ngig 
;                             von den Werten im Array die
;                             schwarz/weiss-Darstellung (COLORMODE=+1) 
;                             oder die rot/gr�n-Darstellung
;                             (COLORMODE=-1) erzwungen werden.
;                 PRINTSTYLE: Wird dieses Schl�sselwort gesetzt, so
;                             wird die gesamte zur Verf�gung stehende Farbpalette
;                             f�r Farbschattierungen benutzt. Die Farben orange
;                             und blau werden NICHT gesetzt.
;                             (gedacht f�r Ausdruck von schwarzweiss-Zeichnungen.)
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
; OPTIONAL OUTPUTS: GET_MAXCOL: ShowWeights benutzt die Farben Blau f�r 
;                               !NONE-Verbindungen und Orange f�r das
;                               Liniengitter.
;                               Daher stehen f�r die Bilddarstellung
;                               nicht mehr alle Farbindizes zur
;                               Verf�gung. In GET_MAXCOL kann der
;                               letzte verwendbare Index abgefragt werden.
;                GET_COLORMODE: Liefert als Ergebnis +1, falls der
;                               schwarz/weiss-Modus zur Darstellung
;                               benutzt wurde (DW-Matrix enthielt nur
;                               positive Werte), und -1, falls der
;                               rot/gr�n-Modus benutzt wurde (DW-Matrix
;                               enthielt negative Werte).
;                GET_RANGE_IN,
;                GET_RANGE_OUT: Diese Werte k�nnen direkt an den 
;                               Befehl <A HREF="../../misc/arrays/#SCL">Scl</A> weitergereicht
;                               werden, um weitere Arrays so zu
;                               skalieren, da� deren Farbwerte
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
; SIDE EFFECTS: Gegebenenfalls wird Farbtabelle ge�ndert.
;        	    Au�erdem setzt es !P.BACKGROUND stets auf den Farbindex f�r schwarz
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
;            Die Werte der Arrays in den beiden Fenstern k�nnen 
;            nun direkt verglichen werden.
;            Der letzte Befehl ist �brigens identisch mit
;             NASETV, ShowWeights_Scale( 0.5*a, RANGE_IN=ri(1) )
;
; SEE ALSO: <A HREF="#SHOWWEIGHTS">ShowWeights()</A>
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 2.22  2001/01/22 19:31:51  kupper
;        Removed !PSGREY and !REVERTPSCOLORS handling, as greyscale PostScripts
;        shall not be used any longer (according to colormanagement guidelines
;        formed during first NASE workshop, fall 2000).
;
;        Revision 2.21  2001/01/22 14:04:26  kupper
;        Changed color management to meet guidelines formed during the first
;        NASE workshop, fall 2000.
;        Pre-Checkin due to technical reasons. Headers not yet englishified...
;
;        Revision 2.20  2000/10/01 14:51:09  kupper
;        Added AIM: entries in document header. First NASE workshop rules!
;
;        Revision 2.19  2000/08/31 10:23:27  kupper
;        Changed to use ScreenDevice() instead of 'X' in Set_Plot for platform independency.
;
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
;                  �nderungen an der Postcript-Sheet-Verarbeitung.
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
;                und Mirko eine �nderung am !P.BACKGROUND gemacht.
;
;        Revision 2.6  1998/05/18 19:46:42  saam
;              minor problem with colortable on true color displays fixed
;
;        Revision 2.5  1998/04/16 16:51:24  kupper
;               Keyword PRINTSTYLE implementiert f�r TomWaits-Print-Output.
;
;        Revision 2.4  1998/02/27 13:09:03  saam
;              benutzt nun UTvLCT
;
;        Revision 2.3  1998/02/26 17:28:54  kupper
;               Benutzt jetzt die neue !TOPCOLOR-Systemvariable.
;        	Au�erdem setzt es die !P.BACKGROUND stets auf den Farbindex f�r schwarz
;        	und initialisiert SET_SHADING geeignet, damit folgende Surface-Plots nicht
;                seltsam aussehen.
;
;        Revision 2.2  1998/02/18 13:48:18  kupper
;               Schl�sselworte COLORMODE,GET_COLORMODE,GET_MAXCOL zugef�gt.
;
;        Revision 2.1  1998/02/11 15:36:32  kupper
;               Sch�pfung durch Auslagern.
;
;-

Function ShowWeights_Scale, Matrix, SETCOL=setcol, GET_MAXCOL=get_maxcol, $
                            COLORMODE=colormode, GET_COLORMODE=get_colormode, $
                            PRINTSTYLE=printstyle, $
                            RANGE_IN=range_in, $
                            GET_RANGE_IN=get_range_in, GET_RANGE_OUT=get_range_out


   Default, SETCOL, 0

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
   GET_MAXCOL = !TOPCOLOR       ;since the revised NASE color
                                ;management (see proceedings of the
                                ;first NASE workshop 2000)
   GET_RANGE_IN  = [0, Range]
   GET_RANGE_OUT = [0, !TOPCOLOR]
   ;;--------------------------------
   
   if min eq 0 and max eq 0 then max = 1 ; Falls Array nur Nullen enth�lt!
   



   If not Keyword_Set(COLORMODE) then $
    If min ge 0 then COLORMODE = 1 else COLORMODE = -1



   if COLORMODE eq 1 then begin ;positives Array

      GET_COLORMODE = 1
      If Keyword_Set(SETCOL) then begin
         If !D.NAME eq "PS" then begin
            ;;umgedrehte Graupalette laden:
            uloadct, FILE=GetEnv("NASEPATH")+"/graphic/nase/NaseColors.tbl", !NASETABLE.PAPER_POS
         endif else uloadct, FILE=GetEnv("NASEPATH")+"/graphic/nase/NaseColors.tbl", !NASETABLE.POS ;utvlct, g, g, g ;Grauwerte
      Endif
      
      If (SETCOL lt 2) then Scl, MatrixMatrix, [0, !TOPCOLOR], [0, Range]

   endif else begin             ;pos/neg Array

      GET_COLORMODE = -1
      If Keyword_Set(SETCOL) then begin
         If !D.Name eq "PS" then begin ;helle Farbpalette
            uloadct, FILE=GetEnv("NASEPATH")+"/graphic/nase/NaseColors.tbl", !NASETABLE.PAPER_NEGPOS
         endif else begin       ;dunkle Farbpalette
            uloadct, FILE=GetEnv("NASEPATH")+"/graphic/nase/NaseColors.tbl", !NASETABLE.NEGPOS
         endelse
         Set_Shading, VALUES=[!TOPCOLOR/2, !TOPCOLOR] ;Gr�ne Werte f�r Shading nehmen
      EndIf

      If (SETCOL lt 2) then Scl, MatrixMatrix, [0, !TOPCOLOR], [-Range, Range]

   endelse



   If not keyword_set(PRINTSTYLE) then begin
      If Keyword_Set(SETCOL) then $
       noneindex = rgb("none") else $ ;;allocate a free index
       noneindex = rgb("none", /Noalloc) ;;get the best match
      IF count NE 0 THEN MatrixMatrix(no_connections) = noneindex
   EndIf

   If (SETCOL lt 2) then Return, MatrixMatrix else Return, 0
End
