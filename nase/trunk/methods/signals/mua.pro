;+
; NAME:                MUA - derives unfiltered MUA signals from spike trains  
;
; PURPOSE:             Derives MUA signals (multiple unit activity)
;                      from a time course of spiketrains in a layer.
;                      You may select specific recording positions or
;                      generate it for the whole layer. A MUA signal
;                      is generated by convolving the spike output at
;                      a given time step with a spatially decaying
;                      kernel (gaussian or exponential). The resulting
;                      signals should be temporally filtered to be
;                      comparable with experimentally derived signals.
;
; CATEGORY:            NASE SIGNALS
;
; CALLING SEQUENCE:    MUAS = MUA( nt [,recSites] [,HMW_EXP=hmw_exp |
;                                  ,HMW_GAUSS=hmw_gauss] [,ROI=roi]
;                                  [,/NASE] [,/WRAP])
;
; INPUTS:              nt      : 3d-array, containing the temporal
;                                development of the layer's output
;                                (layerdim1, layerdim2, time). 
;
; OPTIONAL INPUTS:     recSites: a list of recording positions [[x1,x2,...],[y1,y2,...]];
;                                if the argument is omitted, all
;                                positions will be calculated
;
; KEYWORD PARAMETERS:  HMW_EXP:   exponential decay of the convolution
;                                 kernel, the argument specifies the
;                                 half mean half width of the kernel,
;                                 the centre amplitude is set to 1.
;                                 HMW_EXP=1 is the default behaviour if
;                                 neither HWM_EXP nor HMW_GAUSS are
;                                 specified explicitly. 
;                      HMW_GAUSS: gaussian decay of the convolution
;                                 kernel, the argument specifies the
;                                 half mean half width of the kernel,
;                                 the centre amplitude is set to 1 
;                      NASE  :    correct handling of nase layers
;                      WRAP :     MUA is generated using toroidal
;                                 boundary conditions 
;                       
; OUTPUTS:             MUAS  :    Array containg the mua signals for
;                                 the different recording positions
;                                 (recording position, time)
;
; OPTIONAL OUTPUTS:
;                      ROI   :    after call of mua ROI contains the
;                                 used convolution kernel
;
; EXAMPLE:
;                      nt = FIX(30*RandomN(seed,10,10,1000))
;                      MUAS = MUA(nt, [[0,5], [0,5]], HMW_EXP=2)
;                      plot, REFORM(MUAS(0,*))
;                      oplot, REFORM(MUAS(1,*))-50., LINESTYLE=2                      
;    
; MODIFICATION HISTORY:
; 
;     $Log$
;     Revision 1.5  2000/06/06 14:57:38  saam
;           + completed the new doc header
;           + returns on error
;
;     Revision 1.4  2000/06/06 13:50:04  saam
;             + nearly completely rewritten
;             + can compute full MUA signal via CONVOL now
;
;     Revision 1.3  1998/05/28 12:33:05  saam
;           Keyword NASE added
;
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
FUNCTION MUA, mt, list, HMW_GAUSS=hmw_gauss, HMW_EXP=hmw_exp, ROI=roi, NASE=nase, WRAP=wrap, LOG=log

   ON_ERROR, 2

   ; check syntax
   CASE Set(HMW_GAUSS)+Set(HMW_EXP) OF 
       0   : hmw_exp=1. ; set exponential decay
       1   : x=0;       ; everything ok
       ELSE: Console, 'only one mua method allowed', /FATAL
   END
   

   np = N_Params()
   IF (np GT 2) OR (np LT 1) THEN Console, 'wrong number of args', /FATAL

   mtS = SIZE(mt)
   IF mtS(0) NE 3 THEN Console, 'wrong format for first arg', /FATAL
   maxT   = mtS(3)


   ; calc kernel
   log = ''
   IF Set(HMW_GAUSS) THEN BEGIN
       roi = GAUSS_2D(mtS(1), mtS(2), HWB=hmw_gauss)
       log = log + 'gaussian weighting, HMW '+STR(HMW_GAUSS)
   END 
   IF Set(HMW_EXP) THEN BEGIN
       roi = exp(-Distance(mtS(1), mtS(2))*alog(2)/HMW_EXP)
       log = log + 'exponential weighting, HMW '+STR(HMW_EXP)
   END
   log = log+', area '+STR(TOTAL(roi))
   IF Keyword_Set(WRAP) THEN log=log+', WRAP' ELSE log=log+', NOWRAP'

   
   CASE N_Params() OF 
       1: BEGIN
           ; compute full MUA with Convol
           log=log+', all sites'
           Console, log+'...'
           
           roi = roi(1:mtS(1)-2, 1:mtS(2)-2) ; shrink 1 element at either side for convol
           roiSigs = FltArr((SIZE(mt))(1),(SIZE(MT))(2), (SIZE(MT))(3))
           FOR t=0l, maxT-1 DO BEGIN
               IF Keyword_Set(WRAP) THEN BEGIN
                   roiSigs(*,*,t) = CONVOL(REFORM(Float(mt(*,*,t))), roi, /EDGE_WRAP, /CENTER)            
               END ELSE BEGIN 
                   roiSigs(*,*,t) = CONVOL(REFORM(Float(mt(*,*,t))), roi, /EDGE_TRUNCATE, /CENTER)
               END
               IF (t MOD (maxT/20)) EQ 0 THEN Console, log+'...'+STR(FIX(t/FLOAT(maxT)*100.))+' %',/UP
           ENDFOR
          END
       2: BEGIN
           ; compute MUA at specific points

           ;; both cases are numerically not identical since
           ;; IDL only accepts convolution kernels that are
           ;; smaller than the array
           ;; however, these differences are only restricted
           ;; to points very near to the array's borders

           listS  = SIZE(list)
           IF listS(0) EQ 1 AND N_Elements(list) EQ 2 THEN BEGIN
               list = REFORM(list, 1, 2, /OVERWRITE)
               listS = SIZE(list)
           END
           maxROI = listS(1)  
           log=log+', '+STR(maxRoi)+' sites'
           Console, log+'...'

           ROIs = DblArr(maxROI, mtS(1), mtS(2))
           FOR i=0, maxROI-1 DO BEGIN
               
               IF Keyword_Set(NASE) THEN BEGIN
                   shiftx = list(i,1)-mtS(2)/2
                   shifty = list(i,0)-mtS(1)/2
               END ELSE BEGIN
                   shiftx = list(i,0)-mtS(1)/2
                   shifty = list(i,1)-mtS(2)/2
               END
               IF Keyword_Set(WRAP) THEN ROIS(i,*,*) = SHIFT(ROI, shiftx, shifty) ELSE ROIS(i,*,*) = NOROT_SHIFT(ROI, shiftx, shifty)

           ENDFOR
           roiSigs = DblArr(maxROI, maxT)
           FOR t=0l, maxT-1 DO BEGIN
               FOR i=0, maxROI-1 DO BEGIN
                   roiSigs(i, t) = TOTAL( REFORM(mt(*,*,t))*REFORM(ROIS(i,*,*)) )
               ENDFOR
               IF (t MOD (maxT/20)) EQ 0 THEN Console, log+'...'+STR(FIX(t/FLOAT(maxT)*100.))+' %', /UP
           ENDFOR
          END
      END

      Console, log+'...done',/UP
   
   ; -----> RETURN RAW SIGNALS 
   RETURN, roiSigs


END
