;+
; NAME:
;  STCHFIT()
;
; VERSION:
;  $Id$
;
; AIM:  Fitting routine for <A>STCH</A>
;  
;
; PURPOSE:
;      Fitting routine for <A>STCH</A>
;  
;  
;
; CATEGORY:
;  Signals
;
; CALLING SEQUENCE:
;*  status=stchfit(stc, distance_ax, delay_ax[, rv=rv][,cs=cs][,sf=sf][,/cosf]
;*                 [,/gaussf][, plot=plot][,freqlimit=freqlimit]
;*                 [,sigmalimit=sigmalimit][,VELLIMIT=VELLIMIT])
;
; INPUTS:
;     STC:: result of <A>STCH</A>
;     distance_ax:: s. <A>STCH</A>
;     delay_ax:: s. <A>STCH</A>
;
; INPUT KEYWORDS:
;    COSF:: uses a cosinus as fitting function (default)
;    GAUSSF:: uses a gaussian as fitting function (alpha status: not recommended)
;    FREQLIMIT:: frequency range of cosinus fit (e.g. [30,70]) (unit [Hz])
;    SIGMALIMIT:: sigma range of gaussian fit (e.g. [5,10]) (unit [s])
;    VELLIMIT:: rec. velocity range of fit (unit [ms/mm]) (e.g. [-10.0,10.0])
;    PLOT:: control plot of fit
;
; OUTPUTS:
;  STATUS:: time course of fit status (s. <A>mpfit2dfun</A>)
;
; OPTIONAL OUTPUTS:
;      RV:: reciprocal velocity of fit, 
;           rv(*,0) time course of RV ([ms/mm]),
;           rv(*,1) time course of rv's fit error (s. <A>mpfit2dfun</A>)
;      CS:: correlation strength,
;           cs(*,0) time course of correlation strength,
;           cs(*,1) time course of cs's fit error
;           (s. <A>mpfit2dfun</A>)
;      SF:: frequency/sigma of fit,
;          sf(*,0) time course of frequency/sigma,
;          sf(*,1) time course of sf's fit error
;          (s. <A>mpfit2dfun</A>) 
;
; COMMON BLOCKS:
;          stchfit_sheets
;
; SIDE EFFECTS:
;      If frequency/sigma or velocity limits are reached by the fit, CS
;     is set to zero. Don't use corresponding CS and SF values!
;
; RESTRICTIONS:
;  
;
; PROCEDURE:
;  
;
; EXAMPLE:
;*maxn = 10
;*wset, 0
;*!P.MULTI = 0
;*plot, 1+indgen(maxn), indgen(maxn), yrange=[0, 1], /nodata
;*
;*for n=3, maxn-1 do begin
;*   ntrial = 5
;*   x = FltArr(128,n, ntrial) ;; array(time,channel,trials)
;*   RandomPhases = RandomU(seed,n,ntrial) * 2*!pi
;*   for j=0, n-1 do begin
;*      FOR  i = 0, ntrial-1  DO  begin 
;*         x[*,j,i] = 0.5*RandomN(seed, 128) + Cosine(50.0, RandomPhases[i], 500.0, 128, /samples) 
;*      endfor                    ;
;*   endfor
;*   
;*   x = double(transpose(temporary(x), [1, 0, 2]))
;*   undef, cs_arr
;*   FOR  i = 0, ntrial-1  DO  begin 
;*      stc = spatiotempcorr(x(*,*, i),distance_ax,delay_ax,time_ax,ssize=26, xsample=0.001,SAMPLEPERIOD=0.002)
;*      status = stchfit(stc, distance_ax,delay_ax, cs = cs)
;*      
;*       cs_arr = concat(cs_arr, cs, /extend)
;*       print, "step: "+str(i)
;*  endfor
;*  cs_mean = fztmean(fztmean(cs_arr, dim=1), dim=1)
;*   
;*   oplot,[n], [cs_mean(0)], psym=2
;*endfor
;*
;*
;
; SEE ALSO:
;  <A>STCH</A>
;-

