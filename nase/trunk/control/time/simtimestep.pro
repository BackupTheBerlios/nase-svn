;+
; NAME:
;  SimTimeStep
;
; VERSION:
;  $Id$
;
; AIM:
;  Indicates execution of a simulation step to the <C>SimTime</C> structure.
;
; PURPOSE:
;  The <C>SimTime</C> family of routines is intended to be used when
;  one wants to keep track of the times needed by iterations in a
;  simulation or by a number of
;  simulations. During simulation, the number of iterations already
;  executed as well as the progress and estimated time until
;  completion can be printed. After completion, a small analysis may
;  also be printed or plotted.<BR>
;  <C>SimTimeStep</C> is used to indicate the execution of a single
;  iteration. If desired, the call of <C>SimTimeStep</C> also causes
;  some temporal information about an ongoing simulation to be printed.
;
; CATEGORY:
;  ExecutionControl
;
; CALLING SEQUENCE:
;* SimTimeStep
;
; OUTPUTS:
;  If keyword <C>PRINT</C> was used in the call to <A>SimTimeInit</A>,
;  the following information is printed every time <C>SimTimeStep</C>
;  is called:
;*  Iteration No.
;*  Progress in %
;*  Time in Progress in sec
;*  Time of last Iteration in sec
;*  Mean Time/Iteration in sec
;*  Mission completed in sec
;*  Estim. total Time in sec
; If output is directed into the <A>Console</A> by <A>SimTimeInit</A>,
; only 
;*  Iteration No.
;*  Progress in %
;*  Time in Pogress in sec
;*  Mission completed in sec
; are diplayed as the space in the bottom line of the <A>Console</A>
; is limited.<BR>
;
; COMMON BLOCKS:
;  SimTime
;
; PROCEDURE:
;  A little calculation and some printing.
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
;  <A>SimTimeInit</A>,  <A>SimTimeStop</A>,  <A>Console</A>.
;  
;-



PRO SimTimeStep
   
   COMMON SimTime, stat
   default, CLEAR,0

   IF stat.step LT stat.maxsteps THEN BEGIN
      stat.ast            = SysTime(1)
      stat.tpi(stat.step) = stat.ast - stat.lst
      stat.step           = stat.step + 1
      stat.lst            = stat.ast 
   END ELSE BEGIN
      Print, 'SimTimeStep: too many iterations...quitting'
   END
   ;;mittelwert bilden Time/Iteration
   median = total(stat.tpi)/FLOAT(stat.step)
   estimation = median*(stat.maxsteps-stat.step)
   
   IF stat.print THEN BEGIN
      IF stat.console EQ -1 THEN BEGIN
         IF STAT.CLEAR EQ 1 THEN PRINT,!KEY.CLEAR
         print, '-----------------------------------------------'
         print, '  Iteration              :  ', STRCOMPRESS(STRING(stat.step),/REMOVE_ALL)
         print, '  Progress               :  ', STRCOMPRESS(STRING(((stat.step)/FLOAT(stat.maxsteps)*100)),/REMOVE_ALL),"%"
         print, '  Time in Progress       : ', Seconds2String(Total(stat.tpi))
         print, '  Time of last Iteration : ', Seconds2String(stat.tpi(stat.step-1))
         print, '  Mean Time/Iteration    : ', Seconds2String(median)
         print, '  Mission completed in   : ', Seconds2String(estimation)
         print, '  Estim. total Time      : ', Seconds2String(Total(stat.tpi)+estimation)
         print, '-----------------------------------------------'
         FLUSH, -1
      ENDIF ELSE BEGIN
         Handle_Value, stat.console, status, /NO_COPY

         out = 'Iteration: '+STR(stat.step) $
          +'   Progress: '+STR((stat.step)/FLOAT(stat.maxsteps)*100)+'%' $
          +'   Time: '+Seconds2String(Total(stat.tpi)) $
          +'   Completed in: '+Seconds2String(estimation)

         Widget_Control, status.timewid, SET_VALUE=out
         Handle_Value, stat.console, status, /NO_COPY, /SET
      ENDELSE
   ENDIF ;; print?

END
