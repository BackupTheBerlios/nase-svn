;+
; NAME:                LFP
;
; PURPOSE:             Leitet aus einer Neuronenschicht an waehlbaren
;                      Positionen ein LFP-aehnliches Signal ab. Dazu
;                      werden die Membranpotentiale aller Neurone in
;                      einer waehlbaren Umgebung gewichtet, addiert und
;                      tiefpassgefiltert.
;
; CATEGORY:            STAT SIGNAL
;
; CALLING SEQUENCE:    LFPS = LFP( mt, recSites { ,CONST=const | ,HMW_X2=xmw_x2 } )
;
; INPUTS:              mt      : 3d-Array, das den Zeitverlauf der Membranpotentiale 
;                                enthaelt. Die Dimensionen sind (HOEHE, BREITE, ZEIT).
;                      recSites: ein Liste von Ableitorten der Form [[x1,y1],[x2,y2],..]
;
; KEYWORD PARAMETERS:  CONST:  konstante Gewichtung (=1) aller Membranpotentiale
;                              mit maximaler Distanz const vom jeweiligen Ableitort.
;                      HMW_X2: quadratisch abfallende Gewichtung der Potentiale
;                              mit einer Halbwertsbreite von hmw_x2.
; OUTPUTS:             LFPS  : Array das die LFP-Signale fuer die Ableitorte enthaelt.
;                              Dimension: (ABLEITINDEX, ZEIT)
;
; EXAMPLE:
;                      mt = 5+RandomN(seed,10,10,1000)
;                      LFPS = LFP(mt, [[0,0], [5,5]], HMW_X2=2)
;                      plot, REFORM(LFPS(0,*))
;                      oplot, REFORM(LFPS(1,*))-50., LINESTYLE=2                      
;    
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 1.1  1998/03/03 19:03:14  saam
;           a birth
;
;
;-
FUNCTION LFP, mt, list, CONST=const, HMW_X2=hmw_x2

   Default, radius, 5

   IF N_Params() NE 2 THEN Message, 'wrong number of arguments'

   mtS    = SIZE(mt)
   listS  = SIZE(list)
   maxROI = listS(1)  
   maxT   = mtS(3)

   IF listS(0) NE 2 THEN Message, 'wrong format for second argument'
   IF mtS(0)   NE 3 THEN Message, 'wrong format for first argument'


   roiSigs = DblArr(listS(1), maxT)
   
   
   ; -----> GET THE INTEGRATION AREAS
   print, 'LFP: getting integration areas...'
   ROI = DblArr(maxROI, mtS(1), mtS(2))
   FOR i=0, maxROI-1 DO BEGIN
      IF Set(CONST) THEN BEGIN
         print, 'LFP: using constant weighting with radius ',STRCOMPRESS(const,/REMOVE_ALL)
         tmpArr = Make_Array(mtS(1), mtS(2), /INT, VALUE=1)
         tmpArr = CutTorus(tmpArr, const, X_CENTER=list(0,i)-mtS(1)/2, Y_CENTER=list(1,i)-mtS(2)/2)
         ROI(i,*,*) = tmpArr
      ENDIF ELSE IF Set(hmw_x2) THEN BEGIN
         print, 'LFP: using x^(-2) weighting with HMW  ',STRCOMPRESS(hmw_x2,/REMOVE_ALL)
         tmpArr = SHIFT(DIST(mtS(1), mtS(2)), list(0,i), list(1,i) )
         tmpArr = 1./(HMW_X2^2)*(tmpArr^2)
         tmpArr = 1./(1.+tmpArr)
         ROI(i,*,*) = tmpArr/MAX(tmpArr)
      ENDIF ELSE Message, 'unknown integration method or no method specified'
      help, roi(i,*,*)
      utvscl, REFORM(ROI(i,*,*)), STRETCH=20
      dummy = get_kbrd(1)
   ENDFOR
   
   ; -----> INTEGRATE REGIONS FOR EACH TIMESTEP
   print, 'LFP: integrating potentials for '+STRCOMPRESS(listS(1),/REMOVE_ALL)+' recording site(s)'
   print, '   '
   FOR t=0, maxT-1 DO BEGIN
      FOR i=0, maxROI-1 DO BEGIN
         roiSigs(i, t) = TOTAL( REFORM(mt(*,*,t))*REFORM(ROI(i,*,*)) )
      ENDFOR
      IF (t MOD (maxT/20)) EQ 0 THEN print, !Key.UP, 'LFP: processing... '+STRCOMPRESS(FIX(t/FLOAT(maxT)*100.), /REMOVE_ALL)+' %'
   ENDFOR
      

   ; -----> LOW PASS FILTERING WITH 100Hz CUTOFF-FREQUENCY (1/5*Nyquist)
   LFPS = DblArr(listS(1), maxT)
   filter =  Digital_Filter(0.0, 0.2, 50, 10)
   FOR i=0, maxROI-1 DO LFPS(i,*) = Convol( REFORM(roiSigs(i,*)), filter, /EDGE_TRUNCATE )
   

   RETURN, LFPS
END
