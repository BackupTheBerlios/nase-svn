;+
; NAME:               OscFreq
;  
; PURPOSE:            Berechnet die mittlere Oscillationsfrequenz
;                     eines Signals.
;
; CATEGORY:           STATISTIC
;
; CALLING SEQUENCE:   r = OscFreq(signal [,/PLOT] [,/WAIT] [,CRIT=crit] [,OS=os] [,CL=cl])
;
; INPUTS:             signal: das zu analysierende Signals
;
; KEYWORD PARAMETERS: PLOT: plottet die Ergebnisse des Peakpickings (siehe PROCEDURE) zur
;                           Ueberpruefung
;                     WAIT: wartet nach dem Plot auf Tastendruck und zerstoert dann das Sheet
;                     CRIT: Criterium zum bestimmen der Peaks (siehe RELATIVCRIT bei UPeakPicker)
;                     OS  : Abtastung des Signals in 1./OS ms
;                     CL  : benutzter Bereich der Autocorrelation
;
; OUTPUTS:
;                     r Struktur:
;                       r.m_Hz , r.sd_Hz  : mittlere Rate und Standardabweichung des Signals in Herz 
;                       r.m_BIN, r.sd_BIN : mittlere Rate und Standardabweichung des Signals in BIN 
;
; COMMON BLOCKS:
;                     SH_OF: enthaelt das Sheet OF_1
;
; PROCEDURE:
;                     Es werden Differenzen aus den Maxima der 
;                     Autocorrelation des Signals berechnet.
;                     Differenzen die eine mittlere Breite ueber-/
;                     unterschreiten werden rausgeworfen.
;
; EXAMPLE:
;                     f1 = 40. ;Herz (signal hohe Amplitude)
;                     f2 = 70. ;Herz (rauschen niedrige Amplitude)
;                     t  =  1. ;1s Signal in 1ms Abtastung
;                     sig = sin(2*!Pi*f1*findgen(t*1000)/1000.)+randomu(seed,t*1000)+0.5*sin(2*!Pi*f2*findgen(t*1000)/1000.)
;                     print, OscFreq(sig, /PLOT)
;                         {      40.0000      1.48418      25.0000     0.894427}     
;
; SEE ALSO:           <A HREF="#UPEAKPICKER">UPeakPicker</A>
;
;
; MODIFICATION HISTORY:
;
;       $Log$
;       Revision 1.3  1998/08/23 12:52:05  saam
;             returns {0,0,0,0} if no peaks were found
;
;       Revision 1.2  1998/06/23 12:28:15  saam
;             bugfix
;
;       Revision 1.1  1998/06/01 14:42:48  saam
;             extended and documented for NASE
;
;       Revision 1.1  1998/05/26 14:13:52  saam
;             Initial revision
;
;-
FUNCTION OscFreq, _sig, PLOT=plot, WAIT=WAIT, CRIT=crit, OS=os, CL=cl, _EXTRA=e

   COMMON SH_OF, OFwins, OF_1

   sig =  _sig ; save original signal (dunno if upeakpicker modifies it, but it seems like)


   ;----->
   ;-----> ORGANIZE THE SHEETS
   ;----->
   IF (SIZE(OFwins))(1) EQ 0 THEN BEGIN
      OF_1 = DefineSheet(/Window, XSIZE=300, YSIZE=200, TITLE='Oscillation Frequency')
      OFwins = 1
   END



   ;----->
   ;-----> COMPLETE COMMAND LINE SYNTAX & DEFAULTS
   ;----->    
   Default, OS, 1.

   Default, Crit,     0.2 ; for upeakpicker
   Default, Delta ,  10   ; for upeakpicker

   Default, CL    , 128   ; Shift for ach
   
   Default, WAIT,   0   ; waiting for keystroke is default
   IF Keyword_Set(WAIT) THEN plot = 1



   factor = 1000.*OS
   
   ; get the ach
   t = Indgen(2*CL+1)-CL
   ac = CrossCor(sig, sig, CL)
   
   ; peak maxima
   UPeakPicker, ac, t, ym, tm, mn, DELTA=10, RELATIVCRIT=crit, _EXTRA=e

   IF mn LE 1 THEN BEGIN
      Print, "OSCFREQ: data isn't rhythmic"
      RETURN, {  m_hz : 0,$
                sd_hz : 0,$
                m_bin : 0,$
               sd_bin : 0 }
   END

   ; calculate differences between adjacent peaks
   pl = (tm-SHIFT(tm,1))(1:mn-1)
   meanbin = (umoment(pl, sdev=sdbin))(0)
   
   ; now sort out values which dont fit in mean+-sd
   ; this is needed because peakpicker find sometimes adjacent peaks which disturb 
   ; the calculation
   pn = pl
   ind = WHERE(pn GE meanbin-sdbin, c)
   IF c NE 0 THEN BEGIN
      pn = pn(ind)
      ind = WHERE(pn LE meanbin+sdbin, c)
      IF c NE 0 THEN pn = pn(ind)
   END

   ; and calculate again
   meanbin = (umoment(pn, sdev=sdbin))(0)
   


   sd = MAX([factor/meanbin-factor/(meanbin+sdbin), factor/(meanbin-sdbin)-factor/meanbin])
 
   IF Keyword_Set(PLOT) THEN BEGIN
      OpenSheet, OF_1
      plot, t, ac, XSTYLE=1, YSTYLE=1
      ymin = MIN(ac)
      ymax = MAX(ac)
      FOR i=0,mn-1 DO PlotS, [tm(i),tm(i)], [ymin,ymax], COLOR=RGB(0,0,200)
      XYOuts, 0.6, 0.80, /NORMAL, 'MEAN: '+StrCompress(meanbin, /REMOVE_ALL)+' BIN'
      XYOuts, 0.6, 0.75, /NORMAL, 'SD  : '+StrCompress(sdbin, /REMOVE_ALL)+' BIN'
      XYOuts, 0.6, 0.70, /NORMAL, 'MEAN: '+StrCompress(factor/meanbin, /REMOVE_ALL)+' Hz'
      XYOuts, 0.6, 0.65, /NORMAL, 'SD  : '+StrCompress(sd, /REMOVE_ALL)+' Hz'
      IF Keyword_Set(WAIT) THEN BEGIN
         Waiting
         DestroySheet, OF_1
      END
   END
   
   RETURN, {  m_hz  : factor/meanbin,$
              sd_hz  : sd,$
               m_bin : meanbin,$
              sd_bin : sdbin } 
END
