;+
; NAME:
;  SSpassmacher
;
; AIM:
;  Convert binary array into sparse version.
;  
; PURPOSE:
;  SSpassmacher converts an array containing 0s and 1s
;  (e.g. spiketrains) into a sprase version that saves indices of
;  elements set to 1.
;  Advantages: + Lower memeory consumption in case of few elements
;                being 1.
;              + Routines working with active elements dont have to
;                extract them if they are already provided by a
;                sparse array.
;  Disadvantage: - Large memory consumption for many elements being 1.
;   
; CATEGORY:
;  MISCELLANEOUS / ARRAY OPERATIONS
;  
; CALLING SEQUENCE:
;  ssparse = SSpassmacher( array [/DIMENSIONS] )
;  
; INPUTS:
;  array : A binary array.
;  
; KEYWORD PARAMETERS:
;  DIMENSIONS: Saves dimensions of array at the end of ssparse to
;              enable later reconstruction. 
;  
; OUTPUTS:
;  ssparse: Long array of the following structure:
;            ssparse(0): Number of elements NE 0 in array
;            ssparse(1): Total number of elements in array
;            ssparse(i) with i > 1: Indices of elements ne 0 in array.
;           If /DIMENSION is set:
;            ssparse(ssparse(0)+2): Number of dimensions in array
;            ssparse(ssparse(0)+2+j): jth dimension
;  
;  
; RESTRICTIONS:
;  Only binary information (elemnt is 0 or NE 0) is stored in
;  ssparse. For conversion of non-binary arrays use <A HREF="#SPASSMACHER">Spassmacher</A>.
;  
; EXAMPLE:
;  IDL> a=[[0,1,1,0,1,1,1,0,0],[0,1,0,0,1,1,0,1,0]]  
;  IDL> print, sspassmacher(a)
;             9          18           1           2           4           5
;             6          10          13          14          16
;  IDL> print, sspassbeiseite(sspassmacher(a))
;     0   1   1   0   1   1   1   0   0   0   1   0   0   1   1   0   1   0
;  IDL> print, sspassbeiseite(sspassmacher(a,/DIM),/DIM)
;     0   1   1   0   1   1   1   0   0
;     0   1   0   0   1   1   0   1   0
;
; SEE ALSO:
;  <A HREF="#SSPASSBEISEITE">SSpassBeiseite</A>, <A HREF="#SPASSMACHER">Spassmacher</A>, <A HREF="#SPASSBEISEITE">SpassBeiseite</A>.
;
; MODIFICATION HISTORY:
;
;       $Log$
;       Revision 1.2  2000/08/02 09:58:33  thiel
;           Forgot Log info.
;
;       Revision 1.1  2000/08/01 16:33:15  thiel
;           Moved from SIMU/LAYERS dir and added dimensions support.
;
;       Thu Sep 11 17:16:46 1997, Mirko Saam
;       <saam@ax1317.Physik.Uni-Marburg.DE>
;
;		Schoepfung und ausgiebiger Test, Version 1.1.2.1
;
;-



FUNCTION SSpassmacher, a, DIMENSIONS=dimensions

   Default, dimensions, 0

   s = Size(a)
   d = s(0) ; the number of dimensions of a

   actNeurons = WHERE(a NE 0, count)

   IF Keyword_Set(DIMENSIONS) THEN BEGIN
      ; make longer array with space for size information at the end
      ssparse = Make_Array(count+d+3, TYPE=3, /NOZERO)
      ; store size info at end of sparse array
      ssparse(count+2:count+d+2) = s(0:d)
   ENDIF ELSE BEGIN
      ; conventional sparse array
      ssparse = Make_Array(count+2, TYPE=3, /NOZERO)
   ENDELSE

   ssparse(0,0) = count
   ssparse(1,0) = s(d+2)        ; get total number of elements from Size

   IF count NE 0 THEN ssparse(2:count+1) = actNeurons
  
   RETURN, ssparse


END
