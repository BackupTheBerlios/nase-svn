;+
; NAME:
;  IMoment()
;
; VERSION:
;  $Id$
;
; AIM:
;  Compute mean, variance, ... over given index in a multidimensional array.
;
; PURPOSE:
;  <C>IMoment()</C> computes the first four moments of a given
;  multidimensional distribution for one of the dimensions.<BR>
;  A typical example is to determine the mean and variance of a
;  function <*>y = y(x)</*> using several iterations. Let data be
;  supplied in the format <*>y(x,iter)</*>. <*>IMoment(y,1)</*> now
;  returns the desired values depending on <*>x</*>. Calling
;  conventions are the same as in <A>UMoment()</A>.
;
; CATEGORY:
;  Statistics
;  Signals
;
; CALLING SEQUENCE:
;* result=IMoment(x, i 
;*                [,MDEV=...] [,SDEV=...] 
;*                [,MIN=...] [,MAX=...] 
;*                [,ORDER=...] [,ITER=...] )
;
; INPUTS:
;  x:: An n-dimenional matrix of integer-, float-, or double type.
;  i:: Index over which moments are computed (see also keyword <*>ITER</*>).
;
; INPUT KEYWORDS:
;  MDEV, SDEV:: See <A>UMoment</A>.
;  MIN, MAX:: Set lower and upper boundary to exclude lower and higher
;             entries of <*>x</*> from being considered in the
;             calculation. If, for example, <*>-1</*> is contained in
;             <*>x</*>, but no reasonable value, exclude it by setting
;             <*>MIN=0</*>.
;  ORDER:: Maximum order of the moment to be calculated (default: 3).
;  ITER:: If <*>ITER</*> is set, <*>i</*> is interpreted as the
;         iteration index, <*>i</*> may also be an array of indces.
;
; OUTPUTS:
;  result:: Moments of the distribution contained in
;           <*>x</*>. Undefined values are returned as <*>!NONE</*>.
;
; EXAMPLE:
; First example:
;* x = [[1,2,3,4,5],[0.9,2.1,3.5,4.1,5.0],[1.05,1.99,3.0,4.02,5.1]]
;* m = IMoment(x,1)
;* Print, 'MEAN:', m(*,0)
;* Print, 'VAR :', m(*,1)
;*
; Second example:
;* x=RandomU(s,10,10,30) ; here: x means an array of type (xdim,ydim,iter)
;* m=IMoment(x,3,/ITER)
;* help,m
;*> <Expression>    FLOAT     = Array(10, 10, 4)
;* SurfIt,m(*,*,0) ; plots the mean of the 2-dimensional iterations
;*
;* m=IMoment(x,3,/ITER,order=1) ;calculate only the mean and the variance
;* help,m
;*> <Expression>   FLOAT     = Array[10, 10, 2]
;*
; Third example:
;*  x=RandomU(s,10,10,30,20) ; here: x means an array of type (xdim,ydim,iter1,iter2)
;*  m=IMoment(x,[3,4],/ITER)
;*  help,m
;*> FLOAT     = Array(10, 10, 4) 
; 
; SEE ALSO:
;  <A>UMoment</A>.
;
;-

FUNCTION imoment, A, i, ORDER=order,  mdev = mdev, sdev = sdeviation, min=min, max=max, iter=iter

   ON_ERROR, 2
   default, iter,0
   default, order, 3

   s = Size(A)


      IF s(0) LT max(i) THEN Console, /fatal, 'index too large for array'+string(s(0))
      IF max(i)    GT 7 THEN Console, /fatal, 'maximal index is 7'
      IF min(i)    LT 1 THEN Console,/fatal, 'index has to be greater equal 1'
      IF N_ELEMENTS(i) GE s(0) THEN Console, /fatal,'index has to many elements'
      IF N_ELEMENTS(i) GT 1 AND ITER EQ 0 THEN Console, /fatal,'index array only with keyword ITER possible'

      IF iter EQ 1 THEN BEGIN
         ;; wo ist denn der boese index
         ind = -1
         FOR k=0l, s(0)-1 DO BEGIN 
            index = where(k EQ i-1,count)
            IF count EQ 0   THEN ind = [ind,k]
         ENDFOR
         ind = ind(1:*)
         
         ;; dimensionen bestimmen fuer m , sdeviation , mdev ohne den zu mittelnden index
         new_s1 = [s(0),s(ind+1),order+1,4,product([s(ind+1),order+1])]
         new_s2 = [s(0)-1,s(ind+1),4,product(ind+1)]
         ;; arrays basteln
         m = make_array(size=new_s1)

         if order GT 0 then begin
            mdev = make_array(size=new_s2)
            sdeviation = make_array(size=new_s2)
         endif

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
         FOR x=0l, s(1)-1 DO BEGIN
            Atmp2 = reform(Atmp(x,*,*,*,*,*,*))
            s1 = size(Atmp2)
            indtot = indgen(s1(0))
            
            IF s(0) GT 2 THEN BEGIN
               ;; hier gehts ab recursiv ! (Glaube ist besser als Wissen)
               ;; solange bis (size(a))(0) > 2 und immer nach den letzten index,den  haben wir ja oben getauscht
               m(x,*,*,*,*,*,*) = imoment(Atmp2,last(indtot)+1,/iter, order=order)
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
               m(x,*) = UMOMENT( Atmp2, SDEV=sd, MDEV=md, order=order)
               if order GT 0 then begin
                  sdeviation(x) = sd
                  mdev(x) = md
               endif
            ENDELSE 
         END
         
         RETURN, m
      END ELSE BEGIN
         ;ind =  where(indgen(s(0)) NE (i-1))
         ;return,imoment(A, ind+1 , mdev = mdev, sdev = sdeviation, min=min, max=max,/iter)
         ;;old version
         IF 1 EQ 1 THEN BEGIN
            m    = FltArr(s(i),order+1)
            mdev = FltArr(s(i))
            sdeviation = FltArr(s(i))
            FOR x=0l,s(i)-1 DO BEGIN
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
               
               
               m(x,*) = UMOMENT( Atmp, SDEV=sd, MDEV=md, order=order)
               if order gt 0 then begin
                  sdeviation(x) = sd
                  mdev(x) = md
               endif
            END
         
            RETURN, m
         ENDIF
      ENDELSE
END
