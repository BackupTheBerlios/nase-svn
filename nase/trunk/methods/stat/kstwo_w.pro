;+
; NAME:
;  KSTwo_W
;
; VERSION:
;  $Id$
;
; AIM:
;  Calculate Kolmogorov-Smirnov test (statistics and p value).
;
; PURPOSE:
;  Compute Kolmogorov-Smirnov test for two independant samples
;  of different length. Checks hypothesis, if the two samples are drawn from
;  the same population. Returns Kolmogorov-Smirnov statistic d and
;  p value, respectively.
;  The name means K(olmogorov)S(mirnov)Two(populations test)_W(ashington)
;  It is modified from the code of an astronomer from Washington :-)
;
; CATEGORY:
;
;  Math
;  Statistics
;
; CALLING SEQUENCE:
;
;*    KS_Two_w, data1, data2, d, p
;
; INPUTS:
;  positional input arguments necessarily needed to use
;  the routine. They are written in lower case.
;  data1:: n element vector representing sample one
;  data2:: m element vector representing sample one  (in general m not equal n)
;  d:: named variable, Kolmogorov-Smirnov statistics (i.e. critical value for the test)
;  p:: named variable, p value
;
;
; OUTPUTS:
;  d:: Kolmogorov-Smirnov statistics (i.e. critical value for the test)
;  p:: p value
;
;
; SIDE EFFECTS:
;  d and p are changed, to return d and p value of the test
;
; RESTRICTIONS:
;  sample one and two have to be one dimensional vectors
;
; PROCEDURE:
;  Based on corrected (!) code from 'Numerical Recipes in C'.
;  Modified from code by  Han Wen (astro lib, Washington, August 1996).
;
; EXAMPLE:
;  Please provide a simple example here. Things
;  you specifiy on IDLs command line should be written
;  as
;* data1 = [1., 2., 1., 1., 2., 1., 2., 1., 3., 2., 5.]
;* data2 = [4., 2., 3., 2., 1., 4., 1., 5., 2., 4., 6., 3., 4., 2., 1.]
;* KS_Two_W, data1, data2, d, p
;* print, d,p
;  IDLs output should be shown using
;*  >0.37578  0.26142743
;
;-





function mPROBKS, Alam
;
;   Kolmogorov-Smirnov probability function

         EPS1 = 0.001
         EPS2 = 1.0e-8

         fac  = 2.0
         sum  =( termbf = 0.0 )

         a2   = -2.0*alam^2
         for j=1,100 do begin
              term = fac*EXP(double(a2)*j^2)
              sum  = sum + term
              if (ABS(term) le EPS1*termbf) or $
                 (ABS(term) le EPS2*sum) then return, sum
              fac       = -fac         ; Alternating signs in sum
              termbf    = abs(term)
         endfor
         return, 1.0
end


pro KSTwo_W, Dat1, Dat2, D, Prob

		 data1=dat1
		 data2=dat2

         n1   = N_ELEMENTS(Data1)
         n2   = N_ELEMENTS(Data2)

         j1   =( j2=1L )
         fn1  =( fn2=0.0 )

         Data1= Data1(SORT(Data1))
         Data2= Data2(SORT(Data2))
         en1  = float(n1)
         en2  = float(n2)
         D    = 0.0

         while (j1 le n1) and (j2 le n2) do begin     ; If we are not done...
              d1   = float(data1(j1-1))
              d2   = float(data2(j2-1))
              if (d1 le d2) then begin                ; Next step is in data1
                   fn1  = j1/en1
                   j1   = j1 + 1
              endif
              if (d2 le d1) then begin                ; Next step is in data2
                   fn2  = j2/en2
                   j2   = j2 + 1
              endif
              dt   = ABS(fn2-fn1)
              if (dt gt D) then D=dt
         endwhile

         en   = SQRT(en1*en2/(en1+en2))
         Prob = mPROBKS((en+0.12+0.11/en)*d)           ; Compute significance
end

