;+
; NAME: FZT
;
;
; PURPOSE:         The Fischer Z-transformation is a practical transformation to estimate the median and
;                  standard deviaton of a given data, which has values beetween 0..1, like the results of
;                  crosscorrellation or coherence. It transforms the data to an Gaussian distribution, also
;                  in the other direction.
;
; CATEGORY: MATH
;
;
; CALLING SEQUENCE:        result = fzt( data [,direction]) 
;
; 
; INPUTS:                  data:        The array to which the Fisher Z-Transform should be applied                
;
;
; OPTIONAL INPUTS:         direction:   Direction is a scalar indicating the direction of the transform, which is 
;                                       negative by convention for the forward transform, and positive for the 
;                                       inverse transform. If Direction is not specified, the forward transform is performed.
;                                       -1: from [0..1]-distribution to Gaussian-distribution
;                                        1: backward
;
; OUTPUTS:                 The result of this function is an array of the transformed data-array 
;
;
; EXAMPLE:                 data=[0,0,0,0,0.2,0.2,0.4,0.9,0.9,0.98,0.8,0.6,0.4,0.8,0.99,0.89]
;                          result=fzt(data,-1)
;                          m=umoment(result)
;                          mean=fzt(m,1)
;                          print,"MEDIAN:",mean(0),"VARIANCE:",mean(1)
;
; MODIFICATION HISTORY:
;
;
;     $Log$
;     Revision 2.2  2000/05/03 16:22:06  saam
;           improved error handling
;             + warns if data is too large or small
;             + warns if direction is illegal
;
;     Revision 2.1  1998/11/20 17:03:45  gabriel
;          Die Fisher Z-Trafo (von A.Bruns uebernommen)
;
;
;-


FUNCTION  FZT, data, direction

   Z = DOUBLE(data)
   Default, direction, -1
   Eins = 0.999999999D

   CASE direction OF
       -1: BEGIN
           IF (Max(Z) GT 1.d) OR (Min(Z) LT -1.d) THEN Console, 'data exeeds [-1,1]', /WARN
           ZuGross = WHERE(Z GT  Eins)
           IF  TOTAL(ZuGross) NE -1  THEN  Z(ZuGross) =  Eins
           ZuKlein = WHERE(Z LT -Eins)
           IF  TOTAL(ZuKlein) NE -1  THEN  Z(ZuKlein) = -Eins
           
           RETURN,  0.5 * ALOG( (1+Z) / (1-Z) )
           END
       1:  RETURN,  ( EXP(2*Z) - 1 ) / ( EXP(2*Z) + 1 )
       ELSE: Console, 'direction (second argument) must be 1 or -1', /FATAL
   END
END
