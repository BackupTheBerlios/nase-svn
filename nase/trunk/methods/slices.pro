;+
; NAME:
;  SLICES
;
; PURPOSE:
;  Divides an array into parts of a fixed length and with fixed
;  distance and returns these parts in another array so that they can
;  be processed separately. Parts may overlap depending on the chosen
;  size and distance. The result can then be used for sliding spectra
;  correlation or firing rate analysis etc. In those cases, the last
;  index of the original array is considered to be the "time
;  index". Data at the beginning and the end of the original array not
;  fitting into the first/last part are not returned.
;
; CATEGORY:
;  METHODS
;
; CALLING SEQUENCE: 
;  s = Slices (a [,SSIZE=ssize] [,SSHIFT=sshift] [,SAMPLEPERIOD=sampleperiod] $
;                [,TVALUES=tvalues] [,TINDICES=tindices] )
; 
; INPUTS: 
;  a : The array to be divided. If multidimensional, the array is
;      divided according to the last index (the time index).
;
; OPTIONAL INPUTS:
;  ssize        : Size of resulting parts / ms. (Default: 128ms)
;  sshift       : Distance between parts / ms. (Default: ssize/2)
;  sampleperiod : Duration of the sampling period / s (Default: 0.001s)
;
; OUTPUTS: 
;  s: Array containing the parts of array a arranged like (slice_nr,
;     data)
;
; OPTIONAL OUTPUTS: 
;  tvalues  : Returns the times/ms at which parts start.
;  tindices : Returns starting time array indices of the parts.
;
; PROCEDURE:
;  - Calculate number of parts needed for given ssize and sshift.
;  - Determine size of array to be returned.
;  - Compute starting indices of parts.
;  - Store parts inside return array.
;
; EXAMPLE: 
;  a=RandomU(s,3,500) LT 0.1
;  ; generate 3 spiketrains each 500ms long
;  b=Slices(a, SSIZE=100)
;  ; divide them, parts are 100ms and begin each 50ms (default for SSHIFT)
;  help, b
;  B               BYTE      = Array[9, 3, 100]
;  b contains 9 slices of 3 spiketrains 100ms long
;  Trainspotting, Reform(b(3,*,*))
;  ; show slice no. 3          
;
; SEE ALSO: <A HREF="./signals/#INSTANTRATE">Instantrate</A>.
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 1.9  2000/09/27 15:59:23  saam
;     service commit fixing several doc header violations
;
;     Revision 1.8  2000/03/14 17:43:14  thiel
;         Added timeunit description in header.
;
;     Revision 1.7  2000/02/23 12:30:47  thiel
;         Optimized. LEXTRAC is no longer used. Header translated.
;
;     Revision 1.6  1998/07/28 12:54:19  gabriel
;          SSIZE SSHIFT jetzt lokale Variablen
;
;     Revision 1.5  1998/06/23 11:15:08  saam
;           fixed problems with 1d-Slices
;
;     Revision 1.4  1998/06/10 12:38:33  saam
;           added multidimensional array support
;
;     Revision 1.3  1998/06/08 10:06:06  saam
;           + changed output format: a(slice,data)
;           + new keywords TVALUES, TINDICES
;
;     Revision 1.2  1998/06/08 09:36:53  saam
;           debug messages removed
;
;     Revision 1.1  1998/06/08 09:33:28  saam
;           hope it works
;
;-


FUNCTION Slices, a, SSIZE=ssize, SSHIFT=sshift, SAMPLEPERIOD=SAMPLEPERIOD $
                 , TVALUES=tvalues, TINDICES=tindices

;   On_Error, 2

   Default, SAMPLEPERIOD, 0.001
   OS = 1./(1000.*SAMPLEPERIOD)
   Default, SSIZE       , 128
   Default, SSHIFT      , SSIZE/2
   __SSIZE = LONG(ssize*os)
   __SSHIFT = LONG(sshift*os)

   S = SIZE(a)   
   

   IF __SSIZE GT S(1) THEN Console, 'SSIZE too large.', /FATAL
 
   steps = (S(1)-__ssize)/__sshift + 1

   SB = [__SSIZE, steps]
   IF S(0) GT 1 THEN SB = [SB, S(2:S(0))] 
;   SB = [S(0)+1, SB, S(S(0)+1), PRODUCT(SB)]
;   b =  Make_Array(SIZE=SB, /NOZERO)
   
   tvalues = FIndGen(steps)*__SSHIFT/OS
   tindices = LIndGen(steps)*__SSHIFT

;   FOR slice=0,steps-1 DO BEGIN
;      start = slice*__SSHIFT
;      b(*,slice,*,*,*,*,*,*) = a(start:start+__SSIZE-1,*,*,*,*,*,*)
;   END

   t = (LIndGen(__SSIZE*steps) MOD __SSIZE) + __SSHIFT*(LIndGen(__SSIZE*steps) / __SSIZE)

   RETURN,  REFORM(a(t,*,*,*,*,*,*), SB, /OVERWRITE)

END
