;+
; NAME: ShowWeights_Scale()
;
; PURPOSE: Wurde aus ShowWeights ausgelagert.
;          Ein Array wird so skaliert, da� es mit TV ausgegeben werden 
;          kann und dann aussieht wie bei ShowWeights.
;          Optional kann auch die Farbtabelle entsprechend gesetzt werden.
;
; CATEGORY: Grafik
;
; CALLING SEQUENCE: TV_Array = ShowWeights_Scale( Array [,/SETCOL]
;                                                       [,COLORMODE=mode]
;                                                       [,GET_COLORMODE={+1,-1}]
;                                                       [,GET_MAXCOL=Farbindex] )
;
; INPUTS: Array: Ein (nicht notwendigerweise, ober wohl meist)
;                NASE-Array. (D.h. es darf auch !NONE-Werte
;                enthalten..., ganz positiv oder positiv/negativ sein.)
;
; KEYWORD PARAMETERS: SETCOL: Wird dieses Schl�sselwort gesetzt, so
;                             initialisiert die Routine auch dei
;                             Farbtabelle.
;                             (Graustufen f�r positive Arrays,
;                             Rot/Gr�n f�r gemischtwertige.)
;                  COLORMODE: Mit diesem Schl�sselwort kann unabh�ngig 
;                             von den Werten im Array die
;                             schwarz/weiss-Darstellung (COLORMODE=+1) 
;                             oder die rot/gr�n-Darstellung
;                             (COLORMODE=-1) erzwungen werden.
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
;
; SIDE EFFECTS: Gegebenenfalls wird Farbtabelle ge�ndert.
;
; PROCEDURE: Aus Showweights, Rev. 2.15 ausgelagert.
;
; EXAMPLE: 1. NASETV, ShowWeights_Scale( GetWeight( MyDW, T_INDEX=0 ), /SETCOL ), ZOOM=10
;          2. Window, /FREE, TITLE="Membranpotential"
;             LayerData, MyLayer, POTENTIAL=M
;             NASETV, ShowWeights_Scale( M, /SETCOL), ZOOM=10
;
; SEE ALSO: <A HREF="#SHOWWEIGHTS">ShowWeights()</A>
;
; MODIFICATION HISTORY:
;
;        $Log$
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
                    COLORMODE=colormode, GET_COLORMODE=get_colormode

   MatrixMatrix = Matrix

   no_connections = WHERE(MatrixMatrix EQ !NONE, count)
   IF count NE 0 THEN MatrixMatrix(no_connections) = 0 ;Damits vorerst bei der Berechnung nicht st�rt!

   min = min(MatrixMatrix)
   max = max(MatrixMatrix)
   ts = !TOPCOLOR+1             ;ehemals !D.Table_Size
   GET_MAXCOL = ts-3

   if min eq 0 and max eq 0 then max = 1 ; Falls Array nur Nullen enth�lt!

   If not Keyword_Set(COLORMODE) then $
    If min ge 0 then COLORMODE = 1 else COLORMODE = -1

   if COLORMODE eq 1 then begin       ;positives Array
      GET_COLORMODE = 1
      If Keyword_Set(SETCOL) then begin
         g = indgen(GET_MAXCOL+1)/double(GET_MAXCOL)*255;1
         utvlct, g, g, g         ;Grauwerte
         !P.BACKGROUND = 0      ;Index f�r Schwarz
         Set_Shading, VALUES=[0, GET_MAXCOL] ;verbleibende Werte f�r Shading
      EndIf
      MatrixMatrix = MatrixMatrix/double(max)*GET_MAXCOL
   endif else begin             ;pos/neg Array
      GET_COLORMODE = -1
      If Keyword_Set(SETCOL) then begin
         g = ((2*indgen(GET_MAXCOL+1)-GET_MAXCOL) > 0)/double(GET_MAXCOL)*255
         utvlct, rotate(g, 2), g, bytarr(ts) ;Rot-Gr�n
         !P.BACKGROUND = GET_MAXCOL/2 ;Index f�r Schwarz
         Set_Shading, VALUES=[GET_MAXCOL/2, GET_MAXCOL] ;Gr�ne Werte f�r Shading nehmen
      EndIf
      MatrixMatrix = MatrixMatrix/2.0/double(max([max, -min]))
      MatrixMatrix = (MatrixMatrix+0.5)*GET_MAXCOL
   endelse

   IF count NE 0 THEN MatrixMatrix(no_connections) = ts-2 ;Das sei der Index f�r nichtexistente Verbindungen
   If Keyword_Set(SETCOL) then begin
      SetColorIndex, ts-2, 0, 0, 100 ;Blau sei die Farbe f�r nichtexistente Verbindungen
      SetColorIndex, ts-1, 255, 100, 0 ;Orange die f�r die Trennlinien
   EndIf

   Return, MatrixMatrix
End