;;; look in headerdoc.pro for explanations and syntax,
;;; or view the NASE Standards Document


function __cos_stch_index, x, y, p
   return, where((cos((x-y*p(1))*2.D*!PI*p(2)))(*) GE 0.98)
end

function  __fermi, x, T, x0
   default, T, 1.0
   default, x0, 0
   return, (1.-fermi((x-x0)*5, T))
end

function  __cos_stch, x, y, p
   return, ( p(0)*cos((x-y*p(1))*2.D*!PI*p(2)) )
end

function  __gauss_stch, x, y, p
   return, ( p(0)*(exp(-(x-y*p(1))^2/(2*p(2)^2))-0.5)*2.0) 
   ;return, ( p(0)*(exp(-abs(x-y*p(1))/(2*p(2)))-0.5)*2.0) 
   ;return, ( p(0)*exp(-(x-y*p(1))^2/(2*p(2)^2)))
end

function stchfit, stc, distance_ax, delay_ax, rv=rv, cs=cs, sf=sf, cosf=cosf, gaussf=gaussf, plot=plot, freqlimit=freqlimit, sigmalimit=sigmalimit,vellimit=rvlimit,limitidx=limitidx, verbose=verbose, interpol=interpol, correction=correction, thf=thf, grf=grf
   common stchfit_sheets, sheet_1

   ;on_Error, 2
   default, verbose, 0
   default, plot, 0
   default, cosf, 1
   default, gaussf, 0
   default, interpol, 1
   default,correction,1

   default, thf, 0.2 ;;fermi threshould
   default, grf, 0.02 ;; fermi gradient

   if gaussf eq 1 then cosf = 0

   if plot eq 1 then default, sheet_1, definesheet(/window, xsize=300, ysize=150)

   case 1 of
      cosf EQ 1 : begin
         myfunc = '__cos_stch'
         frequency = double(1000./ abs(delay_ax(0)-last(delay_ax)))
         default, freqlimit, [0.1D,2.0D]*frequency
        
         break
      end
      gaussf EQ 1: begin
         myfunc = '__gauss_stch'
         default, sigmalimit, [0.01D,3.0D]*double(abs(delay_ax(0)-last(delay_ax))/4)/1000.
        
       break
      end
   endcase


   if set(freqlimit) and set(sigmalimit) then console, /fatal, "setting of freqlimit and sigmalimit not possible"
   if set(freqlimit) then begin 
      if verbose eq 1 then begin
         dmsg, "Fitting frequency interval: "+fltstr(freqlimit(0), 2)+"-"+fltstr(freqlimit(1), 2)+" [Hz]"
      endif
      sflimit = freqlimit
   end
   if set(sigmalimit) then begin 
      if verbose eq 1 then begin
         dmsg, "Fitting sigma interval: "+fltstr(sigmalimit(0)*1000, 2)+"-"+fltstr(sigmalimit(1)*1000, 2)+" [ms]"
      endif
      sflimit = sigmalimit
   end


   s_stc = size(stc)

   if interpol GT 1 then  begin 
      interpoldim = [(s_stc(1)/2*interpol*2)+1,(s_stc(2)/2*interpol*2)+1]
      __distance_ax = (lindgen(interpoldim(0))/FLOAT(interpoldim(0)-1)-0.5)*last(distance_ax)*2
      __delay_ax =(lindgen(interpoldim(1))/FLOAT(interpoldim(1)-1)-0.5)*last(delay_ax)*2
      

   end else begin
      interpoldim = [(s_stc(1)/2*interpol*2)+1,(s_stc(2)/2*interpol*2)+1]
      __distance_ax = distance_ax
      __delay_ax = delay_ax

   endelse
   
   

   tdim = s_stc(s_stc(0))

   X = transpose((__delay_ax # (__distance_ax*0.0d + 1.0d))/1000.)
   Y = transpose(((__delay_ax*0.0d + 1.0d) # __distance_ax)/1000.)
   
   ;;rv limits
    default, rvlimit, [-1.0, 1.0]*last(delay_ax)/distance_ax(N_ELEMENTS(distance_ax)/2+1)

   ;rvlimit = [ last(__delay_ax)/__distance_ax(interpoldim(1)/2+1:*),last(__distance_ax)*__delay_ax(1:n_elements(__delay_ax)-2), reverse(last(__delay_ax)/__distance_ax(interpoldim(1)/2+1:*)) ]


   if verbose eq 1 then begin
      dmsg, "Fitting rec. vel. interval: "+fltstr(rvlimit(0), 2)+"-"+fltstr(rvlimit(1), 2)+" [ms]"
   endif

   ;;params for rv initial guess (pre fit)
   steps = 20l
   vel_ax = rvlimit(0)+findgen(steps+1)/float(steps)*(rvlimit(1)-rvlimit(0))

   vel_ax = rvlimit(0)+findgen(steps+1)/float(steps)*(rvlimit(1)-rvlimit(0))

   vel_guess = fltarr(steps+1)
  
   rv = fltarr(tdim, 2)
   cs = fltarr(tdim, 2)
   sf = fltarr(tdim, 2)
   status = intarr(tdim)
   
   fit_weights = dblarr(s_stc(1), s_stc(2))
   fit_weights(*) = 1.d
   case  myfunc of
      '__cos_stch': begin
         p0 = [0.1D, 0.D, frequency]
         parinfo = replicate({value:0.D, fixed:0, limited:[0.D,0.D], limits:[0.D,0.D]}, 3)
         ;;cs limits
         parinfo(0).limited = [1, 1]
         parinfo(0).limits = [0.D, 1.0D]
         ;;rv limits
         parinfo(1).limited = [1, 1]
         parinfo(1).limits = double(rvlimit)
         ;;sf limits (frequency)
         parinfo(2).limited = [1,1]
         parinfo(2).limits = double(sflimit)
         ;;initial guess
         parinfo(*).value = p0
         break
     end
     '__gauss_stch': begin
         p0 = [0.01D, 0.D, mean(sflimit)]
         parinfo = replicate({value:0.D, fixed:0, limited:[0,0], limits:[0.D,0]}, 3)
         parinfo(0).limited = [1, 1]
         parinfo(0).limits = [0.D, 1.0D]
         parinfo(1).limited = [1, 1]
         parinfo(1).limits = [-10.D, 10.0D]
         parinfo(2).limited = [1,1]
         parinfo(2).limits = double(sflimit)
         ;parinfo(2).fixed = 1
         parinfo(*).value = p0
         break
     end
  endcase
   
  for i_t=0l, tdim-1 do begin
     if interpol gt 1 then  begin
        stc_tmp = congrid( stc(*,*,i_t),interpoldim(0),interpoldim(1),cubic=-0.5,/minus)
     end else stc_tmp = stc(*, *, i_t)

     s_stc_tmp = size(stc_tmp)

     stc_tmp(s_stc_tmp(1)/2, s_stc_tmp(2)/2) = (mean(((stc_tmp(s_stc_tmp(1)/2-1:s_stc_tmp(1)/2+1, *))(*,s_stc_tmp(2)/2-1:s_stc_tmp(2)/2+1))(*)))(0)

     
  
     ;;if gaussf eq 1 then stc_tmp = (stc_tmp+1.0)/2.0

     ;;initial rv guess;;;;;;;;
     ;;SD of stc
     SDB = sqrt(total(stc_tmp*stc_tmp))
     for vel_i=0l, N_ELEMENTS(vel_ax)-1 do begin
       
        if cosf eq 1 then begin
           velp = [1.0D, vel_ax(vel_i) , frequency ]
           A = __cos_stch( x, y, velp)
        end else begin 
           velp = [1.0D, vel_ax(vel_i) , mean(sflimit) ]
           A = __gauss_stch( x, y, velp)
        end
        ;;SD of fit
        SDA = sqrt(total(A*A))
        ;;correlation between stc and fit
        vel_guess(vel_i) = total((A*stc_tmp)/(SDA*SDB))
     endfor
     
     ;;wset, 0
     ;;plot, vel_ax, vel_guess, /XSTYLE

     ;;get the rv of best fit 
     max_vel = max(vel_guess, max_idx)
     
     ;;initalize the rv guess
     if max_idx GT 0 AND max_idx LT (steps+1) then begin 
        parinfo(1).value = vel_ax(max_idx)
        parinfo(1).limits = [ vel_ax(max_idx)-1.0 , vel_ax(max_idx)+1.0]
        if verbose eq 1 then dmsg, "Fitting rec. velocity interval: "+ fltstr(parinfo(1).limits(0), 2)+$
         "-"+fltstr(parinfo(1).limits(1), 2)+" [s/m]"
        ;;print, parinfo(1).limits
     endif
     ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
     ;;the fit itsself
     p = mpfit2dfun(myfunc, X, Y, double( stc_tmp), fit_weights,weights=fit_weights, $
                    status=s, yfit=yfit, /quiet, parinfo=parinfo, perror=perror)
     
     ;;reset rv guesses 
     parinfo(*).value = p0
     parinfo(1).limits = double(rvlimit)

     ;;remember fit status
     status(i_t) = s
     
     ;;fit's correlation strength
     cs(i_t, *)= [p(0), perror(0)]
     ;;fit's frequency/sigma
     sf(i_t, *) = [p(2), perror(2)]
     ;;fit's reciprocal velocity
     rv(i_t, *) = [p(1), perror(1)]
     
 
     fac = 1.0
     ;;test+correct the goodness of fit
     if correction EQ 1 then begin
        ;fac=FLOAT(1-correlate(stc_tmp(*),yfit(*)) LT 0.2)

        if(cs(i_t, 0) GE 0.0001) then fac=__fermi(FLOAT(1.0-correlate(stc_tmp(*),yfit(*))),grf,thf)

     end else begin
        if cosf eq 1 then begin
           fac =  __fermi(sqrt((umoment(stc_tmp(__cos_stch_index( X, Y, p))))(1)),grf,thf)
        end 
     end
     
     cs(i_t, 0) =cs(i_t, 0)* fac
   
     ;;some plots for inquiring people
     if  plot eq 1 then begin
        if sf(i_t, 0) EQ sflimit(0) OR sf(i_t, 0) EQ sflimit(1) OR $
         rv(i_t, 0) EQ rvlimit(0) OR rv(i_t, 0) EQ rvlimit(1) then fac = 0.0
        opensheet, sheet_1
        balancect
        !P.MULTI = [0, 2, 1]
        ptvs, stc(*, *, i_t), /smooth, ZRANGE=[-1.0d, 1.0d], yrange=delay_ax, xrange=distance_ax
        if fac ne 0.0 then begin
           ptvs, yfit*fac, /smooth, ZRANGE=[-1d, 1d], title=fltstr(cs(i_t, 0), 2), yrange=delay_ax, xrange=distance_ax
        end else begin
           ptvs, yfit*fac, ZRANGE=[-1d, 1d], title=fltstr(cs(i_t, 0), 2), yrange=delay_ax, xrange=distance_ax
        end
        
        wait, 0.1
        closesheet, sheet_1
     end

  endfor

  ;;set cs to zero if frequency/sigma limits were touched 
  limitidx =  where(sf(*, 0) EQ sflimit(0) OR sf(*, 0) EQ sflimit(1) OR $
                    rv(*, 0) EQ rvlimit(0) OR rv(*, 0) EQ rvlimit(1) , count)
  if count gt 0 then begin
     if verbose eq 1 then console, /warn, "sf or rv limits were touched, set corr. strength to zero"
     cs(limitidx, *) = 0.0
  endif
  
  return, status
end





