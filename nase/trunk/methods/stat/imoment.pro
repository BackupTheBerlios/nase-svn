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
;                     ITER: I ist dann der Iterationsindex (default: 0) und
;                           I kann alternativ auch ein Array von Indizes sein
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
;                     ;third example:
;                     X=randomu(s,10,10,30,20) ; here: x means an array of type (xdim,ydim,iter1,iter2)
;                     m=imoment(x,[3,4],/ITER)
;                    
;                     help,m
;                     ;idl returns:   FLOAT     = Array(10, 10, 4) 
;                     
;
;
;
; SEE ALSO:           <A HREF="#UMOMENT">UMoment</A>
;
; MODIFICATION HISTORY:
;
;       $Log$
;       Revision 1.6  2000/06/08 10:13:55  gabriel
;               ITER  keword supports arrays of indices
;
;       Revision 1.5  1999/09/13 12:56:20  saam
;             array called sdev conflicted with function sdev in
;             the alien directory and was therefore renamed to
;             sdeviation
;
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

FUNCTION imoment, A, i, mdev = mdev, sdev = sdeviation, min=min, max=max, iter=iter

   ON_ERROR, 2
   default, iter,0
   s = Size(A)


      IF s(0) LT max(i) THEN Message, 'index too large for array'+string(s(0))
      IF max(i)    GT 7 THEN Message, 'maximal index is 7'
      IF min(i)    LT 1 THEN Message, 'index has to be greater equal 1'
      IF N_ELEMENTS(i) GE s(0) THEN MESSAGE,'index has to many elements'
      IF N_ELEMENTS(i) GT 1 AND ITER EQ 0 THEN MESSAGE,'index array only with keyword ITER possible'
      IF iter EQ 1 THEN BEGIN
         ;; wo ist denn der boese index
         ind = -1
         FOR k=0, s(0)-1 DO BEGIN 
            index = where(k EQ i-1,count)
            IF count EQ 0   THEN ind = [ind,k]
         ENDFOR
         ind = ind(1:*)
         
         ;; dimensionen bestimmen fuer m , sdeviation , mdev ohne den zu mittelnden index
         new_s1 = [s(0),s(ind+1),4,4,product([s(ind+1),4])]
         new_s2 = [s(0)-1,s(ind+1),4,product(ind+1)]
         ;; arrays basteln
         m = make_array(size=new_s1)
         mdev = make_array(size=new_s2)
         sdeviation = make_array(size=new_s2)

         ;;hier tauschen wir den zu mittelnden index an die letzte stelle
         Atmp = utranspose(A,[ind,i-1])
         s_tmp = size(Atmp)
         CASE N_ELEMENTS(ind) OF
            1: Atmp = reform(Atmp,s_tmp(1),product([s(i)]))
            2: Atmp = reform(Atmp,s_tmp(1),s_tmp(2),product([s(i)]))
            3: Atmp = reform(Atmp,s_tmp(1),s_tmp(2),s_tmp(3),product([s(i)]))
            4: Atmp = reform(Atmp,s_tmp(1),s_tmp(2),s_tmp(3),s_tmp(4),product([s(i)]))
            5: Atmp = reform(Atmp,s_tmp(1),s_tmp(2),s_tmp(3),s_tmp(4),s_tmp(5),product([s(i)]))
            6: Atmp = reform(Atmp,s_tmp(1),s_tmp(2),s_tmp(3),s_tmp(4),s_tmp(5),s_tmp(6),product([s(i)]))
         ENDCASE
         ;;jetzt neue groesse
         
         s = size(Atmp)
         ;stop
         FOR x=0, s(1)-1 DO BEGIN
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
               
               sdeviation(x) = sd
               mdev(x) = md
            ENDELSE 
         END
         
         RETURN, m
      END ELSE BEGIN
         ;ind =  where(indgen(s(0)) NE (i-1))
         ;return,imoment(A, ind+1 , mdev = mdev, sdev = sdeviation, min=min, max=max,/iter)
         ;;old version
         IF 1 EQ 1 THEN BEGIN
            m    = FltArr(s(i),4)
            mdev = FltArr(s(i))
            sdeviation = FltArr(s(i))
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
               sdeviation(x) = sd
               mdev(x) = md
            END
         
            RETURN, m
         ENDIF
      ENDELSE
END
