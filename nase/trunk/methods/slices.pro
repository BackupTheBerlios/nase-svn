;+
; NAME:                SLICES
;
; PURPOSE:             Bildet fuer ein Array ein Sliding Array.
;                      Das Array wird in ueberlappende Teilarras zerlegt.
;                      Dies ist fuer gleitende Spektren, Korrelation,...
;                      notwendig. Datenpunkte, die nicht mehr in ein 
;                      vollstaendiges Fenster passen, werden ignoriert.
;                       
; CATEGORY:            STAT
;
; CALLING SEQUENCE:    s = SLICES(A [,SSIZE=ssize] [SSHIFT=sshift])
;
; INPUTS:              A : das zu zerschneidende Array
;
; KEYWORD PARAMETERS:  SSIZE       : die Groesse eines Zeitfensters (Default: 128ms)
;                      SSHIFT      : der Versatz des Fensters (Default: SSIZE/2)
;                      SAMPLEPERIOD: die Abtastung des Signals in Sekunden (Default: 0.001s)
;
; OUTPUTS:             ein Array das Form (data,slice_nr), das die Zeitschnitte enthaelt
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
;     Revision 1.1  1998/06/08 09:33:28  saam
;           hope it works
;
;
;-
FUNCTION Slices, A, SSIZE=ssize, SSHIFT=sshift, SAMPLEPERIOD=SAMPLEPERIOD

   On_Error, 2

   Default, SAMPLEPERIOD, 0.001
   OS = 1./(1000.*SAMPLEPERIOD)
   Default, SSIZE       , 128
   Default, SSHIFT      , SSIZE/2
   SSIZE = FIX(ssize*os)
   SSHIFT = FIX(sshift*os)

   S = SIZE(A)
   IF S(0) NE 1 THEN Message, 'this only works for one-dimensional array'
  
   steps = (S(1)-ssize)/sshift

   B =  Make_Array(ssize,steps+1,TYPE=S(2))
   FOR slice=0,steps DO BEGIN
      B(*,slice) = A(slice*SSHIFT: slice*SSHIFT+SSIZE-1)
      print, slice*SSHIFT, ':', slice*SSHIFT+SSIZE-1
   END
   RETURN, B
END
