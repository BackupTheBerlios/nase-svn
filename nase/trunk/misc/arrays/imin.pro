;+
; NAME:                 IMin
;
; PURPOSE:              Die MIN-Routine von IDL bildet das Minimum
;                       von der gesamten uebergebenen Matrix. IMax
;                       bildet das Maximum ueber einen laufenden
;                       Index.
;                       Bei einer zweidimensionalen Matrix kann
;                       IMax beispielsweise das Spalten- bzw.
;                       Zeilenminimum ermitteln.
;                       Der Rueckgabewert ist ein Array von der
;                       Dimension des Indices.
;                       Etwas formaler:
;                          A = A(a1 x a2 x a3 x a4 x a5 x a6 x a7)
;   
;                          (IMin(A,i))(j) = MIN(A(*,...,*,  j  ,*,...,*))
;                                                           /\
;                                                          /||\ 
;                                                           || 
;                                                         i-ter Index
;
; CATEGORY:            MISC ARRAY-OPERATIONS
;
; CALLING SEQUENCE:    m = IMin(A,i [,indices] [,/ONED])
;
; INPUTS:              A: ein beliebiges Array beliebigen Typs
;                      i: der Index, ueber den das Minimum gebildet
;                         werden soll
;
; KEYWORD PARAMETERS:  ONED: falls gesetzt werden die indices der Positionen der Minima
;                            im Originalarray zurueckgegeben, sodass mit A(indices)
;                            darauf zugegeriffen werden kann. Dies funktioniert nur fuer
;                            ein- und zweidimensional Arrays.
;
; OUTPUTS:             m: der Minimums-Vektor mit dem gleichen Typ wie A
;
; OPTIONAL OUTPUT:     indices: gibt analog zur MIN-Function von IDL die
;                               entsprechenden Indices (bzgl der angegeben Dimension) 
;                               der Minima zurueck (aber nur fuer die jeweilige Spalte,Zeile).
;                               Das Verhalten aendert sich, wenn das Keyword ONED gesetzt
;                               wird, siehe dazu dort.
;
;
; RESTRICTIONS:        i <= 6 (IDL-Einschraenkung)
;
; EXAMPLE:       
;                      A = IndGen(10,10)
;                      print, IMin(A,0)
;                      print, IMin(A,1)
;
; MODIFICATION HISTORY:
;
;     $Log: 
;
;
;-
FUNCTION IMin, A, i, indices, ONED=oned
   
   On_Error, 2

   s = Size(A)

   IF s(0) LE i THEN Message, 'index too large for array'
   IF i    GT 6 THEN Message, 'maximal index is 6'
   IF Keyword_Set(ONED) AND s(0) GT 2 THEN Message, 'one dimensional indices only work for dimensions less than 3'

   res = Make_Array(TYPE=s(s(0)+1), s(i+1))

   indices = LonArr(s(i+1))
   FOR x=0, s(i+1)-1 DO BEGIN
      CASE i OF  
         0: res(x) = MIN( A(x,*), tmp ) 
         1: res(x) = MIN( A(*,x,*), tmp ) 
         2: res(x) = MIN( A(*,*,x,*), tmp ) 
         3: res(x) = MIN( A(*,*,*,x,*), tmp ) 
         4: res(x) = MIN( A(*,*,*,*,x,*), tmp ) 
         5: res(x) = MIN( A(*,*,*,*,*,x,*), tmp ) 
         6: res(x) = MIN( A(*,*,*,*,*,*,x), tmp ) 
      ENDCASE
      indices(x) = tmp
   END

   IF Keyword_Set(ONED) THEN BEGIN
      so = s
      so(s(0)+1) = 3                          ; type will be long
      B = Make_Array(SIZE=s, /INDEX)          ; index array of same dimension as A

      oned    = LonArr(s(i+1))                ; array containing 1dimensional indices for A of minima in A

      FOR x=0, s(i+1)-1 DO BEGIN
         CASE i OF  
            0: oned(x) = B(x,indices(x))
            1: oned(x) = B(indices(x),x)
         END
      END

      indices = oned
   END
  
   RETURN, res
END
