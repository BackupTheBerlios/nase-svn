;+
; NAME:               IMOMENT
; 
; PURPOSE:            Diese Funktion berechnet die ersten 4 Momente einer
;                     multidimensionalen Verteilung fuer eine bestimmte
;                     Dimension.
;                     Typisches Beispiel ist eine Abhaengigkeit y = y(x),
;                     die ueber viele Iterationen ermittelt werden soll
;                     und in der Form y(x,iter) vorliegt.
;                     IMoment(y,1) liefert nun Mittelwert, Varianz, ...
;                     in Abhaengigkeit von x. Die Uebergabekonventionen
;                     entsprechenden denen von UMoment. Fuer nicht definierte
;                     Werte wird !NONE zurueckgegeben.
;
; CATEGORY:           STATISTICS.
;
; CALLING SEQUENCE:   Result = IMoment(X, i [,ITER=iter] [,MDEV=mdev] [,SDEV=sdev] [,MIN=min] [,MAX=max])
;
; INPUTS:             X:  Eine n-dimensionale Matrix vom Typ integer, float or double.
;                     I:  Index dessen Moment berechnet werden soll (s.a. keyword ITER)                    
;
; KEYWORD PARAMETERS: MDEV/SDEV: siehe UMoment
;                     MIN/MAX  : definiert eine untere und/oder eine obere Grenze fuer
;                                Messwerte die in die Berechnung einbezogen werden sollen.
;                                Ist in der Matrix X z.B. -1 als 'kein sinnvoller Wert'
;                                definiert setzt man z.B. MIN=0
;
;                     ITER: I ist dann der Iterationsindex (default: 0)
; EXAMPLE:            
;                     ;first example:
;                     x = [[1,2,3,4,5],[0.9,2.1,3.5,4.1,5.0],[1.05,1.99,3.0,4.02,5.1]]
;                     m = IMoment(x,1) 
;                     print, 'MEANS:', m(*,0)
;                     print, 'VAR  :', m(*,1)   
;
;                     ;second example:
;                     X=randomu(s,10,10,30) ; here: x means an array of type (xdim,ydim,iter)
;                     m=imoment(x,3,/ITER)
;                     
;                     help,m
;                     ;idl returns:
;                     ;<Expression>    FLOAT     = Array(10, 10, 4)
;                     surfit,m(*,*,0) ; plots the mean of the 2-dimensional iterations
;   
; SEE ALSO:           <A HREF="#UMOMENT">UMoment</A>
;
; MODIFICATION HISTORY:
;
;       $Log$
;       Revision 1.4  1999/04/28 15:13:37  gabriel
;            Keyword Iter new
;
;       Revision 1.3  1998/08/10 09:53:28  saam
;              now jitter scales with samplling period
;
;       Revision 1.2  1998/06/17 08:57:16  saam
;             largest index could not be used
;
;       Revision 1.1  1998/03/13 09:48:32  saam
;             creation
;
;
;-

FUNCTION imoment, A, i, mdev = mdev, sdev = sdev, min=min, max=max, iter=iter

   ;ON_ERROR, 2
   default, iter,0
   s = Size(A)



      IF s(0) LT i THEN Message, 'index too large for array'+string(s(0))
      IF i    GT 7 THEN Message, 'maximal index is 7'
      IF i    LT 1 THEN Message, 'index has to be greater equal 1'

      IF iter EQ 1 THEN BEGIN
         ;; wo ist denn der boese index
         ind = where(indgen(s(0)) NE (i-1))
         ;; dimensionen bestimmen fuer m , sdev , mdev ohne den zu mittelnden index
         new_s1 = [s(0),s(ind+1),4,4,product([s(ind+1),4])]
         new_s2 = [s(0)-1,s(ind+1),4,product(ind+1)]
         ;; arrays basteln
         m = make_array(size=new_s1)
         mdev = make_array(size=new_s2)
         sdev = make_array(size=new_s2)

         ;;hier tauschen wir den zu mittelnden index an die letzte stelle
         Atmp = utranspose(A,[ind,i-1])

         FOR x=0, s(ind(0)+1)-1 DO BEGIN
            Atmp2 = reform(Atmp(x,*,*,*,*,*,*))
            s1 = size(Atmp2)
            indtot = indgen(s1(0))
            IF s(0) GT 2 THEN BEGIN
               ;; hier gehts ab recursiv ! (Glaube ist besser als Wissen)
               ;; solange bis (size(a))(0) > 2 und immer nach den letzten index,den  haben wir ja oben getauscht
               m(x,*,*,*,*,*,*) = imoment(Atmp2,last(indtot)+1,/iter)
            END ELSE BEGIN
               ;; hier wenn (size(a))(0) = 2
               ;;stop
               IF SET(MIN) THEN BEGIN
                  geMin = WHERE(Atmp2 GE min, c)
                  IF c NE 0 THEN Atmp2 = Atmp2(geMin) ELSE Atmp2 = [!NONE]
               END
               IF SET(MAX) THEN BEGIN
                  ltMax = WHERE(Atmp2 LT max, c)
                  IF c NE 0 THEN Atmp2 = Atmp2(ltMax) ELSE Atmp2 = [!NONE]
               END
               m(x,*) = UMOMENT( Atmp2, SDEV=sd, MDEV=md)
               sdev(x) = sd
               mdev(x) = md
            ENDELSE 
         END
         
         RETURN, m
      END ELSE BEGIN
         
         m    = FltArr(s(i),4)
         mdev = FltArr(s(i))
         sdev = FltArr(s(i))
         FOR x=0,s(i)-1 DO BEGIN
            CASE i OF  
               1: Atmp = A(x,*) 
               2: Atmp = A(*,x,*) 
               3: Atmp = A(*,*,x,*) 
               4: Atmp = A(*,*,*,x,*) 
               5: Atmp = A(*,*,*,*,x,*) 
               6: Atmp = A(*,*,*,*,*,x,*) 
               7: Atmp = A(*,*,*,*,*,*,x) 
            ENDCASE
            IF SET(MIN) THEN BEGIN
               geMin = WHERE(Atmp GE min, c)
               IF c NE 0 THEN Atmp = Atmp(geMin) ELSE Atmp = [!NONE]
            END
            IF SET(MAX) THEN BEGIN
               ltMax = WHERE(Atmp LT max, c)
               IF c NE 0 THEN Atmp = Atmp(ltMax) ELSE Atmp = [!NONE]
            END
            
            
            m(x,*) = UMOMENT( Atmp, SDEV=sd, MDEV=md)
            sdev(x) = sd
            mdev(x) = md
         END
         
         RETURN, m
      ENDELSE
END
