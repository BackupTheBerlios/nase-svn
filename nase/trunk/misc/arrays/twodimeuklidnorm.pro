;+
; NAME: TwoDimEuklidNorm
;
; AIM: euclidian norm for multidimensional arrays
;
; PURPOSE: Euklidische Norm eines zwei- oder mehrdimensionalen
;          Arrays berechnen. Die IDL_Funktion Norm berechnet
;          diese nur fuer eindimensionale Arrays, bei zweidimensionalen
;          liefert sie die 'Unendlich'-Norm. (Wer weiss noch, wie die
;          definiert ist?)
;
; CATEGORY: MISCELLANEOUS / ARRAY OPERATIONS 
;
; CALLING SEQUENCE: n = TwoDimEuklidNorm(array)
;
; INPUTS: array: ein Array mit zwei oder mehr Dimensionen
;
; OUTPUTS: n: Die euklidische Norm des Arrays, oder in IDL gesagt:
;             n = Sqrt(Total(array^2))
;
; PROCEDURE: 1. Mehrdimensionales Array auf eine Dimension reformen.
;            2. Dann IDL-Norm zurueckgeben.
;
; EXAMPLE: a = indgen(5,5)
;          Print, Norm(a)
;         
;          IDL sagt: 110.000
;
;          b = Reform(a, N_Elements(a))
;          Print, Norm(b)
;
;          IDL sagt: 70.0000
;
;          Print, TwoDimEuklidNorm(a)
;
;          IDL sagt: 70.0000
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 1.2  2000/09/25 09:12:56  saam
;        * added AIM tag
;        * update header for some files
;        * fixed some hyperlinks
;
;        Revision 1.1  1998/06/14 16:35:23  thiel
;               Einfache Verpackung fuer die IDL-Norm-Routine.
;
;-

FUNCTION TwoDimEuklidNorm, m

   n = Reform(m, N_Elements(m))

   Return, Norm(n)

END
