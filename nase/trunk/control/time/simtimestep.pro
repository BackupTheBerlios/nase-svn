;+
; NAME:                  SimTimeStep
;
; PURPOSE:               Diese Routine ist dazu gedacht, die Zeiten fuer eine Folge von Simulationen 
;                        zu protokollieren und nach der Gesamtsimulation eine Statistik/Graphik aus-
;                        zugeben.
;
; CATEGORY:              ORGANISATION
;
; CALLING SEQUENCE:      SimTimeStep
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
;     Revision 1.3  1998/06/09 16:38:18  gabriel
;          Schreibfehler
;
;     Revision 1.2  1998/06/09 16:22:53  gabriel
;          Jetzt mit Schaetzung der Simulationszeit bis zum Ende
;
;     Revision 1.1  1997/10/26 18:41:58  saam
;           vom Himmel gefallen
;
;
;-
PRO SimTimeStep
   
   COMMON SimTime, stat


   IF stat.step LT stat.maxsteps THEN BEGIN
      stat.ast            = SysTime(1)
      stat.tpi(stat.step) = stat.ast - stat.lst
      stat.step           = stat.step + 1
      stat.lst            = stat.ast 
   END ELSE BEGIN
      Print, 'SimTimeStep: too many iterations...quitting'
   END
   ;;mittelwert bilden Time/Iteration
   median = total(stat.tpi(0:stat.step-1))/FLOAT(stat.step)
   estimation = median*(stat.maxsteps-stat.step+1)
   IF stat.print THEN BEGIN
      print, '-----------------------------------------------'
      print, '  Iteration              : ', stat.step
      print, '  Time of last Iteration : ', Seconds2String(stat.tpi(stat.step-1))
      print, '  Mission completed in   : ', Seconds2String(estimation)
      print, '  Total Time             : ', Seconds2String(Total(stat.tpi))
      print, '-----------------------------------------------'
   END

END
