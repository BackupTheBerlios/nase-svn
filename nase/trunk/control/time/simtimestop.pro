;+
; NAME:                  SimTimeStop
;
; VERSION:  $Id$
;
; AIM: see <A>simtimeinit</A>
;
; PURPOSE:               Diese Routine ist dazu gedacht, die Zeiten fuer eine Folge von Simulationen 
;                        zu protokollieren und nach der Gesamtsimulation eine Statistik/Graphik aus-
;                        zugeben.
;
; CATEGORY:
; 
; ExecutionControl
;
; CALLING SEQUENCE:      SimTimeStop
;
; COMMON BLOCKS:         SimTime
;
; EXAMPLE:
;
;*SimTimeInit, GRAPHIC=5, /PRINT
;*FOR a=1,10 DO BEGIN
;* Wait, 5.*RandomU(seed)
;* SimTimeStep
;*END
;*SimTimeStop
;*
;-
PRO SimTimeStop
   
   COMMON SimTime, stat

   IF stat.step EQ 1 THEN BEGIN
      m  = TOTAL(stat.tpi(0:stat.step-1))/FLOAT(stat.step)
      print, '-----------------------------------------------'
      print, '  Iterations           : ', stat.step
      print, '  Total Time           : ', Seconds2String(Total(stat.tpi))
      print, '-----------------------------------------------'
      FLUSH, -1
   END ELSE BEGIN
      if stat.step GT stat.maxsteps then begin
         CONSOLE, /warn, 'too many iterations...quitting'
         return
      end
      m  = TOTAL(stat.tpi(0:stat.step-1))/FLOAT(stat.step)
      sd = StDev(stat.tpi(0:stat.step-1)) 
      
      print, '-----------------------------------------------'
      print, '  Iterations           : ', stat.step
      print, '  Total Time           : ', Seconds2String(Total(stat.tpi))
      print, '  Mean Time/Iteration  : ', Seconds2String(m)
      print, '  Standard Deviation   : ', Seconds2String(sd)
      print, '-----------------------------------------------'
      FLUSH, -1
      
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
