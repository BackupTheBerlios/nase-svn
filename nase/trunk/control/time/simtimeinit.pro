;+
; NAME:
;  SimTimeInit
;
; VERSION:
;  $Id$
;
; AIM:
;  Initializes a structure for recording the time needed by simulations.
;
; PURPOSE:
;  The <C>SimTime</C> family of routines is intended to be used when
;  one wants to keep track of the times needed by iterations in a
;  simulation or by a number of
;  simulations. During simulation, the number of iterations already
;  executed as well as the progress and estimated time until
;  completion can be printed. After completion, a small analysis may
;  also be printed or plotted.<BR>
;  <C>SimTimeInit</C> initializes the structure needed for recording
;  the time and is used to specify the way in which outputs are
;  displayed. 
;
; CATEGORY:
;  ExecutionControl
;
; CALLING SEQUENCE:
;* SimTimeInit [,MAXSTEPS=...] [,CONSOLE=...] [,/GRAPHIC] [,/PRINT]],[/CLEAR]
;
; INPUT KEYWORDS:
;  MAXSTEPS:: The total number of simulation steps to be
;             executed. This is needed to calculate the
;             progress. Default: 1000.
;  CONSOLE:: A handle pointing to a <A>Console</A> structure that may be
;            used to display the output. The bottom line of the
;            console widget is used for printing ongoing information.
;            <B>Attention:</B> This may interfere with the output of
;            <A>ConsoleTime</A>. 
;  GRAPHIC:: Plot statistics after completion.
;  PRINT:: Print information after each iteration.
;  CLEAR:: Delete previous output and print new information at the top
;          of the IDL window at Pos1.
;
; COMMON BLOCKS:
;  SimTime  
;
; PROCEDURE:
;  Just define a structure. 
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
;  <A>SimTimeStep</A>, <A>SimTimeStop</A>, <A>Console</A>. 
; 
;-
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 1.7  2003/08/14 09:16:19  michler
;
;     Modified Files:
;     	simtimeinit.pro
;
;     changed stat.step from INT to LONGINT
;
;     Revision 1.6  2001/03/08 16:24:20  thiel
;       SimTime supports Console now.
;       New header.
;
;     Revision 1.5  2000/09/28 13:25:35  alshaikh
;           added AIM
;
;     Revision 1.4  1998/06/19 09:22:30  gabriel
;          Keyword CLEAR eingefuehrt
;
;     Revision 1.3  1998/03/13 09:49:26  saam
;           set maximum simtimesteps to 1000
;
;     Revision 1.2  1997/11/13 13:59:39  saam
;           Graphic nur noch Keyword, Output ins aktuellen Device
;
;     Revision 1.1  1997/10/26 18:41:57  saam
;           vom Himmel gefallen
;



PRO SimTimeInit, GRAPHIC=graphic, PRINT=print, MAXSTEPS=maxsteps ,CLEAR=CLEAR $
                 , CONSOLE=console
   
   COMMON SimTime, stat
   
   
   Default, maxsteps, 1000
   Default, print   ,   0
   Default, graphic ,   0
   Default, clear, 0
   Default, console, -1
  
   stat = { tpi     : DblArr(maxsteps+1),$ ; time per iteration i
            lst     : 0d                ,$ ; last system time (internal)
            ast     : 0d                ,$ ; latest system time (internal)
            step    : 0L                 ,$ 
            maxsteps: maxsteps          ,$ ; maximal number of iterations
            print   : print             ,$ ; print time after each step
            clear   : clear             ,$ ; clear term after each step
            graphic : graphic, $; plot diagram at the end
            console: console}                    

   stat.lst = SysTime(1)

END

