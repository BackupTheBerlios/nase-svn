;+
; NAME:               CutTorus                
;
; PURPOSE:            Setzt alle Elemente eines Arrays ausserhalb eines Kreisrings (Torus)
;                     auf einen bestimmten Wert. Der Mittelpunkt des Kreisrings ist standardmaeesig
;                     in der Mitte des Arrays.
;
; CATEGORY:           ARRAYS
;
; CALLING SEQUENCE:   Torus = CutTorus(array, outer_radius [,inner_radius] [X_CENTER=x_center] 
;                                             [,Y_CENTER=y_center] [,/TRUNCATE] [,CUT_VALUE=cut_value]
;                         
;
; INPUTS:             array       : ein zweidimensionales Array
;                     outer_radius: Elemente mit Abstand > outer_radius werden auf Null gesetzt
;
; OPTIONAL INPUTS:    inner_radius: Elemente mit Abstand <= inner_radius werden auf Null gesetzt
;
; KEYWORD PARAMETERS: X_CENTER/
;                     Y_CENTER : Gibt die Verschiebung des Kreisrings vom Mittelpunkt an.
;                                Es koennen natuerlich auch negative Wert angegeben werden.
;                                Die Randbedingungen sind zyklisch.
;                     TRUNCATE : Nicht-zyklische Randbedingungen. Der Torus wird abgeschnitten,
;                                wenn [XY]_Center zu gross sind.
;                     CUT_VALUE: Alle Werte ausserhalb des Torus werden auf CUT_VALUE gesetzt.
;                                Default ist Null.
;                               
; OUTPUTS:            Torus: ein Array mit den array-Werten im definierten Torus und CUT_VALUE sonst.
;
; EXAMPLE:            
;                     a = IntArr(100,100)
;                     a = a+150
;                     tv, cuttorus(a, 40, 30)
;                     for i=-100,100 DO tv, cuttorus(a, 40, 30, Y_CENTER=i, X_CENTER=i)  
;                     for i=-100,100 DO tv, cuttorus(a, 40, 30, Y_CENTER=i, /TRUNCATE)  
;                     for i=-100,100 DO tv, cuttorus(a, 40, 30, Y_CENTER=i, X_CENTER=i, /TRUNCATE, CUT_VALUE=50)      
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 1.3  1999/01/01 14:00:09  saam
;           + the distance is now rounded, which provides a smoooother torus
;
;     Revision 1.2  1997/12/19 13:04:19  saam
;           Keywords [XY]_CENTER, TRUNCATE und CUT_VALUE hinzugefuegt
;
;     Revision 1.1  1997/11/21 18:25:15  saam
;           Neu und Toll
;
;     
;-
FUNCTION CutTorus, data, outer_radius, inner_radius, X_CENTER=x_center, Y_CENTER=y_center, TRUNCATE=truncate, CUT_VALUE=cut_value

   dataDims = SIZE(data) 

   IF dataDims(0) NE 2 THEN Message, 'first argument has to be an 2d array'
   IF N_Params()  LT 2 THEN Message, 'at least two arguments expected' 
   Default, x_center, 0
   Default, y_center, 0
   Default, cut_value, 0
   

   distArr = ROUND(SHIFT( DIST(dataDims(1), dataDims(2)), dataDims(1)/2, dataDims(2)/2 ))
   IF Keyword_Set(TRUNCATE) THEN BEGIN
      distArr = NOROT_SHIFT(distArr, x_center, y_center)
   END ELSE BEGIN
      distArr = SHIFT(distArr, x_center, y_center)
   END

   outerRadius = WHERE (distArr GT outer_radius, count)
   IF count NE 0 THEN distArr(outerRadius) = -1

   IF N_Params() GE 3 THEN BEGIN
      innerRadius = WHERE (distArr LE inner_radius, count)
      IF count NE 0 THEN distArr(innerRadius) = -1
   END

   resArr = data
   cut_elements = WHERE(distArr EQ -1, count)
   IF count NE 0 THEN resArr(cut_elements) = cut_value
   RETURN, resArr

END
