;+
; NAME:               CCI
;
; PURPOSE:            Computes/Saves or restores all possible correlations
;                     between n signals. 
;                     ATTENTION: this routine can do much more than
;                     documented, but the code is possibly outdated
;                     and should be checked before.
;
; CATEGORY:           MIND XPLORE CORRELATION
;
; CALLING SEQUENCE:   cc = CCI(nt [,nt2] [,/R] [,FILE=file] 
;                           [,CORRLENGTH=corrlength] [,/NOSAVE])
;                           [,SAMPLE=sample]
;                           [,/SYNC | ,/FULL]
;
; INPUTS:             nt: array of arbitrary dimension (the last
;                         dimension is interpreted as time); may be undefined
;                         for restore operations (/R)
;
; OPTIONAL INPUT:     nt2: another signal array needed for /SYNC 
; 
; KEYWORD PARAMETERS: R          : already calculated data is restored
;                     file       : file suffix appended loop
;                                   specific values
;                     CORRLENGTH : the distance how much signals are shifted positive
;                                  and negative in time, default is 20 
;                     SAMPLE     : the temporal resoultion of the
;                                  signal in seconds
;                     NOSAVE     : don't save the results
;
;                     SYNC       : correlation for nt(i) and nt2(i)
;                                  for all indices i 
;
; OUTPUTS:            cc         : the resulting cross correlations,
;                                  dimensions depend on used method
;
;-
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 1.2  2000/06/20 13:26:09  saam
;           + nearly completely rewritten
;           + fully functional now
;
;     Revision 1.1  2000/04/07 10:09:45  saam
;           + converted from CCHS and adapated
;           + new documentation
;
;
;
FUNCTION doCC, s1, s2, pshift, SLIDING=sliding

IF sliding(0) GT 0 THEN BEGIN
    rcc = slidcc(REFORM(s1,/OVERWRITE),REFORM(s2,/OVERWRITE),pshift,SSIZE=LONG(sliding(0)*pshift), SSHIFT=sliding(0)*pshift*sliding(1))
    ; average data with fisher-z 
    rcc=fzt(rcc,-1)
    _m=imoment(rcc,2)
    m=fzt(_m,1)
    RETURN, REFORM(m(*,0))
END ELSE RETURN, CrossCor(s1, s2, pshift)

END





FUNCTION CCI, nt, nt2,$
              FILE=file,$
              CORRLENGTH=_corrLength, PSHIFT=pshift, SAMPLE=sample, $
              NOSAVE=nosave,$
              SYNC=sync, SINGLE=single, FULL=full, AUTO=auto, $
              SLIDING=sliding,$
              INFO=info,$
              R=R,$
              _EXTRA=extra

