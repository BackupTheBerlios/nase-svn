;+
; NAME:                  SimTimeInit
;
; PURPOSE:               Diese Routine ist dazu gedacht, die Zeiten fuer eine Folge von Simulationen 
;                        zu protokollieren und nach der Gesamtsimulation eine Statistik/Graphik aus-
;                        zugeben.
;
; CATEGORY:              ORGANISATION
;
; CALLING SEQUENCE:      SimTimeInit [, GRAPHIC=graphic] [,/PRINT], [MAXSTEPS=maxsteps]
;
; KEYWORD PARAMETERS:    graphic : falls angegeben, wird ein Fenster mit der ID graphic geoeffnet und die
;                                  Zeiten inklusive Mittelwert und Standardabweichung angezeigt
;                        print   : nach jeder Iteration werden benoetigte Zeit/Iteration und Gesamtzeit 
;                                  ausgegeben (im Stunde/Minute/Sekunde-Format)
;                        maxsteps: maximale Zahl der Iterationen (default 100)
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
;     Revision 1.1  1997/10/26 18:41:57  saam
;           vom Himmel gefallen
;
;
;-
PRO SimTimeInit, GRAPHIC=graphic, PRINT=print, MAXSTEPS=maxsteps
   
   COMMON SimTime, stat
   
   
   Default, maxsteps, 100
   Default, print   ,   0
   Default, graphic ,   0
   
   stat = { tpi     : DblArr(maxsteps+1),$ ; time per iteration i
            lst     : 0d                ,$ ; last system time (internal)
            ast     : 0d                ,$ ; latest system time (internal)
            step    : 0                 ,$ 
            maxsteps: maxsteps          ,$ ; maximal number of iterations
            print   : print             ,$ ; print time after each step
            graphic : graphic            } ; plot diagram at the end

   stat.lst = SysTime(1)

END

