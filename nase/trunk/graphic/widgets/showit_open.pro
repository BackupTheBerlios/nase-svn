;+
; NAME: ShowIt_Open
;
; PURPOSE: Öffnen eines zuvor mit <A HREF="#WIDGET_SHOWIT">Widget_ShowIt</A> vorbereiteten Widgets.
;          Beim Öffnen werden die Graphik-Systemvariablen auf die zu diesem 
;          Widget gehörenden Werte gesetzt. Außerdem wird die mit dem Widget
;          assoziierte Window-ID ermittelt und das entsprechende Fenster
;          per UWSet geöffnet, sodaß nachfolgende Graphikausgabe dort ankommt.
;          Falls das Widget vor dem ShowIt_Open-Aufruf noch nicht realisiert 
;          war, führt ShowIt_Open die Realisierung durch. (Dies wirkt im
;          übrigen auf die gesamte Widget-Hierarchie, der das ShowIt angehört.)
;
; CATEGORY: GRAPHIC / WIDGETS
;
; CALLING SEQUENCE: ShowIt_Open, widgetid
;
; INPUTS: widget_id: Die Identifikationsnummer des zu öffnenden Widgets. Diese
;                    wird von <A HREF="#WIDGET_SHOWIT">Widget_ShowIt</A> geliefert.
; PROCEDURE: 1. Realisieren.
;            2. UWSet auf das Fenster mit der zugehörigen WinID.
;            3. !P, !X, !Y und !Z setzen.
;
; EXAMPLE: p=Widget_Base()
;          s=Widget_ShowIt(p, /PRIVATE_COLORS, XSIZE=500, YSIZE=200)
;          ShowIt_Open, s
;          Plot, RandomN(seed,50)
;          Showit_Close, s   
;
; SEE ALSO: <A HREF="#SCROLLIT">ScrollIt</A>, <A HREF="./SHEETS/#DEFINESHEET">DefineSheet</A>, <A HREF="./SHEETS/#OPENSHEET">OpenSheet</A>, <A HREF="./SHEETS/#CLOSESHEET">CloseSheet</A>, 
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 1.2  1999/09/06 14:04:56  thiel
;            Wrapped draw-widget inside base to provide free uservalue.
;
;        Revision 1.1  1999/09/01 16:43:53  thiel
;            Moved from other directory.
;
;        Revision 1.1  1999/08/30 09:20:34  thiel
;            DrawWidgets who rember their colortables. For use with FaceIt.
;
;-


PRO ShowIt_Open, widid


   Widget_Control, widid, /REALIZE

   firstchild = Widget_Info(widid, /CHILD)
   Widget_Control, firstchild, GET_VALUE=winid, GET_UVALUE=uservalue, /NO_COPY
   UWSet, winid

   old = !P
   !P = uservalue.p
   uservalue.p = old
   old = !X
   !X = uservalue.x
   uservalue.x = old
   old = !Y 
   !Y = uservalue.y
   uservalue.y = old
   old = !Z
   !Z = uservalue.z
   uservalue.z = old

   Widget_Control, firstchild, SET_UVALUE=uservalue, /NO_COPY

END
