;+
; NAME:                  SimTimeStop
;
; PURPOSE:               Diese Routine ist dazu gedacht, die Zeiten fuer eine Folge von Simulationen 
;                        zu protokollieren und nach der Gesamtsimulation eine Statistik/Graphik aus-
;                        zugeben.
;
; CATEGORY:              ORGANISATION
;
; CALLING SEQUENCE:      SimTimeStop
;
; COMMON BLOCKS:         SimTime
;
; EXAMPLE:
;                        SimTimeInit, GRAPHIC=5, /PRINT
;                        FOR a=1,10 DO BEGIN
;                           Wait, 5.*RandomU(seed)
;                           SimTimeStep
;                        END
;                        SimTimeStop
;             
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 1.3  1997/11/13 13:57:21  saam
;           Anpassung an NULL-Device
;
;     Revision 1.2  1997/10/28 15:24:55  saam
;           !P.Multi wird korrekt gesetzt
;           der alte Zustand von !P.Multi bleibt erhalten
;
;     Revision 1.1  1997/10/26 18:41:58  saam
;           vom Himmel gefallen
;
;
;-
PRO SimTimeStop
   
   COMMON SimTime, stat

   IF stat.step EQ 1 THEN BEGIN
      m  = TOTAL(stat.tpi(0:stat.step-1))/FLOAT(stat.step)
      print, '-----------------------------------------------'
      print, '  Iterations           : ', stat.step
      print, '  Total Time           : ', Seconds2String(Total(stat.tpi))
      print, '-----------------------------------------------'
   END ELSE BEGIN
      m  = TOTAL(stat.tpi(0:stat.step-1))/FLOAT(stat.step)
      sd = StDev(stat.tpi(0:stat.step-1)) 
      
      print, '-----------------------------------------------'
      print, '  Iterations           : ', stat.step
      print, '  Total Time           : ', Seconds2String(Total(stat.tpi))
      print, '  Mean Time/Iteration  : ', Seconds2String(m)
      print, '  Standard Deviation   : ', Seconds2String(sd)
      print, '-----------------------------------------------'
      
      
      IF !D.Name EQ 'NULL' THEN RETURN

      IF stat.step GT 0 THEN BEGIN
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
