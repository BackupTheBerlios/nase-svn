;+
; NAME: ShowWeights_Scale()
;
; AIM: Scale array to be plotted using one of the predefined NASE
;      color tables.
;
; PURPOSE: Wurde aus ShowWeights ausgelagert.
;          Ein Array wird so skaliert, daß es mit <A>UTv</A> ausgegeben werden 
;          kann und dann aussieht wie bei ShowWeights.
;          Alle Array-Einträge werden durch die entsprechenden
;          Farbindizes ersetzt. (Ausnahme: Der Wert !NONE wird
;          unverändert durchgeschleift. !NONE wird von <A>UTv</A>
;          durch den speziellen Farbindex ersetzt.)<BR>
;          Optional kann auch die Farbtabelle entsprechend gesetzt werden.
;
; CATEGORY:
;  Array
;  Color
;  Connections
;  Graphic
;  Image
;  NASE
;
; CALLING SEQUENCE:
;*  UTv_Array = ShowWeights_Scale( Array [,SETCOL={1|2}] ,[/PRINTSTYLE]
;*                                [,COLORMODE=mode]
;*                                [,RANGE_IN=upper_boundary]
;*                                [,GET_COLORMODE={+1|-1}]
;*                                <I>obsolete: </I>[,GET_MAXCOL=Farbindex]
;*                                [,GET_RANGE_IN =scaling_boundaries_in ]
;*                                <I>obsolete: </I>[,GET_RANGE_OUT=scaling_boundaries_out])
;
; INPUTS: Array:: Ein (nicht notwendigerweise, aber wohl meist)
;                NASE-Array. (D.h. es darf auch <*>!NONE</*>-Werte
;                enthalten..., ganz positiv oder positiv/negativ sein.)
;
; INPUT KEYWORDS:
;  SETCOL:: Wird dieses Schlüsselwort auf <*>1</*> gesetzt, so initialisiert
;           die Routine auch die Farbtabelle und paßt die Werte von
;           <*>!P.Background</*> und <C>Set_Shading</C> entsprechend an. (Graustufen
;           für positive Arrays, Rot/Grün für gemischtwertige.)<BR>
;<BR>
;           Wird dieses Schlüsselwort auf <*>2</*> gesetzt, so initialisiert
;           die Routine NUR die Farbtabelle und paßt die Werte von
;           <*>!P.Background</*> und <C>Set_Shading</C> entsprechend an. Das Array
;           wird NICHT skaliert. Der Rückgabewert ist in diesem Fall
;           <*>0</*>.<BR>
;
;  COLORMODE:: Mit diesem Schlüsselwort kann unabhängig von den Werten
;              im Array die schwarz/weiss-Darstellung (<C>COLORMODE</C><*>=+1</*>)
;              oder die rot/grün-Darstellung (<C>COLORMODE</C><*>=-1</*>) erzwungen
;              werden.
;
;  PRINTSTYLE:: Wird dieses Schlüsselwort gesetzt, so wird die gesamte
;               zur Verfügung stehende Farbpalette für
;               Farbschattierungen benutzt. Die Farben orange und blau
;               werden NICHT gesetzt. (gedacht für Ausdruck von
;               schwarzweiss-Zeichnungen.)
;
;  RANGE_IN:: The <I>positive scalar value</I> given in <C>RANGE_IN</C> will be
;             scaled to the maximum color (white / full green). Note
;             that this exact value does not have to be contained in
;             the array. If the array contains values greater than
;             <C>RANGE_IN</C>, the result will contain invalid color
;             indices.<BR>
;             By default, this value will be determined from the
;             arrays contents such as to span the whole available
;             color range.<BR>
;             Please note that this expects a scalar value, in
;             contrary to the <C>RANGE_IN</C> keywords in other
;             routines like <A>UTvScl</A> or <A>PlotTvScl</A>.
;
; OUTPUTS:
;  TV_Array:: Das geeignet skalierte Array, das direkt mit
;             <A>UTV</A> dargestellt werden kann.
;
; OPTIONAL OUTPUTS:
;  GET_MAXCOL:: ShowWeights benutzt die Farben blau für 
;                 <*>!NONE</*>-Verbindungen und orange für das
;                 Liniengitter.
;                 Daher stehen für die Bilddarstellung
;                 nicht mehr alle Farbindizes zur
;                 Verfügung. In <C>GET_MAXCOL</C> kann der
;                 letzte verwendbare Index abgefragt werden.<BR>
;<BR>
;                 <I>The keyword <C>GET_MAXCOL</C> is obsolete, but
;                 maintained for backwards compatibility.<BR>
;                 The value returned is always
;                 <*>GET_MAXCOL = !TOPCOLOR</*></I>.
;  GET_COLORMODE:: Liefert als Ergebnis <*>+1</*>, falls der
;                 schwarz/weiss-Modus zur Darstellung
;                 benutzt wurde (DW-Matrix enthielt nur
;                 positive Werte), und <*>-1</*>, falls der
;                 rot/grün-Modus benutzt wurde (DW-Matrix
;                 enthielt negative Werte).
;  GET_RANGE_IN, GET_RANGE_OUT:: Diese Werte können direkt an den 
;                 Befehl <A>Scl</A> weitergereicht
;                 werden, um weitere Arrays so zu
;                 skalieren, daß deren Farbwerte
;                 direkt vergleichbar sind
;                 (d.h. ein Wert <I>w</I> eines so
;                 skalierten Arrays wird auf den
;                 gleichen Farbindex abgebildet,
;                 wie ein Wert <I>w</I>, der im
;                 Originalarray enthalten war).<BR>
;<BR>
;                 <I>The keyword <C>GET_RANGE_OUT</C> is obsolete, but
;                 maintained for backwards compatibility.<BR>
;                 The value returned is always
;                 <*>GET_RANGE_OUT = [0, !TOPCOLOR]</*></I>.<BR>
;<BR>
;                 Zur Information: Es gilt die Beziehung<BR>
;*  GET_RANGE_IN  = [0, Range_In  ], falls Range_In angegeben wurde,
;*                = [0, max(Array)]  sonst.
;*  GET_RANGE_OUT = [0, !TOPCOLOR]
;
; SIDE EFFECTS: Gegebenenfalls wird Farbtabelle geändert.
;        	Außerdem setzt es <*>!P.BACKGROUND</*> stets auf den Farbindex für schwarz
;               und initialisiert <C>SET_SHADING</C> geeignet, damit folgende Surface-Plots nicht
;               seltsam aussehen.
;
; PROCEDURE: Aus Showweights, Rev. 2.15 ausgelagert.
;
; EXAMPLE:
;*  1. UTV, /NORDER, ShowWeights_Scale( GetWeight( MyDW, T_INDEX=0 ), /SETCOL ), ZOOM=10
;*  2. Window, /FREE, TITLE="Membranpotential"
;*     LayerData, MyLayer, POTENTIAL=M
;*     UTV, /NORDER, ShowWeights_Scale( M, /SETCOL), ZOOM=10
;*  3. a = gauss_2d(100,100)
;*     WINDOW, 0
;*     UTV, ShowWeights_Scale( a, /SETCOL, $
;*                                GET_RANGE_IN=ri, GET_RANGE_OUT=ro )
;*     WINDOW, 1
;*     UTV, Scl( 0.5*a, ro, ri )
;*    Die Werte der Arrays in den beiden Fenstern können 
;*    nun direkt verglichen werden.
;*    Der letzte Befehl ist übrigens identisch mit
;*     UTV, ShowWeights_Scale( 0.5*a, RANGE_IN=ri(1) )
;
; SEE ALSO: <A>ShowWeights()</A>, <A>UTvScl</A>, <A>PlotTvScl</A>.
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

   assert, N_Elements(Range) eq 1, "Range_In must be a positive scalar value for this routine."
   assert, Range gt 0, "Range_In must be a positive scalar value for this routine."

   ;;--------------------------------
   
   ;;------------------> Optional Outputs
   GET_MAXCOL = !TOPCOLOR       ;since the revised NASE color
                                ;management (see proceedings of the
                                ;first NASE workshop 2000)
   GET_RANGE_IN  = [0, Range]
   GET_RANGE_OUT = [0, !TOPCOLOR]
   ;;--------------------------------
   
   if min eq 0 and max eq 0 then max = 1 ; Falls Array nur Nullen enthält!
   



   If not Keyword_Set(COLORMODE) then $
    If min ge 0 then COLORMODE = 1 else COLORMODE = -1



   if COLORMODE eq 1 then begin ;positives Array

      GET_COLORMODE = 1
      If Keyword_Set(SETCOL) then begin
         If !D.NAME eq "PS" then begin
            ;;umgedrehte Graupalette laden:
            uloadct, FILE=GetEnv("NASEPATH")+"/graphic/nase/NaseColors.tbl", !NASEP.TABLESET.PAPER_POS
         endif else uloadct, FILE=GetEnv("NASEPATH")+"/graphic/nase/NaseColors.tbl", !NASEP.TABLESET.POS ;utvlct, g, g, g ;Grauwerte
      Endif
      
      If (SETCOL lt 2) then Scl, MatrixMatrix, [0, !TOPCOLOR], [0, Range]

   endif else begin             ;pos/neg Array

      GET_COLORMODE = -1
      If Keyword_Set(SETCOL) then begin
         If !D.Name eq "PS" then begin ;helle Farbpalette
            uloadct, FILE=GetEnv("NASEPATH")+"/graphic/nase/NaseColors.tbl", !NASEP.TABLESET.PAPER_NEGPOS
         endif else begin       ;dunkle Farbpalette
            uloadct, FILE=GetEnv("NASEPATH")+"/graphic/nase/NaseColors.tbl", !NASEP.TABLESET.NEGPOS
         endelse
         Set_Shading, VALUES=[!TOPCOLOR/2, !TOPCOLOR] ;Grüne Werte für Shading nehmen
      EndIf

      If (SETCOL lt 2) then Scl, MatrixMatrix, [0, !TOPCOLOR], [-Range, Range]

   endelse



   ;; NONEs wiederherstellen:
   If not keyword_set(PRINTSTYLE) then begin

      IF count NE 0 THEN MatrixMatrix(no_connections) = !NONE

   EndIf

   If (SETCOL lt 2) then Return, MatrixMatrix else Return, 0
End
