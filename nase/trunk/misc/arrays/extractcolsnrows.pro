;+
; NAME: ExtractColsnRows
;
; PURPOSE: Schneidet aus einem zweidimensionalen Array
;          jede xte Spalte und jede yte Zeile aus und
;          gibt ein aus diesen Spalten und Zeile bestehendes
;          zweidimensionales Array als Ergebnis zurueck.
;
; CATEGORY: MISCELLANEOUS / ARRAY OPERATIONS
;
; CALLING SEQUENCE: cut = ExtractColsNRows(original 
;                           [,COL_DIST=spaltenabstand] [,ROW_DIST=zeilenabstand] 
;                           [,COL_OFFSET=spaltenoffset] {,ROW_OFFSET=zeilenoffset})
;
; INPUTS: original: 2d_Array
;
; OPTIONAL INPUTS: spaltenabstand: Abstand der Spalten, die herausgeschnitten
;                                  werden sollen, Default=1, also alles wird
;                                  zurueckgegeben).
;                  spaltenoffset: Gibt den Index der ersten Spalte an, die 
;                                 herausgeschnitten wird, Default=0, d.h.
;                                 die erste Spalte des Originalarrays
;                                 Offset muss kleiner als Abstand sein!
;                  zeilenabstand und zeilenoffset: entsprechend
;                    
; OUTPUTS: rest: 2d-Array, das aus den herausgeschnittenen Zeilen 
;                und Spalten besteht.
;
; PROCEDURE: 1. Arraygroesse herausfinden.
;            2. Indexarrays fuer die ausgewaehlten Zeilen
;               Spalten erzeugen.
;            3. Spalten aus dem Originalarray ausschneiden.
;            4. Zeilen aus den Spalten ausschneiden
;            5. Ergebnis zurueckgeben
;
; EXAMPLE: a=indgen(6,4)
;          print, a
;     
;             0       1       2       3       4       5
;             6       7       8       9      10      11
;            12      13      14      15      16      17
;            18      19      20      21      22      23
;
;          print, extractcolsnrows(a, COL_DIST=3, ROW_DIST=2)
;          
;          IDL sagt:    0       3
;                      12      15
;        
;          mit Offset:
;          print, extractcolsnrows(a, COL_DIST=3, COL_OFFSET=1, ROW_DIST=2)
;
;          IDL sagt:    1       4
;                      13      16
;          
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 1.1  1998/06/06 14:30:11  thiel
;               Bruno sagt: colnsrows fuer alle in ganz Europa!
;
;-

FUNCTION ExtractColsnRows, Original, COL_DIST=col_dist, ROW_DIST=row_dist, $
                           COL_OFFSET=col_offset, ROW_OFFSET=row_offset

   IF N_Params() NE 1 THEN Message, 'No array specified! Try again!'

   Default, col_dist, 1
   Default, row_dist, 1
   Default, col_offset, 0
   Default, row_offset, 0

   IF (col_dist EQ 1) AND (row_dist EQ 1) THEN Return, Original
   
   IF (col_offset GE col_dist) THEN Message, 'Column-offset must be less than distance! Try Again!'
   IF (row_offset GE row_dist) THEN Message, 'Row-offset must be less than distance! Try Again!'

   OriginalHoehe=(Size(Original))(2)
   OriginalBreite=(Size(Original))(1)

   If (col_dist GT OriginalBreite) OR (row_dist GT OriginalHoehe) Then $
    Message, 'Distances greater than original arraysize not allowed! Try again!'

   xpos = col_dist*indgen(OriginalBreite/col_dist)+col_offset
   ypos = row_dist*indgen(OriginalHoehe/row_dist)+row_offset 

   Spalten=Original(xpos,*)
        
   Zeilen=Spalten(*,ypos)

   Return, Zeilen

END
