;+
; NAME:                  SimTimeStep
;
; PURPOSE:               Diese Routine ist dazu gedacht, die Zeiten fuer eine Folge von Simulationen 
;                        zu protokollieren und nach der Gesamtsimulation eine Statistik/Graphik aus-
;                        zugeben.
;
; CATEGORY:              ORGANISATION
;
; CALLING SEQUENCE:      SimTimeStep,[CLEAR=CLEAR]
;             
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
;     Revision 1.5  1998/06/19 09:22:08  gabriel
;          Ausfuehrliche Ausgabe, CLEAR Keyword
;
;     Revision 1.4  1998/06/16 17:44:03  gabriel
;          Ein paar neue Ausgaben
;
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

   END

END
