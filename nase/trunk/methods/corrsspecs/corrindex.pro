;+
; NAME:               CorrIndex
;
; PURPOSE:            Diese Funktion berechnet den Correlationsindex einer Auto-
;                     oder Kreuzkorrelation (CH). Der Korrelationsindex ist die signifikante
;                     Flaeche unter dem mittelwertfreien, zentralen Korrelationspeak:
;
;                            __
;                            \
;                       CI = / ( CH(tau) - m )
;                            --
;                            tau
;                      ,mit
;                           CH(tau) > m + 2*sd   
; 
;                      ,wobei 
;                              m, sd : Mittelwert bzw. Standardabweichung von CCH ausserhalb
;                                      des zentralen Peaks
;                      Es gibt die Moeglichkeit, die o.g. Groessen graphisch darzustellen.
;                      Siehe auch: Juergens, Eckhorn in Biological Cybernetics 1997
;
; CATEGORY:           STAT
;
; CALLING SEQUENCE:   CI = CorrIndex(ch [,t] [, PEAKWIDTH=peakwidth] [,PLOT])
;
; INPUTS:             ch : ein Korrelationshistogramm, z.B. durch CrossCor erzeugt
;
; OPTIONAL INPUT:     t  : die zugehoerige Zeitachse, wird es nicht angegeben, so wird
;                          eine Achse von [-tau_max,tau_max] angenommen
;
; KEYWORD PARAMETERS: PEAKWIDTH: Gibt den Bereich an der zum zentral Peak gehoeren darf; dieser
;                                Parameter steuert hauptsaechlich den Einzugsbereich fuer die
;                                Bestimmung des Surround-Mittelwerts, Default ist 30 
;                     PLOT     : CH, CI, m, sd werden im aktuellen Fenster illustriert
;
; OUTPUTS:            CI       : der Korrelationsindex
;
; EXAMPLE:            
;                     length = 32
;                     signal = 0.5 + 0.5*sin(FIndgen(1000)/10.)+RandomN(seed,1000)
;                     ach    = CrossCor(signal, signal, length)
;                     t      = FIndGen(2*length+1)-length
;                     CI     = CorrIndex(ach, t, PEAKWIDTH=1, /PLOT) 
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 1.2  1998/06/14 15:52:28  saam
;           + now returns to calling procedure if an error occurs
;           + time axis is now optional
;
;     Revision 1.1  1997/11/03 11:33:40  saam
;           aus den Tiefen meiner IDL-Verzeichnisse geborgen und
;           dokumentiert
;
;
;-

FUNCTION CorrIndex, ch, t, PEAKWIDTH=peakwidth, PLOT=plot

   On_Error,2
   
   IF (N_PARAMS()    LT 2 )    THEN t=IndGen(N_Elements(ch))-N_ELements(ch)/2
   IF ((Size(ch))(0) NE 1 )    THEN Message, 'wrong format for signal'
   IF ((Size(t))(0)  NE 1 )    THEN Message, 'wrong format for signal'

   IF (NOT Keyword_Set(peakwidth)) THEN peakwidth = 30.0
   

   surr = ch( WHERE(ABS(t) GT peakwidth) )                       ; surround region (y-values)

   IF (MIN(surr) NE MAX(surr)) THEN BEGIN
      stat = MOMENT(surr, SDEV=sd) ; statistics, temp var., sd : standard deviation
      m = stat(0)               ; mean and ...
   END ELSE BEGIN
      m = surr(0)
      sd = 0.0
   END


   IF (Keyword_Set(Plot)) THEN BEGIN
         
      Plot, t, ch, /NODATA, XSTYLE=1, XRANGE=[MIN(t)-5, MAX(t)+5]

      surr_min = t(MAX( WHERE(t LT -peakwidth) ))
      surr_max = t(MIN( WHERE(t GT  peakwidth) ))
      
      PolyFill, [ MIN(t), surr_min, surr_min, MIN(t), MIN(t)]   , [ m+2*sd, m+2*sd, m-2*sd, m-2*sd, m+2*sd], NOCLIP=0, COLOR=RGB(50,50,250)
      PolyFill, [ surr_max, MAX(t), MAX(t), surr_max, surr_max] , [ m+2*sd, m+2*sd, m-2*sd, m-2*sd, m+2*sd], NOCLIP=0, COLOR=RGB(50,50,250)
      PlotS, [MIN(t), surr_min], [m, m], COLOR=RGB(128,128,128)
      PlotS, [surr_max, MAX(t)], [m, m], COLOR=RGB(128,128,128)
   END


   peak_index = WHERE( ch GT m+2*sd, count )                            ; significant peaks (indices)
   IF (count NE 0) THEN BEGIN
      sig_peaks = WHERE( ABS(t(peak_index)) LE peakwidth, count2 )
      IF count2 NE 0 THEN BEGIN
         peak_index = peak_index(sig_peaks) ; sig. peaks in peakwidth (indices)

         CI = TOTAL(ch(peak_index)-m) 
      
         IF (Keyword_Set(Plot)) THEN BEGIN
            PolyFill, [t(MIN(peak_index)),t(peak_index), t(MAX(peak_index)), t(MIN(peak_index))], [0,ch(peak_index),0,0], COLOR=RGB(250,50,50)
         END
      END ELSE CI = 0.0
   END ELSE CI = 0.0
   
   IF (Keyword_Set(Plot)) THEN BEGIN
      OPlot, t, ch
      XYOuts, 0.9, 0.80, 'median: '+STRING(m) , ALIGNMENT=1.0, /NORMAL
      XYOuts, 0.9, 0.75, 'sdev  : '+STRING(sd), ALIGNMENT=1.0, /NORMAL
      XYOuts, 0.9, 0.70, 'CI    : '+STRING(CI), ALIGNMENT=1.0, /NORMAL
   END

   RETURN, CI
END
