;+
; NAME:               lExtrac
;
; PURPOSE:            Extraktion einer Submatrix aus einer n-dimensionalen Matrix 
;                     n-dimensionalen Matrix. Diese Routine hebt die Beschraenkung
;                     der IDL-internen Routine EXTRAC auf rechteckige Untermatrazen
;                     auf, kann das ganze aber nur fuer einen Index gleichzeitig 
;                     (Erweiterung problemlos, aber nicht von mir benoetigt).
;  
;                     Rein intuitiv wuerde man in IDL folgenden schreiben:
;                        Array = IndGen(5,5,5)
;                        newArr = Array(*,[1,2,4],*)
;                     Das klappt aber, wegen der.......haehh??????? jetzt fktionierts ploetzlich!?!?!?!                      
;
; CATEGORY:           MISC ARRAYS
;
; CALLING SEQUENCE:   ex = lExtrac(A, subscript, indices) 
;
; INPUTS:             A        : ein beliebiges Array
;                     subscript: Zahl von 1..7, die die Dimension in A
;                                fuer die zu extrahierenden Indizes indices
;                                angibt
;                     indices  : Array, das die zu extrahierenden Indizes
;                                enthaelt
;                                
;
; OPTIONAL INPUTS:
;
; KEYWORD PARAMETERS:
;
; OUTPUTS:
;
; OPTIONAL OUTPUTS:
;
; COMMON BLOCKS:
;
; SIDE EFFECTS:
;
; RESTRICTIONS:
;
; PROCEDURE:
;
; EXAMPLE:
;
; SEE ALSO:
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 1.1  1998/03/23 14:18:24  saam
;           Hmmm, dunno....
;
;
;-

FUNCTION lExtrac, A, subscript, array

   IF N_Params() NE 3 THEN Message, 'wrong number of arguments'

   s = Size(A) 
   IF s(0) LT subscript THEN Message, 'subscript too large for array'

   IF MAX(array) GT s(subscript) THEN Message, 'at least one index too large for array'

   num = N_Elements(array)

   s(subscript) = num
   tA = Make_Array(size=s)

   FOR i=0, num-1 DO BEGIN
      CASE subscript OF 
         1: tA(i,*,*,*,*,*,*) = A(array(i),*,*,*,*,*,*)
         2: tA(*,i,*,*,*,*,*) = A(*,array(i),*,*,*,*,*)
         3: tA(*,*,i,*,*,*,*) = A(*,*,array(i),*,*,*,*)
         4: tA(*,*,*,i,*,*,*) = A(*,*,*,array(i),*,*,*)
         5: tA(*,*,*,*,i,*,*) = A(*,*,*,*,array(i),*,*)
         6: tA(*,*,*,*,*,i,*) = A(*,*,*,*,*,array(i),*)
         7: tA(*,*,*,*,*,*,i) = A(*,*,*,*,*,*,array(i))
         ELSE: Message, 'incorrect subscript'
      END
   END
   
   RETURN, tA
END
