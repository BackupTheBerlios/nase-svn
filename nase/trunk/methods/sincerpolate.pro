;+
; NAME:               Sincerpolate
;
; PURPOSE:            Interpoliert eine diskrete Zeitreihe (oder was
;                     auch immer) mit einer sin(x)/x Funktion.
;
; CATEGORY:           STAT
;
; CALLING SEQUENCE:   sSig = Sincerpolate(sig, delta [,KSIZE=KSIZE] [,SINC=sinc])
;
; INPUTS:             sig  : die zu interpolierende Zeitreihe
;                     delta: Abstand der urspruenglichen Signalwerte in der
;                            neuen, interpolierten Reihe. Vorher ist der ja 1, denn
;                            die Signale liegen bei 0,1,2,...; nach der Interpolation
;                            liegen diese Werte bei 0,delta,2*delta,3*delta
;                            Daher ist auch sSig = sig fuer delta=1 
;
; KEYWORD PARAMETERS: KSIZE: die Ausdehnung der Sin(x)/x-Funktion als Vielfaches von
;                            Delta. Damit gibt KSIZE an, ueber wieviele Signalwerte
;                            interpoliert wird. Da sin(x)/x an den Raendern abfaellt,
;                            aendert sich ab einem bestimmten KMAX nichts mehr an der
;                            Interpolation. Default ist 10.
;
; OUTPUTS:            sSig:  das interpolierte Signal mit N_Elements(sig)*delta 
;                            Elementen. Die urspruenglichen Abtastwerte liegen an den
;                            Stellen 0,delta,2*delta,...
;
; OPTIONAL OUTPUTS:   SINC:  der verwendete sin(x)/x-Kernel   
;
; PROCEDURE:          + Auffuellen des Signals mit Nullen
;                     + Faltung mit sin(x)/x (CONVOL mit EDGE_TRUNCATE-Option)
;
; EXAMPLE:
;          s = 0.2*Sin(FINDgen(100)/10.) + RandomN(seed, 100)
;          
;          FOR sincSize=1,20,2 DO BEGIN
;             FOR delta=1,10,2 DO BEGIN
;                !P.Multi = [0,0,3,0,0]
;                ss = Sincerpolate(s, delta, KSIZE=sincsize, SINC=sinc)
;                plot, sinc, TITLE='SIZE = '+STRCOMPRESS(sincSize,/REMOVE_ALL), XSTYLE=1
;                plot, s
;                plot, FindGen(N_Elements(s)*delta)/delta, ss, TITLE='DELTA = '+STRCOMPRESS(delta, /REMOVE_ALL)
;                help, sinc, s, ss
;                dummy = get_kbrd(1)
;             END
;          END
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 1.1  1998/02/25 10:50:02  saam
;           Mein Gott, der Header ist mal wieder
;           laenger als die Funktion
;
;
;-
FUNCTION Sincerpolate, signal, delta, KSIZE=KSIZE, SINC=sinc

   IF N_Params() NE 2 THEN Message, 'wrong number of parameters'
   IF delta LT 1      THEN Message, 'Delta has to be 1,2,3,...'


   signalC = N_Elements(signal)

   ; GENERATE THE SINC KERNEL
   Default, KSIZE, 10
   kernelSize = delta*2*KSIZE+1

   t = !Pi*(DIndgen(kernelSize)-kernelSize/2)/DOUBLE(Delta)
   sinc = sin(t)/t
   sinc(kernelSize/2) = 1.0


   ; FILL SIGNAL WITH ZEROs
   signalZ      = DblArr(delta, signalC)
   signalZ(0,*) = signal
   signalZ      = REFORM(signalZ, delta*signalC) 


   ; CONVOLVE SIGNAL AND KERNEL
   signalS = CONVOL(signalZ, sinc, /EDGE_TRUNCATE)
   
   RETURN,signalS
END
