;+
; NAME:
;  Slices()
;
; VERSION:
;   $Id$
; 
; AIM:
;   Divides an array into parts of a fixed length and fixed overlap
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
;  Array
;  Signals
;
; CALLING SEQUENCE: 
;*  s = Slices (a [,SSIZE=...] [,SSHIFT=...] [,SAMPLEPERIOD=...] 
;*                [,TVALUES=...] [,TINDICES=...] [,/TFIRST] )
; 
; INPUTS: 
;  a :: The array to be divided. If multidimensional, the array is
;      divided according to the time index (first index in array,
;      if <*>/TFIRST</*> is set, last index else).
;
; INPUT KEYWORDS:
;  SSIZE        :: Size of resulting parts / ms. (Default: 128ms)
;  SSHIFT       :: Distance between parts / ms. (Default: ssize/2)
;  SAMPLEPERIOD :: Duration of the sampling period / s (Default: 0.001s)
;  TFIRST       :: Normally the last index of <*>a</*> is assumed to
;                  be the time index. Setting <*>TFIRST</*> enforces
;                  <C>Slices</C> to use the first array index as time.
;
; OUTPUTS: 
;  s:: Array containing the parts of array a arranged like (slice_nr,
;      iteration, time) or (time, slice_nr, iteration) if <*>TFIRST</*> is set.
;
; OPTIONAL OUTPUTS: 
;  tvalues  :: Returns the times/ms at which parts start.
;  tindices :: Returns starting time array indices of the parts.
;
; PROCEDURE:
;*  - Calculate number of parts needed for given ssize and sshift.
;*  - Determine size of array to be returned.
;*  - Compute starting indices of parts.
;*  - Store parts inside return array.
;
; EXAMPLE: 
;* a=RandomU(s,3,500) LT 0.1
;* ; generate 3 spiketrains each 500ms long
;* b=Slices(a, SSIZE=100)
;* ; divide them, parts are 100ms and begin each 50ms (default for SSHIFT)
;* help, b
;* >B               BYTE      = Array[9, 3, 100]
;* ; b contains 9 slices of 3 spiketrains 100ms long
;* Trainspotting, Reform(b(3,*,*))
;* ; show slice no. 3          
;
; SEE ALSO: <A>INSTANTRATE</A>.
;
;-
FUNCTION Slices, a, SSIZE=ssize, SSHIFT=sshift, SAMPLEPERIOD=SAMPLEPERIOD $
                 , TVALUES=tvalues, TINDICES=tindices, TFIRST=tfirst

   On_Error, 2

   Default, SAMPLEPERIOD, 0.001
   OS = 1./(1000.*SAMPLEPERIOD)
   Default, SSIZE       , 128
   Default, SSHIFT      , SSIZE/2
   __SSIZE = LONG(ssize*os)
   __SSHIFT = LONG(sshift*os)

   S = SIZE(a)   
   
   IF Keyword_Set(TFIRST) THEN BEGIN
       IF __SSIZE GT S(1) THEN Console, 'SSIZE too large.', /FATAL
       
       steps = (S(1)-__ssize)/__sshift + 1
       
       SB = [__SSIZE, steps]
       IF S(0) GT 1 THEN SB = [SB, S(2:S(0))] 
       
       tvalues = FIndGen(steps)*__SSHIFT/OS
       tindices = LIndGen(steps)*__SSHIFT
       
       t = (LIndGen(__SSIZE*steps) MOD __SSIZE) + __SSHIFT*(LIndGen(__SSIZE*steps) / __SSIZE)
       
       RETURN,  REFORM(a(t,*,*,*,*,*,*), SB, /OVERWRITE)

   END ELSE BEGIN

       DMsg, "assuming time in last index"
       Console, "would you mind assuming time as the first array index?"
       IF __SSIZE GT s(s(0)) THEN Message, 'SSIZE too large.'
 
       steps = (S(S(0))-__ssize)/__sshift
       
       Sn = N_Elements(S)
       SB = [steps+1]
       IF S(0) GT 1 THEN SB = [SB, S(1:S(0)-1)] 
       SB = [SB, __SSIZE]
       SB = [S(0)+1, SB, S(S(0)+1), PRODUCT(SB)]
       b =  Make_Array(SIZE=SB)
       
       tvalues = FIndGen(steps+1)*__SSHIFT/OS
       tindices = LIndGen(steps+1)*__SSHIFT
       
       FOR slice=0,steps DO BEGIN
           start = slice*__SSHIFT
           CASE s(0) OF
               1: b(slice,*)           = a(start:start+__SSIZE-1)
               2: b(slice,*,*)         = a(*,start:start+__SSIZE-1)
               3: b(slice,*,*,*)       = a(*,*,start:start+__SSIZE-1)
               4: b(slice,*,*,*,*)     = a(*,*,*,start:start+__SSIZE-1)
               5: b(slice,*,*,*,*,*)   = a(*,*,*,*,start:start+__SSIZE-1)
               6: b(slice,*,*,*,*,*,*) = a(*,*,*,*,*,start:start+__SSIZE-1)
               
               ELSE: Message, 'array has tooo much dimensions'
           END
       END
       
       RETURN, b
   END

END
