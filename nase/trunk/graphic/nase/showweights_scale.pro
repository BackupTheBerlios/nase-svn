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
;        Revision 2.1  1998/02/11 15:36:32  kupper
;               Sch�pfung durch Auslagern.
;
;-

Function ShowWeights_Scale, MatrixMatrix, SETCOL=setcol, GET_MAXCOL=get_maxcol
   no_connections = WHERE(MatrixMatrix EQ !NONE, count)
   IF count NE 0 THEN MatrixMatrix(no_connections) = 0 ;Damits vorerst bei der Berechnung nicht st�rt!

   min = min(MatrixMatrix)
   max = max(MatrixMatrix)
   ts = !D.Table_Size

   if min eq 0 and max eq 0 then max = 1 ; Falls Array nur Nullen enth�lt!

   if min ge 0 then begin
      If Keyword_Set(SETCOL) then begin
         g = indgen(ts)/double(ts-1)*255
         tvlct, g, g, g         ;Grauwerte
      EndIf
      MatrixMatrix = MatrixMatrix/double(max)*(ts-3)
   endif else begin
      If Keyword_Set(SETCOL) then begin
         g = ((2*indgen(ts)-ts+1) > 0)/double(ts-1)*255
         tvlct, rotate(g, 2), g, bytarr(ts) ;Rot-Gr�n
      EndIf
      MatrixMatrix = MatrixMatrix/2.0/double(max([max, -min]))
      MatrixMatrix = (MatrixMatrix+0.5)*(ts-3)
   endelse

   IF count NE 0 THEN MatrixMatrix(no_connections) = ts-2 ;Das sei der Index f�r nichtexistente Verbindungen
   If Keyword_Set(SETCOL) then begin
      SetColorIndex, ts-2, 0, 0, 100 ;Blau sei die Farbe f�r nichtexistente Verbindungen
      SetColorIndex, ts-1, 255, 100, 0 ;Orange die f�r die Trennlinien
   EndIf
   GET_MAXCOL = ts-3

   Return, MatrixMatrix
End
