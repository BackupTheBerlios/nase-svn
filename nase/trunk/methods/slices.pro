;+
; NAME:                SLICES
;
; PURPOSE:             Bildet fuer ein Array ein Sliding Array.
;                      Das Array wird in ueberlappende Teilarrays zerlegt.
;                      Dies ist fuer gleitende Spektren, Korrelation,...
;                      notwendig. Datenpunkte, die nicht mehr in ein 
;                      vollstaendiges Fenster passen, werden ignoriert.
;                       
; CATEGORY:            STAT
;
; CALLING SEQUENCE:    s = SLICES(A [,SSIZE=ssize] [,SSHIFT=sshift] [,SAMPLEPERIOD=sampleperiod] $
;                                 [,TVALUES=tvalues] [,TINDICES=tindices] )
;
; INPUTS:              A : das zu zerschneidende Array. Ist das Array mehrdimensional, so
;                          wird der letzte Index als Zeit betrachtet!
;
; KEYWORD PARAMETERS:  SSIZE       : die Groesse eines Zeitfensters (Default: 128ms)
;                      SSHIFT      : der Versatz des Fensters (Default: SSIZE/2)
;                      SAMPLEPERIOD: die Abtastung des Signals in Sekunden (Default: 0.001s)
;
; OPTIONAL OUTPUTS:    TVALUES     : gibt die Anfangszeiten der einzelnen Slices zurueck
;                      TINDICES    : gibt die Arrayindizes der Anfangszeiten der einzelnen Slices zurueck
;
; OUTPUTS:             s: ein Array das Form (slice_nr, data), das die Zeitschnitte enthaelt
;
; EXAMPLE:             
;                      a = Indgen(1000)
;                      b = SLICES(a, SSIZE=100)
;                      help, b
;                         B               INT       = Array(100, 19)     
;
; MODIFICATION HISTORY:
;
;     $Log$
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
;
;-
FUNCTION Slices, A, SSIZE=ssize, SSHIFT=sshift, SAMPLEPERIOD=SAMPLEPERIOD, TVALUES=tvalues, TINDICES=tindices

   On_Error, 2

   Default, SAMPLEPERIOD, 0.001
   OS = 1./(1000.*SAMPLEPERIOD)
   Default, SSIZE       , 128
   Default, SSHIFT      , SSIZE/2
   SSIZE = LONG(ssize*os)
   SSHIFT = LONG(sshift*os)

   S = SIZE(A)   
  
   steps = (S(S(0))-ssize)/sshift
   tvalues = FLTARR(steps+1)
   tindices = LONARR(steps+1)

   Sn = N_Elements(S)
   SB = [steps+1]
   IF S(0) GT 1 THEN SB = [SB, S(1:S(0)-1)] 
   SB = [SB, SSIZE]
   SB = [S(0)+1, SB, S(S(0)+1), PRODUCT(SB)]
   B =  Make_Array(SIZE=SB)

   FOR slice=0,steps DO BEGIN
      tvalues(slice) = slice*SSHIFT/OS
      tindices(slice) = slice*SSHIFT
      CASE s(0) OF
	      1: B(slice,*)           = LExtrac( A, S(0), LindGen(SSIZE)+slice*SSHIFT )
	      2: B(slice,*,*)         = LExtrac( A, S(0), LindGen(SSIZE)+slice*SSHIFT )
	      3: B(slice,*,*,*)       = LExtrac( A, S(0), LindGen(SSIZE)+slice*SSHIFT )
	      4: B(slice,*,*,*,*)     = LExtrac( A, S(0), LindGen(SSIZE)+slice*SSHIFT )
	      5: B(slice,*,*,*,*,*)   = LExtrac( A, S(0), LindGen(SSIZE)+slice*SSHIFT )
	      6: B(slice,*,*,*,*,*,*) = LExtrac( A, S(0), LindGen(SSIZE)+slice*SSHIFT )
           ELSE: Message, 'array has tooo much dimensions'
        END
;      print, slice*SSHIFT, ':', slice*SSHIFT+SSIZE-1
   END

   RETURN, B
END
