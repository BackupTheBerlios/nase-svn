;+
; NAME:               IMax
;
; PURPOSE:            Die MAX-Routine von IDL bildet das Maximum
;                     von der gesamten uebergebenen Matrix. IMax
;                     bildet das Maximum ueber einen laufenden
;                     Index.
;                     Bei einer zweidimensionalen Matrix kann
;                     IMax beispielsweise das Spalten- bzw.
;                     Zeilenmaximum ermitteln.
;                     Der Rueckgabewert ist ein Array von der
;                     Dimension des Indices.
;                     Etwas formaler:
;                        A = A(a1 x a2 x a3 x a4 x a5 x a6 x a7)
;   
;                        (IMax(A,i))(j) = MAX(A(*,...,*,  j  ,*,...,*))
;                                                         /\
;                                                        /||\ 
;                                                         || 
;                                                       i-ter Index
;
; CATEGORY:          MISC ARRAY-OPERATIONS
;
; CALLING SEQUENCE:  m = IMax(A,i)
;
; INPUTS:            A: ein beliebiges Array beliebigen Typs
;                    i: der Index, ueber den das Maximum gebildet
;                       werden soll
;
; OUTPUTS:           m: der Maximums-Vektor mit dem gleichen Typ wie A
;
; RESTRICTIONS:      i <= 6 (IDL-Einschraenkung)
;
; EXAMPLE:       
;                    A = IndGen(10,10)
;                    print, IMax(A,0)
;                       90      91      92      93      94      95      96      97      98 
;                       99
;                    print, IMax(A,1)
;                        9      19      29      39      49      59      69      79      89
;                       99
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 1.1  1997/12/15 11:46:47  saam
;           Birth == Pain !!
;
;
;-
FUNCTION IMax, A, i
   
   s = Size(A)

   IF s(0) LE i THEN Message, 'index too large for array'
   IF i    GT 6 THEN Message, 'maximal index is 6'

   res = Make_Array(TYPE=s(s(0)+1), s(i+1))
   FOR x=0, s(i+1)-1 DO BEGIN
      CASE i OF  
         0: res(x) = MAX( A(x,*) ) 
         1: res(x) = MAX( A(*,x,*) ) 
         2: res(x) = MAX( A(*,*,x,*) ) 
         3: res(x) = MAX( A(*,*,*,x,*) ) 
         4: res(x) = MAX( A(*,*,*,*,x,*) ) 
         5: res(x) = MAX( A(*,*,*,*,*,x,*) ) 
         6: res(x) = MAX( A(*,*,*,*,*,*,x) ) 
      ENDCASE
   END
   RETURN, res
END
