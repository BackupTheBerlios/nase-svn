;+
; NAME:                PRODUCT
;
; PURPOSE:             Bildet das Produkt ueber alle Elemente eines uebergebenen Arrays
;                      und bildet damit das Gegenstueck zu TOTAL. Dies Produktbildung
;                      ueber einen speziellen Index wurde leider noch nicht implementiert.
;
; CATEGORY:            MATH
;
; CALLING SEQUENCE:    p = PRODUCT(A [,DOUBLE])
;
; INPUTS:              A: irgendein Array, was nicht vom Typ String ist.
;
; KEYWORD PARAMETERS:  DOUBLE: Wird ein Float-Array uebergeben, so erfolgt die
;                              Produktbildung mit doppelter Genauigkeit.
;
; OUTPUTS:             p: das Produkt (Skalar) vom Typ long (bei int/long) oder
;                         float/double.
;
; EXAMPLE:
;                      A = [5,4,7]
;                      print, product(A)
;                           140
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 2.1  1998/06/23 11:34:13  saam
;           product across index missing
;
;
;-
FUNCTION PRODUCT, A, ind, DOUBLE=DOUBLE

   On_Error, 2
   
   S = SIZE(A)
   AType = S(S(0)+1)
   IF N_Params() EQ 1 THEN ind = 0
   IF N_Params() GT 2 THEN Message, 'too many arguments'


   IF ind EQ 0 THEN BEGIN       ; no index given

      IF (AType GE 1) AND (AType LE 3) THEN BEGIN
         fac = 1l               ; array is of type byte, int or long
      END ELSE IF (AType EQ 4) THEN BEGIN ; array is float
         IF Keyword_Set(DOUBLE) THEN fac = 1.d ELSE fac = 1.
      END ELSE IF (AType EQ 5) THEN fac = 1.d $ ;array is double 
      ELSE Message, 'cannot handle array type'
      
      FOR i=0,S(S(0)+2)-1 DO BEGIN
         fac = fac * A(i) 
      END
      RETURN, fac
      
   END ELSE BEGIN
      Message, 'index multiplication not working ... yet'
;      IF ind GT S(0) THEN Message, 'index too large for array'
      
      ; determine resulting array's size
;      Sfac = S(0)-1
;      FOR i=1,S(0) DO IF i NE ind THEN Sfac = [Sfac, S(i)]
;      Sfac = [Sfac, S(S(0)+1), S(S(0)+2)/S(ind)]

;      SR = Make_Array(SIZE=SFac)
;      FOR i=0,S(ind)-1 DO BEGIN
;         Product(LExtrac(A,ind,i))
;      END
      
   END

END
