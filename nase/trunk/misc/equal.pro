;+
; NAME: equal(a,b,[precision])
;
;
; PURPOSE: Vergleicht zwei beliebige Werte/Arrays. Wenn dies floats sind, wird auf 
;          beliebige Praezision hin ueberprueft, z.B. bis zur 5. Nachkommastelle.
;
;          Wenn die beiden Werte unterschiedliche Vorzeichen haben, aber genuegend
;          kleine Betraege, werden sie (entsprechend der gewaehlten Praezision) als 
;          identisch qualifiziert. (Das alte 'eq' entscheidet gnadenlos anhand des 
;          Vorzeichens!)
;
;          Funktioniert auch fuer Felder und Kombinationen aus Einzelwerten und Feldern. 
;         
;          Wenn die uebergebenen Werte Integers oder Bytes sind, nutzt 'equal' das
;          herkoemmlich 'eq' .
;
;
; CATEGORY: Basics
;
;
; CALLING SEQUENCE: c = equal(a,b,[precision])
;
; 
; INPUTS: Zwei beliebige Werte oder Arrays oder Mix aus beiden (byte, int, longint, float, double). 
;
;
; OPTIONAL INPUTS: Die Praezision, Anzahl der Nachkommastellen, auf die hin die beiden
;                  Werte verglichen werden. Defaultwert ist 7. 
;                  Bei Integerwerten wird die Praezision nicht beruecksichtigt.
;                  Bei floats machen Praezisionen groesser 7 keinen Sinn!!! 
;	
; OUTPUTS: -1, falls ein Aufruffehler vorliegt.
;           0, wenn die beiden Werte unterschiedlich sind,
;           1, falls sie gleich sind. 
;
;           Wenn ein (oder zwei) Array(s) verglichen wurden, ist der Output entsprechend wieder 
;           ein Array. 
;
;
; SIDE EFFECTS: ?
;
;
; EXAMPLE:  a=3.123456789D  
;           b=3.123456089D
;
;           c=equal(a,b,8)
;           c=0
;
; MODIFICATION HISTORY:
;
;
;     $Log$
;     Revision 1.2  1998/11/17 14:49:17  brinks
;     *** empty log message ***
;
;     Revision 1.1  1998/11/17 13:33:26  brinks
;     *** empty log message ***
;
;
;-



FUNCTION equal, a, b, precision

  on_error, 2
 
  IF NOT(keyword_set(precision)) THEN precision = 7L  ;; Maximalwert fuer Floats

  element_typ1 = size(a)
  element_typ1 = element_typ1(n_elements(element_typ1)-2)
  element_typ2 = size(b)
  element_typ2 = element_typ2(n_elements(element_typ2)-2)

  IF ((element_typ1 EQ 0) OR (element_typ2 EQ 0) OR (precision LT 0)) THEN BEGIN
   message,'kein gueltiger Parameter (function equal)'
   return, -1
  ENDIF 
  
  precision = 10L^precision

    ;; handelt es sich um floats,.. oder integers ?

    IF ((element_typ1 EQ 4 OR element_typ1 EQ 5) AND (element_typ2 EQ 4 OR element_typ2 EQ 5))  THEN $  ;; -> floats
      BEGIN

        IF (total(abs(a-b)) LT (2*precision*(n_elements(a) >  n_elements(b)))) THEN $   ;; Das Vorzeichen wird getrennt behandelt!!!
          return, ( floor(precision*abs(a)) EQ floor(precision*abs(b)) ) $             ;; Wenn Abstand(Betraege) klein genug,  
            ELSE return, 0                                                             ;; dann verwirf das Vorzeichen!

      ENDIF $

    ELSE $   ;; -> integers                      
      return, (a EQ b) 

END 