COMMON ATTENTION

   Default, file, ''              ; special extension
   Default, PShift, 20
   Default, _corrLength, PShift
   Default, SAMPLE, P.SIMULATION.SAMPLE
   Default, SLIDING, [-1,-1]

   corrLength = LONG(_corrLength/(1000.*FLOAT(sample)))
   
   


   IF Keyword_Set(R) THEN BEGIN
       Console, 'loading...'
       V = LoadVideo(TITLE=P.File+file+'.cc', GET_STARRING=info, GET_COMPANY=log2, /SHUTUP, ERROR=err)
       IF err THEN BEGIN
           Console, 'data doesnt exist...'+P.File+file+'.cc', /WARN
           CONSOLE, 'stopping', /FATAL
       END
       cc = Replay(V)
       Eject, V, /NOLABEL, /SHUTUP
       Console, 'loading...done', /UP
       Console, info
       IF log2 NE '' THEN Console, log2
   END ELSE BEGIN

       s = SIZE(nt)
       tCount = S(S(0))
       nCount = N_Elements(nt)/tCount
       Iter = 0l
       
       
       IF Keyword_Set(SYNC) THEN BEGIN
           IF TOTAL(Size(nt) NE Size(nt2)) NE 0 THEN Console, '1st and 2nd argument must have same dimension for /SYNC', /FATAL
           nt2 = REFORM(nt2,nCount, tCount, /OVERWRITE)  
           nt = REFORM(NT, nCount, tCount, /OVERWRITE) ; handle various dimensions
           maxIter = nCount-1
           cc = FltArr(nCount, 2*corrLength+1) 
           log = 'correlations, SIG1 and SIG2, n='+STR(maxIter)+', '+STR(_corrLength)+' ms, dt='+STR(P.SIMULATION.SAMPLE) 
           Console, log+'...'
           FOR source=0,nCount-1 DO BEGIN
               cc(source,*) = doCC(nt(source,*), nt2(source,*), corrLength, SLIDING=sliding)               
               Iter =  Iter+1
               IF ((Iter MOD 100) EQ 0) THEN Console, log+'...'+STR(100*Iter/maxIter)+' %', /UP
           ENDFOR
           nt = REFORM(nt, S(1:S(0)), /OVERWRITE)  
           nt2 = REFORM(nt2, S(1:S(0)), /OVERWRITE)  
           cc = REFORM(cc, [S(1:S(0)-1), 2*corrLength+1], /OVERWRITE)
           Console, log+'...done', /UP
           
       END ELSE IF Keyword_Set(SINGLE) THEN BEGIN
           nt = REFORM(NT, nCount, tCount, /OVERWRITE) ; handle various dimensions
           nt2 = nt(flatindex(S, single),*)
           maxIter = (nCount-1)
           cc = FltArr(nCount, 2*corrLength+1) 
           log = 'correlations, SINGLE '+PrettyArr(SINGLE)+', n='+STR(maxIter)+', '+STR(corrLength)+' ms, dt='+STR(P.SIMULATION.SAMPLE)
           Console, log+'...'
           FOR source=0,nCount-1 DO BEGIN
               cc(source,*) = doCC(nt2, nt(source,*), corrLength, SLIDING=sliding)
               Iter =  Iter+1
               IF ((Iter MOD 100) EQ 0) THEN Console, log+'...'+STR(100*Iter/maxIter)+' %', /UP
           ENDFOR
           nt = REFORM(nt, S(1:S(0)), /OVERWRITE)  
           cc = REFORM(cc, [S(1:S(0)-1), 2*corrLength+1], /OVERWRITE)
           Console, log+'...done', /UP
           
       END ELSE IF Keyword_Set(FULL) THEN BEGIN 
           nt = REFORM(NT, nCount, tCount, /OVERWRITE) ; handle various dimensions
           maxIter = (nCount+1)*nCount/2
           cc = FltArr(nCount, nCount, 2*corrLength+1) 
           log = 'correlations, FULL, n='+STR(maxIter)+', '+STR(corrLength)+' ms, dt='+STR(P.SIMULATION.SAMPLE)
           Console, log+'...'
           FOR source=0,nCount-1 DO BEGIN
               FOR target=source,nCount-1 DO BEGIN
                   cc(source,target,*) = doCC(nt(source,*), nt(target,*), corrLength, SLIDING=sliding)
                   cc(target,source,*) = REVERSE(REFORM(cc(source,target,*)))
                   Iter =  Iter+1
                   IF ((Iter MOD 100) EQ 0) THEN Console, log+'...'+STR(100*Iter/maxIter)+' %', /UP
               ENDFOR
           END
           Console, log+'...done', /UP

           nt = REFORM(nt, S(1:S(0)), /OVERWRITE)  
           cc = REFORM(cc, [S(1:S(0)-1), S(1:S(0)-1), 2*corrLength+1], /OVERWRITE)
           
       END ELSE IF Keyword_Set(AUTO)  THEN BEGIN
           nt = REFORM(NT, nCount, tCount, /OVERWRITE) ; handle various dimensions
           maxIter = (nCount-1)
           cc = FltArr(nCount, 2*corrLength+1) 
           log = 'correlations, SINGLE '+PrettyArr(SINGLE)+', n='+STR(maxIter)+', '+STR(corrLength)+' ms, dt='+STR(P.SIMULATION.SAMPLE)
           Console, log+'...'
           FOR source=0,nCount-1 DO BEGIN
               cc(source,*) = doCC(nt2, nt(source,*), corrLength, SLIDING=sliding)
               Iter =  Iter+1
               IF ((Iter MOD 100) EQ 0) THEN Console, log+'...'+STR(100*Iter/maxIter)+' %', /UP
           ENDFOR
           nt = REFORM(nt, S(1:S(0)), /OVERWRITE)  
           cc = REFORM(cc, [S(1:S(0)-1), 2*corrLength+1], /OVERWRITE)
           Console, log+'...done', /UP
           
       END ELSE BEGIN
           Console, 'one known iteration method must be specified', /FATAL
       END
       
       IF NOT Keyword_Set(NOSAVE) THEN BEGIN
           log2=''
           IF sliding(0) GT 0 THEN BEGIN
               log2= 'averaged, win='+STR(Sliding(0)*_corrlength)+' ms, shift='+STR(_corrLength*Sliding(0)*Sliding(1))+' ms'
               Console, log2
           END
           Console, 'saving data...'
           V = InitVideo( cc, TITLE=P.File+file+'.cc', STARRING=log, COMPANY=log2, /SHUTUP)
           dummy = CamCord(V, cc)
           Eject, V, /NOLABEL, /SHUTUP
           Console, 'saving data...done', /UP
       END
   
   END
   RETURN, cc
   
END
