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
;  correlation or firing rate analysis etc.
;  Data at the beginning and the end of the original array not
;  fitting into the first/last part are not returned.
;
; CATEGORY:
;  Array
;  Signals
;
; CALLING SEQUENCE: 
;*  s = Slices (a [,SSIZE=...] [,SSHIFT=...] [,SAMPLEPERIOD=...] 
;*                [,TVALUES=...] [,TINDICES=...] 
;*                [,SNR=...] [,SMAX=...] )
;
;*  smax = Slices (a [,SSIZE=...] [,SSHIFT=...] [,SAMPLEPERIOD=...] 
;*                 [,TVALUES=...] [,TINDICES=...]
;*                 /GETMAX )
; 
; INPUTS: 
;  a :: The array to be divided. If multidimensional, the array is
;      divided according to the first index of the array (usually the
;      time index).
;
; INPUT KEYWORDS:
;  GETMAX       :: <*>Slices</*> will just return the maximal number
;                  of possible slices.
;  SAMPLEPERIOD :: Duration of the sampling period / s (Default: 0.001s)
;  SNR          :: Specify the slice indices you actually want to calculate
;                  (single number or array). This option allows to
;                  generate the slices as they are needed. You can
;                  sequentially retrieve individual slices. This can
;                  be necessary if the complete slice array would bomb
;                  your memory.
;  SSIZE        :: Size of resulting parts / ms. (Default: 128ms)
;  SSHIFT       :: Distance between parts / ms. (Default: ssize/2)
;  TFIRST=0     :: Normally the first index of <*>a</*> is assumed to
;                  be the time index. Setting <*>TFIRST=0</*> enforces
;                  <C>Slices</C> to use the last array index as
;                  time. The result will then have the following
;                  dimensions (slice_nr, iteration, time). <B>BEWARE!</B> This option is
;                  unmaintained and inefficient and only kept for
;                  compatibility with old programs.
;
; OUTPUTS: 
;  s:: Array containing the parts of array a arranged like (time, slice_nr,
;      iteration) 
;
; OPTIONAL OUTPUTS: 
;  tvalues  :: returns starting times of all slices in ms
;  tindices :: returns starting time array indices of all slices
;  SMAX     :: returns the maximal number of slices that can be or are
;              generated. This information is 
;              especially useful, when working with the <*>SNR<*> option.  
;
; PROCEDURE:
;*  - Calculate number of parts needed for given ssize and sshift.
;*  - Determine size of array to be returned.
;*  - Compute starting indices of parts.
;*  - Store parts inside return array.
;
; EXAMPLE: 
; generate 3 spiketrains each 500ms long
;*a=RandomU(s,500,3) LT 0.1
;
; divide them, parts are 100ms and begin each 50ms (default for SSHIFT)
;*b=Slices(a, SSIZE=100)
;*help, b
;*;B               BYTE      = Array[100, 9, 3]
;b contains 9 slices of 3 spiketrains 100ms long
;*
; get maximal count of possible slices
;*print, Slices(a, SSIZE=100, /GETMAX) 
;*; 9
;extract slices number 3 and 5
;*C=Slices(a, SSIZE=100, SNR=[3,5])
;*; C    BYTE      = Array[100, 2, 3]
;
; SEE ALSO: <A>INSTANTRATE</A>.
;
;-
FUNCTION Slices, a, SSIZE=ssize, SSHIFT=sshift, SAMPLEPERIOD=SAMPLEPERIOD $
                 , TVALUES=tvalues, TINDICES=tindices, TFIRST=tfirst, SNR=_snr, SMAX=steps, GETMAX=getmax

   On_Error, 2

   Default, SAMPLEPERIOD, 0.001
   Default, TFIRST, 1
   OS = 1./(1000.*SAMPLEPERIOD)
   Default, SSIZE       , 128
   Default, SSHIFT      , SSIZE/2
   __SSIZE = LONG(ssize*os)
   __SSHIFT = LONG(sshift*os)
   
   IF ABS(__SSHIFT - (sshift*os)) GT SAMPLEPERIOD THEN $
     Console, "SSHIFT="+STR(SSHIFT)+"ms not compatible with SAMPLEPERIOD="+STR(1000*SAMPLEPERIOD)+"ms ...expect strange results", /WARN

   S = SIZE(a)   
   
   IF Keyword_Set(TFIRST) THEN BEGIN
       IF __SSIZE GT S(1) THEN Console, 'SSIZE too large.', /FATAL
       
       smax = (S(1)-__ssize)/__sshift + 1
       IF Keyword_Set(GETMAX) THEN return, smax
       IF Set(_SNR) THEN BEGIN
           IF NOT Ordinal(_SNR) THEN Console, 'slice numbers have to be ordinal', /FATAL
           IF MIN(_SNR) LT 0    THEN Console, 'slice number is less than zero', /FATAL
           IF Max(_SNR) GE smax THEN Console, 'slice number in SNR too large', /FATAL
           snr=[_snr]
           steps = N_Elements(snr)
       END ELSE BEGIN
           steps = smax
           snr = LIndgen(steps)
       END

       SB = [__SSIZE, steps]
       IF S(0) GT 1 THEN SB = [SB, S(2:S(0))] 
       
       tvalues = Float(snr)*__SSHIFT/OS
       tindices = snr*__SSHIFT

;       t = (LIndGen(__SSIZE*steps) MOD __SSIZE) + __SSHIFT*(LIndGen(__SSIZE*steps) / __SSIZE)
       t = (LIndGen(__SSIZE*steps) MOD __SSIZE) + __SSHIFT*REBIN(snr, steps*__SSIZE, /SAMPLE) 
       
       RETURN,  REFORM(a(t,*,*,*,*,*,*), SB, /OVERWRITE)

   END ELSE BEGIN

       DMsg, "assuming time in last index"
       Console, "leaving supported area, consider to NOT use TFIRST=0", /WARN
       IF Set(_SNR) THEN Console, 'keyword SNR is only supported for /TFIRST',/FATAL
       IF __SSIZE GT s(s(0)) THEN Message, 'SSIZE too large.'
 
       smax = (S(S(0))-__ssize)/__sshift + 1
       IF Keyword_Set(GETMAX) THEN return, smax
       steps = smax

       Sn = N_Elements(S)
       SB = [steps]
       IF S(0) GT 1 THEN SB = [SB, S(1:S(0)-1)] 
       SB = [SB, __SSIZE]
       SB = [S(0)+1, SB, S(S(0)+1), PRODUCT(SB)]
       b =  Make_Array(SIZE=SB)
       
       tvalues = FIndGen(steps)*__SSHIFT/OS
       tindices = LIndGen(steps)*__SSHIFT
       
       FOR slice=0,steps-1 DO BEGIN
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
