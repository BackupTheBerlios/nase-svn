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
;                     entsprechenden denen von UMoment
;
; CATEGORY:           STATISTICS.
;
; CALLING SEQUENCE:   Result = IMoment(X, i [,MDEV=mdev] [,SDEV=sdev] [,MIN=min] [,MAX=max])
;
; INPUTS:             X:  Eine n-dimensionale Matrix vom Typ integer, float or double.
;                     
;
; KEYWORD PARAMETERS: MDEV/SDEV: siehe UMoment
;                     MIN/MAX  : definiert eine untere und/oder eine obere Grenze fuer
;                                Messwerte die in die Berechnung einbezogen werden sollen.
;                                Ist in der Matrix X z.B. -1 als 'kein sinnvoller Wert'
;                                definiert setzt man z.B. MIN=0
;
; EXAMPLE:
;                     x = [[1,2,3,4,5],[0.9,2.1,3.5,4.1,5.0],[1.05,1.99,3.0,4.02,5.1]]
;                     m = IMoment(x,1) 
;                     print, 'MEANS:', m(*,0)
;                     print, 'VAR  :', m(*,1)   
;
; SEE ALSO:           <A HREF="#UMOMENT">UMoment</A>
;
; MODIFICATION HISTORY:
;
;       $Log$
;       Revision 1.2  1998/06/17 08:57:16  saam
;             largest index could not be used
;
;       Revision 1.1  1998/03/13 09:48:32  saam
;             creation
;
;
;-

FUNCTION imoment, A, i, mdev = mdev, sdev = sdev, min=min, max=max

  ON_ERROR, 2

  s = Size(A)
  IF s(0) LT i THEN Message, 'index too large for array'
  IF i    GT 7 THEN Message, 'maximal index is 7'
  IF i    LT 1 THEN Message, 'index has to be greater equal 1'

  
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
        IF c NE 0 THEN Atmp = Atmp(geMin) ELSE Atmp = [0]
     END
     IF SET(MAX) THEN BEGIN
        ltMax = WHERE(Atmp LT max, c)
        IF c NE 0 THEN Atmp = Atmp(ltMax) ELSE Atmp = [0]
     END
     

     m(x,*) = UMOMENT( Atmp, SDEV=sd, MDEV=md)
     sdev(x) = sd
     mdev(x) = md
  END
  
  RETURN, m
END

