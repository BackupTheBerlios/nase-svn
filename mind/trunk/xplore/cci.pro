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
;                           [,CORRLENGTH=corrlength], [/NOSAVE])
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
;     Revision 1.1  2000/04/07 10:09:45  saam
;           + converted from CCHS and adapated
;           + new documentation
;
;
;
FUNCTION CCI, nt, sig,$
              FILE=file,$
              CORRLENGTH=corrLength, PSHIFT=pshift,$
              NOSAVE=nosave,$
              SYNC=sync,$
              ITERATE=iterate,$
              R=R,$
              _EXTRA=extra

COMMON ATTENTION

   EACH = 0
   ONE  = 1
   AUTO = 2
   ONEF = 3 ;one foreign


   Default, file, ''              ; special extension
   Default, PShift, 20
   Default, corrLength, PShift
   Default, ITERATE, EACH
   


   IF Keyword_Set(R) THEN BEGIN
       Console, 'loading...'
       V = LoadVideo(TITLE=P.File+file+'.cc', GET_STARRING=log, /SHUTUP, ERROR=err)
       IF err THEN BEGIN
           Console, 'data doesnt exist...'+P.File+file+'.cc', /WARN
           CONSOLE, 'stopping', /FATAL
       END
       cc = Replay(V)
       Eject, V, /NOLABEL, /SHUTUP
       Console, 'loading...'+log+'...done', /UP
   END ELSE BEGIN

       Console, 'using a correlation length of '+STRCOMPRESS(corrLength, /REMOVE_ALL)
       
       s = SIZE(nt)
       tCount = S(S(0))
       nCount = N_Elements(nt)/tCount
;   IF s(0) NE 2 THEN Message, 'first argument has wrong array dimensions'
       
       Iter = 0l
       
       
       IF Keyword_Set(SYNC) THEN BEGIN
           IF TOTAL(Size(nt) NE Size(sig)) NE 0 THEN Console, '1st and 2nd argument must have same dimension for /SYNC', /FATAL
           sig = REFORM(sig,nCount, tCount, /OVERWRITE)  
           nt = REFORM(NT, nCount, tCount, /OVERWRITE) ; handle various dimensions
           maxIter = nCount-1
           cc = FltArr(nCount, 2*corrLength+1) 
           log = 'correlations, SIG1 and SIG2, n='+STR(maxIter)+', '+STR(corrLength)+' ms'
           Console, log+'...'
           FOR source=0,nCount-1 DO BEGIN
                                ;cc(source,*) = CrossCor(nt(source,*), sig(source,*), corrLength)               
               cc(source,*) = CrossCor(nt(source,*), sig(source,*), corrLength)               
               Iter =  Iter+1
               IF ((Iter MOD 100) EQ 0) THEN Console, log+'...'+STR(100*Iter/maxIter)+' %', /UP
           ENDFOR
           nt = REFORM(nt, S(1:S(0)), /OVERWRITE)  
           sig = REFORM(sig, S(1:S(0)), /OVERWRITE)  
           cc = REFORM(cc, [S(1:S(0)-1), 2*corrLength+1], /OVERWRITE)
           Console, log+'...done', /UP
           
       END ELSE BEGIN 
           Console, 'entering possibly outdated code section', /WARN
           IF ITERATE(0) EQ EACH THEN BEGIN
               cc = FltArr(nCount, nCount, 2*corrLength+1) 
               maxIter = (nCount-1)*nCount/2
               log = 'full correlations, n='+STR(maxIter)+', '+STR(corrLength)+' ms'
               Console, log+'...'
               FOR source=0,nCount-1 DO BEGIN
                   FOR target=source, nCount-1 DO BEGIN
                       cc(source,target,*) = CrossCor(nt(source,*), nt(target,*), corrLength)               
                       Iter =  Iter+1
                   ENDFOR
                   Console, log+'...'+STR(100*Iter/maxIter)+' %', /UP
               ENDFOR
               Console, log+'...done'
                                ; only the non-redundant cases were computed,
                                ; the rest is now assigned via cch(x,y,tau) = cch(y,x,-tau)
               Console, 'using symmetries...'
               FOR source=0l,nCount-1 DO BEGIN
                   FOR target=source,nCount-1 DO BEGIN
                       cc(target,source,*) = REVERSE(REFORM(cc(source,target,*)))
                   ENDFOR
               ENDFOR
               Console, 'using symmetries...done', /UP
               
               
           END ELSE IF ITERATE(0) EQ ONE THEN BEGIN
               print, 'CCI: computing  correlations for a fixed neuron'
               print, ''
               cc = FltArr(nCount, 1, 2*corrLength+1) 
               maxIter = (nCount-1)
               FOR source=0,nCount-1 DO BEGIN
                   cc(source,0,*) = CrossCor(nt(source,*), nt(ITERATE(1),*), corrLength)               
                   Iter =  Iter+1
                   print, !KEY.UP+'CCI: calculating data... '+STRCOMPRESS(100*Iter/maxIter, /REMOVE_ALL),' %'
               ENDFOR
               
           END ELSE IF ITERATE(0) EQ ONEF THEN BEGIN
               print, 'CCI: computing  correlations with an external signal'
               print, ''
               cc = FltArr(nCount, 1, 2*corrLength+1) 
               maxIter = (nCount-1)
               FOR source=0,nCount-1 DO BEGIN
                   cc(source,0,*) = CrossCor(nt(source,*), sig, corrLength)               
                   Iter =  Iter+1
                   print, !KEY.UP+'CCI: calculating data... '+STRCOMPRESS(100*Iter/maxIter, /REMOVE_ALL),' %'
               ENDFOR
               
           END ELSE IF ITERATE(0) EQ AUTO THEN BEGIN
               print, 'CCI: computing the ACHs'
               cc = FltArr(nCount, 2*corrLength+1) 
               maxIter = (nCount-1)
               
               FOR source=0,nCount-1 DO BEGIN
                   cc(source,*) = CrossCor(nt(source,*), nt(source,*), corrLength)               
                   Iter =  Iter+1
                   print, !KEY.UP+'CCI: calculating data... '+STRCOMPRESS(100*Iter/maxIter, /REMOVE_ALL),' %'
               ENDFOR
       
           END ELSE Message, 'cant handle '+ITERATE(0)+' method for iteration'
       END
       
       IF NOT Keyword_Set(NOSAVE) THEN BEGIN
           Console, 'saving data...'
           V = InitVideo( cc, TITLE=P.File+file+'.cc', STARRING=log, COMPANY='', /SHUTUP)
           dummy = CamCord(V, cc)
           Eject, V, /NOLABEL, /SHUTUP
           Console, 'saving data...done', /UP
       END
   
   END
   RETURN, cc
   
END
