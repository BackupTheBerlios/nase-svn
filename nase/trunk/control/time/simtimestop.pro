;+
; NAME:
;  SimTimeStop
;
; VERSION:
;  $Id$
;
; AIM:
;  Indicates completion of a simulation to the <C>SimTime</C> structure.
;  
; PURPOSE:
;  The <C>SimTime</C> family of routines is intended to be used when
;  one wants to keep track of the times needed by iterations in a
;  simulation or by a number of
;  simulations. During simulation, the number of iterations already
;  executed as well as the progress and estimated time until
;  completion can be printed. After completion, a small analysis may
;  also be printed or plotted.<BR>
;  <C>SimTimeStop</C> is used to indicate the completion of the
;  simulation. The call of <C>SimTimeStop</C> also causes
;  some temporal information about the executed simulation to be printed.
;
; CATEGORY:
;  ExecutionControl
;
; CALLING SEQUENCE:
;  SimTimeStop
;
; OUTPUTS:
;  This information is either printed into the standard IDL window or
;  into the <A>console</A>, depending on the initialization with
;  <A>SimTimeInit</A>.
;* Number of iterations
;* Total Time
;* Mean Time/Iteration
;* Standard Deviation
;  Setting the <C>GRAPHICS</C> keyword in <A>SimTimeInit</A> also
;  causes the durations of the single iterations to be plotted.
;
; COMMON BLOCKS:
;  SimTime
;
; PROCEDURE:
;  A little calculation and some printing and/or plotting.
;
; EXAMPLE:
;* SimTimeInit, MAXSTEPS=10, /GRAPHIC, /PRINT
;* FOR a=1,10 DO BEGIN
;*    Wait, 5.*RandomU(seed)
;*    SimTimeStep
;* END
;* SimTimeStop
;
; SEE ALSO:
;  <A>SimTimeInit</A>,  <A>SimTimeStep</A>,  <A>Console</A>.
;
;-



PRO SimTimeStop
   
   COMMON SimTime, stat

   IF stat.step EQ 1 THEN BEGIN
 
      m  = TOTAL(stat.tpi(0:stat.step-1))/FLOAT(stat.step)
      
      IF stat.console EQ -1 THEN BEGIN
         print, '-----------------------------------------------'
         print, '  Iterations           : ', stat.step
         print, '  Total Time           : ', Seconds2String(Total(stat.tpi))
         print, '-----------------------------------------------'
         FLUSH, -1
      ENDIF ELSE BEGIN
         Console, stat.console $
          , '-----------------------------------------------', /MSG
         Console, stat.console $
          , '  Iterations           : '+Str(stat.step), /MSG
         Console, stat.console $
          , '  Total Time           : '+Seconds2String(Total(stat.tpi)), /MSG
         Console, stat.console $
          , '-----------------------------------------------', /MSG
      ENDELSE

   END ELSE BEGIN
      IF stat.step GT stat.maxsteps THEN BEGIN 
         Console, /warn, 'too many iterations...quitting'
         Return
      END 
      m  = TOTAL(stat.tpi(0:stat.step-1))/FLOAT(stat.step)
      sd = StDev(stat.tpi(0:stat.step-1)) 
      
      IF stat.console EQ -1 THEN BEGIN
         print, '-----------------------------------------------'
         print, '  Iterations           : ', stat.step
         print, '  Total Time           : ', Seconds2String(Total(stat.tpi))
         print, '  Mean Time/Iteration  : ', Seconds2String(m)
         print, '  Standard Deviation   : ', Seconds2String(sd)
         print, '-----------------------------------------------'
         FLUSH, -1
      ENDIF ELSE BEGIN
         Console, stat.console $
          , '-----------------------------------------------', /MSG
         Console, stat.console $
          , '  Iterations           : '+Str(stat.step), /MSG
         Console, stat.console $
          , '  Total Time           : '+Seconds2String(Total(stat.tpi)), /MSG
         Console, stat.console $
          , '  Mean Time/Iteration  : '+Seconds2String(m), /MSG
         Console, stat.console $
          , '  Standard Deviation   : '+Seconds2String(sd)
         Console, stat.console $
          , '-----------------------------------------------', /MSG
      ENDELSE
      
      IF !D.Name EQ 'NULL' THEN RETURN

      IF stat.graphic AND stat.step GT 0 THEN BEGIN
         oldmulti = !P.Multi
         !P.Multi = [0,0,1,0,0]
         Plot, stat.tpi(0:stat.step-1), /NODATA, XTITLE='Iteration', YTITLE='Seconds'         
         PolyFill, [ 0, stat.step, stat.step, 0, 0]   , [ m+sd, m+sd, m-sd, m-sd, m+sd], NOCLIP=0, COLOR=RGB(50,50,250)
         PlotS, [0, stat.step], [m, m], COLOR=23         
         OPlot, stat.tpi(0:stat.step-1)
         !P.Multi = oldmulti
      END
   END

END
