;+
; NAME:                MUA
;
; PURPOSE:             Leitet aus einer Neuronenschicht an waehlbaren
;                      Positionen ein MUA Signal ab. Dazu
;                      werden die Aktionspotentiale aller Neurone in
;                      einer waehlbaren Umgebung gewichtet und addiert.
;
; CATEGORY:            STAT SIGNAL
;
; CALLING SEQUENCE:    MUAS = MUA( nt, recSites { ,CONST=const | ,HMW_X2=xmw_x2 } [,ROI=roi] )
;
; INPUTS:              nt      : 3d-Array, das den Zeitverlauf der Membranpotentiale 
;                                enthaelt. Die Dimensionen sind (HOEHE, BREITE, ZEIT).
;                      recSites: ein Liste von Ableitorten der Form [[x1,y1],[x2,y2],..]
;
; KEYWORD PARAMETERS:  CONST : konstante Gewichtung (=1) aller Membranpotentiale
;                              mit maximaler Distanz const vom jeweiligen Ableitort.
;                      HMW_X2: quadratisch abfallende Gewichtung der Potentiale
;                              mit einer Halbwertsbreite von hmw_x2.
;                      ROI   : nach Aufruf von LFP enthaelt ROI die verwendeten Masken
;                              fuer die Gewichtung der LFP's. Dimension (SIGNAL_NR,HOEHE,BREITE)
;                       
; OUTPUTS:             MUAS  : Array das die MUA-Signale fuer die Ableitorte enthaelt.
;                              Dimension: (ABLEITINDEX, ZEIT)
;
; EXAMPLE:
;                      nt = FIX(30*RandomN(seed,10,10,1000))
;                      MUAS = MUA(nt, [[0,0], [5,5]], HMW_X2=2)
;                      plot, REFORM(MUAS(0,*))
;                      oplot, REFORM(MUAS(1,*))-50., LINESTYLE=2                      
;    
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 1.2  1998/04/01 17:35:09  saam
;           only two recording sites were handled
;           corrected -> now it hopefully with 1..n
;
;     Revision 1.1  1998/04/01 16:27:28  saam
;           created by modification of lfp.pro
;           revision 1.3
;
;
;-
FUNCTION MUA, mt, list, CONST=const, HMW_X2=hmw_x2, ROI=roi

   Default, radius, 5

   IF N_Params() NE 2 THEN Message, 'wrong number of arguments'

   mtS    = SIZE(mt)

   listS  = SIZE(list)
   IF listS(0) EQ 1 AND N_Elements(list) EQ 2 THEN BEGIN
      list = REFORM(list, 2, 1, /OVERWRITE)
      listS = SIZE(list)
   END

   maxROI = listS(2)  
   maxT   = mtS(3)

   IF listS(0) NE 2 THEN Message, 'wrong format for second argument'
   IF mtS(0)   NE 3 THEN Message, 'wrong format for first argument'


   roiSigs = DblArr(maxROI, maxT)
   
   
   ; -----> GET THE INTEGRATION AREAS
   print, 'MUA: getting integration areas...'
   print, ' '
   ROI = DblArr(maxROI, mtS(1), mtS(2))
   FOR i=0, maxROI-1 DO BEGIN
      IF Set(CONST) THEN BEGIN
         print, !KEY.UP, 'MUA: using constant weighting with radius ',STRCOMPRESS(const,/REMOVE_ALL)
         tmpArr = Make_Array(mtS(1), mtS(2), /INT, VALUE=1)
         tmpArr = CutTorus(tmpArr, const, X_CENTER=list(0,i)-mtS(1)/2, Y_CENTER=list(1,i)-mtS(2)/2)
         ROI(i,*,*) = tmpArr
      ENDIF ELSE IF Set(hmw_x2) THEN BEGIN
         print, !KEY.UP, 'MUA: using x^(-2) weighting with HMW  ',STRCOMPRESS(hmw_x2,/REMOVE_ALL)
         tmpArr = SHIFT(DIST(mtS(1), mtS(2)), list(0,i), list(1,i) )
         tmpArr = 1./(HMW_X2^2)*(tmpArr^2)
         tmpArr = 1./(1.+tmpArr)
         ROI(i,*,*) = tmpArr/MAX(tmpArr)
      ENDIF ELSE Message, 'unknown integration method or no method specified'
   ENDFOR
   
   ; -----> INTEGRATE REGIONS FOR EACH TIMESTEP
   print, 'MUA: integrating potentials for '+STRCOMPRESS(maxROI,/REMOVE_ALL)+' recording site(s)'
   print, '   '
   FOR t=0l, maxT-1 DO BEGIN
      FOR i=0, maxROI-1 DO BEGIN
         roiSigs(i, t) = TOTAL( REFORM(mt(*,*,t))*REFORM(ROI(i,*,*)) )
      ENDFOR
      IF (t MOD (maxT/20)) EQ 0 THEN print, !Key.UP, 'MUA: processing... '+STRCOMPRESS(FIX(t/FLOAT(maxT)*100.), /REMOVE_ALL)+' %'
   ENDFOR
      
   RETURN, roiSigs
END
