;+
; NAME: InsertColsnRows
;
; AIM: inserts regularly spaced columns and rows into an array
;
; PURPOSE: Fuegt in ein zweidimensionales Array
;          in regelmaessigem Abstand eine gewuenschte
;          Anzahl Zeilen und Spalten ein und gibt ein 
;          entsprechend groesseres Array als Ergebnis 
;          zurueck.
;
; CATEGORY: MISCELLANEOUS / ARRAY OPERATIONS
;
; CALLING SEQUENCE: blow = InsertColsNRows(original 
;                           [,COL_DIST=spaltenabstand] [,ROW_DIST=zeilenabstand] 
;                           [,COL_OFFSET=spaltenoffset] [,ROW_OFFSET=zeilenoffset]
;                           [,VALUE=zahl])
;
; INPUTS: original: 2d_Array
;
; OPTIONAL INPUTS: spaltenabstand: Abstand der Original-Spalten im neu
;                                  erzeugten Array. Default=1, d.h. es
;                                  wird nichts eingefuegt.
;                  spaltenoffset: Gibt den Index der Spalte des neuen Arrays
;                                 an, in die die erste Spalte des Original-
;                                 Arrays geschrieben wird. Default=0, d.h.
;                                 die erste Spalte des Originalarrays
;                                 ist auch die erste Spalte des neuen Arrays.
;                  zeilenabstand und zeilenoffset: entsprechend
;                    
; OUTPUTS: blow: 2d-Array vom Typ des Originalarrays, das aus den 
;                urspruenglichen Zeilen und Spalten mit den eingefuegten 
;                dazwischen besteht. 
;                Dimensionen: 
;                (originalbreite*spaltenabstand, originalhoehe*zeilenabstand)
;
; PROCEDURE: 1. Neues groesseres Array vorbelegen 
;            2. Indexarrays fuer die ausgewaehlten Zeilen
;               Spalten erzeugen.
;            3. Spalten aus dem Originalarray ins neue Array uebertragen.
;            4. Zeilen uebertragen
;            5. Ergebnis zurueckgeben
;
; EXAMPLE: a=indgen(3,3)
;          print, a
;  
;          IDL sagt:     0       1       2
;                        3       4       5
;                        6       7       8
;     
;          print, insertcolsnrows(a, col_dist=3, row_dist=2, value=1.0, col_offset=1)
;
;           IDL sagt:
;          1       0       1       1       1       1       1       2       1
;          1       1       1       1       1       1       1       1       1
;          1       3       1       1       4       1       1       5       1
;          1       1       1       1       1       1       1       1       1
;          1       6       1       1       7       1       1       8       1
;          1       1       1       1       1       1       1       1       1
;          
; SEE ALSO: <A HREF="#EXTRACTCOLSNROWS">ExtractColsnRows</A>
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 1.3  2000/09/25 09:12:55  saam
;        * added AIM tag
;        * update header for some files
;        * fixed some hyperlinks
;
;        Revision 1.2  1998/06/28 11:22:51  thiel
;               Bugfix: eindimensionale Arrays funktionieren jetzt auch.
;
;        Revision 1.1  1998/06/15 19:08:18  thiel
;               Wer Extract sagt muss auch Insert sagen.
;
;
;-

FUNCTION InsertColsnRows, Original, COL_DIST=col_dist, ROW_DIST=row_dist, $
                           COL_OFFSET=col_offset, ROW_OFFSET=row_offset, VALUE=value

   IF N_Params() NE 1 THEN Message, 'No array specified! Try again!'

   Default, col_dist, 1
   Default, row_dist, 1
   Default, col_offset, 0
   Default, row_offset, 0
   Default, value, 0

   IF (col_dist EQ 1) AND (row_dist EQ 1) THEN Return, Original
   
   IF (col_offset GE col_dist) THEN Message, 'Column-offset must be less than distance! Try Again!'
   IF (row_offset GE row_dist) THEN Message, 'Row-offset must be less than distance! Try Again!'

   IF (Size(original))(0) EQ 1 THEN BEGIN ;eindimensionales Array
      originalhoehe = 1
      originalbreite = (Size(Original))(1)
      resulthoehe = originalhoehe*row_dist
      resultbreite = originalbreite*col_dist
      result1 = Make_Array(resultbreite,originalhoehe, VALUE=value, TYPE=(Size(original))(2))
      result2 = Make_Array(resultbreite,resulthoehe, VALUE=value, TYPE=(Size(original))(2))
   ENDIF ELSE BEGIN
      originalhoehe=(Size(Original))(2)
      originalbreite=(Size(Original))(1)
      resulthoehe = originalhoehe*row_dist
      resultbreite = originalbreite*col_dist
      result1 = Make_Array(resultbreite,originalhoehe, VALUE=value, TYPE=(Size(original))(3))
      result2 = Make_Array(resultbreite,resulthoehe, VALUE=value, TYPE=(Size(original))(3))
   ENDELSE


;   If (col_dist GT OriginalBreite) OR (row_dist GT OriginalHoehe) Then $
;    Message, 'Distances greater than original arraysize not allowed! Try again!'

   xpos = col_dist*indgen(originalbreite)+col_offset
   ypos = row_dist*indgen(originalhoehe)+row_offset 

   result1(xpos,*) = original(*,*)
        
   result2(*,ypos) = result1(*,*)

   Return, result2

END
