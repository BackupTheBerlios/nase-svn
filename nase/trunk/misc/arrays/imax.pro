;+
; NAME:                 IMax
;
; PURPOSE:              Die MAX-Routine von IDL bildet das Maximum
;                       von der gesamten uebergebenen Matrix. IMax
;                       bildet das Maximum ueber einen laufenden
;                       Index.
;                       Bei einer zweidimensionalen Matrix kann
;                       IMax beispielsweise das Spalten- bzw.
;                       Zeilenmaximum ermitteln.
;                       Der Rueckgabewert ist ein Array von der
;                       Dimension des Indices.
;                       Etwas formaler:
;                          A = A(a1 x a2 x a3 x a4 x a5 x a6 x a7)
;   
;                          (IMax(A,i))(j) = MAX(A(*,...,*,  j  ,*,...,*))
;                                                           /\
;                                                          /||\ 
;                                                           || 
;                                                         i-ter Index
;
; CATEGORY:            MISC ARRAY-OPERATIONS
;
; CALLING SEQUENCE:    m = IMax(A,i [,indices] [,/ONED])
;
; INPUTS:              A: ein beliebiges Array beliebigen Typs
;                      i: der Index, ueber den das Maximum gebildet
;                         werden soll
;
; KEYWORD PARAMETERS:  ONED: falls gesetzt werden die indices der Positionen der Maxima
;                            im Originalarray zurueckgegeben, sodass mit A(indices)
;                            darauf zugegeriffen werden kann. Dies funktioniert nur fuer
;                            ein- und zweidimensional Arrays.
;
;                      ITER: I ist dann der Iterationsindex (default: 0)
;
; OUTPUTS:             m: der Maximums-Vektor mit dem gleichen Typ wie A
;
; OPTIONAL OUTPUT:     indices: gibt analog zur MAX-Function von IDL die
;                               entsprechenden Indices (bzgl der angegeben Dimension) 
;                               der Maxima zurueck (aber nur fuer die jeweilige Spalte,Zeile).
;                               Das Verhalten aendert sich, wenn das Keyword ONED gesetzt
;                               wird, siehe dazu dort.
;
;
; RESTRICTIONS:        i <= 6 (IDL-Einschraenkung)
;
; EXAMPLE:       
;                      A = IndGen(10,10)
;                      print, IMax(A,0)
;                         90      91      92      93      94      95      96      97      98 
;                         99
;                      print, IMax(A,1)
;                          9      19      29      39      49      59      69      79      89
;                         99
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 1.6  1999/11/18 14:28:07  gabriel
;           ITER Keyword added (s.a. imoment)
;
;     Revision 1.5  1999/01/14 14:18:19  saam
;           + loop variables are long now
;
;     Revision 1.4  1998/08/11 15:16:58  saam
;           new keyword ONED implemented
;
;     Revision 1.3  1998/07/02 09:35:23  saam
;           returns now if an error occurs
;
;     Revision 1.2  1998/06/03 08:30:50  saam
;           added optional output 'indices'
;
;     Revision 1.1  1997/12/15 11:46:47  saam
;           Birth == Pain !!
;
;
;-
FUNCTION IMax, A, i, indices, ONED=oned, iter=iter
   
   On_Error, 2

   s = Size(A)
   default,iter,0
   IF s(0) LE i THEN Message, 'index too large for array'
   IF i    GT 6 THEN Message, 'maximal index is 6'
   IF Keyword_Set(ONED) AND s(0) GT 2 THEN Message, 'one dimensional indices only work for dimensions less than 3'
   IF Keyword_Set(ONED) AND Keyword_Set(ITER) THEN Message, 'one dimensional indices only work for ITER=0'
   IF iter EQ 1 THEN BEGIN
    
      ;; wo ist denn der boese index
      ind = where(indgen(s(0)) NE (i))
      type = s(N_elements(s)-2)
      ;; dimensionen bestimmen fuer max
      new_s1 = [s(0),s(ind+1),type,product([s(ind+1)])]
      new_s2 = [s(0),s(ind+1),3,product([s(ind+1)])]
      ;;stop
      m = make_array(size=new_s1)
      indices = make_array(size=new_s2)
      ;;hier tauschen wir den zu mittelnden index an die letzte stelle
      Atmp = utranspose(A,[ind,i])
      
      FOR x=0, s(ind(0)+1)-1 DO BEGIN
         Atmp2 = reform(Atmp(x,*,*,*,*,*,*))
         s1 = size(Atmp2)
         indtot = indgen(s1(0))
         IF s(0) GT 2 THEN BEGIN
            m(x,*,*,*,*,*,*) = imax(Atmp2,last(indtot),indices,/iter)
         END ELSE BEGIN
            m(x) = max(Atmp2,tmp)
            indices(x) = tmp
         ENDELSE
      END
      return,m
   END ELSE BEGIN
         
      res = Make_Array(TYPE=s(s(0)+1), s(i+1))
      
      indices = LonArr(s(i+1))
      FOR x=0l, s(i+1)-1 DO BEGIN
         CASE i OF  
            0: res(x) = MAX( A(x,*), tmp ) 
            1: res(x) = MAX( A(*,x,*), tmp ) 
            2: res(x) = MAX( A(*,*,x,*), tmp ) 
            3: res(x) = MAX( A(*,*,*,x,*), tmp ) 
            4: res(x) = MAX( A(*,*,*,*,x,*), tmp ) 
            5: res(x) = MAX( A(*,*,*,*,*,x,*), tmp ) 
            6: res(x) = MAX( A(*,*,*,*,*,*,x), tmp ) 
         ENDCASE
         indices(x) = tmp
      END

      IF Keyword_Set(ONED) THEN BEGIN
         so = s
         so(s(0)+1) = 3         ; type will be long
         B = Make_Array(SIZE=s, /INDEX) ; index array of same dimension as A
         
         oned    = LonArr(s(i+1)) ; array containing 1dimensional indices for A of maxima in A
         
         FOR x=0l, s(i+1)-1 DO BEGIN
            CASE i OF  
               0: oned(x) = B(x,indices(x))
               1: oned(x) = B(indices(x),x)
            END
         END
         
         indices = oned
      END
      
      RETURN, res
   ENDELSE
END
