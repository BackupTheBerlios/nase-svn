;+
; NAME:               CutTorus                
;
; PURPOSE:            Setzt alle Elemente eines Arrays ausserhalb eines Kreisrings (Torus)
;                     auf Null. 
;
; CATEGORY:           ARRAYS
;
; CALLING SEQUENCE:   Torus = CutTorus(array, outer_radius [,inner_radius])
;
; INPUTS:             array       : ein zweidimensionales Array
;                     outer_radius: Elemente mit Abstand > outer_radius werden auf Null gesetzt
;
; OPTIONAL INPUTS:    inner_radius: Elemente mit Abstand <= inner_radius werden auf Null gesetzt
;
; OUTPUTS:            Torus: der ausgeschnittene Torus
;
; EXAMPLE:            
;                     a = IntArr(100,100)
;                     a = a+10
;                     tvscl, cuttorus(a, 40, 30)
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 1.1  1997/11/21 18:25:15  saam
;           Neu und Toll
;
;     
;-
FUNCTION CutTorus, data, outer_radius, inner_radius

   dataDims = SIZE(data) 

   IF dataDims(0) NE 2 THEN Message, 'first argument has to be an 2d array'
   IF N_Params()  LT 2 THEN Message, 'at least two arguments expected' 
   
   distArr = SHIFT( DIST(dataDims(1), dataDims(2)), dataDims(1)/2, dataDims(2)/2 )
   
   outerRadius = WHERE (distArr GT outer_radius, count)
   IF count NE 0 THEN distArr(outerRadius) = -1

   IF N_Params() GE 3 THEN BEGIN
      innerRadius = WHERE (distArr LE inner_radius, count)
      IF count NE 0 THEN distArr(innerRadius) = -1
   END

   RETURN, data*(distArr GT -1)

END
