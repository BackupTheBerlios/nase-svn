;+
; NAME:
;  ConsoleTime
;
; VERSION:
;  $Id$
;
; AIM:
;  A <A>Console</A>-utility that sets the console time.
;
; PURPOSE:
;  Update <A>console</A> time and display number of simulated BINs, simulated
;  time in milliseconds  and progress in percent in the bottom line of
;  the console window.
;
; CATEGORY:
;  ExecutionControl
;  Graphic
;  MIND
;  Widgets
;
; CALLING SEQUENCE:
;* consoletime, MyCons, BIN=..., MS=... [, PROGRESS=...]
;
; INPUTS:
;  MyCons:: Handle pointing towards a <A>console</A>-structure. Get
;           such a handle by calling <A>InitConsole()</A>.
;
; INPUT KEYWORDS:
;  BIN:: Number of timesteps already simulated.
;  MS:: Time in milliseconds corresponding to the simulated number of
;       BINs.
;  PROGRESS:: Number of simulated timesteps divided by their total
;             number times 100. The user has to take care of
;             calculating this correctly before passing the result to
;             <C>ConsoleTime</C>.
;
; OUTPUTS:
;  The bottom line of the console widget is updated by the values
;  passed to <C>ConsoleTime</C>.
;  
; SIDE EFFECTS:
;  The states of the console structure's tags <C>acttime_steps</C> and
;  <C>acttime_ms</C> are changed to the new values.
;
; PROCEDURE:
;  - Get current console state from handle.<BR>
;  - Compose new output string.<BR>
;  - Set console tags to new values.<BR>
;  - Send output string to Widget or print it conventionally.<BR>
;
; EXAMPLE:
;* MyCons = InitConsole(MODE='win',LENGTH=30)
;* Console, MyCons, 'hi there','TestProc',/MSG
;* ConsoleTime, MyCons, BIN=30, MS=30.0, PROGRESS=23
;*  ...
;* FreeConsole, MyCons 
;
; SEE ALSO:
;  <A>InitConsole()</A>, <A>Console</A>, <A>ConsoleConf</A>,
;  <A>FreeConsole</A>.
; 
;-
;
; MODIFICATION HISTORY:
;
;
;     $Log$
;     Revision 2.3  2001/03/07 13:46:25  thiel
;        Now progress can be displayed optionally.
;
;     Revision 2.2  2000/09/28 13:23:54  alshaikh
;           added AIM
;
;     Revision 2.1  2000/01/26 17:03:36  alshaikh
;           initial version
;



PRO ConsoleTime, _console, BIN=bin, MS=ms, PROGRESS=progress

   Handle_Value, _console, status, /NO_COPY


   temp = 'BINS: '+STR(bin)+'   Time: '+STR(ms)+'ms'

   IF Set(PROGRESS) THEN temp = temp+'   Progress: '+STR(progress)+'%'

   status.acttime_steps = bin
   status.acttime_ms = ms
 
   IF status.mode EQ 1 THEN $
    Widget_Control, status.timewid, SET_VALUE=temp $
   ELSE IF status.mode EQ 0 THEN Print, temp


   Handle_Value, _console, status, /NO_COPY, /SET

END
